# Seznam SEM Conversion API — SGTM šablona

Server-Side Google Tag Manager šablona pro odesílání konverzních událostí do Seznam SEM API (`https://sem.seznam.cz/rtgconv`). Každé pole payloadu je explicitní parametr šablony, který se přiřadí přes GTM variable.

## Podporované události

PageView, ViewContent, Purchase, Contact, AddToCart, AddToWishlist, InitiateCheckout, AddPaymentInfo, Search, CompleteRegistration, Lead, Subscribe, CustomizeProduct, Donate, FindLocation, Schedule, StartTrial, SubmitApplication

Lze také zadat vlastní název přes volbu "Custom".

## Instalace

1. Otevřete svůj Server-Side GTM container.
2. `Templates` → `Tag Templates` → `New` → menu (`...`) → `Import`.
3. Vyberte soubor `template.tpl` a uložte.

### Vytvoření tagu
1. `Tags` → `New` → zvolte `Seznam SEM Conversion API`.
2. Nastavte povinná pole:
   - **Event Name**: GTM variable s názvem události
   - **SEM ID**: váš Sklik advertiser ID
3. Volitelná pole:
   - **Event URL**: URL stránky (fallback na Referer header)
   - **Event ID**: unikátní ID pro deduplikaci
   - **Event Time**: timestamp (auto-detect ms vs s)
4. Rozbalte **Event Data** — currency, value, order ID, contents atd.
5. Rozbalte **User Data** — email, phone, name, address fields, nebo jeden User Data Object.
6. Rozbalte **Settings**:
   - **Test Mode**: zapněte při testování (loguje celý payload a response)
   - **Use Optimistic Scenario**: vypněte při počátečním nasazení
   - **Strict Event Validation**: zapněte v produkci

### Trigger
- Custom Event trigger pro jednotlivý event
- Event Name equals `PageView`, `Purchase`, `ViewContent` atd.

## Konfigurace

**Povinné**: Event Name, SEM ID

**Volitelné sekce**:
- **Consent** — consent mode object (ad_storage, ad_user_data, ...) + IAB TCF consent string
- **User Data** — em, ph, fn, ln, ge, db, ct, st, zp, sr, country, SID, subscription_id
- **Event Data** — currency, value, order_id, content_type, contents, delivery_price, delivery_type, payment_type, other_costs, predicted_ltv, sznaiid
- **Settings** — test mode, optimistic scenario, strict validation, S2S headers
- **BigQuery Logs** — logování request/response do BigQuery
- **Advanced Overrides** — override tabulky pro user data a event data

Data se slučují ve 3 vrstvách: object variable → individual fields → override table.


## Troubleshooting

| Problém | Řešení |
|---------|--------|
| Tag okamžitě selhává | Zkontrolujte, že `eventName` a `semId` jsou assigned a non-empty. |
| Purchase events selhávají | Ověřte, že `orderId`, `currency`, `value` a `contents` jsou vyplněny. |
| Unknown event name warning | Ověřte název události vs. 18 supported events. Zapněte `strictEventValidation`. |
| API errors | Ověřte SEM ID, payload structure, zkontrolujte error logs (logují se vždy). |
