# Seznam SEM (Server-Side) - Changelog

## 2.3.1 (unreleased)

Correctness patch for the v2.3 line. The tag now assembles all input layers, normalizes the result once and validates that final payload once, so what is checked is what is sent. No UI parameter is removed or renamed, no default value changes, and no permission is added. `X-Client-Version` and `api.template_version` report `2.3.1`.

### Upgrade notes

Every item below changes what an existing tag sends or whether it fails. After updating, check each one that applies to your setup, then work through the Preview checklist.

1. **A Purchase without an explicit value fails.** The template no longer derives `value` from the GA4 items (`unit_price × quantity`). `unit_price` includes VAT, `value` excludes it, and a partly priced item list was accepted as the whole order. Send the order value without VAT, in CZK, through the Value field, the Event Data Object, an override row, or GA4 `value` / `revenue` / `totalWithoutVat` with GA4 Auto-Map. Other events are sent without `value` when none is supplied.
2. **A malformed consent configuration fails the tag.** If **Consent Mode Object** is set but is not an object or JSON object string, has no supported key (for example the wrapper `{consent_mode: {...}}`), or has an invalid value on a supported key (`'Granted'`, `'yes'`, `null`), the tag calls `gtmOnFailure`, sends nothing and writes no cookie. The same applies when **Consent String (IAB TCF)** is set but does not start with `C` or contains characters other than `A-Z a-z 0-9 _ . -`. The Console shows one line, `Seznam SEM [ERROR]: <field>: <problem>, got <type>`; it never contains a consent value. This happens regardless of Strict Event Validation. Empty values and the strings `'undefined'` / `'null'` count as absent and do not fail the tag.
3. **An item with an invalid quantity is dropped.** In `contents` from every source (GA4 items, Event Data Object, Contents field, overrides), a missing quantity is sent as `1`, and an item whose quantity is present but not a whole number of at least 1 (`0`, negative, `0.5`, `1.9`, non-numeric, `Infinity`) is dropped with a WARN. The other items and the event are still sent. If every item is dropped, `contents` is omitted, and so is a `content_type` that the template would have generated for it. Before 2.3.1, GA4 quantities were floored (`1.9` → `1`, `0.5` → `0`) and other sources were not checked.
4. **The SEM ID is checked against `^[0-9a-z]{24}$`.** Uppercase letters or other characters now fail the tag under Strict Event Validation. Without Strict, the tag logs a WARN and still sends the hit, which Seznam rejects.
5. **The request times out after 5 seconds** (previously the 15 s platform default). A timeout logs `request to Seznam failed: timed_out`; it fails the tag when Use Optimistic Scenario is off.
6. **Unknown keys are dropped with a WARN.** Keys outside the Seznam schema in `event_data`, `user_data` and `contents` items (for example GA4-shaped `email_address`, or a misspelled key) are no longer forwarded. Override rows with an unknown property name are dropped the same way.
7. **Values are converted to their wire types; invalid optional values are omitted with a WARN.** Numbers must be finite numbers or plain decimal strings (`'1234.50'`); locale formats such as `'1 234,50'` or `'1,234'`, `'1e3'` and `'Infinity'` are invalid. A Purchase whose value is invalid therefore fails. A non-integer `goods_phase` is omitted (before 2.3.1 it was sent with a WARN). IDs are strings: numeric `order_id`, `event_id` and `contents[].id` are converted, and `'undefined'` / `'null'` IDs are dropped. String values are trimmed. `status` is a boolean from every layer.
8. **Explicit sid and udid pass the same shape check as the cookies.** A `sid` from the SID field, the User Data Object or an override must have the sul.js shape `id=…|t=…|te=…|c=<32 characters>`, and a `udid` must be a UUID (a `@<timestamp>` suffix is stripped). A malformed explicit value is dropped with a WARN, and the request cookie fills the gap when it is valid. A hit without a valid sid logs a WARN.
9. **A missing value in a later layer no longer erases an earlier one.** An Event Data Object with `order_id: null` or `value: ''` keeps the GA4 Auto-Map value instead of overwriting it.
10. **Override rows with `false` or `0` are applied**, and `'false'` is sent as boolean `false` (before 2.3.1 a boolean `false` row was ignored and `'false'` was sent as a string). `sem_id` in the Event Data Object or the overrides is ignored; it always comes from the S2S SEM ID field.
11. **Event Time:** `0`, negative, non-numeric and non-finite values fall back to server time with a WARN; fractional milliseconds are rounded.
12. **Consent values are normalized.** `true`/`1`/`'1'`/`'true'` are sent as `granted`, `false`/`0`/`'0'`/`'false'` as `denied`. Before 2.3.1 only booleans were converted. Missing keys are not filled. A hit with no consent signal at all logs a WARN.
13. **The sznaiid cookie uses the documented option names** `sameSite: 'lax'` and `httpOnly: false` (previously `samesite: 'Lax'` and `HttpOnly: false`). First-touch mode and the 90-day max-age are unchanged.

