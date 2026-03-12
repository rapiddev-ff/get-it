# Shortlist v2 + POS — Release 1 Оценка

**Дата:** 12.03.2026
**Проект:** Get It (Flutter marketplace)
**Основа:** Звонок с Max (клиент) от 12.03.2026 — scope сокращён для Release 1

---

## 1. Что убрали из scope (Release 1)

| Блок (из оригинала) | Причина |
|----------------------|---------|
| Shortlist типы UI | Только `convention` по умолчанию, без UI выбора |
| Privacy settings (3 toggle) | Не нужны — товары уже снимаются с маркетплейса при добавлении в shortlist |
| Sale description page | Не нужно |
| Flash sale notifications | Не нужно |
| Фильтрация при добавлении | Не обсуждалось |
| Promotion logic | Не нужно |
| Publish button UX | Не обсуждалось |
| POS Analytics dashboard | Не нужно (только базовый summary при закрытии) |
| Cash drawer reconciliation | Не нужно |
| Inventory transfer при checkout | Max OK для Release 2 |

---

## 2. Ключевые решения из звонка

| # | Вопрос | Решение |
|---|--------|---------|
| 1 | Platform fee | **10% + $0.30 от всего total** (включая tax). Max подтвердил |
| 2 | Скидки | Нет отдельной логики — просто **редактируемая цена** в корзине |
| 3 | Shipping | **Нет** для shortlist (всё in-person) |
| 4 | Refunds | Не нужны для in-person. Если сложно — те же правила что и обычные заказы |
| 5 | Funds payout | **Immediate** payout seller'у при app checkout |
| 6 | Generic items | Только **name + price** (+/-). Без категории. Минус = trade-in |
| 7 | Buyer без аккаунта | Показываем "Download the app and create an account to checkout" |
| 8 | Referral | Seller получает referral credit когда buyer регистрируется через QR shortlist |
| 9 | Subscription | 1 tier, **$40/мес** (POS + AI scan) |
| 10 | Shortlist expiration | QR код ломается при expiration или closeout shortlist |

---

## 3. Scope Release 1

### Блок 1 — Shortlist type field (0.5h dev / 0.15h ревью)

- Новое поле `type` в таблице `shortlists`, default `convention`
- Без UI выбора типа — convention по умолчанию

### Блок 2 — POS Cart & Search (4-6h dev / 1.5h ревью)

- Поиск товаров внутри активного shortlist
- Добавление в корзину с выбором количества
- **Редактируемая цена** прямо в корзине (вместо сложной логики скидок)
- Итого: items + tax (без shipping — всё in-person)
- Валидация доступного количества в реальном времени (Supabase Realtime)

### Блок 3 — Generic Items упрощённые (2-3h dev / 0.5h ревью)

- Seller может добавить в корзину не-инвентарные позиции
- Только два поля: **name** и **price** (+/-)
- Положительное значение: новый товар, допродажа
- Отрицательное значение: trade-in, вычитается из total
- Без категории, без конвертации в инвентарь (Release 2)

### Блок 4 — QR Checkout через Stripe (8-12h dev / 3h тест)

- Seller нажимает "Checkout with App" → генерирует QR код для текущей корзины
- Buyer сканирует QR → видит корзину → платит через Stripe
- Platform fee: **10% + $0.30 от всей суммы** (включая tax)
- При успешной оплате:
  - Заказ автоматически получает статус "Completed/Delivered"
  - Показывается в buyer orders и seller dashboard
  - Funds переводятся seller'у **немедленно**
- QR инвалидируется при изменении корзины, timeout, или closeout shortlist
- Buyer без аккаунта → "Download the app and create an account to checkout"
- Seller получает referral credit если buyer новый пользователь

### Блок 5 — External Payment Tracking (2-3h dev / 0.5h ревью)

- Кнопка "Checkout with Other" рядом с "Checkout with App"
- Seller выбирает метод: **Cash / Credit / Crypto**
- Для Cash: ввод полученной суммы → расчёт сдачи (cart = $20, получил $40 → сдача $20)
- Не влияет на seller revenue в приложении
- Platform fee **не применяется**
- Транзакция хранится для будущей аналитики (Release 2)

### Блок 6 — Post-event Reconciliation упрощённый (4-6h dev / 1.5h тест)

- При истечении shortlist или нажатии "End Shortlist":
  - Список **непроданных** товаров (проданные не показываются)
  - Кнопка "Remove from inventory" для каждого товара (damaged / sold without tracking)
  - **Базовый summary продаж** сверху страницы (сколько cash, сколько через app)
  - Кнопка "Close out shortlist" → неотмеченные товары возвращаются на маркетплейс
