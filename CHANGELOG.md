# Seznam SEM (Server-Side) - Changelog

## 2.3.1 (unreleased)

Correctness patch for the v2.3 line. The tag now assembles all input layers, normalizes the result once and validates that final payload once, so what is checked is what is sent. No UI parameter is removed or renamed, no default value changes, and no permission is added. The INFO description is shortened to 176 characters, because the GTM editor rejects more than 200. `X-Client-Version` and `api.template_version` report `2.3.1`.

### Upgrade notes

Every item below changes what an existing tag sends or whether it fails. After updating, check each one that applies to your setup, then work through the Preview checklist.

1. **A Purchase without an explicit value fails.** The template no longer derives `value` from the GA4 items (`unit_price × quantity`). `unit_price` includes VAT, `value` excludes it, and a partly priced item list was accepted as the whole order. Send the order value without VAT, in CZK, through the Value field, the Event Data Object, an override row, or GA4 `value` / `revenue` / `totalWithoutVat` with GA4 Auto-Map. Other events are sent without `value` when none is supplied.
2. **A malformed consent configuration fails the tag.**
   - **Consent Mode Object** fails the tag when it is set but:
     - is not an object or JSON object string;
     - has no supported key (for example the wrapper `{consent_mode: {...}}`);
     - has an invalid value on a supported key (`'Granted'`, `'yes'`, a number other than `0`/`1`).
   - **Consent String (IAB TCF)** fails the tag when it is set but does not start with `C` or contains characters other than `A-Z a-z 0-9 _ . -`.
   - On failure the tag calls `gtmOnFailure`, sends nothing and writes no cookie, regardless of Strict Event Validation. The Console shows one line, `Seznam SEM [ERROR]: <field>: <problem>, got <type>`; it never contains a consent value.
   - What does not fail:
     - Surrounding spaces are ignored (`' granted '` is granted); there is no case folding, so `' Granted '` still fails.
     - Empty values and the strings `'undefined'` / `'null'` count as absent.
     - An actual `null` on a supported key counts as missing: that key is omitted with a WARN and never filled in as granted or denied.
3. **An item with an invalid quantity is dropped.** This applies to `contents` from every source (GA4 items, Event Data Object, Contents field, overrides).
   - A missing quantity, or the string `'null'` / `'undefined'`, is sent as `1`; the placeholder logs a WARN.
   - An item whose quantity is present but not a whole number of at least 1 (`0`, negative, `0.5`, `1.9`, `'abc'`, `Infinity`) is dropped with a WARN. The other items and the event are still sent.
   - If every item is dropped, `contents` is omitted, and so is a `content_type` that the template would have generated for it.
   - Before 2.3.1, GA4 quantities were floored (`1.9` → `1`, `0.5` → `0`) and other sources were not checked.
4. **The SEM ID is checked against `^[0-9a-z]{24}$`,** the pattern the schema requires. On a mismatch, Strict Event Validation fails the tag locally. Without Strict, the tag logs a WARN and sends the hit, with no guaranteed outcome at Seznam. In the playground, hits without consent or sid/udid also received `200`. All logged hits used a valid-format SEM ID, so they say nothing about a malformed ID. A `200` response alone does not establish downstream consent evaluation or attribution.
5. **The request times out after 5 seconds** (previously the 15 s platform default). A timeout logs `request to Seznam failed: timed_out`; it fails the tag when Use Optimistic Scenario is off.
6. **Unknown keys are dropped with a WARN.** Keys outside the Seznam schema in `event_data`, `user_data` and `contents` items (for example GA4-shaped `email_address` or `item_id`, or a misspelled key) are no longer forwarded. Override rows with an unknown property name are dropped the same way.
7. **Values are converted to their wire types; invalid optional values are omitted with a WARN.**
   - Numbers must be finite numbers or plain decimal strings (`'1234.50'`). Locale formats such as `'1 234,50'` or `'1,234'`, and `'1e3'` and `'Infinity'`, are invalid, so a Purchase whose value is invalid fails.
   - A non-integer `goods_phase` is omitted (before 2.3.1 it was sent with a WARN).
   - `content_type` must be `page`, `product`, `product_group` or `search`; any other value is omitted, and `product` is used when contents remain.
   - IDs are strings: numeric `order_id`, `event_id` and `contents[].id` are converted (`0` becomes `"0"`).
   - String values are trimmed.
   - `status` is a boolean from every layer, including the Status field (`true`/`false`, `1`/`0`, `'true'`/`'false'`).
   - GA4 Auto-Map no longer turns objects, booleans, arrays, NaN or Infinity into strings: such a GA4 `transaction_id` or `item_id` is skipped, and the next alias (`id`, `orderNo`) is used. A GA4 Purchase that used to be sent with `order_id: "[object Object]"` now fails unless an alias holds a valid ID.