### Preview checklist

1. Import `template.tpl`, keep the existing permissions, and run the template's tests in the editor (Templates → Seznam SEM (Server-Side) → Tests).
2. In each production tag, turn **Use Optimistic Scenario** off for the test session, so the tag status reflects the API response.
3. Fire a Purchase. The tag status is *Succeeded*. In the outgoing request to `sem.seznam.cz/rtgconv`, `event_data` contains `order_id` (string), `currency` and `value` (number, without VAT).
4. Read the Console for the tag. An `[ERROR]` line means the tag failed. Fix the named field. `[WARN]` lines name the dropped keys, invalid values and dropped items; each one is a mapping to correct.
5. Check consent: the resolved Consent Mode Object variable is an object (or JSON object string) with supported keys, and the outgoing `consent_mode` contains only `granted` / `denied`. Leave Consent String empty unless the CMP is IAB TCF v2 and lists Seznam.
6. Check `user_ids.user_data`: `sid` and `udid` are present when the `sid` / `udid` cookies reach the server container, and no "no valid sid" WARN appears for consenting users.
7. Open a page with `?sznaiid=TEST` and check the `Set-Cookie` response header: `sznaiid=TEST`, `SameSite=Lax`, `Secure`, `Max-Age=7776000`, no `HttpOnly`.
8. If Strict Event Validation is on, confirm that the S2S SEM ID is 24 characters of `0-9` and `a-z`.
9. Optionally enable **Test Mode**: the `Request` log line shows the consent summary, the raw GA4 `x-ga-gcs` value and the source of `sid` / `udid` (`tag`, `cookie` or `missing`).
10. Switch Use Optimistic Scenario back to your production setting.

### Fixed

- Purchase validation ran on `data.*` and GA4 values instead of the payload, so a valid Purchase in the default Object mode or in the overrides failed, and a valid GA4 Purchase could be sent with `order_id: null`. One validation now runs on the final payload.
- GA4 contents overwrote the Event Data Object's `contents`, including an explicit `[]`. GA4 contents are now the lowest layer.
- NaN and Infinity reached the wire as `null`; unknown keys, `null` and placeholder IDs were forwarded; numeric IDs were sent as numbers; object `product_ids` were not normalized.
- `quantity` 0, negative and fractional values were sent.
- The value fallback summed VAT-inclusive item prices into the VAT-exclusive `value`.
- Consent values other than booleans were forwarded unchanged, and malformed consent JSON was only a WARN.
- The rejection handler discarded the transport error; 401/403 responses gave no hint.
- `event_time` could be 0, negative, fractional or non-finite.
- The sznaiid cookie was written before validation; it is now written only after the payload passed validation.
- `X-Client-Version` and `api.template_version` reported `2.2.1` in 2.3.0.

### Added

- 401/403 responses log a hint to use the S2S SEM ID from Sklik, not the sul.js SEM ID. HTTP error lines include the `x-request-id`.
- The Test Mode request line includes a consent summary, the raw GA4 `x-ga-gcs` value (logged only, never decoded into the payload) and the identity source.

### Notes

- Tests: 70 → 137 scenarios, with a shared `setup:` block. They cover the P0 rows of the review regression matrix.
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
