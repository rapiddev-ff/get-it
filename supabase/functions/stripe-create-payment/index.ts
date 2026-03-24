// =============================================================================
// GET IT - Create Payment Intent
// Edge Function: stripe-create-payment
// 
// Создаёт Payment Intent для покупки с поддержкой:
// - Комиссии платформы
// - Отложенных выплат (hold)
// - Manual capture (авторизация без списания)
// =============================================================================

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Stripe from 'https://esm.sh/stripe@14.5.0'

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY')!, {
  apiVersion: '2023-10-16',
})

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// Комиссия платформы: 10% + $0.30
const PLATFORM_FEE_PERCENT = 10
const PLATFORM_FEE_FIXED_CENTS = 30

interface CreatePaymentRequest {
  order_id: string
  // Опционально: использовать manual capture (заморозка без списания)
  capture_method?: 'automatic' | 'manual'
  // Количество дней для hold выплаты продавцу
  hold_days?: number
  // ID сохранённого payment method
  payment_method_id?: string
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Создаём admin client для операций без RLS (создаём сразу)
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    // User client для проверки авторизации
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    const { data: { user }, error: authError } = await supabaseClient.auth.getUser()
    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const body: CreatePaymentRequest = await req.json()
    const { order_id, capture_method = 'automatic', hold_days = 7, payment_method_id } = body

    if (!order_id) {
      return new Response(
        JSON.stringify({ error: 'order_id is required' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Получаем заказ с деталями (используем admin для надёжности)
    const { data: order, error: orderError } = await supabaseAdmin
      .from('orders')
      .select(`
        *,
        order_items (
          id,
          product_id,
          product_title,
          product_price,
          quantity
        )
      `)
      .eq('id', order_id)
      .eq('buyer_id', user.id)
      .single()

    if (orderError || !order) {
      return new Response(
        JSON.stringify({ error: 'Order not found or access denied' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Проверяем статус заказа
    if (order.status !== 'pending') {
      return new Response(
        JSON.stringify({ error: `Order is already ${order.status}` }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Получаем Stripe аккаунт продавца (используем admin чтобы обойти RLS)
    const { data: sellerStripeAccount, error: sellerError } = await supabaseAdmin
      .from('stripe_accounts')
      .select('stripe_account_id, charges_enabled, onboarding_completed')
      .eq('user_id', order.seller_id)
      .single()

    if (sellerError) {
      console.error('Error fetching seller stripe account:', sellerError)
    }

    if (!sellerStripeAccount || !sellerStripeAccount.charges_enabled) {
      return new Response(
        JSON.stringify({ 
          error: 'Seller cannot accept payments',
          code: 'SELLER_NOT_READY',
          debug: {
            seller_id: order.seller_id,
            has_account: !!sellerStripeAccount,
            charges_enabled: sellerStripeAccount?.charges_enabled,
          }
        }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Получаем или создаём Stripe Customer для покупателя
    let stripeCustomerId: string

    const { data: existingCustomer } = await supabaseAdmin
      .from('stripe_customers')
      .select('stripe_customer_id')
      .eq('user_id', user.id)
      .single()

    if (existingCustomer) {
      stripeCustomerId = existingCustomer.stripe_customer_id
    } else {
      // Получаем данные покупателя
      const { data: buyerProfile } = await supabaseAdmin
        .from('user_profiles')
        .select('email, first_name, last_name, phone')
        .eq('user_id', user.id)
        .single()

      // Создаём Customer в Stripe
      const customer = await stripe.customers.create({
        email: buyerProfile?.email || user.email,
        name: buyerProfile ? `${buyerProfile.first_name || ''} ${buyerProfile.last_name || ''}`.trim() : undefined,
        phone: buyerProfile?.phone || undefined,
        metadata: {
          user_id: user.id,
          platform: 'getit',
        },
      })

      stripeCustomerId = customer.id

      // Сохраняем в БД
      await supabaseAdmin.from('stripe_customers').insert({
        user_id: user.id,
        stripe_customer_id: stripeCustomerId,
        email: buyerProfile?.email || user.email,
        name: buyerProfile ? `${buyerProfile.first_name || ''} ${buyerProfile.last_name || ''}`.trim() : null,
      })
    }

    // Рассчитываем суммы (в центах)
    const totalAmountCents = Math.round(Number(order.total_amount) * 100)
    const platformFeeCents = Math.round(totalAmountCents * PLATFORM_FEE_PERCENT / 100) + PLATFORM_FEE_FIXED_CENTS
    const sellerAmountCents = totalAmountCents - platformFeeCents

    // Рассчитываем hold_until
    const holdUntil = new Date()
    holdUntil.setDate(holdUntil.getDate() + hold_days)

    // Создаём Payment Intent
    const paymentIntentParams: Stripe.PaymentIntentCreateParams = {
      amount: totalAmountCents,
      currency: 'usd',
      customer: stripeCustomerId,
      capture_method: capture_method,
      
      // Автоматический перевод продавцу
      transfer_data: {
        destination: sellerStripeAccount.stripe_account_id,
      },
      
      // Комиссия платформы
      application_fee_amount: platformFeeCents,
      
      // Метаданные
      metadata: {
        order_id: order.id,
        order_number: order.order_number,
        buyer_id: user.id,
        seller_id: order.seller_id,
        platform: 'getit',
        hold_days: hold_days.toString(),
      },
      
      // Описание
      description: `Order ${order.order_number} on Get It`,
      
      // Statement descriptor (что увидит покупатель в выписке)
      statement_descriptor_suffix: 'GETIT',
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!

    // Если передан payment_method_id, добавляем его
    if (payment_method_id) {
      paymentIntentParams.payment_method = payment_method_id
      paymentIntentParams.confirm = true
      paymentIntentParams.return_url = `${supabaseUrl}/functions/v1/stripe-redirect?type=return`
    }
    
  
    const paymentIntent = await stripe.paymentIntents.create(paymentIntentParams)

    // Сохраняем Payment Intent в БД
    await supabaseAdmin.from('stripe_payment_intents').insert({
      order_id: order.id,
      buyer_id: user.id,
      seller_id: order.seller_id,
      stripe_payment_intent_id: paymentIntent.id,
      stripe_customer_id: stripeCustomerId,
      stripe_connected_account_id: sellerStripeAccount.stripe_account_id,
      amount: totalAmountCents,
      platform_fee: platformFeeCents,
      seller_amount: sellerAmountCents,
      currency: 'usd',
      status: paymentIntent.status,
      capture_method: capture_method,
      hold_until: holdUntil.toISOString(),
      metadata: {
        hold_days: hold_days,
      },
    })

    // Обновляем order
    await supabaseAdmin
      .from('orders')
      .update({
        stripe_payment_intent_id: paymentIntent.id,
        platform_fee: platformFeeCents / 100,
      })
      .eq('id', order.id)

    return new Response(
      JSON.stringify({
        success: true,
        payment_intent_id: paymentIntent.id,
        client_secret: paymentIntent.client_secret,
        status: paymentIntent.status,
        amount: totalAmountCents,
        platform_fee: platformFeeCents,
        seller_amount: sellerAmountCents,
        hold_until: holdUntil.toISOString(),
        // Для Stripe Payment Sheet
        customer_id: stripeCustomerId,
        ephemeral_key: (await stripe.ephemeralKeys.create(
          { customer: stripeCustomerId },
          { apiVersion: '2023-10-16' }
        )).secret,
        publishable_key: Deno.env.get('STRIPE_PUBLISHABLE_KEY'),
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error creating payment:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})