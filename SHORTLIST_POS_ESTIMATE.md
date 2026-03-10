# Shortlist v2 + POS — Оценка разработки

**Дата:** 10.03.2026
**Проект:** Get It (Flutter marketplace)
**Исполнитель:** Claude Code (AI-assisted development)
**Ревью/тестирование:** команда

---

## 1. Что уже реализовано

- Базовый CRUD shortlist (создание, список, редактирование, публикация, архив, дупликат)
- Добавление товаров из инвентаря (поиск по названию)
- 1 toggle приватности (`is_public`)
- Скидка в % (одно поле)
- Share code + QR ссылка (генерация кода, копирование)
- Онлайн checkout через Stripe
- Управление заказами/доставкой
- Инвентарь seller dashboard

---

## 2. Принятые решения

| # | Вопрос | Решение |
|---|--------|---------|
| 1 | POS транзакции — отдельная таблица или расширяем `orders` | **Отдельная таблица `pos_transactions`** — POS и online orders имеют разную структуру (payment source, generic items, discounts, cash drawer). Связь через `shortlist_id`. Online `orders` не трогаем. |
| 2 | Platform fee — процент | **10%**, только app-based checkout (QR оплата через Stripe) |
| 3 | Cart reservation timeout | **10 мин** для обоих: seller POS корзина и buyer QR checkout |
| 4 | Mixed payments (split cash + app) | **Не в MVP** — один источник оплаты на транзакцию |
| 5 | Apple Pay | **Да, включён в scope** через Stripe Apple Pay integration |
| 6 | Generic items → inventory conversion | **MVP** — при закрытии shortlist trade-in/purchased items конвертируются в инвентарь |
| 7 | Cash drawer | **Да** — подсчёт наличных начало/конец дня, обязателен при reconciliation |
| 8 | Real-time inventory sync | **Да** — Supabase Realtime для конкурентных POS сессий |
| 9 | Buyer без аккаунта при QR scan | **Нет** — buyer должен уже иметь аккаунт. Без аккаунта → показываем сообщение "скачайте приложение и зарегистрируйтесь" |
| 10 | Analytics dashboard | **Часть seller dashboard** — новая секция/таб в существующем dashboard |

---

## 3. Scope новой разработки

### Блок 1 — Shortlist типы (1-2h dev / ~30min ревью)

- Новое поле `type` в таблице `shortlists`: `convention`, `flash_sale`, `promotion`
- UI выбора типа при создании shortlist (Step 1)
- Условная логика на основе типа (влияет на promotion, privacy defaults)

### Блок 2 — Расширенные Privacy Settings (3-4h dev / ~1h ревью)

Три независимых toggle вместо одного:

| Toggle | Описание |
|--------|----------|
| **Allow Public Viewing** | Shortlist виден на профиле seller'а |
| **Limit to In-Person Only** | Покупка только лично, онлайн checkout отключён |
| **Private Access** | Доступ только по QR коду или приватной ссылке |

- Новые поля в БД: `is_in_person_only`, `is_private_access`
- Backend enforcement на API уровне (RLS policies)
- UI с пояснениями для каждого toggle

### Блок 3 — Sale Description Page (4-6h dev / ~1h ревью)

Новая страница конфигурации скидок:

- **Discount duration:** long-term sale vs flash sale (start/end time)
- **Типы скидок:**
  - Flat discount (% или фиксированная сумма)
  - Spend $X → free shipping
  - Spend $X → unlock $Y off
- Новая таблица `shortlist_discount_rules` (type, value, threshold, duration)
- UI формы с динамическими полями в зависимости от типа скидки

### Блок 4 — Flash Sale Notifications (8-12h dev / ~2h тест)

- Supabase Edge Function для отправки push-уведомлений
- Условия отправки:
  - **Обязательно (convention/event):** пользователь сканировал QR + скачал приложение
  - **Опционально:** создал аккаунт, подписан на seller'а, товар в wishlist
- Интеграция с FCM (Firebase Cloud Messaging)
- Настройки notification preferences для buyer'а
- Scheduled notifications (за N минут до начала flash sale)

### Блок 5 — Фильтрация при добавлении в Shortlist (2-3h dev / ~30min ревью)

Сейчас только поиск по имени. Добавить фильтры как в inventory:

- Category
- Tags
- Price range
- Quantity
- Condition
- Item name (уже есть)

### Блок 6 — Promotion Logic Constraint (1h dev / ~15min ревью)

- Кнопка "Promote Product" скрыта/disabled для shortlist type = `convention`
- Promote доступен только для public-facing shortlists
- Валидация на backend

### Блок 7 — Publish Button UX (0.5h dev / ~10min ревью)

- Кнопка "Publish Shortlist" — primary color fill, визуально главная
- "Add Product" — secondary стиль
- Swap визуального акцента на финальном шаге

### Блок 8 — Post-Event Inventory Reconciliation (8-12h dev / ~2.5h тест)

Новый flow после завершения convention/sale:

- Система показывает все непроданные товары
- Seller подтверждает статус каждого товара:
  - Returned to inventory
  - Missing
  - Damaged
  - Hold for next convention
