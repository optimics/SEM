# Seznam SEM (Server-Side) - SGTM šablona

Server-Side Google Tag Manager šablona pro odesílání konverzních událostí do Seznam SEM API (`https://sem.seznam.cz/rtgconv`).

Šablona je primárně **variable-driven**: jednotlivá pole payloadu přiřazujete přes GTM proměnné. Od verze 2.2 umí volitelně načítat část dat automaticky z příchozí GA4 události (`getAllEventData()`), ale tato funkce je ve výchozím stavu vypnutá.

## Důležité před nasazením

### `sul.js` je stále potřeba

Serverová šablona nenahrazuje frontendový skript `sul.js`. Ten je stále potřeba, protože na webu vytváří identifikátory `sid` a `udid`, které Seznam používá pro párování uživatele.

Doporučený postup:

1. Na webu načtěte oficiální Seznam skript `sul.js` nebo použijte frontendovou GTM šablonu.
2. Hodnoty `sid` a `udid` dostaňte do serverové šablony jedním ze dvou způsobů:
   - **Předáním jako GTM proměnné** (přiřadit do skupiny **User Data**), nebo
   - **Automaticky z request cookies** — od verze 2.3 šablona umí jako fallback přečíst `sid` a `udid` z příchozích cookies (`sid`, `udid`). Viz [Auto-map sid/udid z cookies](#auto-map-sidudid-z-cookies).

`sid` a `udid` se neposílají zahashované. Jsou to hodnoty ze `sul.js`.

### S2S SEM ID není stejné jako frontend SEM ID

Pole **S2S SEM ID (Sklik)** je identifikátor pro server-to-server měření. Najdete ho ve Skliku v pokročilém nastavení účtu. Není to stejné ID jako frontendové `sul.js?id=...`.

### Serverová šablona nehashuje PII

Email, telefon, jméno, příjmení, adresa a další PII pole musí být zahashovaná pomocí SHA-256 už před odesláním do SGTM. Serverová šablona hodnoty pouze předává dál.

Výjimky:

- `sid` a `udid` se nehashují.
- `subscription_id` se posílá tak, jak ho máte v systému.
- `review_email` pro Zboží.cz dotazník spokojenosti se posílá jako plain text.

## Instalace

1. Otevřete Server-Side GTM container.
2. `Templates` -> `Tag Templates` -> `New` -> menu (`...`) -> `Import`.
3. Vyberte soubor `template.tpl`.
4. Zkontrolujte nová oprávnění a šablonu uložte.

Při aktualizaci ze starší verze může GTM vyžadovat schválení nových oprávnění:

- `read_event_data` - čtení příchozích event dat pro GA4 Auto-Map a URL fallback pro `sznaiid`.
- `set_cookies` - zápis cookie `sznaiid`.
- `get_cookies` - čtení cookies `sznaiid`, `sid`, `udid`.

## Vytvoření tagu

1. `Tags` -> `New` -> zvolte `Seznam SEM (Server-Side)`.
2. Nastavte povinná pole:
   - **Event Name**: vyberte podporovanou SEM událost, `Auto from GA4`, nebo `From variable`.
   - **S2S SEM ID (Sklik)**: S2S SEM ID ze Skliku.
3. Doporučená pole:
   - **Event URL**: URL stránky. Pokud zůstane prázdné, šablona použije GA4 `page_location` nebo `Referer`.
   - **Event ID**: unikátní ID události pro deduplikaci.
   - **User Data**: minimálně `sid` a `udid` ze `sul.js` (nebo je nechte načíst z cookies, viz [Auto-map sid/udid z cookies](#auto-map-sidudid-z-cookies)), ideálně i zahashované PII.
4. Pro ecommerce události vyplňte **Event Data** (`currency`, `value`, `order_id`, `contents`, atd.) nebo zapněte GA4 Auto-Map.
5. Při prvním testování vypněte **Use Optimistic Scenario**, aby GTM čekal na odpověď API.
6. V produkci doporučujeme zapnout **Strict Event Validation**.

## Podporované události

Šablona pracuje s pevným seznamem SEM událostí. Neznámý název události zaloguje warning; pokud je zapnutý **Strict Event Validation**, tag selže.

| SEM událost | GA4 Auto-Map zdroj | Poznámka |
|---|---|---|
| `PageView` | `page_view` | |
| `ViewContent` | `view_item`, `view_item_list`, `select_item`, `view_promotion` | Detail produktu / obsahu. |
| `Purchase` | `purchase` | Vyžaduje `order_id`, `currency`, `value`. |
| `Contact` | `contact` | |
| `AddToCart` | `add_to_cart` | |
| `AddToWishlist` | `add_to_wishlist` | |
| `InitiateCheckout` | `begin_checkout` | |
| `AddPaymentInfo` | `add_payment_info`, `add_shipping_info` | SEM nemá samostatnou událost pro shipping info. |
| `Search` | `search`, `view_search_results` | `search_term` se mapuje na `search_string`. |
| `CompleteRegistration` | `sign_up`, `login` | Pokud není nastavený `status`, šablona doplní `status=true`. |
| `Lead` | `generate_lead` | |
| `Subscribe` | `subscribe` | |
| `CustomizeProduct` | explicitně | Bez GA4 Auto-Map zdroje. |
| `Donate` | explicitně | Bez GA4 Auto-Map zdroje. |
| `FindLocation` | explicitně | Ponecháno, protože je stále v dokumentaci Seznamu. |
| `Schedule` | explicitně | Bez GA4 Auto-Map zdroje. |
| `StartTrial` | explicitně | Bez GA4 Auto-Map zdroje. |
| `SubmitApplication` | explicitně | Bez GA4 Auto-Map zdroje. |

### Způsoby nastavení názvu události

| Nastavení | Chování |
|---|---|
| Vybraná konkrétní událost | Použije se vybraný SEM název. |
| `Auto from GA4` | Použije se mapování z GA4 `event_name` podle tabulky výše. Vyžaduje zapnutý GA4 Auto-Map a `autoMapEventName`. |
| `From variable` | Použije se hodnota z GTM proměnné, ale musí být jedna z podporovaných SEM událostí. |

Šablona záměrně neposílá neznámé GA4 názvy jako custom události. Na rozdíl od Facebook CAPI není u Seznam SEM vhodné spoléhat na libovolné custom event names.

## GA4 Auto-Map

GA4 Auto-Map je ve výchozím stavu vypnutý. Zapíná se ve skupině **GA4 Auto-Map (opt-in)**.

Podvolby:

| Volba | Výchozí stav | Popis |
|---|---|---|
| `enableGa4AutoMap` | vypnuto | Hlavní přepínač. |
| `autoMapEventName` | vypnuto | Mapuje GA4 `event_name` na SEM event, pokud je Event Name nastavený na `Auto from GA4`. |
| `autoMapEventData` | zapnuto po zapnutí hlavní volby | Mapuje ecommerce a event_data pole. |
| `autoMapUserData` | zapnuto po zapnutí hlavní volby | Mapuje pouze předem zahashované `sha256_*` hodnoty z GA4 `user_data`. |

### Mapování event_data z GA4

| SEM pole | GA4 / vstupní zdroj | Poznámka |
|---|---|---|
| `order_id` | `transaction_id` -> `id` -> `orderNo` | `orderNo` pomáhá například u Shoptetu. |
| `value` | `value` -> `revenue` -> `totalWithoutVat` -> součet `unit_price * quantity` z contents | Zaokrouhleno na 2 desetinná místa. Součet se použije jen u auto-mapovaných contents. |
| `currency` | `currency` | Seznam typicky očekává `CZK`; jiná měna zaloguje warning. |
| `value_tax` | `tax` | |
| `delivery_price` | `shipping` | |
| `payment_type` | `payment_type` | |
| `delivery_type` | `shipping_tier` | |
| `search_string` | `search_term` | |
| `event_url` | `page_location` | Top-level pole payloadu. |
| `event_id` | `event_id` -> `transaction_id` | Top-level pole payloadu. |

### Mapování `items[]` na `contents[]`

| SEM `contents[]` pole | GA4 / vstupní zdroj | Poznámka |
|---|---|---|
| `id` | `item_id` -> `id` | Povinné pro auto-mapované položky. Položky bez ID se přeskočí s warningem. |
| `content_name` | `item_name` -> `name` | |
| `unit_price` | `price` -> `priceWithVat` -> `fullPrice` | Zaokrouhleno na 2 desetinná místa. |
| `quantity` | `quantity` -> `1` | Pokud chybí nebo není číslo, doplní se `1`. |
| `content_category` | `category` -> `currentCategory` / `defaultCategory` -> `item_category...item_category5` | Priorita je exkluzivní, první nalezený zdroj vyhrává. |

Příklady kategorií:

- `category: "A/B/C"` -> `A | B | C`
- `item_category: "A", item_category2: "B"` -> `A | B`
- `currentCategory: ["A", "B"]` -> `A | B`

### Mapování GA4 user_data

Automaticky se mapují pouze předem zahashované hodnoty:

| GA4 pole | SEM user_data pole |
|---|---|
| `user_data.sha256_email_address` | `em` |
| `user_data.sha256_phone_number` | `ph` |
| `user_data.address.sha256_first_name` | `fn` |
| `user_data.address.sha256_last_name` | `ln` |

Raw hodnoty jako `email`, `phone`, `first_name`, `last_name` se automaticky neposílají. Serverová šablona je nehashuje.

## Podporované parametry payloadu

### Top-level pole

| Pole | Zdroj |
|---|---|
| `event_name` | Event Name nastavení, `From variable`, nebo GA4 Auto-Map |
| `schema_version` | konstantně `v2` |
| `event_type` | konstantně `rtgconv` |
| `event_time` | `Event Time` nebo serverový čas |
| `event_source` | `web` nebo `app` |
| `event_url` | `Event URL` -> GA4 `page_location` -> `Referer` |
| `event_id` | `Event ID` -> GA4 `event_id` -> GA4 `transaction_id` |
| `consent_mode` | Consent Mode Object |
| `consent_string` | IAB TCF consent string |
| `user_ids.user_data` | User Data sekce |
| `event_data` | Event Data sekce |
| `s2s_headers` | IP, User-Agent a Client Hints z requestu, pokud je povoleno a consent granted |

### User Data

| SEM pole | Parametr v šabloně | Poznámka |
|---|---|---|
| `sid` | `sid` | Hodnota ze `sul.js`, nehashovat. Pokud je pole prázdné, fallback z cookie `sid`. |
| `udid` | `userUdid` | Hodnota ze `sul.js`, nehashovat. Pokud je pole prázdné, fallback z cookie `udid` (suffix `@timestamp` se ořízne). |
| `em` | `userEmail` | SHA-256 email. |
| `ph` | `userPhone` | SHA-256 telefon. |
| `fn` | `userFirstName` | SHA-256 jméno. |
| `ln` | `userLastName` | SHA-256 příjmení. |
| `ge` | `userGender` | SHA-256 gender. |
| `db` | `userDob` | SHA-256 datum narození. |
| `ct` | `userCity` | SHA-256 město. |
| `region` | `userRegion` | SHA-256 region/stát. |
| `zp` | `userZip` | SHA-256 PSČ. |
| `sr` | `userStreet` | SHA-256 ulice. |
| `country` | `userCountry` | SHA-256 země. |
| `subscription_id` | `userSubscriptionId` | Identifikátor subscription. |

`userDataObject` může obsahovat přímo SEM klíče (`em`, `ph`, `fn`, ...). Od v2.2.1 umí šablona přeložit i frontend-style aliasy:

| Alias v `userDataObject` | SEM klíč |
|---|---|
| `email` | `em` |
| `phone` | `ph` |
| `fname` | `fn` |
| `lname` | `ln` |
| `gender`, `g` | `ge` |
| `birth`, `birthDate` | `db` |
| `postalCode`, `zip` | `zp` |
| `subscription`, `subscriptionId` | `subscription_id` |

Alias změní pouze název klíče. Hodnota musí být stále už zahashovaná. Při použití aliasu šablona zaloguje warning, aby bylo vidět, že je lepší používat kanonický SEM klíč.

### Event Data

| SEM pole | Parametr v šabloně | Poznámka |
|---|---|---|
| `sem_id` | `semId` | Povinné S2S SEM ID. |
| `sznaiid` | `sznaiid`, URL, nebo cookie | Click-through ID. Manuální hodnota vyhrává. |
| `currency` | `currency` | Například `CZK`. |
| `value` | `value` | Číslo. |
| `value_tax` | `valueTax` | Číslo. |
| `order_id` | `orderId` | Povinné pro Purchase. |
| `content_type` | `contentType` | Pokud existují `contents` a chybí `content_type`, doplní se `product`. |
| `contents` | `contents` | Array v SEM tvaru nebo GA4 Auto-Map z `items[]`. |
| `product_ids` | `productIds` | Pole nezáporných integer ID produktů pro Zboží.cz. |
| `delivery_price` | `deliveryPrice` | Číslo. |
| `delivery_type` | `deliveryType` | |
| `payment_type` | `paymentType` | |
| `other_costs` | `otherCosts` | Číslo. |
| `predicted_ltv` | `predictedLtv` | Číslo. |
| `goods_intention` | `goodsIntention` | Číslo. |
| `goods_phase` | `goodsPhase` | Integer; neinteger zaloguje warning. |
| `search_string` | `searchString` | Hlavně pro Search. |
| `review_email` | `reviewEmail` | Plain text, nehashovat. |
| `status` | `statusEnabled` + `status` | Boolean. |

## Contents - ruční formát

Pokud nepoužíváte GA4 Auto-Map, `contents` posílejte v nativním SEM tvaru:

```json
[
  {
    "id": "SKU-123",
    "quantity": 2,
    "unit_price": 249.9,
    "content_name": "Modrá čepice",
    "content_category": "Příslušenství | Čepice"
  }
]
```

| Pole | Typ | Poznámka |
|---|---|---|
| `id` | string | SKU nebo produktové ID. |
| `quantity` | integer | Počet kusů. |
| `unit_price` | number | Cena za kus. |
| `content_name` | string | Název produktu/obsahu. |
| `content_category` | string | Kategorie, například `Elektronika | Telefony`. |

## `sznaiid` first-party cookie

Ve výchozím stavu je zapnuté ukládání `sznaiid` do first-party cookie.

Chování:

1. Šablona hledá `?sznaiid=...` v GA4 `page_location`.
2. Pokud ho nenajde, zkusí `Referer`.
3. Pokud je zapnutá cookie persistence, uloží hodnotu do cookie `sznaiid`.
4. Na dalších událostech bez URL parametru použije hodnotu z cookie.
5. Manuálně vyplněné pole `sznaiid` v tagu má vždy přednost.

Režimy:

| Režim | Popis |
|---|---|
| `first_touch` | Zapíše cookie jen pokud ještě neexistuje. Výchozí. |
| `last_touch` | Přepíše cookie při každém novém `?sznaiid=...`. |

Vypnutí `persistSznaiidCookie` vypne čtení i zápis cookie, ale URL hodnota `?sznaiid=...` se stále může poslat v payloadu.

## Auto-map sid/udid z cookies

Od verze 2.3 umí šablona načíst `sid` a `udid` z příchozích request cookies jako **fallback**. Ovládá to checkbox **Auto-map sid & udid from request cookies (fallback)** v sekci User Data, ve výchozím stavu **zapnutý**.

Jak to funguje:

1. Pokud je `sid` / `udid` vyplněné explicitně (pole tagu, User Data Object, nebo override), použije se ta hodnota. Cookie fallback má **nejnižší prioritu** a doplní hodnotu jen když chybí.
2. `sid` se čte z cookie `sid`. Hodnota obsahuje `=` (`id=...|t=...|te=...|c=...`), ale čte se celá.
3. `udid` se čte z cookie `udid`. Suffix `<uuid>@<timestamp>`, který nastavuje `sul.js`, se ořízne na samotné `uuid`.
4. Hodnoty z cookies se **validují** proti očekávanému tvaru (UUID pro `udid`, `id=…|t=…|te=…|c=…` pro `sid`). Nevalidní hodnota se zahodí a zaloguje se WARN — chrání to proti uživatelsky podvrženým cookies.

Předpoklady:

- **First-party / same-site SGTM endpoint**, aby cookies vůbec dorazily do server containeru.
- **Consent**: šablona neví, za jakých podmínek cookie vznikla — vidí jen příchozí cookie. Předpoklad je, že `sul.js` vytváří `sid`/`udid` pouze při platném consentu a že web po odvolání consentu cookies odstraní / neposílá. Šablona stejně jako u explicitních polí předává `user_ids` spolu s `consent_mode`; vyhodnocení consentu je na straně Seznamu. Pokud chcete být striktnější, fallback vypněte a posílejte `sid`/`udid` jen explicitně.
- **Safari (ITP)**: cookie `sid` může chybět (vytváří ji JS, ITP ji ořezává). `udid` je dostupné. V takovém případě fallback `sid` prostě nedoplní.

Pokud cookies do SGTM dorazí, nemusíte `sid`/`udid` posílat jako GA4 event parametry (`ep.sid`/`ep.udid`).

## Event ID a deduplikace

`event_id` je doporučené pro deduplikaci. Pokud posíláte stejnou konverzi z frontendu i ze serveru, musí být `event_id` na obou stranách stejné.

Pozor: některé frontendové šablony pro Purchase automaticky generují `event_id` ve tvaru:

```text
Purchase__<order_id>
```

Tato serverová šablona takové ID záměrně automaticky nevytváří. Pokud chcete deduplikovat frontend a server, nastavte `Event ID` na stejnou hodnotu jako na frontendu.

## Merge order

Pole se skládají ve vrstvách. Pozdější vrstva přepisuje předchozí:

1. GA4 Auto-Map - pokud je zapnutý.
2. Object variable - `userDataObject` / `eventDataObject`.
3. Individual fields - jednotlivá UI pole.
4. Advanced Overrides - override tabulky.
5. Cookie fallback `sid`/`udid` - až po overrides, jen vyplní prázdná pole.

Speciální případy:

- `contents` z GA4 Auto-Map se použije jen pokud není vyplněné ruční `contents`.
- `sznaiid` z cookie/URL je fallback mezi object variable a individual fields.
- `sid`/`udid` z cookies (`sid`, `udid`) jsou fallback **až po Advanced Overrides** - doplní se jen když je hodnota prázdná ze všech předchozích vrstev. Cookie hodnoty se navíc validují (nevalidní se zahodí). Viz [Auto-map sid/udid z cookies](#auto-map-sidudid-z-cookies).
- Advanced Overrides umí přidat nebo přepsat pole, ale neumí pole odstranit.

## Advanced Overrides

Skupina **Advanced Overrides** je nouzový mechanismus pro hodnoty, které nejsou v UI jako samostatné pole.

- `userDataOverrides` zapisuje do `user_ids.user_data`.
- `eventDataOverrides` zapisuje do `event_data`.
- Pokud zadáte klíč, který už existuje, override ho přepíše.
- Pokud zadáte nový klíč, šablona ho do payloadu přidá.
- Seznam ale může neznámá pole ignorovat nebo odmítnout podle schématu. Používejte jen po potvrzení, že dané pole Seznam podporuje.

Override tabulka neumí mazat pole. Prázdné hodnoty jsou ignorované.

## Consent a S2S headers

`s2s_headers` obsahuje IP adresu, User-Agent a Client Hints. Šablona je pošle jen když:

- `sendS2sHeaders` je zapnuté,
- `consent_mode.ad_storage` je `granted`,
- `consent_mode.ad_user_data` je `granted`.

Podporované consent keys:

- `ad_storage`
- `ad_user_data`
- `ad_personalization`
- `functionality_storage`
- `analytics_storage`

Boolean hodnoty se normalizují na `granted` / `denied`.

## BigQuery logging

BigQuery logging je volitelné a ve výchozím stavu vypnuté. Zapne se nastavením **BigQuery Log Type = `always`** a vyplněním **Project / Dataset / Table** v sekci BigQuery Logs.

### Vytvoření tabulky

Tabulku (a případně dataset) si vytvoř předem. Šablona zapisuje tyto sloupce:

| Sloupec | Typ | Obsah |
|---|---|---|
| `tag_name` | STRING | vždy `"Seznam SEM"` |
| `event_name` | STRING | např. `Purchase` (prázdné u validační chyby) |
| `request_method` | STRING | `"POST"` |
| `request_url` | STRING | endpoint API |
| `request_body` | STRING | JSON string odeslaného payloadu |
| `timestamp` | INT64 | epoch v **milisekundách** |
| `request_id` | STRING | hlavička `x-request-id` z odpovědi |
| `response_status_code` | INT64 | HTTP status |
| `response_headers` | STRING | JSON string hlaviček odpovědi |
| `response_body` | STRING | tělo odpovědi API |

```sql
-- dataset (pokud ještě neexistuje)
CREATE SCHEMA IF NOT EXISTS `PROJECT.DATASET`;

CREATE TABLE `PROJECT.DATASET.sem_log`
(
  tag_name              STRING,
  event_name            STRING,
  request_method        STRING,
  request_url           STRING,
  request_body          STRING,
  timestamp             INT64,
  request_id            STRING,
  response_status_code  INT64,
  response_headers      STRING,
  response_body         STRING
)
PARTITION BY DATE(_PARTITIONTIME);   -- ingestion-time partitioning (volitelné)
```

Poznámky:

- Celou cestu `PROJECT.DATASET.TABLE` uzavři do **backticks** (povinné, když project ID obsahuje pomlčky).
- `timestamp` musí být **INT64**, ne TIMESTAMP — šablona vkládá milisekundy jako číslo. V dotazech převedeš přes `TIMESTAMP_MILLIS(timestamp)`.
- Všechny sloupce NULLABLE — u validační chyby (před odesláním) se vyplní jen request část, response sloupce zůstanou NULL.
- Zápis probíhá s `ignoreUnknownValues: true`, takže sloupce navíc v tabulce nevadí, ale názvy/typy výše musí sedět.

### Oprávnění

Šablona má v `access_bigquery` permission wildcard scope (`projectId: *`, `datasetId: *`, `tableId: *`, `operation: write`). GTM Custom Template permissions jsou statické a nejdou navázat na runtime hodnoty parametru.

Efektivní omezení zápisu řešte přes IAM na sGTM service accountu:

- service account by měl mít `roles/bigquery.dataEditor` jen na konkrétní dataset,
- ideálně ve vlastním projektu mimo produkční data,
- pokud BigQuery logging nepoužíváte, nedávejte service accountu BigQuery oprávnění.

## Troubleshooting

| Problém | Řešení |
|---|---|
| Tag okamžitě selhává | Zkontrolujte, že je vyplněný `eventNameSelect` / `eventNameFromVariable` a `semId`. |
| Warning na SEM ID | S2S SEM ID musí mít 24 znaků a obsahovat jen malá písmena a čísla. |
| Purchase selhává | Po všech vrstvách musí existovat `order_id`, `currency` a `value`. |
| Unknown event name warning | Název události musí být jeden z podporovaných SEM eventů. |
| Chybí `event_url` | Vyplňte `Event URL`, zapněte GA4 Auto-Map s `page_location`, nebo zajistěte `Referer`. |
| Chybí user_ids | Předávejte minimálně `sid` a `udid` ze `sul.js`, případně zahashované PII. |
| User data se posílají jako raw PII | Hashování musí proběhnout na frontendu před příchodem do SGTM. Serverová šablona nehashuje. |
| `sznaiid` se neukládá do cookie | Zkontrolujte, že je zapnuté `persistSznaiidCookie`, request obsahuje `?sznaiid=...` a tag běží mimo GTM preview ping. |
| API errors | Zkontrolujte S2S SEM ID, payload shape a error logs. Při ladění vypněte optimistic scenario. |