8. **Explicit sid and udid pass the same shape check as the cookies.** A `sid` from the SID field, the User Data Object or an override must have the sul.js shape `id=…|t=…|te=…|c=<32 characters>`, and a `udid` must be a UUID (a `@<timestamp>` suffix is stripped). A malformed explicit value is dropped with a WARN, and the request cookie fills the gap when it is valid. A hit without a valid sid logs a WARN.
9. **Merge contract: a value that is not supplied never erases an earlier layer.**
   - "Not supplied" means `undefined`, `null`, a blank string, or the placeholder `'undefined'` / `'null'`.
   - The rule covers every key except the free-text keys `search_string`, `content_name` and `content_category`, which keep those words literally. It applies to the GA4, object, field and override layers, to `event_id`, and to the frontend-alias choice in the User Data Object.
   - Example: an Event Data Object with `order_id: 'null'` or `value: ''` keeps the GA4 Auto-Map value instead of overwriting it, and logs a WARN for the placeholder.
   - `false`, `0` and `[]` are values. A supplied but invalid value still overrides the earlier layer and is then normalized and validated; there is no silent fallback.
10. **Override rows with `false` or `0` are applied**, and `'false'` is sent as boolean `false` (before 2.3.1 a boolean `false` row was ignored and `'false'` was sent as a string). `sem_id` in the Event Data Object or the overrides is ignored; it always comes from the S2S SEM ID field.
    - CompleteRegistration gets the default `status: true` only when no layer supplied a status. An invalid status (for example an override `'no'`) is omitted with a WARN instead of being sent as `true`.
    - An enabled Status field without a value still sends `false`.
11. **Event Time:** `0`, negative, non-numeric and non-finite values fall back to server time with a WARN; fractional milliseconds are rounded.
12. **Consent values are normalized.** `true`/`1`/`'1'`/`'true'` are sent as `granted`, `false`/`0`/`'0'`/`'false'` as `denied`. Before 2.3.1 only booleans were converted. Missing and `null` keys are not filled. When no supported key has a value and no Consent String is set, `consent_mode` is omitted and the hit logs a "no consent signal" WARN.
13. **The sznaiid cookie uses the documented option names** `sameSite: 'lax'` and `httpOnly: false` (previously `samesite: 'Lax'` and `HttpOnly: false`). First-touch mode and the 90-day max-age are unchanged.
14. **Purchases with their fields in the Event Data Object or the overrides are now sent.** Before 2.3.1 they failed validation, so no hit reached Seznam. If you added a workaround (for example a second Purchase tag with Individual fields), review triggers and Event IDs and remove the workaround tag only after you have verified the fixed tag in Preview, to avoid double counting. Do not delete Purchase tags mechanically.
15. **Normalized consent values can open the `s2s_headers` gate.** The gate needs `ad_storage` and `ad_user_data` to be `granted`. Values such as `1`, `'1'` or `'true'` now count as granted, so IP address, User-Agent and Client Hints are sent on hits that did not carry them before. Check that your consent mapping means what it says.
16. **The Event Data Object's `contents` now win over GA4 items.** Before 2.3.1 the GA4 items replaced them, even an explicit `[]`. With GA4 Auto-Map on, check which product list you send.
17. **JSON input fields:** `false` and `0` in the User Data Object, Event Data Object, Contents or Product IDs field are input errors (Strict fails the tag, loose logs an ERROR); blank strings count as empty.

