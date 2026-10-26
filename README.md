# Seznam SEM (Server-Side) - SGTM šablona

Server-Side Google Tag Manager šablona pro odesílání konverzních událostí do Seznam SEM API (`https://sem.seznam.cz/rtgconv`).

Data události a uživatele zadáváte v tabulkách **Klíč – Hodnota** (klíč vybíráte ze seznamu, hodnotu přiřadíte z GTM proměnné) nebo jako objekt z GTM proměnné. Volitelně umí šablona část dat předvyplnit z příchozí GA4 události (`getAllEventData()`); ve výchozím stavu je to vypnuté.

Změny mezi verzemi a kontrolní postup po aktualizaci (upgrade notes, Preview checklist) jsou v [CHANGELOG.md](CHANGELOG.md). Přechod z verze 2.x popisuje sekce [Přechod na verzi 3](#přechod-na-verzi-3).

## Důležité před nasazením

### `sul.js` je stále potřeba

Serverová šablona nenahrazuje frontendový skript `sul.js`. Ten je stále potřeba, protože na webu vytváří identifikátory `sid` a `udid`, které Seznam používá pro párování uživatele.

Doporučený postup:

1. Na webu načtěte oficiální Seznam skript `sul.js` nebo použijte frontendovou GTM šablonu.
2. Hodnoty `sid` a `udid` dostaňte do serverové šablony jedním ze dvou způsobů:
   - **Předáním jako GTM proměnné** (řádky `sid` a `udid` v tabulce **User data**), nebo
   - **Automaticky z request cookies** — od verze 2.3 šablona umí jako fallback přečíst `sid` a `udid` z příchozích cookies (`sid`, `udid`). Viz [Auto-map sid/udid z cookies](#auto-map-sidudid-z-cookies).

`sid` a `udid` se neposílají zahashované. Jsou to hodnoty ze `sul.js`.

`sid` vzniká až po udělení souhlasu a po asynchronním požadavku `sul.js` na identitu. Načtěte `sul.js` na každé stránce před GA4 tagem; událost odeslaná dřív `sid` neobsahuje.

### SGTM endpoint musí být na stejném webu (same-site)

`sul.js` ukládá cookies `sid` a `udid` na doménu tvořenou posledními dvěma částmi hostname webu: z `www.eshop.cz` vznikne `.eshop.cz`. Prohlížeč tyto cookies posílá jen na adresy pod touto doménou. SGTM endpoint proto musí běžet na subdoméně stejné domény, například `sgtm.eshop.cz`. Na endpoint s jinou doménou (výchozí adresa Cloud Run, doména poskytovatele hostingu) cookies `sid` a `udid` nedorazí a cookie fallback nic nedoplní.

### Souhlas musí dostat `sul.js` i serverový tag (dva samostatné kroky)

**1. CMP → `sul.js`.** Pokud CMP nepoužívá IAB TCF, předejte její stav také knihovně Seznamu: po načtení `sul.js` zavolejte `SEM('updateConsent', {consent_mode: stavZCMP})` při inicializaci stránky (výchozí stav CMP) a po každé změně volby uživatele. Samotný Google Consent Mode update tento krok nenahrazuje. Bez tohoto propojení `sul.js` cookies `sid` ani `udid` nevytvoří (ověřeno v testovacím kontejneru 26. 10. 2026: po zavolání vznikly do 6 s).

Příklad. Funkce `nactiStavCmp()` a `priZmeneCmp()` nahraďte API vaší CMP a kategorie (`marketing`, `analytics`, `functional`) kategoriemi, které vaše CMP používá. Hodnoty musí odpovídat skutečné volbě uživatele, ne napevno `granted`. Funkce `semState()` vrátí `granted` jen pro `true`, `1`, `'1'`, `'true'` a `'granted'`; cokoli jiného (`false`, `'denied'`, `'false'`, `'0'`, neznámá hodnota) je `denied`. Používá-li vaše CMP jiné hodnoty souhlasu (například `'accepted'`), doplňte je do `semState()` výslovně.

```html
<script src="https://l.seznam.cz/sul.js?id=VASE_SEM_ID"></script>
<script>
  function semState(v) {
    return (v === true || v === 1 || v === '1' || v === 'true' || v === 'granted') ? 'granted' : 'denied';
  }
  function semConsentMode(stav) {
    return {
      ad_storage: semState(stav.marketing),
      ad_user_data: semState(stav.marketing),
      ad_personalization: semState(stav.marketing),
      analytics_storage: semState(stav.analytics),
      functionality_storage: semState(stav.functional)
    };
  }
  if (typeof window.SEM === 'function') {
    // Při inicializaci stránky: aktuální (výchozí) stav CMP.
    SEM('updateConsent', { consent_mode: semConsentMode(nactiStavCmp()) });
    // Po každé změně volby uživatele.
    priZmeneCmp(function (stav) {
      SEM('updateConsent', { consent_mode: semConsentMode(stav) });
    });
  }
</script>
```

**2. CMP → serverový tag.** Proměnnou se stavem souhlasu namapujte do **Consent Mode Object v každém SEM tagu**, včetně tagů se zapnutým GA4 prefill. GA4 prefill consent neodvozuje; bez tohoto pole odejde hit bez informace o souhlasu (warning `no consent signal`). Propojení CMP → `sul.js` a přenos CMP → serverový tag jsou dva samostatné kroky; ověřte oba. Jak stav souhlasu do SGTM přenést, popisuje sekce [Přenos stavu souhlasu do SGTM](#přenos-stavu-souhlasu-do-sgtm).

**3. Hity těsně po udělení souhlasu.** Automaticky znovu odeslaný `page_view` po kliknutí na „Přijmout“ SEM tag nespustí. Postup popisuje sekce [Hity před souhlasem a po něm](#hity-před-souhlasem-a-po-něm).

### S2S SEM ID není stejné jako frontend SEM ID

Pole **S2S SEM ID (Sklik)** je identifikátor pro server-to-server měření. Najdete ho ve Skliku v pokročilém nastavení účtu. Není to stejné ID jako frontendové `sul.js?id=...`.

Šablona kontroluje, že S2S SEM ID má přesně 24 znaků z `0-9` a `a-z` (`^[0-9a-z]{24}$`), jak vyžaduje schéma. Jiná hodnota tag zastaví a nic se neodešle. Od verze 3 platí kontrola vždy; dřívější volba **Strict Event Validation** se ignoruje.

Frontendové i S2S SEM ID mají 24 znaků, takže jejich záměnu lokální kontrola nerozpozná. Podle dokumentace Seznamu může odpověď 401/403 znamenat chybné SEM ID nebo nepřístupný endpoint; šablona k takové odpovědi zaloguje nápovědu.

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

Oprávnění šablony (kromě `logging`, `read_request` a `access_bigquery`):

- `read_event_data` - čtení příchozích event dat pro GA4 prefill, název události z GA4, `sznaiid` z URL a IP/User-Agent.
- `set_cookies` - zápis cookie `sznaiid`.
- `get_cookies` - čtení cookies `sznaiid`, `sid`, `udid`.
- `read_container_data` - zjištění, zda kontejner běží v Preview nebo debug režimu (Console logging `debug`). Nové ve verzi 3.
- `send_http` - od verze 3 jen na `https://sem.seznam.cz/rtgconv` (dříve `https://sem.seznam.cz/*`).

Při aktualizaci na verzi 3 zkontrolujte na záložce **Permissions** nové `read_container_data` a užší `send_http`.

## Přechod na verzi 3

Na tuto sekci odkazuje řádek `Seznam SEM [WARN]: v2.x settings in use: … (README "Přechod na verzi 3")`. Všechny změny i s tím, co zkontrolovat, jsou v [CHANGELOG.md](CHANGELOG.md) (3.0.0, Upgrade notes).

Verze 3 zjednodušuje rozhraní. U *Event data* a *User data* najdete jeden objekt z GTM proměnné a jednu tabulku **Klíč – Hodnota**, kde klíč vybíráte ze seznamu. Nový tag má 21 polí a 4 pole pro BigQuery logging. Volby *User Data input mode* a *Event Data input mode* zmizely; šablona je nikdy nečetla.

Nastavení z verze 2.x se při aktualizaci zachovají, **s výjimkami uvedenými níže**. Dřívější jednotlivá pole, tabulky *Overrides* a dřívější nastavení najdete ve sbalené skupině **Starší pole (v2.x)**. Šablona je dál používá. Když tag některé z nich používá, zapíše při každém spuštění do logu jeden řádek:

```text
Seznam SEM [WARN]: v2.x settings in use: userEmail→user_data.em, orderId→event_data.order_id, alias email→em, ga4.orderNo, testMode; move them to the v3 tables/settings (README "Přechod na verzi 3") | trace=…
```

Řádek obsahuje jen názvy, nikdy hodnoty. Loguje se vždy, nezávisle na nastavení Console logging, i když tag skončí chybou. Starší pole ve verzi 3 fungují. Pozdější verze je buď zachová, nebo hit s vyplněným starším polem zastaví s jasným řádkem `[ERROR]`; takovou změnu předem oznámíme v CHANGELOGu.

### Postup

1. Nejdřív aktualizujte na 2.3.1 a opravte všechny `[ERROR]` a `[WARN]`.
2. Aktualizujte na verzi 3. Na záložce **Permissions** zkontrolujte nové oprávnění `read_container_data` a užší `send_http` (jen `https://sem.seznam.cz/rtgconv`).
3. V Preview si přečtěte řádek `v2.x settings in use`.
4. Pro každou položku přidejte řádek do nové tabulky podle převodní tabulky níže. Pak starší pole **vymažte**: text smažte, *Include status* odškrtněte, řádky starých *Overrides* odstraňte.
5. *Test Mode*: v nastavení **Console logging** zvolte úroveň a *Test Mode* odškrtněte. Dokud je zaškrtnutý, loguje se v režimu `always`.
6. Znovu otestujte v Preview. Řádek `v2.x settings in use` zmizí, jakmile tag žádné starší pole nepoužívá. Pak publikujte.

### Převodní tabulka

| Dřívější pole | Nový řádek tabulky |
|---|---|
| SID / UDID | `sid` / `udid` (User data) |
| Email, Phone, First Name, Last Name | `em`, `ph`, `fn`, `ln` |
| Gender, Date of Birth, City, Region, Postal Code, Street, Country, Subscription ID | `ge`, `db`, `ct`, `region`, `zp`, `sr`, `country`, `subscription_id` |
| Order ID, Currency, Value, Value Tax | `order_id`, `currency`, `value`, `value_tax` (Event data) |
| Content Type, Contents, Product IDs | `content_type`, `contents`, `product_ids` |
| Delivery Price, Delivery Type, Payment Type, Other Costs | `delivery_price`, `delivery_type`, `payment_type`, `other_costs` |
| Predicted LTV, Goods Intention, Goods Phase, Search String | `predicted_ltv`, `goods_intention`, `goods_phase`, `search_string` |
| Review Email | `review_email` (dál nehashovat) |
| sznaiid | `sznaiid` |
| Include status + Status | `status` (`true` / `false`) |
| User/Event Data Overrides | stejné klíče v tabulkách User data / Event data |
| Aliasy v User Data Object (`email`, `phone`, `fname`…) | kanonické klíče `em`, `ph`, `fn`… |

Položky v řádku `v2.x settings in use`:

| Položka | Co udělat |
|---|---|
| `pole→user_data.klíč`, `pole→event_data.klíč` (například `userEmail→user_data.em`) | Přidejte řádek `klíč` do tabulky User data nebo Event data a pole vymažte. `userState→user_data.region` je dřívější název pole Region; použijte řádek `region`. |
| `statusEnabled→event_data.status` | Přidejte řádek `status` do tabulky Event data a odškrtněte *Include status*. |
| `userDataOverrides`, `eventDataOverrides` | Přeneste řádky do tabulky User data / Event data a staré řádky smažte. |
| `alias email→em` | V User Data Object použijte kanonický klíč (`em`). |
| `ga4.<klíč>`, `ga4.items.<klíč>` | GA4 událost obsahuje klíč mimo standard GA4 (Shoptet, MeasureHive) a šablona ho použila. Upravte data na webu na standardní GA4 klíč (`transaction_id`, `value`, `items[].item_id`, `item_name`, `price`, `item_category`…). |
| `testMode` | Zvolte Console logging a *Test Mode* odškrtněte. |
| `persistSznaiidCookieMode` | Zvolte `last_touch`. |
| `sznaiidCookieMaxAge` | Pole vymažte. |

Volby *Auto-map event name* a *Strict Event Validation* se v řádku neobjevují: šablona je ignoruje a jejich uloženou hodnotu nejde smazat.

### Výjimky – co se změní i při zachované kompatibilitě

- **Názvy událostí z GA4 jen 1:1.** `login`, `add_shipping_info`, `view_item_list`, `select_item` a `view_promotion` se už nemapují; takový tag skončí *Failed* s `[ERROR]` `Unknown event name: ga4:<název>`. Namapujte je přes `From variable` nebo samostatným tagem. `Auto from GA4` mapuje název i bez GA4 prefill; dřívější volba *Auto-map event name* se ignoruje.
- **Validace je vždy přísná.** Neznámý název události a SEM ID mimo `^[0-9a-z]{24}$` nově tag zastaví bez ohledu na *Strict Event Validation*; prázdný název, chybějící SEM ID a neúplný Purchase zastavovala už verze 2.3.1. Má-li tag tuto volbu uloženou vypnutou, řádek `[ERROR]` u těchto dvou případů končí `(v2 loose validation no longer applies)`. Název z `Auto from GA4` bez mapování tuto koncovku nemá: verze 2.3.1 ho zastavila jako prázdný název.
- **`event_id` se už nedoplňuje z `transaction_id`.** Pro deduplikaci s frontendem ho nastavte sami (například `Purchase__` + číslo objednávky). Se zapnutým GA4 prefill, bez `event_id` a s vyplněným `transaction_id` šablona zaloguje warning.
- **Cookie `sznaiid` ukládá vždy poslední proklik** (last touch) s pevnou platností 30 dní. Dřívější režim a délka platnosti se ignorují; warning se objeví jen tehdy, když by zápis změnily.
- **IP adresa a User-Agent** v `s2s_headers` se berou z event dat GA4 klienta (`ip_override`, `user_agent`) a teprve bez nich z hlaviček requestu. Brána podle consentu se nemění.
- **Use Optimistic Scenario** je u nových tagů vypnuté. Šablona hlásí úspěch před odpovědí Seznamu jen tehdy, když je volba uložená jako zaškrtnutá. Doporučujeme ji vypnout, aby stav tagu odpovídal odpovědi Seznamu.
- **WARN se v produkci ve výchozím stavu nelogují.** Console logging `debug` (výchozí) loguje warningy a diagnostiku jen v Preview a debug režimu. Řádky `[ERROR]` a řádek `v2.x settings in use` se logují vždy. Dřívější chování dává úroveň `always`.
- **Chybný JSON v User Data Object nebo Event Data Object tag nezastaví.** Šablona zaloguje `[ERROR]`, objekt vynechá a hit odešle. Purchase, kterému po sloučení vrstev chybí `order_id`, `currency` nebo `value`, tag dál zastaví.
- **Chybný JSON v `contents` nebo `product_ids`** (starší pole Contents a Product IDs, tabulka, objekt) se vynechá s warningem. Hodnota z nižší vrstvy se neobnoví: rozbitý JSON ve starším poli Contents už nespadne zpět na `contents` z GA4 nebo z objektu.
- **Platný JSON string v `contents` nebo `product_ids`** v Event Data Object nebo v řádku Event Data Overrides se nově rozparsuje a odešle; verze 2.3.1 ho vynechala s warningem.
- **`event_url` bez zdroje se neodešle.** Verze 2.3.1 posílala `event_url: ""`.

## Vytvoření tagu

1. `Tags` -> `New` -> zvolte `Seznam SEM (Server-Side)`.
2. Nastavte povinná pole:
   - **Event Name**: vyberte podporovanou SEM událost, `Auto from GA4`, nebo `From variable`.
   - **S2S SEM ID (Sklik)**: S2S SEM ID ze Skliku.
3. Doporučená pole:
   - **Event URL**: URL stránky. Pokud zůstane prázdné, šablona použije GA4 `page_location` (se zapnutým GA4 prefill) nebo `Referer`.
   - **Event ID**: unikátní ID události pro deduplikaci.
   - **User data**: minimálně `sid` a `udid` ze `sul.js` (nebo je nechte načíst z cookies, viz [Auto-map sid/udid z cookies](#auto-map-sidudid-z-cookies)), ideálně i zahashované PII.
4. Pro ecommerce události vyplňte řádky tabulky **Event data** (`currency`, `value`, `order_id`, `contents`, atd.), Event Data Object, nebo zapněte GA4 prefill.
5. **Use Optimistic Scenario** (skupina Advanced) je u nových tagů vypnuté, takže stav tagu odpovídá odpovědi API.
6. **Console logging** (skupina Advanced) má výchozí úroveň `debug`: warningy loguje jen v Preview a debug režimu. Řádky `[ERROR]` se logují vždy (viz [Console logging](#console-logging)).

## Podporované události

Šablona pracuje s pevným seznamem SEM událostí. Neznámý název události tag zastaví (*Failed*) a nic se neodešle.

| SEM událost | GA4 zdroj (`Auto from GA4`) | Poznámka |
|---|---|---|
| `PageView` | `page_view` | |
| `ViewContent` | `view_item` | Detail produktu / obsahu. |
| `Purchase` | `purchase` | Výsledný payload musí obsahovat `order_id`, `currency` a `value`; jinak tag selže a nic neodešle. |
| `Contact` | `contact` | |
| `AddToCart` | `add_to_cart` | |
| `AddToWishlist` | `add_to_wishlist` | |
| `InitiateCheckout` | `begin_checkout` | |
| `AddPaymentInfo` | `add_payment_info` | |
| `Search` | `search`, `view_search_results` | `search_term` se mapuje na `search_string`. |
| `CompleteRegistration` | `sign_up` | Pokud není nastavený `status`, šablona doplní `status=true`. |
| `Lead` | `generate_lead` | |
| `Subscribe` | `subscribe` | |
| `CustomizeProduct` | explicitně | Bez GA4 zdroje. |
| `Donate` | explicitně | Bez GA4 zdroje. |
| `FindLocation` | explicitně | Ponecháno, protože je stále v dokumentaci Seznamu. |
| `Schedule` | explicitně | Bez GA4 zdroje. |
| `StartTrial` | explicitně | Bez GA4 zdroje. |
| `SubmitApplication` | explicitně | Bez GA4 zdroje. |

### Způsoby nastavení názvu události

| Nastavení | Chování |
|---|---|
| Vybraná konkrétní událost | Použije se vybraný SEM název. |
| `Auto from GA4` | Použije se mapování 1:1 z GA4 `event_name` podle tabulky výše, i když je GA4 prefill vypnutý. Jiná GA4 událost (například `login`, `add_shipping_info`, `view_item_list`, `select_item`, `view_promotion`) tag zastaví s řádkem `[ERROR]` `Unknown event name: ga4:<název>`. |
| `From variable` | Použije se hodnota z GTM proměnné, ale musí být jedna z podporovaných SEM událostí. |

Šablona záměrně neposílá neznámé GA4 názvy jako custom události. Na rozdíl od Facebook CAPI není u Seznam SEM vhodné spoléhat na libovolné custom event names.

## GA4 prefill

GA4 prefill je ve výchozím stavu vypnutý. Zapíná se ve skupině **GA4 prefill** volbou **Prefill from GA4 event data**. Hodnoty z objektů, tabulek i starších polí mají před předvyplněnými hodnotami přednost.

Volby:

| Volba | Výchozí stav | Popis |
|---|---|---|
| `enableGa4AutoMap` (Prefill from GA4 event data) | vypnuto | Hlavní přepínač. |
| `autoMapEventData` (Prefill event data) | zapnuto po zapnutí hlavní volby | Mapuje ecommerce a event_data pole. |
| `autoMapUserData` (Prefill user data) | zapnuto po zapnutí hlavní volby | Mapuje pouze předem zahashované `sha256_*` hodnoty z GA4 `user_data`. |

Název události GA4 prefill neovládá: `Auto from GA4` v poli Event Name mapuje GA4 `event_name` i bez něj. Dřívější volba `autoMapEventName` je ve skupině Starší pole (v2.x) a šablona ji ignoruje.

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
| `event_id` | `event_id` | Top-level pole payloadu. `transaction_id` se jako `event_id` nepoužívá. Když chybí GA4 `event_id` i pole Event ID a `transaction_id` existuje, šablona zaloguje warning `transaction_id is no longer used as event_id; set Event ID`. |

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

Klíče mimo standard GA4 (Shoptet, MeasureHive) šablona ve verzi 3 dál čte: `id`, `orderNo`, `revenue`, `totalWithoutVat` a u položek `id`, `name`, `priceWithVat`, `fullPrice`, `category`, `currentCategory`, `defaultCategory`. Když se některý z nich použije, šablona ho uvede v řádku `v2.x settings in use` jako `ga4.<klíč>`, u položek jako `ga4.items.<klíč>` (viz [Přechod na verzi 3](#přechod-na-verzi-3)).

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
| `event_name` | Event Name nastavení, `From variable`, nebo `Auto from GA4` |
| `schema_version` | konstantně `v2` |
| `event_type` | konstantně `rtgconv` |
| `event_time` | `Event Time` (kladné celé číslo v ms; hodnota v sekundách se převede) nebo serverový čas. Hodnota 0, záporná nebo nečíselná se nahradí serverovým časem s warningem. |
| `event_source` | `web` nebo `app` |
| `event_url` | První použitelný zdroj: `Event URL` -> GA4 `page_location` (s GA4 prefill) -> `Referer`. Prázdná hodnota, `'undefined'` / `'null'` ani objekt se nepoužijí. Bez zdroje se `event_url` neodešle. |
| `event_id` | `Event ID` -> GA4 `event_id` (s GA4 prefill). Číslo se převede na string. |
| `consent_mode` | Consent Mode Object, normalizovaný (viz [Consent](#consent)) |
| `consent_string` | IAB TCF v2 consent string (viz [Consent](#consent)) |
| `user_ids.user_data` | Skupina User data |
| `event_data` | Skupina Event data |
| `s2s_headers` | IP a User-Agent z event dat GA4 klienta (`ip_override`, `user_agent`), jinak z requestu; Client Hints z requestu. Jen když je povoleno a consent granted. |

### User Data

Každé pole je řádek tabulky **User data** se stejným klíčem. Sloupec „Starší pole (v2.x)“ uvádí dřívější jednotlivé pole, které ve verzi 3 funguje dál (viz [Přechod na verzi 3](#přechod-na-verzi-3)).

| SEM pole / klíč řádku | Starší pole (v2.x) | Poznámka |
|---|---|---|
| `sid` | `sid` | Hodnota ze `sul.js`, nehashovat. Musí mít tvar `id=…\|t=…\|te=…\|c=<32 znaků>`. Pokud chybí nebo nemá tento tvar, použije se cookie `sid`. |
| `udid` | `userUdid` | Hodnota ze `sul.js`, nehashovat. Musí to být UUID; suffix `@timestamp` se ořízne. Pokud chybí nebo není UUID, použije se cookie `udid`. |
| `em` | `userEmail` | SHA-256 email. |
| `ph` | `userPhone` | SHA-256 telefon. |
| `fn` | `userFirstName` | SHA-256 jméno. |
| `ln` | `userLastName` | SHA-256 příjmení. |
| `ge` | `userGender` | SHA-256 gender. |
| `db` | `userDob` | SHA-256 datum narození. |
| `ct` | `userCity` | SHA-256 město. |
| `region` | `userRegion` (a runtime `userState`) | SHA-256 region/stát. `userState` platí jen při prázdném `userRegion`. |
| `zp` | `userZip` | SHA-256 PSČ. |
| `sr` | `userStreet` | SHA-256 ulice. |
| `country` | `userCountry` | SHA-256 země. |
| `subscription_id` | `userSubscriptionId` | Identifikátor subscription. |
| `said`, `id5`, `secid` | — | Identifikátory podle schématu Seznamu. |

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

Alias změní pouze název klíče. Hodnota musí být stále už zahashovaná. Při použití aliasu šablona zaloguje warning a uvede alias v řádku `v2.x settings in use` (například `alias email→em`), aby bylo vidět, že je lepší používat kanonický SEM klíč.

Ostatní klíče mimo SEM schéma `user_data` (`em`, `ph`, `fn`, `ln`, `ge`, `db`, `ct`, `region`, `zp`, `sr`, `country`, `said`, `id5`, `secid`, `subscription_id`, `sid`, `udid`) šablona neodešle a zaloguje warning. Všechny hodnoty jsou stringy; číslo se převede na string.

### Event Data

Každé pole kromě `sem_id` je řádek tabulky **Event data** se stejným klíčem. Sloupec „Starší pole (v2.x)“ uvádí dřívější jednotlivé pole, které ve verzi 3 funguje dál.

| SEM pole / klíč řádku | Starší pole (v2.x) | Poznámka |
|---|---|---|
| `sem_id` | — | Povinné S2S SEM ID, vždy z pole **S2S SEM ID**; `sem_id` v objektu nebo v tabulkách se ignoruje. |
| `sznaiid` | `sznaiid` | Click-through ID. Když chybí, použije se URL nebo cookie. |
| `currency` | `currency` | Seznam přijímá jen `CZK`; jiné měny přepočítejte před odesláním. Jiná měna zaloguje warning. |
| `value` | `value` | Číslo, hodnota **bez DPH** v CZK. Povinné pro Purchase. |
| `value_tax` | `valueTax` | Číslo, DPH k `value`. |
| `order_id` | `orderId` | Povinné pro Purchase. Číslo se převede na string. |
| `content_type` | `contentType` | Pokud existují `contents` a chybí `content_type`, doplní se `product`. |
| `contents` | `contents` | Pole v SEM tvaru, JSON string téhož, nebo GA4 prefill z `items[]`. |
| `product_ids` | `productIds` | Pole nezáporných integer ID produktů pro Zboží.cz, nebo JSON string téhož. |
| `delivery_price` | `deliveryPrice` | Číslo, cena dopravy **s DPH**. |
| `delivery_type` | `deliveryType` | |
| `payment_type` | `paymentType` | |
| `other_costs` | `otherCosts` | Číslo, další náklady nebo slevy **s DPH**. |
| `predicted_ltv` | `predictedLtv` | Číslo. |
| `goods_intention` | `goodsIntention` | Číslo. |
| `goods_phase` | `goodsPhase` | Integer; jiná hodnota se vynechá s warningem. |
| `search_string` | `searchString` | Hlavně pro Search. |
| `review_email` | `reviewEmail` | Plain text, nehashovat. |
| `status` | `statusEnabled` + `status` | Boolean (`true` / `false`). Starší pole Status platí jen se zaškrtnutým *Include status*. |

### Typová normalizace

Po sloučení všech vrstev šablona projde výsledný payload jednou a každou hodnotu převede na typ podle SEM schématu:

- Klíč mimo schéma `event_data`, `user_data` nebo položky `contents` se neodešle a zaloguje se warning.
- Čísla: JS číslo nebo desetinný řetězec s tečkou (`'1234.50'`, `'-5'`). Řetězce `'1 234,50'`, `'1,234'`, `'1e3'` a `'Infinity'` jsou neplatné; šablona nehádá formát čísla podle locale.
- ID (`order_id`, `event_id`, `sznaiid`, `contents[].id`, hodnoty `user_data`): neprázdný string; číslo se převede na string (`0` → `"0"`).
- Řetězce `'undefined'` a `'null'` (typický výsledek rozbitého mapování proměnné) se ve všech klíčích kromě volného textu (`search_string`, `content_name`, `content_category`) berou jako nevyplněné: nepřepíšou hodnotu z dřívější vrstvy a šablona zaloguje warning. Ve volném textu zůstanou jako slova.
- `status`: `true`/`false`, `1`/`0`, `'true'`/`'false'`, ze všech vrstev včetně staršího pole Status. Zaškrtnuté *Include status* bez hodnoty odešle `false`.
- `content_type`: `page`, `product`, `product_group` nebo `search`. Jiná hodnota se vynechá s warningem; když zůstanou `contents`, doplní se `product`.
- GA4 prefill bere jako ID jen string nebo konečné číslo. Objekt, boolean, pole, NaN nebo Infinity v `transaction_id` či `item_id` přeskočí a použije další zdroj (`id`, `orderNo`).
- User Data Object a Event Data Object: prázdný řetězec znamená nevyplněno. Nečitelný JSON nebo jiný typ (`false`, `0`, číslo) šablona vždy zaloguje jako `[ERROR]` a objekt vynechá; hit pokračuje k validaci. Purchase bez `order_id`, `currency` a `value` po sloučení vrstev tag zastaví.
- `contents` a `product_ids` jako JSON string z libovolné vrstvy (tabulka, objekt, starší pole, overrides) šablona rozparsuje až po sloučení vrstev. Nečitelná hodnota nebo hodnota, která není pole, se vynechá s warningem a hodnota z nižší vrstvy se neobnoví.
- Řetězce se ořežou o mezery na začátku a na konci.
- Neplatná nepovinná hodnota se vynechá s warningem. Neplatná povinná hodnota (`order_id`, `currency`, `value` u Purchase) tag zastaví.
- Chybějící hodnota (`undefined`, `null`, prázdný řetězec) nic nepřepisuje. `false`, `0` a `[]` jsou hodnoty.

## Contents - ruční formát

Pokud nepoužíváte GA4 prefill, `contents` posílejte v nativním SEM tvaru, jako pole z GTM proměnné nebo jako JSON string (řádek `contents` v tabulce Event data):

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

Pravidla pro `contents` ze všech zdrojů (GA4 prefill, Event Data Object, tabulka Event data, starší pole Contents a overrides):

- Chybějící `quantity` i řetězec `'null'` / `'undefined'` šablona odešle jako `1`; řetězec zaloguje warning.
- Položka, jejíž `quantity` je vyplněné, ale není celé číslo alespoň 1 (`0`, záporné, `0.5`, `1.9`, `'abc'`, `Infinity`), se zahodí s warningem. Ostatní položky i událost se odešlou.
- Položka nepotřebuje žádný konkrétní klíč (schéma žádný nevyžaduje); šablona ponechá i položku bez `id`, `content_name` a `content_category`.
- Když se zahodí všechny položky, `contents` se neodešle a šablona nedoplní ani `content_type`. Explicitně vyplněné `content_type` zůstane.
- Explicitně předané prázdné pole `[]` se odešle jako `[]`.
- Klíče mimo tabulku výše se zahodí s warningem.

## `sznaiid` first-party cookie

Ve výchozím stavu je zapnuté ukládání `sznaiid` do first-party cookie.

Chování:

1. Šablona hledá `?sznaiid=...` v GA4 `page_location`.
2. Pokud ho nenajde, zkusí `Referer`.
3. Pokud je zapnutá cookie persistence, uloží hodnotu do cookie `sznaiid`. Nový proklik vždy přepíše existující cookie a obnoví její platnost (last touch), stejně jako `sem.js`.
4. Na dalších událostech bez URL parametru použije hodnotu z cookie.
5. `sznaiid` z tabulky Event data, z Event Data Object nebo ze staršího pole má vždy přednost.

Dřívější nastavení *Cookie write strategy* (`first_touch` / `last_touch`) a *Cookie max-age* jsou ve skupině Starší pole (v2.x) a šablona je ignoruje. V řádku `v2.x settings in use` se objeví jen tehdy, když by zápis změnily: uložené `first_touch` při existující cookie, nebo uložená délka jiná než 2592000 s. Cookie s délkou 90 dní zapsané starší verzí zůstanou, dokud je nový proklik nepřepíše nebo nevyprší.

Vypnutí `persistSznaiidCookie` vypne čtení i zápis cookie, ale URL hodnota `?sznaiid=...` se stále může poslat v payloadu.

Šablona cookie zapíše až poté, co payload projde validací. Když tag selže (například chybný consent nebo neúplný Purchase), cookie se nezapíše. Atributy: `Path=/`, doména `auto`, `Secure`, `SameSite=Lax`, bez `HttpOnly`, `Max-Age` pevně 2592000 s (30 dní). Podle dokumentace Seznamu lze `sznaiid` uložit i bez souhlasu uživatele.

## Auto-map sid/udid z cookies

Od verze 2.3 umí šablona načíst `sid` a `udid` z příchozích request cookies jako **fallback**. Ovládá to checkbox **Auto-map sid & udid from request cookies (fallback)** v sekci User Data, ve výchozím stavu **zapnutý**.

Jak to funguje:

1. Pokud je `sid` / `udid` vyplněné explicitně (řádek tabulky User data, User Data Object nebo starší pole) a má správný tvar, použije se ta hodnota. Cookie fallback má **nejnižší prioritu** a doplní hodnotu, když explicitní hodnota chybí nebo nemá správný tvar.
2. `sid` se čte z cookie `sid`. Hodnota obsahuje `=` (`id=...|t=...|te=...|c=...`), ale čte se celá.
3. `udid` se čte z cookie `udid`. Suffix `<uuid>@<timestamp>`, který nastavuje `sul.js`, se ořízne na samotné `uuid`.
4. Explicitní hodnoty i hodnoty z cookies se **validují** proti stejnému tvaru (UUID pro `udid`, `id=…|t=…|te=…|c=<32 znaků>` pro `sid`). Nevalidní hodnota se zahodí a zaloguje se WARN; hodnota se do logu nevypisuje. Kontrola chrání proti chybně namapovaným proměnným i uživatelsky podvrženým cookies.
5. Když payload nakonec neobsahuje platné `sid`, šablona zaloguje WARN `no valid sid`, i když obsahuje jiné identifikátory.

Předpoklady:

- **Same-site SGTM endpoint**, aby cookies vůbec dorazily do server containeru (viz [SGTM endpoint musí být na stejném webu](#sgtm-endpoint-musí-být-na-stejném-webu-same-site)).
- **Consent**: šablona vidí jen příchozí cookie, ne podmínky, za kterých vznikla. `sul.js` vytváří `sid` až po udělení souhlasu. Šablona stejně jako u explicitních polí předává `user_ids` spolu s `consent_mode`; vyhodnocení consentu je na straně Seznamu (viz [Consent](#consent)). Pokud chcete být striktnější, fallback vypněte a posílejte `sid`/`udid` jen explicitně.
- **Safari (ITP)**: WebKit maže cookies vytvořené JavaScriptem, tedy i `sid` a `udid`, po 7 dnech bez interakce uživatele s webem ([WebKit Tracking Prevention](https://webkit.org/tracking-prevention/#intelligent-tracking-prevention-itp)). Dokud je `sul.js` znovu nevytvoří, fallback je nedoplní.

Pokud cookies do SGTM dorazí, nemusíte `sid`/`udid` posílat jako GA4 event parametry (`ep.sid`/`ep.udid`).

## Event ID a deduplikace

`event_id` je doporučené pro deduplikaci. Pokud posíláte stejnou konverzi z frontendu i ze serveru, musí být `event_id` na obou stranách stejné.

Pozor: některé frontendové šablony pro Purchase automaticky generují `event_id` ve tvaru:

```text
Purchase__<order_id>
```

Tato serverová šablona takové ID záměrně automaticky nevytváří. Pokud chcete deduplikovat frontend a server, nastavte `Event ID` na stejnou hodnotu jako na frontendu.

## Merge order

Pole se skládají ve vrstvách. Pozdější vrstva přepisuje předchozí. Pro `event_data`:

1. GA4 prefill - pokud je zapnutý. Patří sem i `contents` z GA4 `items[]`.
2. Event Data Object.
3. `sznaiid` z URL nebo cookie - jen když `sznaiid` zatím chybí.
4. Starší jednotlivá pole (v2.x) a starší Status.
5. Starší tabulka Event Data Overrides (v2.x).
6. Tabulka **Event data**.

Pro `user_ids.user_data`:

1. GA4 prefill (jen `sha256_*` hodnoty).
2. User Data Object (aliasy přeložené na kanonické klíče).
3. Starší jednotlivá pole (v2.x).
4. Starší tabulka User Data Overrides (v2.x).
5. Tabulka **User data**.
6. Cookie fallback `sid`/`udid` - až po všech vrstvách, jen doplní chybějící nebo neplatnou hodnotu.

Po sloučení vrstev šablona výsledný payload jednou normalizuje (viz [Typová normalizace](#typová-normalizace)) a jednou validuje: název události, S2S SEM ID a u Purchase `order_id`, `currency` a `value`. Validuje se přesně ten payload, který se odešle.

Speciální případy:

- Hodnota, která není vyplněná, nikdy nepřepíše hodnotu z dřívější vrstvy. Nevyplněná je hodnota `undefined`, `null`, prázdný řetězec a řetězec `'undefined'` / `'null'` (ten ve všech klíčích kromě volného textu `search_string`, `content_name`, `content_category`). Například `eventDataObject` s `order_id: null` nebo `order_id: 'null'` ponechá `order_id` z GA4 prefill.
- `false`, `0` a `[]` jsou hodnoty. Vyplněná, ale neplatná hodnota přepíše dřívější vrstvu a pak ji normalizace vynechá s warningem; šablona se k dřívější hodnotě nevrací.
- `contents` z Event Data Object, tabulky Event data, staršího pole Contents nebo overrides, včetně prázdného `[]`, nahradí `contents` z GA4 prefill.
- `sid`/`udid` z cookies (`sid`, `udid`) jsou fallback **až po tabulce User data** - doplní se jen když z předchozích vrstev chybí platná hodnota. Viz [Auto-map sid/udid z cookies](#auto-map-sidudid-z-cookies).
- `sem_id` vždy pochází z pole S2S SEM ID.
- Tabulky umí přidat nebo přepsat pole, ale neumí pole odstranit.

## Tabulky Event data a User data

Skupiny **Event data** a **User data** mají tabulku **Klíč – Hodnota**. Klíč vybíráte ze seznamu SEM klíčů (každý klíč nejvýš jednou), hodnotu zadáte textem nebo GTM proměnnou.

- Řádky tabulky mají nejvyšší prioritu: přepíšou GA4 prefill, objekt i starší pole.
- Hodnota se převede na typ daného klíče (čísla, `true`/`false` pro `status`, `contents` a `product_ids` jako pole nebo JSON string). Neplatná hodnota se vynechá s warningem.
- Řádek s prázdnou hodnotou nebo s řetězcem `'undefined'` / `'null'` nic nepřepíše; `false` a `0` jsou hodnoty.
- Tabulka neumí pole odstranit.
- `em`, `ph`, `fn`, `ln`, `ge`, `db`, `ct`, `region`, `zp`, `sr` a `country` musí být SHA-256 hashe z frontendu. `sid`, `udid` a `subscription_id` se posílají tak, jak jsou; `sid` a `udid` šablona kontroluje na tvar.

Starší tabulky **User Data Overrides** a **Event Data Overrides** (klíč zapsaný textem) jsou ve skupině Starší pole (v2.x). Fungují dál s prioritou těsně pod novými tabulkami. Klíč mimo SEM schéma šablona neodešle a zaloguje warning.

## Consent

### Odkud šablona consent bere

Šablona čte consent jen z polí **Consent Mode Object** a **Consent String (IAB TCF)** ve skupině Consent. Nečte ho z GA4 event dat (ani z parametrů `x-ga-gcs` / `x-ga-gcd`) ani z cookies CMP. Stav souhlasu proto musíte do SGTM přenést sami a namapovat ho v každém SEM tagu.

### Přenos stavu souhlasu do SGTM

**Varianta A: parametr GA4 události.** GA4 omezuje hodnotu parametru události na 100 znaků a počítá délku po URL kódování ([limity sběru událostí GA4](https://support.google.com/analytics/answer/9267744)). Pošlete proto jen tři reklamní klíče, s hodnotami `1` (granted) a `0` (denied), které šablona přijímá:

```json
{"ad_storage":1,"ad_user_data":1,"ad_personalization":0}
```

Tato hodnota má 56 znaků, po URL kódování 82. Tvar s řetězci, `{"ad_storage":"granted","ad_user_data":"granted","ad_personalization":"granted"}`, má 80 znaků, ale po URL kódování 118, tedy nad limitem.

1. Na webu přidejte do GA4 události parametr `sem_consent` s touto hodnotou, sestavenou ze skutečné volby uživatele v CMP.
2. V SGTM vytvořte proměnnou typu **Event Data** s Key Path `sem_consent`.
3. Proměnnou přiřaďte do pole **Consent Mode Object** v každém SEM tagu.

Částečný `consent_mode` je platný: schéma vyžaduje alespoň jeden podporovaný klíč (`anyOf`), ne všech pět. Šablona chybějící klíče nedoplňuje. Klíče `ad_storage` a `ad_user_data` otevírají bránu pro `s2s_headers`.

**Varianta B: objekt přes Data Tag a Data Client.** Testovací kontejner předává stav souhlasu jako objekt `consent_state` v event datech z Data Clientu: proměnná **Event Data** `consent_state` je v Purchase tagu namapovaná do Consent Mode Object a všech 8 zalogovaných Purchase hitů z tohoto tagu obsahovalo `consent_mode`. Nejde o parametr GA4 události, takže se na něj limit 100 znaků nevztahuje. Hodnoty `true`/`false` i `granted`/`denied` šablona převede.

U obou variant ověřte v sGTM Preview, že proměnná obsahuje celou hodnotu: objekt nebo JSON string objektu s podporovanými klíči, ne zkrácený řetězec ani obal typu `{"consent_mode": {...}}`. Zkrácený JSON nejde rozparsovat a tag pak podle pravidla pro chybný consent selže.

### Podporované klíče a hodnoty

Podporované klíče: `ad_storage`, `ad_user_data`, `ad_personalization`, `functionality_storage`, `analytics_storage`.

| Vstup | Odešle se |
|---|---|
| `'granted'`, `true`, `1`, `'1'`, `'true'` | `granted` |
| `'denied'`, `false`, `0`, `'0'`, `'false'` | `denied` |

- Mezery na začátku a na konci řetězce se ignorují (`' granted '` je `granted`). Velikost písmen se nemění: `'Granted'` je chyba.
- Klíče, které v objektu jsou, se odešlou. Chybějící klíče šablona nedoplňuje.
- Ostatní klíče (například `wait_for_update`) se ignorují.
- Prázdná hodnota a řetězce `'undefined'` / `'null'` znamenají, že klíč není vyplněný.
- Hodnota `null` také znamená, že klíč není vyplněný: šablona ho vynechá, zaloguje warning a nedoplní ho jako `granted` ani `denied`.
- Když žádný podporovaný klíč nemá hodnotu a Consent String není vyplněný, šablona `consent_mode` neodešle, hit odešle a zaloguje warning `no consent signal`.

### Chybně nastavený consent tag zastaví

Pokud je pole vyplněné, ale chybné, tag skončí jako *Failed* (`gtmOnFailure`), nic neodešle a nezapíše cookie `sznaiid`. Platí to vždy. Chybou je:

- Consent Mode Object, který není objekt ani JSON string objektu, nebo nejde rozparsovat;
- objekt bez podporovaného klíče, například obal `{"consent_mode": {...}}`;
- neplatná hodnota u podporovaného klíče, například `'Granted'`, `'yes'` nebo číslo jiné než `0` a `1`;
- Consent String, který nezačíná `C` nebo obsahuje jiné znaky než `A-Z`, `a-z`, `0-9`, `_`, `.`, `-`.

Šablona zaloguje jeden řádek ve tvaru `Seznam SEM [ERROR]: <pole>: <problém>, got <typ>`, například `Seznam SEM [ERROR]: consentModeObject: expected object with granted/denied values, got string`. Řádek nikdy neobsahuje hodnotu souhlasu. Loguje se vždy, nezávisle na nastavení Console logging: v sGTM Preview je na záložce Console a v produkci v serverových logách (Cloud Logging). Do DevTools prohlížeče se nedostane, protože tag běží na serveru.

### IAB TCF consent string

Seznam vyhodnocuje TCF consent string přednostně před `consent_mode` („Systém vždy upřednostní IAB TCF“, dokumentace Seznamu k consentu; v S2S payloadu „bude upřednostněn“). Pole **Consent String (IAB TCF)** proto vyplňte jen tehdy, když vaše CMP je IAB TCF v2 a má Seznam ve vendor listu. Jinak ho nechte prázdné.

Šablona kontroluje jen syntaxi (první znak `C`, povolené znaky). Kontrola neověřuje, že string je platný TCF ani že obsahuje souhlas pro Seznam; to vyhodnotí Seznam.

### Co šablona s consentem dělá a co ne

- Předá `consent_mode` a `consent_string` Seznamu.
- Hity podle consentu neblokuje. `user_ids`, `review_email` a `sznaiid` se odešlou bez ohledu na stav souhlasu; vyhodnocení je na straně Seznamu. V testovacím kontejneru dostaly odpověď `200` i hity bez consentu nebo bez `sid`/`udid`; samotná odpověď `200` nedokládá, jak Seznam vyhodnotil consent ani atribuci.
- `s2s_headers` (IP adresa, User-Agent, Client Hints) pošle jen když je zapnuté `sendS2sHeaders` a zároveň `consent_mode.ad_storage` i `consent_mode.ad_user_data` jsou `granted`.
- Brána pro `s2s_headers` čte jen `consent_mode`. Nastavení jen s TCF stringem (bez Consent Mode Object) proto `s2s_headers` nikdy neodešle.
- Když se loguje diagnostika (Console logging `always`, nebo `debug` v Preview), zaloguje u každého requestu souhrn consentu, surovou hodnotu GA4 `x-ga-gcs` (jen do logu, do payloadu se nepřevádí) a zdroj `sid` / `udid`.

### Hity před souhlasem a po něm

Ověřeno v testovacím kontejneru 26. 10. 2026 (web s cookie lištou bez IAB TCF, SEM tag s GA4 Auto-Map verze 2.3):

| Hit | Consent | GA4 tag | SEM tag |
|---|---|---|---|
| `page_view` před souhlasem (`gcs=G100`) | denied | spustil se | spustil se |
| stejný `page_view` znovu odeslaný po kliknutí na „Přijmout“ (`gcs=G111`, `gcu=1`) | granted | spustil se | **nespustil se** |
| nový běžný `page_view` na další stránce (`gcs=G111`, bez `gcu`) | granted | spustil se | spustil se |

Trigger SEM tagu neměl žádnou podmínku na consent ani na `gcu`. SGTM tedy na automaticky znovu odeslaném hitu (`gcu=1`) SEM tag nespustí, a pro vstupní stránku dostane SEM jen hit z doby před souhlasem. Šablona to opravit nemůže, protože se na znovu odeslaném hitu vůbec nespustí. Nové běžné události odeslané po udělení souhlasu SEM tag spouštějí normálně.

Stejné chování popisují [Simo Ahava (30. 4. 2024)](https://www.simoahava.com/gtmtips/automatic-page-view-hits-to-sgtm-after-consent-granted/) a dokumentace [Stape Event Generator (14. 4. 2026)](https://community.stape.io/t/event-generator-tag-for-google-tag-manager-server-side/3933). Google parametr `x-ga-gcu` uvádí mezi [interními parametry](https://developers.google.com/tag-platform/tag-manager/server-side/internal-parameters), pravidlo potlačení tagů ale nedokumentuje.

Doporučený postup:

1. CMP načtěte před GTM, nastavte výchozí stav (`default`) i aktualizaci (`update`) a `wait_for_update`.
2. Po udělení souhlasu (a pokud potřebujete `sid`, po načtení identity ze `sul.js`) odešlete samostatnou běžnou událost, například `sem_consent_ready`.
3. Na tuto událost spusťte SEM tag s explicitně nastaveným Event Name `PageView`. Auto mapování názvu z GA4 pomocnou událost nezná.
4. Sjednoťte triggery a Event ID tak, aby se PageView nezapočítal dvakrát, a pomocnou událost podle potřeby vynechte z přeposílání do GA4. Nákupy znovu neodesílejte.

Ověření v sGTM Preview: původní hit se souhlasem denied, znovu odeslaný hit s `x-ga-gcu` a seznam tagů, které se na něm spustily.

## Console logging

Nastavení **Console logging** (`logType`) ve skupině Advanced určuje, které řádky šablona zapíše do logu (sGTM Preview → Console, v produkci Cloud Logging):

| Úroveň | `[WARN]` a diagnostika requestu a odpovědi |
|---|---|
| `no` (Do not log) | nelogují se |
| `debug` (Preview and debug only), výchozí | jen v Preview a debug režimu kontejneru |
| `always` (Always) | vždy, i v produkci |

- Řádky `[ERROR]` se logují vždy.
- Řádek `v2.x settings in use` (viz [Přechod na verzi 3](#přechod-na-verzi-3)) se loguje vždy.
- Režim Preview/debug šablona zjišťuje přes `getContainerVersion` (oprávnění `read_container_data`). Když informace o kontejneru chybí, šablona se chová jako v produkci.
- Zaškrtnutý starší *Test Mode* vynutí úroveň `always`.
- Verze 2.3.1 logovala warningy vždy. Ve verzi 3 se v produkci ve výchozím stavu nelogují; pro dřívější chování zvolte `always`.

## BigQuery logging

BigQuery logging je volitelné a ve výchozím stavu vypnuté. Zapne se nastavením **BigQuery Log Type = `always`** a vyplněním **Project / Dataset / Table** v sekci BigQuery Logs.

### Vytvoření tabulky

Tabulku (a případně dataset) si vytvoř předem. Šablona zapisuje tyto sloupce:

| Sloupec | Typ | Obsah |
|---|---|---|
| `tag_name` | STRING | vždy `"Seznam SEM"` |
| `event_name` | STRING | vyhodnocený název události, pokud je k dispozici (např. `Purchase`) |
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
| Tag skončí jako *Failed* hned, bez requestu | V Console sGTM Preview najděte řádek `Seznam SEM [ERROR]`. Jmenuje pole a problém: chybějící nebo neznámý Event Name, chybějící SEM ID nebo SEM ID mimo `^[0-9a-z]{24}$`, chybný consent, neúplný Purchase. Konec řádku `(v2 loose validation no longer applies)` u neznámého názvu události nebo chybného SEM ID znamená, že tag má uloženou dřívější volbu Strict Event Validation vypnutou: verze 2.3.1 by takový hit odeslala, verze 3 ho zastaví vždy. |
| `[ERROR] consentModeObject…` nebo `[ERROR] consentString…` | Consent Mode Object nebo Consent String je vyplněný, ale chybný. Opravte mapování proměnné podle sekce [Consent](#consent). |
| `[ERROR] userDataObject: …; omitting it` (nebo `eventDataObject`) | Objekt není čitelný JSON ani objekt. Šablona ho vynechala a hit odeslala bez jeho hodnot. Opravte proměnnou. |
| `[ERROR]` na SEM ID | S2S SEM ID musí mít 24 znaků z `0-9` a `a-z`; jiná hodnota tag zastaví. |
| HTTP 401 / 403 | Podle dokumentace Seznamu může 401/403 znamenat chybné SEM ID nebo nepřístupný endpoint. Zkontrolujte, že je v tagu S2S SEM ID ze Skliku, ne SEM ID ze `sul.js`. |
| Purchase selhává | Výsledný payload (po všech vrstvách a normalizaci) musí obsahovat `order_id`, `currency` a číselné `value` bez DPH. Šablona `value` nedopočítává z položek. ERROR řádek jmenuje chybějící pole. |
| Warning `… is not a Seznam field` | Klíč není v SEM schématu a šablona ho neodešle. Přejmenujte ho na SEM klíč nebo ho odstraňte. |
| Warning `…: expected number…; omitting` | Hodnota není číslo ani desetinný řetězec s tečkou. Opravte formát na webu (`1234.50`, ne `1 234,50`). |
| Warning `… is the placeholder string "undefined"` | Proměnná se vyhodnotila na text `undefined` nebo `null`. Šablona hodnotu bere jako nevyplněnou; opravte mapování proměnné. |
| Warning `…quantity…; dropping the item` | Položka má množství 0, záporné, desetinné nebo nečíselné a neodešle se. Opravte data na webu; chybějící množství šablona doplní jako `1`. |
| Warning `no valid sid` | Do SGTM nedorazila platná cookie `sid` ani platná explicitní hodnota. U CMP bez IAB TCF zkontrolujte volání `SEM('updateConsent', …)` (bez něj `sul.js` `sid` nevytvoří), dále same-site endpoint a načtení `sul.js` před GA4. |
| Warning `no consent signal` | Consent Mode Object ani Consent String nejsou v tomto tagu vyplněné, nebo mají všechny klíče prázdnou hodnotu. Namapujte Consent Mode Object v každém SEM tagu, včetně tagů s GA4 prefill (viz [Přenos stavu souhlasu do SGTM](#přenos-stavu-souhlasu-do-sgtm)). |
| `[ERROR]` `Unknown event name` | Název události musí být jeden z 18 podporovaných SEM eventů. `ga4:<název>` je GA4 událost bez mapování 1:1 (viz [Podporované události](#podporované-události)); namapujte ji přes `From variable` nebo samostatným tagem s pevným Event Name. |
| Warning `v2.x settings in use` | Tag používá starší pole z verze 2.x. Postup je v sekci [Přechod na verzi 3](#přechod-na-verzi-3). |
| Warning `transaction_id is no longer used as event_id` | Nastavte Event ID (například `Purchase__` + číslo objednávky), pokud deduplikujete frontend a server. |
| V produkčních logech nejsou warningy | Console logging `debug` loguje warningy jen v Preview a debug režimu. Zvolte `always` (viz [Console logging](#console-logging)). |
| Chybí `event_url` | Vyplňte `Event URL`, zapněte GA4 prefill (`page_location`), nebo zajistěte `Referer`. Bez zdroje se `event_url` neodešle a šablona zaloguje warning. |
| Chybí user_ids | Předávejte minimálně `sid` a `udid` ze `sul.js`, případně zahashované PII. |
| User data se posílají jako raw PII | Hashování musí proběhnout na frontendu před příchodem do SGTM. Serverová šablona nehashuje. |
| `sznaiid` se neukládá do cookie | Zkontrolujte, že je zapnuté `persistSznaiidCookie`, request obsahuje `?sznaiid=...`, tag běží mimo GTM preview ping a tag neselhal (cookie se zapisuje až po úspěšné validaci). |
| API errors | Zkontrolujte S2S SEM ID, payload shape a error logs (obsahují `x-request-id`). Tělo chybové odpovědi Seznamu je v diagnostickém řádku Response (Console logging `always`, nebo `debug` v Preview). Při ladění vypněte optimistic scenario. Request má timeout 5 s. |