- Missing/damaged товары автоматически убираются из публичного инвентаря
- Reconciliation обязательна перед закрытием shortlist
- **Cash drawer reconciliation:**
  - Seller вводит начальную сумму наличных при открытии POS сессии
  - При закрытии — вводит итоговую сумму
  - Система сравнивает: начальная + cash-продажи - cash-выплаты = ожидаемая
  - Расхождения логируются
- **Generic items conversion:** trade-in и purchased items доступны для конвертации в инвентарь
- Новая таблица `shortlist_reconciliation` (item_id, status, notes)
- Новая таблица `pos_cash_drawer` (shortlist_id, opening_amount, closing_amount, expected_amount, difference, notes)

### Блок 9 — POS: Cart & Search (5-8h dev / ~2h тест)

Новый экран Point-of-Sale:

- Поиск товаров внутри активного shortlist
- Добавление в корзину с выбором количества
- Временное резервирование товара (10 мин timeout)
- Отображение: название, цена, qty, изображение
- Корзина с итоговой суммой
- Валидация доступного количества в реальном времени (Supabase Realtime)

### Блок 10 — POS: Discounts (4-6h dev / ~1h тест)

Два уровня скидок:

| Уровень | Описание |
|---------|----------|
| **Item-level** | Скидка на отдельный товар в корзине (% или $) |
| **Transaction-level** | Скидка на всю корзину |

- Цена не может уйти ниже $0 (с предупреждением)
- UI показывает: оригинальная цена → скидка → итоговая цена
- Конфликт скидок: система применяет максимально допустимую

### Блок 11 — POS: Custom Generic Items (4-6h dev / ~1h тест)

Seller может добавить в корзину не-инвентарные позиции:

