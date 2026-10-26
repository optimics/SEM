# Seznam SEM (Server-Side) - SGTM šablona

Server-Side Google Tag Manager šablona pro odesílání konverzních událostí do Seznam SEM API (`https://sem.seznam.cz/rtgconv`).

Šablona je primárně **variable-driven**: jednotlivá pole payloadu přiřazujete přes GTM proměnné. Od verze 2.2 umí volitelně načítat část dat automaticky z příchozí GA4 události (`getAllEventData()`), ale tato funkce je ve výchozím stavu vypnutá.

Změny mezi verzemi a kontrolní postup po aktualizaci (upgrade notes, Preview checklist) jsou v [CHANGELOG.md](CHANGELOG.md).

## Důležité před nasazením

### `sul.js` je stále potřeba

Serverová šablona nenahrazuje frontendový skript `sul.js`. Ten je stále potřeba, protože na webu vytváří identifikátory `sid` a `udid`, které Seznam používá pro párování uživatele.

Doporučený postup:

1. Na webu načtěte oficiální Seznam skript `sul.js` nebo použijte frontendovou GTM šablonu.
2. Hodnoty `sid` a `udid` dostaňte do serverové šablony jedním ze dvou způsobů:
   - **Předáním jako GTM proměnné** (přiřadit do skupiny **User Data**), nebo
   - **Automaticky z request cookies** — od verze 2.3 šablona umí jako fallback přečíst `sid` a `udid` z příchozích cookies (`sid`, `udid`). Viz [Auto-map sid/udid z cookies](#auto-map-sidudid-z-cookies).

`sid` a `udid` se neposílají zahashované. Jsou to hodnoty ze `sul.js`.

`sid` vzniká až po udělení souhlasu a po asynchronním požadavku `sul.js` na identitu. Načtěte `sul.js` na každé stránce před GA4 tagem; událost odeslaná dřív `sid` neobsahuje.

### SGTM endpoint musí být na stejném webu (same-site)

`sul.js` ukládá cookies `sid` a `udid` na doménu tvořenou posledními dvěma částmi hostname webu: z `www.eshop.cz` vznikne `.eshop.cz`. Prohlížeč tyto cookies posílá jen na adresy pod touto doménou. SGTM endpoint proto musí běžet na subdoméně stejné domény, například `sgtm.eshop.cz`. Na endpoint s jinou doménou (výchozí adresa Cloud Run, doména poskytovatele hostingu) cookies `sid` a `udid` nedorazí a cookie fallback nic nedoplní.

### S2S SEM ID není stejné jako frontend SEM ID

Pole **S2S SEM ID (Sklik)** je identifikátor pro server-to-server měření. Najdete ho ve Skliku v pokročilém nastavení účtu. Není to stejné ID jako frontendové `sul.js?id=...`.

Šablona kontroluje, že S2S SEM ID má přesně 24 znaků z `0-9` a `a-z` (`^[0-9a-z]{24}$`). Se zapnutou volbou **Strict Event Validation** jiná hodnota tag zastaví a nic se neodešle. Bez ní šablona zaloguje warning a hit odešle; Seznam ho odmítne. Frontendové i S2S SEM ID mají 24 znaků, takže jejich záměnu lokální kontrola nerozpozná. Seznam na ni odpoví HTTP 401 nebo 403 a šablona k chybě zaloguje nápovědu.

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
| `Purchase` | `purchase` | Výsledný payload musí obsahovat `order_id`, `currency` a `value`; jinak tag selže a nic neodešle. |
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
| `value` | `value` -> `revenue` -> `totalWithoutVat` | Zaokrouhleno na 2 desetinná místa. Šablona `value` nikdy nedopočítává z položek: `unit_price` je s DPH, `value` bez DPH. |
| `currency` | `currency` | Seznam přijímá jen `CZK`; jiná měna zaloguje warning. |
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
| `unit_price` | `price` -> `priceWithVat` -> `fullPrice` | Cena za kus s DPH. Zaokrouhleno na 2 desetinná místa. |
| `quantity` | `quantity` -> `1` | Pokud chybí, doplní se `1`. Položka s množstvím 0, záporným, desetinným nebo nečíselným se zahodí s warningem (viz [Contents](#contents---ruční-formát)). |
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
| `event_time` | `Event Time` (kladné celé číslo v ms; hodnota v sekundách se převede) nebo serverový čas. Hodnota 0, záporná nebo nečíselná se nahradí serverovým časem s warningem. |
| `event_source` | `web` nebo `app` |
| `event_url` | `Event URL` -> GA4 `page_location` -> `Referer` |
| `event_id` | `Event ID` -> GA4 `event_id` -> GA4 `transaction_id`. Číslo se převede na string. |
| `consent_mode` | Consent Mode Object, normalizovaný (viz [Consent](#consent)) |
| `consent_string` | IAB TCF v2 consent string (viz [Consent](#consent)) |
| `user_ids.user_data` | User Data sekce |
| `event_data` | Event Data sekce |
| `s2s_headers` | IP, User-Agent a Client Hints z requestu, pokud je povoleno a consent granted |

### User Data

| SEM pole | Parametr v šabloně | Poznámka |
|---|---|---|
| `sid` | `sid` | Hodnota ze `sul.js`, nehashovat. Musí mít tvar `id=…\|t=…\|te=…\|c=<32 znaků>`. Pokud je pole prázdné nebo hodnota nemá tento tvar, použije se cookie `sid`. |
| `udid` | `userUdid` | Hodnota ze `sul.js`, nehashovat. Musí to být UUID; suffix `@timestamp` se ořízne. Pokud je pole prázdné nebo hodnota není UUID, použije se cookie `udid`. |
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

Ostatní klíče mimo SEM schéma `user_data` (`em`, `ph`, `fn`, `ln`, `ge`, `db`, `ct`, `region`, `zp`, `sr`, `country`, `said`, `id5`, `secid`, `subscription_id`, `sid`, `udid`) šablona neodešle a zaloguje warning. Všechny hodnoty jsou stringy; číslo se převede na string.

### Event Data

| SEM pole | Parametr v šabloně | Poznámka |
|---|---|---|
| `sem_id` | `semId` | Povinné S2S SEM ID. Vždy z tohoto pole; `sem_id` v objektu nebo v overrides se ignoruje. |
| `sznaiid` | `sznaiid`, URL, nebo cookie | Click-through ID. Manuální hodnota vyhrává. |
| `currency` | `currency` | Seznam přijímá jen `CZK`; jiné měny přepočítejte před odesláním. Jiná měna zaloguje warning. |
| `value` | `value` | Číslo, hodnota **bez DPH** v CZK. Povinné pro Purchase. |
| `value_tax` | `valueTax` | Číslo, DPH k `value`. |
| `order_id` | `orderId` | Povinné pro Purchase. Číslo se převede na string. |
| `content_type` | `contentType` | Pokud existují `contents` a chybí `content_type`, doplní se `product`. |
| `contents` | `contents` | Array v SEM tvaru nebo GA4 Auto-Map z `items[]`. |
| `product_ids` | `productIds` | Pole nezáporných integer ID produktů pro Zboží.cz. |
| `delivery_price` | `deliveryPrice` | Číslo, cena dopravy **s DPH**. |
| `delivery_type` | `deliveryType` | |
| `payment_type` | `paymentType` | |
| `other_costs` | `otherCosts` | Číslo, další náklady nebo slevy **s DPH**. |
| `predicted_ltv` | `predictedLtv` | Číslo. |
| `goods_intention` | `goodsIntention` | Číslo. |
| `goods_phase` | `goodsPhase` | Integer; jiná hodnota se vynechá s warningem. |
| `search_string` | `searchString` | Hlavně pro Search. |
| `review_email` | `reviewEmail` | Plain text, nehashovat. |
| `status` | `statusEnabled` + `status` | Boolean. |

### Typová normalizace

Po sloučení všech vrstev šablona projde výsledný payload jednou a každou hodnotu převede na typ podle SEM schématu:

- Klíč mimo schéma `event_data`, `user_data` nebo položky `contents` se neodešle a zaloguje se warning.
- Čísla: JS číslo nebo desetinný řetězec s tečkou (`'1234.50'`, `'-5'`). Řetězce `'1 234,50'`, `'1,234'`, `'1e3'` a `'Infinity'` jsou neplatné; šablona nehádá formát čísla podle locale.
- ID (`order_id`, `event_id`, `sznaiid`, `contents[].id`, hodnoty `user_data`): neprázdný string; číslo se převede na string. Řetězce `'undefined'` a `'null'` se zahodí s warningem.
- `status`: `true`/`false`, `1`/`0`, `'true'`/`'false'`.
- Řetězce se ořežou o mezery na začátku a na konci.
- Neplatná nepovinná hodnota se vynechá s warningem. Neplatná povinná hodnota (`order_id`, `currency`, `value` u Purchase) tag zastaví.
- Chybějící hodnota (`undefined`, `null`, prázdný řetězec) nic nepřepisuje. `false`, `0` a `[]` jsou hodnoty.

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
| `quantity` | integer ≥ 1 | Počet kusů. Chybějící množství šablona odešle jako `1`. |
| `unit_price` | number | Cena za kus **s DPH**. |
| `content_name` | string | Název produktu/obsahu. |
| `content_category` | string | Kategorie, například `Elektronika | Telefony`. |

Pravidla pro `contents` ze všech zdrojů (GA4 Auto-Map, Event Data Object, pole Contents, overrides):

- Položka, jejíž `quantity` je vyplněné, ale není celé číslo alespoň 1 (`0`, záporné, `0.5`, `1.9`, nečíselné, `Infinity`), se zahodí s warningem. Ostatní položky i událost se odešlou.
- Když se zahodí všechny položky, `contents` se neodešle a šablona nedoplní ani `content_type`. Explicitně vyplněné `content_type` zůstane.
- Explicitně předané prázdné pole `[]` se odešle jako `[]`.
- Klíče mimo tabulku výše se zahodí s warningem.

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

Šablona cookie zapíše až poté, co payload projde validací. Když tag selže (například chybný consent nebo neúplný Purchase), cookie se nezapíše. Atributy: `Path=/`, doména `auto`, `Secure`, `SameSite=Lax`, bez `HttpOnly`, `Max-Age` podle nastavení (výchozí 7776000 s = 90 dní). Podle dokumentace Seznamu lze `sznaiid` uložit i bez souhlasu uživatele.

## Auto-map sid/udid z cookies

Od verze 2.3 umí šablona načíst `sid` a `udid` z příchozích request cookies jako **fallback**. Ovládá to checkbox **Auto-map sid & udid from request cookies (fallback)** v sekci User Data, ve výchozím stavu **zapnutý**.

Jak to funguje:

1. Pokud je `sid` / `udid` vyplněné explicitně (pole tagu, User Data Object, nebo override) a má správný tvar, použije se ta hodnota. Cookie fallback má **nejnižší prioritu** a doplní hodnotu, když explicitní hodnota chybí nebo nemá správný tvar.
2. `sid` se čte z cookie `sid`. Hodnota obsahuje `=` (`id=...|t=...|te=...|c=...`), ale čte se celá.
3. `udid` se čte z cookie `udid`. Suffix `<uuid>@<timestamp>`, který nastavuje `sul.js`, se ořízne na samotné `uuid`.
4. Explicitní hodnoty i hodnoty z cookies se **validují** proti stejnému tvaru (UUID pro `udid`, `id=…|t=…|te=…|c=<32 znaků>` pro `sid`). Nevalidní hodnota se zahodí a zaloguje se WARN; hodnota se do logu nevypisuje. Kontrola chrání proti chybně namapovaným proměnným i uživatelsky podvrženým cookies.
5. Když payload nakonec neobsahuje platné `sid`, šablona zaloguje WARN `no valid sid`, i když obsahuje jiné identifikátory.

Předpoklady:

- **Same-site SGTM endpoint**, aby cookies vůbec dorazily do server containeru (viz [SGTM endpoint musí být na stejném webu](#sgtm-endpoint-musí-být-na-stejném-webu-same-site)).
- **Consent**: šablona vidí jen příchozí cookie, ne podmínky, za kterých vznikla. `sul.js` vytváří `sid` až po udělení souhlasu. Šablona stejně jako u explicitních polí předává `user_ids` spolu s `consent_mode`; vyhodnocení consentu je na straně Seznamu (viz [Consent](#consent)). Pokud chcete být striktnější, fallback vypněte a posílejte `sid`/`udid` jen explicitně.
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

1. GA4 Auto-Map - pokud je zapnutý. Patří sem i `contents` z GA4 `items[]`.
2. Object variable - `userDataObject` / `eventDataObject`.
3. Individual fields - jednotlivá UI pole.
4. Advanced Overrides - override tabulky.
5. Cookie fallback `sid`/`udid` - až po overrides, jen vyplní prázdná pole.

Po sloučení vrstev šablona výsledný payload jednou normalizuje (viz [Typová normalizace](#typová-normalizace)) a jednou validuje: název události, S2S SEM ID a u Purchase `order_id`, `currency` a `value`. Validuje se přesně ten payload, který se odešle.

Speciální případy:

- Chybějící hodnota (`undefined`, `null`, prázdný řetězec) v pozdější vrstvě hodnotu z dřívější vrstvy nepřepíše. Například `eventDataObject` s `order_id: null` ponechá `order_id` z GA4 Auto-Map.
- `contents` z object variable, pole Contents nebo overrides, včetně prázdného `[]`, nahradí `contents` z GA4 Auto-Map.
- `sznaiid` z cookie/URL je fallback mezi object variable a individual fields.
- `sid`/`udid` z cookies (`sid`, `udid`) jsou fallback **až po Advanced Overrides** - doplní se jen když z předchozích vrstev chybí platná hodnota. Viz [Auto-map sid/udid z cookies](#auto-map-sidudid-z-cookies).
- `sem_id` vždy pochází z pole S2S SEM ID.
- Advanced Overrides umí přidat nebo přepsat pole, ale neumí pole odstranit.

## Advanced Overrides

Skupina **Advanced Overrides** je nouzový mechanismus pro hodnoty, které nejsou v UI jako samostatné pole.

- `userDataOverrides` zapisuje do `user_ids.user_data`.
- `eventDataOverrides` zapisuje do `event_data`.
- Pokud zadáte klíč, který už existuje, override ho přepíše.
- Pokud zadáte nový klíč ze SEM schématu, šablona ho do payloadu přidá.
- Klíč mimo SEM schéma šablona neodešle a zaloguje warning.
- Hodnota se převede na typ daného klíče (čísla, `true`/`false` pro `status`); neplatná hodnota se vynechá s warningem.

Override tabulka neumí mazat pole. Řádky s prázdnou hodnotou jsou ignorované; `false` a `0` jsou hodnoty.

## Consent

### Odkud šablona consent bere

Šablona čte consent jen z polí **Consent Mode Object** a **Consent String (IAB TCF)** ve skupině Consent. Nečte ho z GA4 event dat (ani z parametrů `x-ga-gcs` / `x-ga-gcd`) ani z cookies CMP. Stav souhlasu proto musíte do SGTM přenést sami, například jako parametr GA4 události.

Příklad přenosu:

1. Na webu přidejte do GA4 události parametr `sem_consent` s JSON stringem stavu souhlasu z vaší CMP, například:

   ```json
   {"ad_storage":"granted","ad_user_data":"granted","ad_personalization":"denied","analytics_storage":"granted"}
   ```

2. V SGTM vytvořte proměnnou typu **Event Data** s Key Path `sem_consent`.
3. Tuto proměnnou přiřaďte do pole **Consent Mode Object**.

Hodnotu ověříte v sGTM Preview: proměnná musí obsahovat objekt nebo JSON string objektu s podporovanými klíči, ne obal typu `{"consent_mode": {...}}`.

### Podporované klíče a hodnoty

Podporované klíče: `ad_storage`, `ad_user_data`, `ad_personalization`, `functionality_storage`, `analytics_storage`.

| Vstup | Odešle se |
|---|---|
| `'granted'`, `true`, `1`, `'1'`, `'true'` | `granted` |
| `'denied'`, `false`, `0`, `'0'`, `'false'` | `denied` |

- Klíče, které v objektu jsou, se odešlou. Chybějící klíče šablona nedoplňuje.
- Ostatní klíče (například `wait_for_update`) se ignorují.
- Prázdná hodnota a řetězce `'undefined'` / `'null'` znamenají, že klíč není vyplněný.
- Hodnota `null` také znamená, že klíč není vyplněný: šablona ho vynechá, zaloguje warning a nedoplní ho jako `granted` ani `denied`.
- Když žádný podporovaný klíč nemá hodnotu a Consent String není vyplněný, šablona `consent_mode` neodešle, hit odešle a zaloguje warning `no consent signal`.

### Chybně nastavený consent tag zastaví

Pokud je pole vyplněné, ale chybné, tag skončí jako *Failed* (`gtmOnFailure`), nic neodešle a nezapíše cookie `sznaiid`. Platí to bez ohledu na Strict Event Validation. Chybou je:

- Consent Mode Object, který není objekt ani JSON string objektu, nebo nejde rozparsovat;
- objekt bez podporovaného klíče, například obal `{"consent_mode": {...}}`;
- neplatná hodnota u podporovaného klíče, například `'Granted'`, `'yes'` nebo číslo jiné než `0` a `1`;
- Consent String, který nezačíná `C` nebo obsahuje jiné znaky než `A-Z`, `a-z`, `0-9`, `_`, `.`, `-`.

Šablona zaloguje jeden řádek ve tvaru `Seznam SEM [ERROR]: <pole>: <problém>, got <typ>`, například `Seznam SEM [ERROR]: consentModeObject: expected object with granted/denied values, got string`. Řádek nikdy neobsahuje hodnotu souhlasu. Loguje se vždy, nezávisle na Test Mode: v sGTM Preview je na záložce Console a v produkci v serverových logách (Cloud Logging). Do DevTools prohlížeče se nedostane, protože tag běží na serveru.

### IAB TCF consent string

Seznam vyhodnocuje TCF consent string přednostně před `consent_mode` („Systém vždy upřednostní IAB TCF“, dokumentace Seznamu k consentu; v S2S payloadu „bude upřednostněn“). Pole **Consent String (IAB TCF)** proto vyplňte jen tehdy, když vaše CMP je IAB TCF v2 a má Seznam ve vendor listu. Jinak ho nechte prázdné.

Šablona kontroluje jen syntaxi (první znak `C`, povolené znaky). Kontrola neověřuje, že string je platný TCF ani že obsahuje souhlas pro Seznam; to vyhodnotí Seznam.

### Co šablona s consentem dělá a co ne

- Předá `consent_mode` a `consent_string` Seznamu.
- Hity podle consentu neblokuje. `user_ids`, `review_email` a `sznaiid` se odešlou bez ohledu na stav souhlasu; vyhodnocení je na straně Seznamu.
- `s2s_headers` (IP adresa, User-Agent, Client Hints) pošle jen když je zapnuté `sendS2sHeaders` a zároveň `consent_mode.ad_storage` i `consent_mode.ad_user_data` jsou `granted`.
- Brána pro `s2s_headers` čte jen `consent_mode`. Nastavení jen s TCF stringem (bez Consent Mode Object) proto `s2s_headers` nikdy neodešle.
- S Test Mode zaloguje u každého requestu souhrn consentu, surovou hodnotu GA4 `x-ga-gcs` (jen do logu, do payloadu se nepřevádí) a zdroj `sid` / `udid`.

### Hity před souhlasem a po něm

V Advanced Consent Mode Google tag po udělení souhlasu `ad_storage` automaticky znovu odešle dřívější `page_view` a klíčové události, které vznikly se souhlasem denied (hit s parametrem `x-ga-gcu`). Publikované testy ([Simo Ahava, 30. 4. 2024](https://www.simoahava.com/gtmtips/automatic-page-view-hits-to-sgtm-after-consent-granted/)) a dokumentace [Stape Event Generator (14. 4. 2026)](https://community.stape.io/t/event-generator-tag-for-google-tag-manager-server-side/3933) uvádějí, že na těchto znovu odeslaných hitech se custom serverové tagy, včetně tohoto typu šablony, nespouštějí. Google parametr `x-ga-gcu` uvádí mezi [interními parametry](https://developers.google.com/tag-platform/tag-manager/server-side/internal-parameters), pravidlo potlačení tagů ale nedokumentuje.

Když k tomu dojde, SEM tag proběhne jen na původním hitu se souhlasem denied. Šablona to opravit nemůže, protože se na znovu odeslaném hitu vůbec nespustí. Netýká se to nových běžných událostí odeslaných po udělení souhlasu.

Doporučený postup:

1. CMP načtěte před GTM, nastavte výchozí stav (`default`) i aktualizaci (`update`) a `wait_for_update`.
2. Po udělení souhlasu (a pokud potřebujete `sid`, po načtení identity ze `sul.js`) odešlete samostatnou běžnou událost, například `sem_consent_ready`.
3. Na tuto událost spusťte SEM tag s explicitně nastaveným Event Name `PageView`. Auto mapování názvu z GA4 pomocnou událost nezná.
4. Sjednoťte triggery a Event ID tak, aby se PageView nezapočítal dvakrát, a pomocnou událost podle potřeby vynechte z přeposílání do GA4. Nákupy znovu neodesílejte.

Ověření v sGTM Preview: původní hit se souhlasem denied, znovu odeslaný hit s `x-ga-gcu` a seznam tagů, které se na něm spustily.

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
- Všechny sloupce NULLABLE. U validační nebo konfigurační chyby (před odesláním) se vyplní `tag_name`, `event_name`, `request_method`, `request_url`, `timestamp` a do `response_body` text chyby; `request_body`, `request_id`, `response_status_code` a `response_headers` zůstanou NULL. U requestu, který selhal bez HTTP odpovědi (timeout, síťová chyba), se vyplní request část včetně `request_body` a response sloupce zůstanou NULL.
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
| Tag skončí jako *Failed* hned, bez requestu | V Console sGTM Preview najděte řádek `Seznam SEM [ERROR]`. Jmenuje pole a problém: chybějící Event Name nebo SEM ID, chybný consent, neúplný Purchase, nevalidní JSON nebo SEM ID mimo `^[0-9a-z]{24}$` při Strict Event Validation. |
| `[ERROR] consentModeObject…` nebo `[ERROR] consentString…` | Consent Mode Object nebo Consent String je vyplněný, ale chybný. Opravte mapování proměnné podle sekce [Consent](#consent). |
| Warning na SEM ID | S2S SEM ID musí mít 24 znaků z `0-9` a `a-z`. Se Strict Event Validation tag selže. |
| HTTP 401 / 403 | Seznam odmítl SEM ID nebo přístup k endpointu. Použijte S2S SEM ID ze Skliku, ne SEM ID ze `sul.js`. |
| Purchase selhává | Výsledný payload (po všech vrstvách a normalizaci) musí obsahovat `order_id`, `currency` a číselné `value` bez DPH. Šablona `value` nedopočítává z položek. ERROR řádek jmenuje chybějící pole. |
| Warning `… is not a Seznam field` | Klíč není v SEM schématu a šablona ho neodešle. Přejmenujte ho na SEM klíč nebo ho odstraňte. |
| Warning `…: expected number…; omitting` | Hodnota není číslo ani desetinný řetězec s tečkou. Opravte formát na webu (`1234.50`, ne `1 234,50`). |
| Warning `…quantity…; dropping the item` | Položka má množství 0, záporné, desetinné nebo nečíselné a neodešle se. Opravte data na webu; chybějící množství šablona doplní jako `1`. |
| Warning `no valid sid` | Do SGTM nedorazila platná cookie `sid` ani platná explicitní hodnota. Zkontrolujte same-site endpoint, consent a načtení `sul.js` před GA4. |
| Warning `no consent signal` | Consent Mode Object ani Consent String nejsou vyplněné. Nastavte přenos consentu podle sekce [Consent](#consent). |
| Unknown event name warning | Název události musí být jeden z podporovaných SEM eventů. |
| Chybí `event_url` | Vyplňte `Event URL`, zapněte GA4 Auto-Map s `page_location`, nebo zajistěte `Referer`. |
| Chybí user_ids | Předávejte minimálně `sid` a `udid` ze `sul.js`, případně zahashované PII. |
| User data se posílají jako raw PII | Hashování musí proběhnout na frontendu před příchodem do SGTM. Serverová šablona nehashuje. |
| `sznaiid` se neukládá do cookie | Zkontrolujte, že je zapnuté `persistSznaiidCookie`, request obsahuje `?sznaiid=...`, tag běží mimo GTM preview ping a tag neselhal (cookie se zapisuje až po úspěšné validaci). |
| API errors | Zkontrolujte S2S SEM ID, payload shape a error logs (obsahují `x-request-id`). Při ladění vypněte optimistic scenario. Request má timeout 5 s. |
