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
- **User Data** — em, ph, fn, ln, ge, db, ct, region, zp, sr, country, SID, subscription_id
- **Event Data** — currency, value, order_id, content_type, contents, delivery_price, delivery_type, payment_type, other_costs, predicted_ltv, sznaiid
- **Settings** — test mode, optimistic scenario, strict validation, S2S headers
- **BigQuery Logs** — logování request/response do BigQuery
- **Advanced Overrides** — override tabulky pro user data a event data

Data se slučují ve 3 vrstvách: object variable → individual fields → override table.


## User data — hashing kontrakt

Server-side šablona PII **nehashuje**. Klient (frontend) **musí** zahashovat SHA-256 následující pole **před** odesláním do SGTM:

| Pole | Normalizace před hashem |
|------|--------------------------|
| `em` (email) | lowercase + trim |
| `ph` (phone) | E.164 (např. `+420606666666`) |
| `fn` (first name) | lowercase + trim |
| `ln` (last name) | lowercase + trim |
| `ge` (gender) | `m` / `f` / `o` |
| `db` (date of birth) | formát `YYYYMMDD` |
| `ct` (city) | lowercase + trim |
| `region` | lowercase + trim |
| `zp` (ZIP) | trim |
| `sr` (street) | lowercase + trim |
| `country` | ISO 3166-1 alpha-2, lowercase |

### Výjimka — `review_email`

Pole `review_email` (Zboží.cz dotazník spokojenosti) se **nehashuje** — posílá se jako plain text. Šablona ho pass-through bez jakékoli modifikace.


## Contents — formát

`contents` musí být v nativním SEM tvaru. **Žádné mapování z GA4 `items` se neprovádí** — pokud používáš GA4, namapuj si pole v GTM variable před přiřazením do `contents`.

Očekávaný tvar:

```json
[
  {
    "id": "SKU-123",
    "quantity": 2,
    "unit_price": 249.90,
    "content_name": "Modrá čepice",
    "content_category": "Prislusenstvi | Kryty | Apple"
  }
]
```

| Pole | Typ | Poznámka |
|------|-----|----------|
| `id` | string | SKU |
| `quantity` | integer | počet kusů |
| `unit_price` | number | **s DPH** |
| `content_name` | string | název — pro Purchase povinné |
| `content_category` | string | hierarchie kategorie, např. `Prislusenstvi \| Kryty \| Apple` |

Pozor na VAT: `value` na eventu je **bez DPH**, `unit_price` v `contents[]` je **s DPH**. Součet `quantity * unit_price` nemusí být roven `value`.


## Deployment notes

### Event URL fallback
Pokud necháš `Event URL` prázdný, šablona použije HTTP hlavičku `Referer` z příchozího requestu jako fallback. Pokud chybí i `Referer`, odejde `event_url: ''` (prázdný string). Seznam S2S dokumentace označuje `event_url` jako povinný, takže minimálně jednu z cest musíš zajistit:
- přiřadit GTM variable na `Event URL` (preferované — má přesnou URL stránky, ne jen dokument, odkud request přišel), **nebo**
- zajistit, aby klient posílal `Referer` hlavičku do SGTM endpointu.

### Client IP detection
Šablona bere `client_ip_address` z prvního záznamu hlavičky `X-Forwarded-For`. Pokud je sGTM za více proxies (Cloudflare + GCP LB + další), první IP může být IP proxy, ne klienta. Pro produkční nasazení na GCP Cloud Run za HTTPS LB je první IP obvykle client IP. Pokud používáš jinou topologii, ověř si to v `request_headers` logu.


## Security — BigQuery logging

Šablona má v `access_bigquery` permission deklarovaný wildcard scope (`projectId: *, datasetId: *, tableId: *, operation: write`). To není laxita — GTM Custom Template permissions jsou staticky deklarované při publikaci šablony a **nelze je navázat na runtime hodnotu parametru**. Pokud bychom hardcodovali konkrétní project/dataset/table, byla by šablona nepoužitelná pro kohokoli s jinou konfigurací.

Efektivní omezení zápisu se řeší **IAM** na sGTM service accountu:
- service account by měl mít roli `roles/bigquery.dataEditor` **jen** na konkrétní dataset, kam má šablona logovat,
- ideálně ve vlastním projektu mimo produkční data,
- `logBigQueryProjectId` / `logBigQueryDatasetId` / `logBigQueryTableId` pak musí ukazovat na povolený target, jinak BigQuery odmítne insert a šablona chybu zaloguje.

Kromě toho platí: BigQuery logování je celkově **opt-in** (`BigQuery Logs` = „Do not log to BigQuery" je default). Pokud funkci nepoužíváš, IAM na sGTM service account BigQuery oprávnění vůbec nedávej.


## Troubleshooting

| Problém | Řešení |
|---------|--------|
| Tag okamžitě selhává | Zkontrolujte, že `eventName` a `semId` jsou assigned a non-empty. |
| Purchase events selhávají | Ověřte, že `orderId`, `currency`, `value` jsou vyplněny. `contents` je doporučené, ale ne povinné. |
| Unknown event name warning | Ověřte název události vs. 18 supported events. Zapněte `strictEventValidation`. |
| API errors | Ověřte SEM ID, payload structure, zkontrolujte error logs (logují se vždy). |