- **Положительное значение:** новый товар, допродажа
- **Отрицательное значение:** trade-in, частичный возврат, скидка по договорённости
- Поля: описание/категория, значение (+/-), заметки (seller-only)
- Отрицательные позиции могут быть оформлены отдельно (трекинг покупок seller'а)
- **При закрытии shortlist:** UI для конвертации generic items в полноценные inventory items (фото, категория, состояние)

### Блок 12 — POS: QR Checkout + Apple Pay (10-14h dev / ~3.5h тест)

Buyer оплата через приложение:

- Seller генерирует QR код для текущей корзины
- Buyer сканирует QR → видит корзину → оплачивает через Stripe
- **Apple Pay** поддержка через Stripe Apple Pay integration
- Platform fee: **10%** автоматически удерживается при app-based checkout
- При успешной оплате:
  - Inventory ownership переходит buyer'у
  - Продажа записывается в shortlist
  - Транзакция автоматически маркируется как app checkout (без выбора seller'а)
- QR код инвалидируется после изменения корзины или timeout (10 мин)
- Buyer без аккаунта → сообщение "Download the app and create an account to checkout"

### Блок 13 — External Payment Tracking (2-3h dev / ~30min ревью)

Seller выбирает источник оплаты для не-app транзакций:

- Cash
- Credit
- Peer2Peer app
- Crypto

- App Checkout маркируется **автоматически** при успешной QR оплате (не требует выбора seller'а)
- Выбор обязателен перед завершением продажи
- Platform fee (10%) **не применяется** к внешним платежам
- Данные сохраняются для аналитики и reconciliation

### Блок 14 — POS Analytics (5-8h dev / ~1.5h ревью)

Новая секция в seller dashboard:

- Количество и сумма проданных товаров
- Количество и сумма новых товаров (generic positive)
- Количество и сумма trade-in (generic negative)
- Сумма cash payouts
- Breakdown по источникам оплаты (Cash / Credit / P2P / Crypto / App)
- Platform fee collected (10% от app checkout)
- Cash drawer summary (opening → closing → difference)
- Фильтр по shortlist и периоду

### Блок 15 — Backend: Supabase (10-14h dev / ~3.5h тест)

Новые таблицы:

| Таблица | Назначение |
|---------|-----------|
| `shortlist_discount_rules` | Правила скидок для shortlist |
| `pos_transactions` | POS транзакции (отдельно от online orders) |
| `pos_cart_items` | Позиции в POS корзине |
| `pos_generic_items` | Custom generic позиции (+/-) |
| `shortlist_reconciliation` | Reconciliation статусы товаров |
| `pos_cash_drawer` | Cash drawer open/close записи |
| `shortlist_notifications` | Настройки уведомлений |

Новые поля в существующих таблицах:

- `shortlists`: `type`, `is_in_person_only`, `is_private_access`, `flash_sale_start`, `flash_sale_end`

RPC функции:

- `create_pos_transaction` (атомарная: оплата + inventory transfer + 10% fee)
- `get_shortlist_analytics` (агрегация метрик)
- `reconcile_shortlist` (batch update статусов)
- `convert_generic_to_inventory` (конвертация trade-in → inventory item)

Edge Functions:

- `send_flash_sale_notification` (FCM push)
- `generate_pos_qr_checkout` (Stripe payment intent + Apple Pay для QR)

RLS Policies:

- Privacy enforcement для shortlist access
- POS transaction ownership

Supabase Realtime:

- Channel на `pos_cart_items` и `products` для real-time inventory sync между POS сессиями

### Блок 16 — Edge Cases (5-8h dev / ~2h тест)

- Товар продан в другой сессии → real-time обновление через Supabase Realtime
- Quantity mismatch → блокировка checkout + ошибка
- Cart reservation timeout (10 мин) → возврат товаров в пул (оба: seller POS + buyer QR)
- Conflicting discounts → enforcement максимальных лимитов
- Flash sale expiration mid-transaction → скидка сохраняется если корзина создана до expiration
- QR code expired/reused → ошибка, seller regenerate
- Buyer abandons QR checkout → timeout → seller может отменить или сменить payment source
- Shortlist closure без reconciliation → система блокирует
- Missing item later found → seller может восстановить
- Platform fee bypass attempt → atomic transaction (fee + transfer неразделимы)
- Cash drawer mismatch → логируется, seller подтверждает расхождение

---

## 4. Сводная оценка

### По блокам

| # | Блок | Claude Code | Ваше время |
|---|------|:-----------:|:----------:|
| 1 | Shortlist типы | 1-2h | 0.5h |
| 2 | Privacy settings | 3-4h | 1h |
| 3 | Sale description page | 4-6h | 1h |
| 4 | Flash sale notifications | 8-12h | 2h |
| 5 | Фильтрация shortlist add | 2-3h | 0.5h |
| 6 | Promotion constraint | 1h | 0.25h |
| 7 | Publish button UX | 0.5h | 0.15h |
| 8 | Post-event reconciliation + cash drawer | 8-12h | 2.5h |
| 9 | POS cart & search | 5-8h | 2h |
| 10 | POS discounts | 4-6h | 1h |
| 11 | POS custom generic items + conversion | 4-6h | 1h |
| 12 | POS QR checkout + Apple Pay | 10-14h | 3.5h |
| 13 | External payment tracking | 2-3h | 0.5h |
| 14 | POS analytics (seller dashboard) | 5-8h | 1.5h |
| 15 | Backend Supabase | 10-14h | 3.5h |
| 16 | Edge cases | 5-8h | 2h |

### Итого

| | Min | Max |
|---|:---:|:---:|
| **Claude Code разработка** | **73h** | **110h** |
| **Ваше время (ревью, тест, фидбек)** | **23h** | **33h** |
| **Общее время проекта** | **96h** | **143h** |

---

## 5. Рекомендуемые фазы

### Фаза 1 — Shortlist Enhancements

**~22-32h Claude Code / ~5.5h ваше время**

- Блоки 1-7: типы, privacy, sale description, фильтрация, promotion constraint, publish UX
- Блок 15 (частично): миграции БД для фазы 1

**Результат:** расширенный shortlist с типами, тремя toggle приватности, гибкими скидками.

### Фаза 2 — POS Core

**~30-48h Claude Code / ~11.5h ваше время**

- Блоки 9-13: POS cart, discounts, generic items + conversion, QR checkout + Apple Pay, payment tracking
- Блок 15 (частично): POS таблицы, RPC, edge functions, Realtime

**Результат:** работающая POS система с корзиной, скидками, QR + Apple Pay оплатой, 10% platform fee.

### Фаза 3 — Analytics, Reconciliation & Polish

**~21-30h Claude Code / ~8h ваше время**

- Блоки 4, 8, 14, 16: flash notifications, reconciliation + cash drawer, analytics в seller dashboard, edge cases

**Результат:** полный lifecycle shortlist от создания до закрытия с аналитикой и cash drawer.

---

## 6. Технический стек

| Компонент | Технология |
|-----------|-----------|
| Frontend | Flutter + Riverpod |
| Backend | Supabase (PostgreSQL + RLS) |
| Payments | Stripe (Payment Intents, Connect, Apple Pay) |
| Push | FCM via Supabase Edge Functions |
| Real-time | Supabase Realtime (inventory sync + chat) |
| QR | `qr_flutter` (генерация) + `mobile_scanner` (сканирование) |
| Models | Freezed + json_serializable |
| Navigation | GoRouter |

---

## 7. Архитектура данных

### Связи таблиц

```
shortlists (extended)
├── shortlist_items (existing)
├── shortlist_discount_rules (new)
├── shortlist_reconciliation (new)
├── shortlist_notifications (new)
├── pos_cash_drawer (new)
└── pos_transactions (new)
    ├── pos_cart_items (new)
    └── pos_generic_items (new)
```

### Platform Fee Flow

```
Buyer scans QR → Stripe Payment Intent (+ Apple Pay option)
  → Success → pos_transaction created
    → inventory transfer (atomic)
    → 10% platform fee deducted (server-side, non-bypassable)
    → transaction auto-marked as "app_checkout"

Seller selects external payment (Cash/Credit/P2P/Crypto)
  → pos_transaction created
    → inventory updated
    → 0% platform fee
    → payment_source recorded for analytics
```

---

*Оценка актуальна на 10.03.2026. Все вопросы закрыты — scope зафиксирован.*