- QR код инвалидируется при closeout или expiration

### Блок 7 — Backend Supabase (6-10h dev / 2h тест)

Новые таблицы:

| Таблица | Назначение |
|---------|-----------|
| `pos_transactions` | POS транзакции (отдельно от online orders) |
| `pos_cart_items` | Позиции в POS корзине |
| `pos_generic_items` | Custom generic позиции (+/-) |
| `shortlist_reconciliation` | Reconciliation статусы товаров |

Новые поля в существующих таблицах:

- `shortlists`: `type` (default 'convention')

RPC функции:

- `create_pos_transaction` — атомарная: оплата + inventory update + 10% + $0.30 fee
- `reconcile_shortlist` — batch update статусов, возврат товаров на маркетплейс

Edge Functions:

- `generate_pos_qr_checkout` — Stripe payment intent для QR

RLS Policies:

- POS transaction ownership
- Shortlist access control

Supabase Realtime:

- Channel на `pos_cart_items` и `products` для real-time inventory sync

### Блок 8 — Edge Cases (3-5h dev / 1.5h тест)

- Товар продан в другой сессии → real-time обновление
- Quantity mismatch → блокировка checkout + ошибка
- QR code expired → ошибка, seller regenerate
- Buyer abandons QR checkout → timeout → seller может отменить или сменить payment source
- Shortlist closure → QR инвалидация
- Concurrent POS sessions → Supabase Realtime sync

### Блок 9 — Referral Credit (1-2h dev / 0.5h ревью)

- Buyer регистрируется через QR shortlist → seller получает referral credit
- Интеграция с существующей referral системой

---

## 4. Сводная оценка Release 1

### По блокам

| # | Блок | Claude Code | Ваше время |
|---|------|:-----------:|:----------:|
| 1 | Shortlist type field | 0.5h | 0.15h |
| 2 | POS Cart & Search | 4-6h | 1.5h |
| 3 | Generic Items (упрощённые) | 2-3h | 0.5h |
| 4 | QR Checkout (Stripe) | 8-12h | 3h |
| 5 | External Payment Tracking | 2-3h | 0.5h |
| 6 | Post-event Reconciliation | 4-6h | 1.5h |
| 7 | Backend Supabase | 6-10h | 2h |
| 8 | Edge Cases | 3-5h | 1.5h |
| 9 | Referral Credit | 1-2h | 0.5h |

### Итого

| | Min | Max |
|---|:---:|:---:|
| **Claude Code разработка** | **31h** | **48h** |
| **Ваше время (ревью, тест)** | **11h** | **16h** |
| **Общее время Release 1** | **42h** | **64h** |

**Снижение с оригинала: ~96-143h → ~42-64h (убрали ~55% scope)**

---

## 5. Рекомендуемые фазы Release 1

### Фаза 1A — Backend + POS Cart (~14-22h Claude Code)

- Блок 1: type field
- Блок 7: все таблицы, RPC, RLS, Realtime
- Блок 2: POS cart UI + search

**Результат:** работающая корзина с поиском товаров из shortlist

### Фаза 1B — Checkout Flows (~11-17h Claude Code)

- Блок 3: generic items
- Блок 4: QR checkout + Stripe
- Блок 5: external payment tracking

**Результат:** seller может принимать оплату через app (QR) и внешние методы (cash/credit/crypto)

### Фаза 1C — Closeout & Polish (~6-9h Claude Code)

- Блок 6: reconciliation
- Блок 8: edge cases
- Блок 9: referral credit

**Результат:** полный lifecycle shortlist от создания до закрытия

---

## 6. Release 2 (будущее)

- Inventory transfer при app checkout (данные товара → buyer's inventory)
- POS Analytics dashboard (breakdown по payment sources)
- Trade-in analytics (что купил/продал seller)
- Curbside pickup (online checkout для shortlist)
- Cash drawer reconciliation
- Generic items → inventory conversion
- Расширенные subscription tiers
- Privacy settings (3 toggle)
- Sale description page (гибкие скидки)
- Flash sale notifications

---

## 7. Технический стек

| Компонент | Технология |
|-----------|-----------|
| Frontend | Flutter + Riverpod |
| Backend | Supabase (PostgreSQL + RLS) |
| Payments | Stripe (Payment Intents, Connect) |
| Real-time | Supabase Realtime (inventory sync) |
| QR | `qr_flutter` (генерация) + `mobile_scanner` (сканирование) |
| Models | Freezed + json_serializable |
| Navigation | GoRouter |

---

*Оценка актуальна на 12.03.2026. Scope зафиксирован по результатам звонка с Max.*