### Preview checklist

1. Import `template.tpl`, keep the existing permissions, and run the template's tests in the editor (Templates → Seznam SEM (Server-Side) → Tests).
2. In each production tag, turn **Use Optimistic Scenario** off for the test session, so the tag status reflects the API response.
3. Fire a Purchase. The tag status is *Succeeded*. In the outgoing request to `sem.seznam.cz/rtgconv`, `event_data` contains `order_id` (string), `currency` and `value` (number, without VAT).
4. Read the Console for the tag.
   - An `[ERROR]` line names a configuration or transport problem. Under loose validation and in optimistic mode the tag can still show *Succeeded*; malformed consent always fails it.
   - `[WARN]` lines are diagnostics: dropped keys, invalid values, dropped items, placeholders. Some are legitimate for your setup: "no consent signal", "no valid sid", a generated `content_type`.
5. Check consent:
   - The resolved Consent Mode Object variable is an object (or JSON object string) with supported keys, and the outgoing `consent_mode` contains only `granted` / `denied`.
   - Every SEM tag, including GA4 Auto-Map tags, has the Consent Mode Object mapped.
   - Leave Consent String empty unless the CMP is IAB TCF v2 and lists Seznam.
6. Check `user_ids.user_data`: `sid` and `udid` are present when the `sid` / `udid` cookies reach the server container, and no "no valid sid" WARN appears for consenting users. With a non-TCF CMP this requires the `SEM('updateConsent', …)` call described in the README.
7. Open a page with `?sznaiid=TEST` and check the `Set-Cookie` response header: `sznaiid=TEST`, `SameSite=Lax`, `Secure`, `Max-Age=7776000`, no `HttpOnly`.
8. If Strict Event Validation is on, confirm that the S2S SEM ID is 24 characters of `0-9` and `a-z`.
9. Optionally enable **Test Mode**: the `Request` log line shows the consent summary, the raw GA4 `x-ga-gcs` value and the source of `sid` / `udid` (`tag`, `cookie` or `missing`).
10. Switch Use Optimistic Scenario back to your production setting.

### Fixed

- Purchase validation ran on `data.*` and GA4 values instead of the payload, so a valid Purchase in the default Object mode or in the overrides failed, and a valid GA4 Purchase could be sent with `order_id: null`. One validation now runs on the final payload.
- GA4 contents overwrote the Event Data Object's `contents`, including an explicit `[]`. GA4 contents are now the lowest layer.
- NaN and Infinity reached the wire as `null`; unknown keys, `null` and placeholder IDs were forwarded; numeric IDs were sent as numbers; object `product_ids` were not normalized.
- GA4 Auto-Map stringified any value for `order_id`, item `id` and `content_name` (`"[object Object]"`, `"true"`, `"A,B"`).
- An actual `null` in a later layer kept the earlier value, but the string `'null'` erased it.
- `quantity` 0, negative and fractional values were sent.
- The value fallback summed VAT-inclusive item prices into the VAT-exclusive `value`.
- Consent values other than booleans were forwarded unchanged, and malformed consent JSON was only a WARN.
- `content_type` was not checked against its enum.
- The Status field turned any value other than `true`/`'true'` into `false`, and CompleteRegistration turned an invalid status into `true`.
- The JSON input fields treated `false` and `0` as empty.
- The rejection handler discarded the transport error; 401/403 responses gave no hint.
- `event_time` could be 0, negative, fractional or non-finite.
- The sznaiid cookie was written before validation; it is now written only after the payload passed validation.
- `X-Client-Version` and `api.template_version` reported `2.2.1` in 2.3.0.
- The INFO description had 268 characters (since 2.3.0); the GTM editor marks more than 200 as invalid input.
- Two test scenarios used ES6 object shorthand, which the GTM test parser rejects.
- ERROR lines, which are logged whatever Test Mode holds, could carry payload values, PII and consent values: a BigQuery insert failure logged the rejected row with its `request_body`, the HTTP ERROR an excerpt of the response body, and a transport rejection its serialized object. The BigQuery line now logs only a reason code from BigQuery's documented error table (any other reason as `unknown`) and the row count; the HTTP line has no `body=` (the body stays in the Test Mode Response line); a transport rejection logs `failed`, `timed_out` or `unknown`.
- A `page_location` that is not a string (an object, number, boolean or array written by a client other than GA4) threw in the sznaiid lookup before any callback. It is now skipped like a missing value: GA4 Auto-Map does not take it as `event_url`, and the Referer fallback applies.

### Added

- 401/403 responses log a hint to use the S2S SEM ID from Sklik, not the sul.js SEM ID. HTTP error lines include the `x-request-id`.
- The Test Mode request line includes a consent summary, the raw GA4 `x-ga-gcs` value (logged only, never decoded into the payload) and the identity source.

### Release gates

2.3.1 is a compatibility-preserving patch candidate. These gates must pass before the release commit:

1. One green run of the embedded test suite in a connected GTM editor, recorded with the file hash. **Open.** No green editor test run is recorded: in Matěj's container the editor's test runner never produced results. Attempts produced a generic "Invalid input" and/or "Unable to connect to the tag server", with timing-dependent results; the cause remains unisolated (`review/gtm-verification/p0-editor-run.md`). The Node runner reports 166/166. This gate stays open until the agreed editor run passes or Matěj explicitly changes the gate.
2. Preview of the upgraded playground tags (17 and 20): payloads, consent behavior and `Set-Cookie`. **Partly done:** HEAD 551bb2d was verified at runtime in real sGTM: the existing tag 17 fired on the upgraded template, rtgconv answered `200`, `api.template_version` was `2.3.1`, and `sid`/`udid` came from the cookie fallback; no permission dialog appeared on import. Tag 20 (Purchase with the consent object) and the `Set-Cookie` check are still open.
3. The README consent transport verified end to end (browser → GA4 client event data → mapped variable → outgoing `consent_mode`).
4. The "(unreleased)" label replaced by the release date only in the release commit; `metadata.yaml` re-pinned after the push.

### Notes

- Tests: 70 → 177 scenarios, with a shared `setup:` block. They cover the P0 rows of the review regression matrix and the P0 review fixes. Valid hits assert exactly one request; failures assert none.
- The WARN for a payload without `user_ids` now states only what is observable: "no valid sid/udid/hashed PII is present; hit is sent without user_ids".
- Items in `contents` need no particular key (the schema requires none). Whether items without `id`, `content_name` and `content_category` should be dropped is an open product decision; 2.3.1 keeps them.
- Deliberately unchanged in 2.3.1 (planned for v3): the optimistic default, Strict Event Validation, first-touch sznaiid, the GA4 event-name map, `transaction_id` as an `event_id` fallback, the frontend-template aliases, BigQuery logging, and the pass-through of identifiers and `review_email` regardless of consent.

## 2.3.0 - 2026-06-24

Commit `dce9231`.

### Added

- `sid` and `udid` are read from the request cookies as the lowest-priority fallback (checkbox, default on). Cookie values are shape-checked, and the `@<timestamp>` suffix is stripped from `udid`.
- User Data and Event Data input mode selectors (Object variable / Individual fields); SID and UDID are grouped together.
- `get_cookies` permission extended with `sid` and `udid`.
- README: BigQuery log table schema and DDL, cookie fallback section, updated permissions and naming.
- Tests for the cookie fallback (read, udid normalization, precedence, malformed values).

### Changed

- Template renamed to "Seznam SEM (Server-Side)" with a reworded description.
- Event ID help: frontend template name dropped, deduplication guidance kept.

### Fixed

- `USER_DATA_ALIAS_MAP` is declared before the main flow. The sandbox hoists `const` declarations var-style, so in 2.2.x the tag crashed whenever a User Data Object was mapped.

### Known issues (fixed in 2.3.1)

- `X-Client-Version` and `api.template_version` still reported `2.2.1`.
- A Purchase with its fields only in the Event Data Object (the default input mode) or in the overrides failed validation.
- See the 2.3.1 "Fixed" list for the payload normalization issues.
