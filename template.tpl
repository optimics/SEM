___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_seznam_sem",
  "version": 1,
  "displayName": "Seznam SEM (Server-Side)",
  "categories": [
    "ADVERTISING",
    "CONVERSIONS",
    "MARKETING"
  ],
  "brand": {
    "id": "seznam_sem",
    "displayName": "Seznam SEM"
  },
  "description": "Server-side GTM tag that sends conversion events to the Seznam SEM API (rtgconv). Object or per-field mapping, optional GA4 auto-map, consent mode and sid/udid cookie fallback.",
  "containerContexts": [
    "SERVER"
  ],
  "securityGroups": []
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "eventNameSelect",
    "displayName": "Event Name",
    "selectItems": [
      { "value": "auto", "displayValue": "Auto from GA4 (requires GA4 Auto-Map)" },
      { "value": "PageView", "displayValue": "PageView" },
      { "value": "ViewContent", "displayValue": "ViewContent" },
      { "value": "Purchase", "displayValue": "Purchase" },
      { "value": "Contact", "displayValue": "Contact" },
      { "value": "AddToCart", "displayValue": "AddToCart" },
      { "value": "AddToWishlist", "displayValue": "AddToWishlist" },
      { "value": "InitiateCheckout", "displayValue": "InitiateCheckout" },
      { "value": "AddPaymentInfo", "displayValue": "AddPaymentInfo" },
      { "value": "Search", "displayValue": "Search" },
      { "value": "CompleteRegistration", "displayValue": "CompleteRegistration" },
      { "value": "Lead", "displayValue": "Lead" },
      { "value": "Subscribe", "displayValue": "Subscribe" },
      { "value": "CustomizeProduct", "displayValue": "CustomizeProduct" },
      { "value": "Donate", "displayValue": "Donate" },
      { "value": "FindLocation", "displayValue": "FindLocation" },
      { "value": "Schedule", "displayValue": "Schedule" },
      { "value": "StartTrial", "displayValue": "StartTrial" },
      { "value": "SubmitApplication", "displayValue": "SubmitApplication" },
      { "value": "from_variable", "displayValue": "— From variable —" }
    ],
    "simpleValueType": true,
    "defaultValue": "PageView",
    "help": "Select a Seznam event name, choose 'From variable' to wire a GTM variable that resolves to a supported Seznam event name, or 'Auto from GA4' to derive the name from the inbound GA4 event_name (requires GA4 Auto-Map enabled below).",
    "valueValidators": [{ "type": "NON_EMPTY" }]
  },
  {
    "type": "TEXT",
    "name": "eventNameFromVariable",
    "displayName": "Event Name from Variable",
    "simpleValueType": true,
    "help": "Assign a GTM variable that resolves to one of the 18 supported Seznam event names (PageView, ViewContent, Purchase, Contact, AddToCart, AddToWishlist, InitiateCheckout, AddPaymentInfo, Search, CompleteRegistration, Lead, Subscribe, CustomizeProduct, Donate, FindLocation, Schedule, StartTrial, SubmitApplication). Values outside this allowlist log a WARN and fail the tag under 'Strict Event Validation'. Custom (non-allowlist) event names are NOT supported by Seznam.",
    "enablingConditions": [
      {
        "paramName": "eventNameSelect",
        "paramValue": "from_variable",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [{ "type": "NON_EMPTY" }]
  },
  {
    "type": "TEXT",
    "name": "semId",
    "displayName": "S2S SEM ID (Sklik)",
    "simpleValueType": true,
    "help": "Your S2S SEM ID — visible in Sklik account settings under 'Show advanced settings'. This is a SEPARATE identifier from the SEM ID used by the frontend sul.js script. Required for S2S tracking. Must be 24 characters of 0-9 and a-z; any other value fails the tag under 'Strict Event Validation' and logs a warning otherwise.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "eventSource",
    "displayName": "Event Source",
    "selectItems": [
      {
        "value": "web",
        "displayValue": "Web"
      },
      {
        "value": "app",
        "displayValue": "App"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "web",
    "help": "Source of the event — web or app."
  },
  {
    "type": "TEXT",
    "name": "eventUrl",
    "displayName": "Event URL (optional)",
    "simpleValueType": true,
    "help": "Page URL for the event. Falls back to the Referer header if left empty."
  },
  {
    "type": "TEXT",
    "name": "eventId",
    "displayName": "Event ID (optional)",
    "simpleValueType": true,
    "help": "Unique event ID for deduplication. To dedupe across frontend and server tracking, the SAME event_id MUST be used on both sides. For Purchase events, frontend tracking commonly uses 'Purchase__' + order_id when no explicit event ID is set — to align, use the same value (or a shared variable) here."
  },
  {
    "type": "TEXT",
    "name": "eventTime",
    "displayName": "Event Time (optional)",
    "simpleValueType": true,
    "help": "Event timestamp in milliseconds. Seconds input is auto-upscaled to ms and fractional milliseconds are rounded. Falls back to server time if empty; a value that is not a positive number (0, negative, non-numeric) also falls back to server time, with a warning."
  },
  {
    "type": "GROUP",
    "name": "autoMapGroup",
    "displayName": "GA4 Auto-Map (opt-in)",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableGa4AutoMap",
        "checkboxText": "Enable GA4 auto-map",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Reads inbound GA4 event and pre-fills SEM event_data, contents, event_url, event_id, and hashed sha256_* user_data only. Raw PII (email/phone/name/address) is never auto-forwarded — the template does not hash. Explicit fields below always override (Layer 0 precedence). Consent is not auto-mapped: map the Consent Mode Object on this tag too. Off by default to preserve v2.0 GA4 decoupling."
      },
      {
        "type": "CHECKBOX",
        "name": "autoMapEventName",
        "checkboxText": "Auto-map event name (when Event Name is \"Auto from GA4\")",
        "simpleValueType": true,
        "defaultValue": false,
        "enablingConditions": [
          { "paramName": "enableGa4AutoMap", "paramValue": true, "type": "EQUALS" }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "autoMapUserData",
        "checkboxText": "Auto-map hashed user_data (sha256_* only)",
        "simpleValueType": true,
        "defaultValue": true,
        "enablingConditions": [
          { "paramName": "enableGa4AutoMap", "paramValue": true, "type": "EQUALS" }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "autoMapEventData",
        "checkboxText": "Auto-map event_data + contents",
        "simpleValueType": true,
        "defaultValue": true,
        "enablingConditions": [
          { "paramName": "enableGa4AutoMap", "paramValue": true, "type": "EQUALS" }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "consentGroup",
    "displayName": "Consent",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "TEXT",
        "name": "consentModeObject",
        "displayName": "Consent Mode Object (optional)",
        "simpleValueType": true,
        "help": "A GTM variable resolving to a consent_mode object, or a JSON string of one. Supported keys: ad_storage, ad_user_data, ad_personalization, functionality_storage, analytics_storage. Accepted values: 'granted'/'denied', true/false, 1/0 and '1'/'0'/'true'/'false' (surrounding spaces are ignored, letter case is not); they are sent as 'granted'/'denied'. Map this field on every SEM tag, including GA4 Auto-Map tags: auto-map does not derive consent. Supported keys are forwarded as present and missing keys are not filled. Other keys (e.g. wait_for_update) are ignored. A null value counts as missing: that key is omitted with a warning. If the variable is set but malformed (not an object, no supported key, or an invalid value such as 'Granted', 'yes' or 2 on a supported key), the tag fails with an ERROR and sends nothing."
      },
      {
        "type": "TEXT",
        "name": "consentString",
        "displayName": "Consent String (IAB TCF)",
        "simpleValueType": true,
        "help": "IAB TCF v2 consent string from your CMP. Seznam evaluates the TCF string in preference to consent_mode, so leave this empty unless your CMP is IAB TCF v2 and lists Seznam as a vendor. The template checks the syntax only (starts with C; letters, digits, _ . -); a value that fails the check fails the tag with an ERROR. Empty values and the strings 'undefined'/'null' count as absent."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "userDataGroup",
    "displayName": "User Data",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SELECT",
        "name": "userDataInputMode",
        "displayName": "User Data input mode",
        "macrosInSelect": false,
        "selectItems": [
          { "value": "object", "displayValue": "Object variable" },
          { "value": "fields", "displayValue": "Individual fields" }
        ],
        "simpleValueType": true,
        "defaultValue": "object",
        "help": "Choose how to provide user data. 'Object variable': one GTM variable resolving to an object with SEM-native keys. 'Individual fields': map each field separately. Both produce the same payload; the cookie sid/udid fallback below applies to either mode."
      },
      {
        "type": "TEXT",
        "name": "userDataObject",
        "displayName": "User Data Object",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "object", "type": "EQUALS" }
        ],
        "help": "A GTM variable resolving to an object with user data fields. SEM-native keys (em, ph, fn, ln, ge, db, ct, region, zp, sr, country, subscription_id, sid, udid) are used as-is. Frontend-template aliases (email, phone, fname, lname, gender / g, birth / birthDate, postalCode / zip, subscription / subscriptionId) are translated to canonical names with a WARN log. Other keys, including GA4-shaped keys (email_address, phone_number, nested address), are dropped with a warning. All PII values must already be SHA-256 hashed — the server template never hashes."
      },
      {
        "type": "TEXT",
        "name": "sid",
        "displayName": "SID (Seznam Identity)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Seznam SID cookie value — primary user identifier for S2S. Obtain via window.sznIVA.IS.getIdentity('sid') after loading sul.js, or leave empty to use the cookie fallback below. The value must have the sul.js shape id=…|t=…|te=…|c=<32 characters>; a malformed value is ignored with a warning and the cookie fallback can fill it."
      },
      {
        "type": "TEXT",
        "name": "userUdid",
        "displayName": "UDID (udid)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Unique user/device ID. Server-side template does not hash this value. If left empty and 'Auto-map sid & udid from request cookies' is on, it is read from the 'udid' cookie (the '<uuid>@<timestamp>' suffix is stripped to the canonical uuid). The value must be a UUID; a '@<timestamp>' suffix is stripped here too, and a malformed value is ignored with a warning so the cookie fallback can fill it."
      },
      {
        "type": "TEXT",
        "name": "userEmail",
        "displayName": "Email (em)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of the normalized email (lowercase + trim). Hashing must be done on the frontend — the server-side template does not hash."
      },
      {
        "type": "TEXT",
        "name": "userPhone",
        "displayName": "Phone (ph)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of the phone in E.164 format (e.g. +420606666666). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userFirstName",
        "displayName": "First Name (fn)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of the normalized first name (lowercase + trim). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userLastName",
        "displayName": "Last Name (ln)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of the normalized last name (lowercase + trim). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userGender",
        "displayName": "Gender (ge)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of 'm' / 'f' / 'o'. Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userDob",
        "displayName": "Date of Birth (db)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of YYYYMMDD. Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userCity",
        "displayName": "City (ct)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of the normalized city (lowercase + trim). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userRegion",
        "displayName": "Region / State (region)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of the normalized region/state (lowercase + trim). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userZip",
        "displayName": "Postal Code (zp)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of the trimmed ZIP/postal code. Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userStreet",
        "displayName": "Street (sr)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of the normalized street (lowercase + trim). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userCountry",
        "displayName": "Country",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Expected SHA-256 hash of ISO 3166-1 alpha-2 code (lowercase). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userSubscriptionId",
        "displayName": "Subscription ID",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "userDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "autoMapIdsFromCookies",
        "checkboxText": "Auto-map sid & udid from request cookies (fallback)",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "When on, sid and udid are read from the inbound request cookies ('sid', 'udid') as a LOWEST-priority fallback — only when not already provided by the SID/UDID fields, User Data Object, or overrides, or when the provided value is malformed. Explicit and cookie values pass the same shape check. The 'udid' cookie's '<uuid>@<timestamp>' suffix is stripped to the canonical uuid. The 'sid' cookie value contains '=' but is read whole. Note: Seznam SID is NEVER taken from GA4 event_data, because GA4's 'sid' query param is the GA4 session id, not the Seznam SID. Requires same-site (first-party) SGTM so cookies reach the server. Safari's ITP deletes cookies created in JavaScript, which includes sid and udid, after 7 days without user interaction with the website (webkit.org/tracking-prevention)."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "eventDataGroup",
    "displayName": "Event Data",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SELECT",
        "name": "eventDataInputMode",
        "displayName": "Event Data input mode",
        "macrosInSelect": false,
        "selectItems": [
          { "value": "object", "displayValue": "Object variable" },
          { "value": "fields", "displayValue": "Individual fields" }
        ],
        "simpleValueType": true,
        "defaultValue": "object",
        "help": "Choose how to provide event data. 'Object variable': one GTM variable resolving to an object with event_data keys (currency, value, order_id, contents, etc.). 'Individual fields': map each field separately. Both produce the same payload."
      },
      {
        "type": "TEXT",
        "name": "eventDataObject",
        "displayName": "Event Data Object",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "object", "type": "EQUALS" }
        ],
        "help": "A GTM variable resolving to an object with event data fields (currency, value, order_id, value_tax, delivery_price, content_type, contents, etc.). Keys outside the Seznam event_data schema are dropped with a warning. Values are converted to their wire types; a missing value (undefined, null, empty) does not override a GA4 Auto-Map value."
      },
      {
        "type": "TEXT",
        "name": "sznaiid",
        "displayName": "sznaiid (click-through ID)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "currency",
        "displayName": "Currency",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "value",
        "displayName": "Value",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "orderId",
        "displayName": "Order ID",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "contentType",
        "displayName": "Content Type",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "contents",
        "displayName": "Contents (array variable or JSON string)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Assign a GTM variable resolving to an array of SEM-native content objects [{id, quantity, unit_price, content_name, content_category}], or a JSON string in the same shape. A missing quantity is sent as 1; an item whose quantity is not a whole number of at least 1 is dropped with a warning. When contents is present, content_type is required by SEM; if omitted, this template defaults it to product. This field does not convert GA4 items[]; GA4 Auto-Map does that."
      },
      {
        "type": "TEXT",
        "name": "deliveryPrice",
        "displayName": "Delivery Price",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "deliveryType",
        "displayName": "Delivery Type",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "paymentType",
        "displayName": "Payment Type",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "otherCosts",
        "displayName": "Other Costs",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "predictedLtv",
        "displayName": "Predicted LTV",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "valueTax",
        "displayName": "Value Tax (value_tax)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Tax portion of value. Numeric."
      },
      {
        "type": "TEXT",
        "name": "reviewEmail",
        "displayName": "Review Email (review_email, UNHASHED)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Zboží.cz satisfaction survey email. MUST be sent as plain text, NOT hashed. Only send with user consent."
      },
      {
        "type": "TEXT",
        "name": "productIds",
        "displayName": "Product IDs (product_ids, array)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "GTM variable resolving to an array of Zboží.cz product IDs (non-negative integers), or JSON string. Non-integer or negative entries are skipped with a warning."
      },
      {
        "type": "TEXT",
        "name": "goodsIntention",
        "displayName": "Goods Intention (goods_intention)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "User intent weight. Numeric."
      },
      {
        "type": "TEXT",
        "name": "goodsPhase",
        "displayName": "Goods Phase (goods_phase)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "User interest phase. Integer — non-integer values are omitted with a warning."
      },
      {
        "type": "TEXT",
        "name": "searchString",
        "displayName": "Search String (search_string)",
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Search query text (e.g. for Search event)."
      },
      {
        "type": "CHECKBOX",
        "name": "statusEnabled",
        "checkboxText": "Include status field",
        "simpleValueType": true,
        "defaultValue": false,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" }
        ],
        "help": "Enable this to include a boolean status in event_data. Needed because false is a legitimate value — a plain checkbox could not distinguish it from 'not set'."
      },
      {
        "type": "SELECT",
        "name": "status",
        "displayName": "Status (bool)",
        "selectItems": [
          { "value": "true",  "displayValue": "true" },
          { "value": "false", "displayValue": "false" }
        ],
        "simpleValueType": true,
        "enablingConditions": [
          { "paramName": "eventDataInputMode", "paramValue": "fields", "type": "EQUALS" },
          { "paramName": "statusEnabled", "paramValue": true, "type": "EQUALS" }
        ],
        "help": "Registration/subscription status. Boolean — both true and false are legitimate values."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "settingsGroup",
    "displayName": "Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "testMode",
        "checkboxText": "Enable Test Mode",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Enables verbose logging of full payloads and responses. Events are still sent normally."
      },
      {
        "type": "CHECKBOX",
        "name": "useOptimisticScenario",
        "checkboxText": "Use Optimistic Scenario",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Returns success to GTM immediately without waiting for the API response. Warning: 4xx/5xx responses and failed requests are logged as errors but GTM still reports success. Disable for higher observability during rollout or for critical conversion tags. The request times out after 5 seconds."
      },
      {
        "type": "CHECKBOX",
        "name": "strictEventValidation",
        "checkboxText": "Strict Event Validation",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "When enabled, unknown event names, a SEM ID that is not 24 characters of 0-9 and a-z, and invalid JSON in the user/event data object, contents and product ID fields cause the tag to fail (and call gtmOnFailure) instead of just logging. Recommended for production hardening. When disabled, such issues are logged but the tag reports success. A malformed consent configuration always fails the tag, regardless of this setting."
      },
      {
        "type": "CHECKBOX",
        "name": "sendS2sHeaders",
        "checkboxText": "Send S2S Headers (consent-gated)",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "When enabled, forwards client IP address, User-Agent, and Client Hints (sec-ch-ua) to Seznam for device targeting and analytics. These headers are only sent when ad_storage and ad_user_data consent are both 'granted'. Disable to never send these headers regardless of consent."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "serverCookiesGroup",
    "displayName": "Server Cookies",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "persistSznaiidCookie",
        "checkboxText": "Persist sznaiid as first-party cookie",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "When enabled, reads sznaiid from URL (?sznaiid=...) and stores it as a 1P cookie named 'sznaiid'. Read on subsequent events when event_data.sznaiid is otherwise empty. Consent-free per Seznam docs (technical click ID, not PII). Disabling cookie persistence does NOT disable URL-based capture — sznaiid extracted from the URL is still injected into event_data.sznaiid."
      },
      {
        "type": "SELECT",
        "name": "persistSznaiidCookieMode",
        "displayName": "Cookie write strategy",
        "selectItems": [
          { "value": "first_touch", "displayValue": "First touch (write only if no cookie exists)" },
          { "value": "last_touch",  "displayValue": "Last touch (overwrite on every URL hit)" }
        ],
        "simpleValueType": true,
        "defaultValue": "first_touch",
        "enablingConditions": [
          { "paramName": "persistSznaiidCookie", "paramValue": true, "type": "EQUALS" }
        ]
      },
      {
        "type": "TEXT",
        "name": "sznaiidCookieMaxAge",
        "displayName": "Cookie max-age (seconds)",
        "simpleValueType": true,
        "defaultValue": "7776000",
        "valueValidators": [{ "type": "POSITIVE_NUMBER" }],
        "enablingConditions": [
          { "paramName": "persistSznaiidCookie", "paramValue": true, "type": "EQUALS" }
        ],
        "help": "Default 7776000 (90 days)."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "bigQueryLogsGroup",
    "displayName": "BigQuery Logs",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "RADIO",
        "name": "bigQueryLogType",
        "radioItems": [
          { "value": "no", "displayValue": "Do not log to BigQuery" },
          { "value": "always", "displayValue": "Log to BigQuery" }
        ],
        "simpleValueType": true,
        "defaultValue": "no"
      },
      {
        "type": "GROUP",
        "name": "logsBigQueryConfigGroup",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "TEXT",
            "name": "logBigQueryProjectId",
            "displayName": "BigQuery Project ID",
            "simpleValueType": true,
            "help": "Optional. If omitted, uses the GOOGLE_CLOUD_PROJECT environment variable of the server container."
          },
          {
            "type": "TEXT",
            "name": "logBigQueryDatasetId",
            "displayName": "BigQuery Dataset ID",
            "simpleValueType": true,
            "valueValidators": [{ "type": "NON_EMPTY" }]
          },
          {
            "type": "TEXT",
            "name": "logBigQueryTableId",
            "displayName": "BigQuery Table ID",
            "simpleValueType": true,
            "valueValidators": [{ "type": "NON_EMPTY" }]
          }
        ],
        "enablingConditions": [
          {
            "paramName": "bigQueryLogType",
            "paramValue": "always",
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "advancedOverridesGroup",
    "displayName": "Advanced Overrides",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SIMPLE_TABLE",
        "name": "userDataOverrides",
        "displayName": "User Data Overrides",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Property Name",
            "name": "name",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Property Value",
            "name": "value",
            "type": "TEXT"
          }
        ],
        "help": "Catch-all override table for user data fields. Overrides both the object variable and individual fields above. Property names must be Seznam user_data keys; other names are dropped with a warning. Rows with an empty value are ignored."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "eventDataOverrides",
        "displayName": "Event Data Overrides",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Property Name",
            "name": "name",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Property Value",
            "name": "value",
            "type": "TEXT"
          }
        ],
        "help": "Catch-all override table for event data fields. Values are converted to the wire type of their key (numbers for value, value_tax, delivery_price, other_costs, predicted_ltv, goods_intention, goods_phase; true/false for status). Unknown property names and invalid values are dropped with a warning. Rows with an empty value are ignored; false and 0 are values. sem_id always comes from the S2S SEM ID field."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const JSON = require('JSON');
const Math = require('Math');
const BigQuery = require('BigQuery');
const sendHttpRequest = require('sendHttpRequest');
const getTimestampMillis = require('getTimestampMillis');
const logToConsole = require('logToConsole');
const getRequestHeader = require('getRequestHeader');
const makeNumber = require('makeNumber');
const getType = require('getType');
const getAllEventData = require('getAllEventData');
const setCookie = require('setCookie');
const getCookieValues = require('getCookieValues');
const parseUrl = require('parseUrl');

const ALLOWED_EVENTS = [
  'PageView', 'ViewContent', 'Purchase', 'Contact',
  'AddToCart', 'AddToWishlist', 'InitiateCheckout', 'AddPaymentInfo',
  'Search', 'CompleteRegistration', 'Lead', 'Subscribe',
  'CustomizeProduct', 'Donate', 'FindLocation', 'Schedule',
  'StartTrial', 'SubmitApplication'
];

// Wire type of every event_data key in rtgconv.json; the normalization pass converts each value to it.
// 'id' = non-empty string (finite numbers are converted, the placeholders 'undefined'/'null' are invalid),
// 'text' = free text, 'number' = finite number, 'integer' = whole number, 'boolean' = true/false,
// 'content_type' = one of CONTENT_TYPES.
// product_ids and contents have their own normalizers. sem_id is not listed: it always comes
// from the S2S SEM ID field.
const EVENT_DATA_TYPES = {
  sznaiid: 'id',
  order_id: 'id',
  currency: 'id',
  content_type: 'content_type',
  delivery_type: 'id',
  payment_type: 'id',
  review_email: 'id',
  search_string: 'text',
  value: 'number',
  value_tax: 'number',
  delivery_price: 'number',
  other_costs: 'number',
  predicted_ltv: 'number',
  goods_intention: 'number',
  goods_phase: 'integer',
  status: 'boolean',
  product_ids: 'product_ids',
  contents: 'contents'
};

// content_type values in rtgconv.json.
const CONTENT_TYPES = ['page', 'product', 'product_group', 'search'];

// Free text: the words 'undefined' and 'null' are kept literally here; in every other key
// they are placeholders from a broken variable mapping and count as not supplied (R8).
const FREE_TEXT_KEYS = ['search_string', 'content_name', 'content_category'];

const CONTENT_ITEM_TYPES = {
  id: 'id',
  quantity: 'quantity',
  unit_price: 'number',
  content_name: 'text',
  content_category: 'text'
};

// user_data keys in sem-hit-json-schema-v2.json; every value is a string.
const USER_DATA_KEYS = [
  'em', 'ph', 'fn', 'ln', 'ge', 'db', 'ct', 'region', 'zp', 'sr',
  'country', 'said', 'id5', 'secid', 'subscription_id', 'sid', 'udid'
];

// Booleans and the encodings data layers and CMPs commonly use for them.
const TRUE_VALUES = [true, 1, '1', 'true'];
const FALSE_VALUES = [false, 0, '0', 'false'];

// consent_mode keys in sem-hit-json-schema-v2.json (each 'granted' | 'denied').
const CONSENT_KEYS = [
  'ad_storage', 'ad_user_data', 'ad_personalization',
  'functionality_storage', 'analytics_storage'
];

// Characters of a sem_id (rtgconv.json: ^[0-9a-z]{24}$).
const SEM_ID_CHARS = '0123456789abcdefghijklmnopqrstuvwxyz';

// Characters of an IAB TCF v2 string: base64url segments joined by '.'.
const TCF_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.-';

// Maps FE-template alias keys → canonical SEM wire keys.
// Use an ordered ARRAY (not an object) because order matters when multiple
// aliases resolve to the same canonical (e.g. gender vs g): the entry listed
// FIRST wins. Object iteration order in the GTM sandbox is "should-be-stable"
// but an explicit array removes the should.
// MUST be declared before the main execution flow (buildPayload): the GTM sandbox
// hoists `const` declarations var-style (initialized to undefined), so a const used
// by buildUserData() would be undefined if declared after the buildPayload() call.
const USER_DATA_ALIAS_MAP = [
  { alias: 'email',          canonical: 'em' },
  { alias: 'phone',          canonical: 'ph' },
  { alias: 'fname',          canonical: 'fn' },
  { alias: 'lname',          canonical: 'ln' },
  { alias: 'gender',         canonical: 'ge' },
  { alias: 'g',              canonical: 'ge' },
  { alias: 'birth',          canonical: 'db' },
  { alias: 'birthDate',      canonical: 'db' },
  { alias: 'postalCode',     canonical: 'zp' },
  { alias: 'zip',            canonical: 'zp' },
  { alias: 'subscription',   canonical: 'subscription_id' },
  { alias: 'subscriptionId', canonical: 'subscription_id' }
];

// GA4 → SEM event-name map. Used only when eventNameSelect === 'auto' AND
// autoMapEventName === true. Unknown GA4 names log a WARN and fall through.
const GA4_EVENT_NAME_MAP = {
  page_view: 'PageView',
  view_item: 'ViewContent',
  view_item_list: 'ViewContent',
  select_item: 'ViewContent',
  view_promotion: 'ViewContent',
  search: 'Search',
  view_search_results: 'Search',
  add_to_cart: 'AddToCart',
  add_to_wishlist: 'AddToWishlist',
  begin_checkout: 'InitiateCheckout',
  add_payment_info: 'AddPaymentInfo',
  add_shipping_info: 'AddPaymentInfo',
  purchase: 'Purchase',
  generate_lead: 'Lead',
  sign_up: 'CompleteRegistration',
  login: 'CompleteRegistration',
  contact: 'Contact',
  subscribe: 'Subscribe'
};

// Static 1:1 map for fields without multi-source aliases.
// `value` and `transaction_id` are handled by multi-source extractors below
// (value: value/revenue/totalWithoutVat; order_id: transaction_id/id/orderNo).
const GA4_EVENT_DATA_MAP = {
  currency: 'currency',
  tax: 'value_tax',
  shipping: 'delivery_price',
  payment_type: 'payment_type',
  shipping_tier: 'delivery_type',
  search_term: 'search_string'
};

const traceId = getRequestHeader('trace-id');

// The inbound event is read once; GA4 Auto-Map and the sznaiid URL lookup share it.
const inboundEvent = getAllEventData();

// Auto-map: gather GA4-derived values once at top-level. Returns a `blank` shape when
// enableGa4AutoMap=false, so downstream code can always read ga4.* without null-checks.
const ga4 = extractFromEventData(data, inboundEvent);

const resolvedEventName = data.eventNameSelect === 'from_variable'
  ? data.eventNameFromVariable
  : (data.eventNameSelect === 'auto' ? ga4.resolvedEventName : data.eventNameSelect);

const apiUrl = 'https://sem.seznam.cz/rtgconv';

// Seznam telemetry: `api.version` tracks the integration client version (bump on contract/behavior changes).
// `api.template_version` tracks our CHANGELOG release version. These are independent of the
// GTM ___INFO___.version field, which is a GTM-internal stability flag constrained to 0 or 1.
const API_CLIENT_VERSION = '1';
const TEMPLATE_VERSION = '2.3.1';

// Parse JSON object/array fields once, up-front. `checkJsonInputs` decides severity, `buildPayload` consumes values.
const parsed = {
  userData:   parseJsonObjectField('userDataObject',    data.userDataObject),
  eventData:  parseJsonObjectField('eventDataObject',   data.eventDataObject),
  contents:   parseJsonArray('contents',   data.contents),
  productIds: parseJsonArray('productIds', data.productIds)
};

// A malformed configured consent input fails the tag before anything is assembled.
const consent = resolveConsent(data.consentModeObject, data.consentString);
const inputError = consent.error || checkJsonInputs(data, parsed);
if (inputError) {
  failTag(inputError);
  return;
}

// Assemble all input layers, normalize the result once, then validate that final payload.
// The sznaiid cookie write is only planned here; it happens after validation succeeds.
const sznaiid = planSznaiid(inboundEvent);
// Source of sid / udid in the payload ('tag', 'cookie' or 'missing'), filled by buildUserData().
const identity = { sid: 'missing', udid: 'missing' };
const payload = buildPayload(data, parsed, consent, sznaiid.value);
const validationError = validate(payload);
if (validationError) {
  failTag(validationError + ' | event=' + resolvedEventName + ' | trace=' + traceId);
  return;
}

if (sznaiid.writeCookie) {
  writeSznaiidCookie(sznaiid.value);
}

// Test Mode diagnostics: the consent summary, the raw GA4 x-ga-gcs value (logged only,
// never decoded into the payload) and the source of sid / udid, next to the payload.
log({
  Name: 'Seznam SEM',
  Type: 'Request',
  TraceId: traceId,
  EventName: resolvedEventName,
  RequestMethod: 'POST',
  RequestUrl: apiUrl,
  Consent: {
    consent_mode: payload.consent_mode || 'absent',
    consent_string: payload.consent_string ? 'present' : 'absent',
    s2s_headers: payload.s2s_headers ? 'sent' : 'not sent',
    x_ga_gcs: getType(inboundEvent) === 'object' ? inboundEvent['x-ga-gcs'] : undefined
  },
  Identity: identity,
  RequestBody: payload
});

// Seznam recommends a 3-5 s timeout (s2s.html); the sendHttpRequest default is 15 s.
sendHttpRequest(
  apiUrl,
  {
    headers: {
      'content-type': 'application/json',
      'X-Client-Id': 'gtm-server-template-seznam-sem',
      'X-Client-Version': TEMPLATE_VERSION
    },
    method: 'POST',
    timeout: 5000
  },
  JSON.stringify(payload)
).then(function(result) {
  log({
    Name: 'Seznam SEM',
    Type: 'Response',
    TraceId: traceId,
    EventName: resolvedEventName,
    ResponseStatusCode: result.statusCode,
    ResponseHeaders: result.headers,
    ResponseBody: result.body
  });

  logToBigQuery(
    { url: apiUrl, body: payload },
    { statusCode: result.statusCode, headers: result.headers, body: result.body }
  );

  if (!data.useOptimisticScenario) {
    if (result.statusCode >= 200 && result.statusCode < 300) {
      data.gtmOnSuccess();
    } else {
      logHttpError(result);
      data.gtmOnFailure();
    }
  } else if (result.statusCode < 200 || result.statusCode >= 300) {
    logHttpError(result);
  }
}).catch(function(error) {
  // sendHttpRequest rejects with { reason: 'failed' | 'timed_out' }.
  var reason = (error && error.reason) ? error.reason : JSON.stringify(error);
  logToConsole('Seznam SEM [ERROR]: request to Seznam failed: ' + ('' + reason).substring(0, 200) +
    ' | event=' + resolvedEventName + ' | trace=' + traceId);
  logToBigQuery({ url: apiUrl, body: payload });

  if (!data.useOptimisticScenario) {
    data.gtmOnFailure();
  }
});

if (data.useOptimisticScenario) {
  data.gtmOnSuccess();
}

/*******************************************************************************
 * Validation
 ******************************************************************************/

// Malformed JSON in the object/array fields fails the tag under Strict Event Validation and is
// logged as an ERROR otherwise.
function checkJsonInputs(data, parsed) {
  var results = [parsed.userData, parsed.eventData, parsed.contents, parsed.productIds];
  for (var i = 0; i < results.length; i++) {
    if (!results[i].error) continue;
    if (data.strictEventValidation) return results[i].error;
    logToConsole('Seznam SEM [ERROR]: ' + results[i].error + ' | trace=' + traceId);
  }
  return undefined;
}

// The one validation of the FINAL payload, after every layer has been merged and normalized:
// event name, sem_id, and the Purchase trio (rtgconv.json requires value, currency, order_id).
// Returns an error message, or undefined when the payload may be sent.
function validate(payload) {
  var ed = payload.event_data;
  if (!payload.event_name) return 'eventName is required';
  if (!ed.sem_id) return 'semId is required';

  // sem_id must match ^[0-9a-z]{24}$ (rtgconv.json); fails under Strict, WARN otherwise.
  if (!isValidSemId(ed.sem_id)) {
    var semIdMsg = 'semId must be 24 characters of 0-9 and a-z (^[0-9a-z]{24}$)';
    if (data.strictEventValidation) {
      return semIdMsg;
    }
    warn(semIdMsg + ' | semId=' + ed.sem_id);
  }

  if (!contains(ALLOWED_EVENTS, payload.event_name)) {
    var msg = 'Unknown event name: ' + payload.event_name;
    if (data.strictEventValidation) {
      return msg;
    }
    warn(msg);
  }

  // After normalization a present order_id/currency is a non-empty string and value a finite
  // number (0 is valid). `contents` is recommended for retargeting/attribution but not required.
  if (payload.event_name === 'Purchase') {
    var missing = [];
    if (ed.order_id === undefined) missing.push('order_id');
    if (ed.currency === undefined) missing.push('currency');
    if (ed.value === undefined) missing.push('value');
    if (missing.length > 0) {
      return 'Purchase requires: ' + missing.join(', ');
    }
    if (ed.contents === undefined) {
      warn('Purchase without contents is accepted by the API but strongly recommended for retargeting/attribution');
    }
  }

  return undefined;
}

// Configuration and validation failures: ERROR log, no request, no cookie write.
function failTag(message) {
  logToConsole('Seznam SEM [ERROR]: ' + message);
  logToBigQuery({ url: apiUrl }, { body: message });
  data.gtmOnFailure();
}

/*******************************************************************************
 * Consent
 ******************************************************************************/

// Validates and normalizes the configured consent inputs. Returns { mode, string, error }.
// - consent_mode: an object or a JSON object string. Supported keys take granted/denied or
//   true/false, 1/0 (also as strings, trimmed) and are forwarded as present; missing keys are
//   never filled. Other keys (e.g. wait_for_update) are ignored.
// - consent_string: forwarded when it passes a syntax check for IAB TCF v2 (first character C,
//   only A-Z a-z 0-9 _ . -). The check is a heuristic, not proof of a valid TCF string.
// Missing inputs (undefined, null, '', 'undefined', 'null') are optional. An actual null on a
// supported key is missing too: the key is omitted with a WARN and never filled (R1).
// A malformed object, any other invalid value on a supported key or a failed TCF check is a
// configuration error and fails the tag: Seznam prefers TCF over consent_mode, so dropping or
// replacing one of them would send a consent signal the advertiser did not configure.
// Error messages name the field and the received type, never the value.
function resolveConsent(rawMode, rawString) {
  var result = { mode: {}, string: undefined, error: undefined };

  if (!isUnset(rawMode)) {
    var obj = getType(rawMode) === 'string' ? JSON.parse(rawMode) : rawMode;
    if (getType(obj) !== 'object') {
      result.error = 'consentModeObject: expected object with granted/denied values, got ' + getType(rawMode);
      return result;
    }
    var keyCount = 0;
    var consentKeyCount = 0;
    for (var key in obj) {
      if (!obj.hasOwnProperty(key)) continue;
      keyCount++;
      if (contains(CONSENT_KEYS, key)) consentKeyCount++;
    }
    if (keyCount > 0 && consentKeyCount === 0) {
      result.error = 'consentModeObject: no supported consent key (' + CONSENT_KEYS.join(', ') + '), got object';
      return result;
    }
    for (var i = 0; i < CONSENT_KEYS.length; i++) {
      var name = CONSENT_KEYS[i];
      var v = obj[name];
      if (!obj.hasOwnProperty(name) || v === undefined || (getType(v) === 'string' && isUnset(v))) continue;
      if (v === null) {
        warn('consentModeObject.' + name + ' is null; treating it as missing');
        continue;
      }
      // Strings are trimmed but never case-folded: ' granted ' is granted, ' Granted ' fails (R9).
      var value = getType(v) === 'string' ? v.trim() : v;
      var state = (value === 'granted' || value === 'denied') ? value : undefined;
      var bool = toBoolean(value);
      if (bool !== undefined) state = bool ? 'granted' : 'denied';
      if (!state) {
        result.error = 'consentModeObject.' + name + ': expected granted/denied (or true/false, 1/0), got ' + getType(v);
        return result;
      }
      result.mode[name] = state;
    }
  }

  if (!isUnset(rawString)) {
    if (getType(rawString) !== 'string' || !isTcfString(rawString.trim())) {
      result.error = 'consentString: expected IAB TCF v2 string (starts with C; letters, digits, _ . -), got ' + getType(rawString);
      return result;
    }
    result.string = rawString.trim();
  }

  if (!hasProperties(result.mode) && !result.string) {
    warn('no consent signal (Consent Mode Object and Consent String are empty); Seznam receives the hit without consent information');
  }
  return result;
}

function isTcfString(s) {
  if (s.charAt(0) !== 'C') return false;
  for (var i = 1; i < s.length; i++) {
    if (TCF_CHARS.indexOf(s.charAt(i)) === -1) return false;
  }
  return true;
}

/*******************************************************************************
 * GA4 Auto-Map (opt-in)
 ******************************************************************************/

// FE-parity helper: returns the first usable candidate so fallback candidates can be tried.
// 'id' / 'text': a non-blank string or a finite number, returned RAW (the normalization pass
// converts it); objects, booleans, arrays, NaN/Infinity are skipped, and for 'id' so are the
// placeholders 'undefined'/'null'. 'number': a canonical finite number.
function getFirstValue(candidates, targetType) {
  for (var i = 0; i < candidates.length; i++) {
    var v = candidates[i];
    if (isMissing(v)) continue;
    if (targetType === 'number') {
      var num = toNumber(v);
      if (num !== undefined) return num;
      continue;
    }
    if (toText(v, targetType === 'id') !== undefined) return v;
  }
  return undefined;
}

// FE-parity helper: round a finite number to 2 decimal places.
function roundTo2(n) {
  return Math.round(n * 100) / 100;
}

// Category resolution priority (exclusive, mirrors FE template):
//   1. `category` (string, possibly slash-separated → MeasureHive)
//   2. `currentCategory` || `defaultCategory` (Shoptet)
//   3. `item_category` ... `item_category5` joined with ' | ' (GA4 EE chain)
// Returns undefined when no source matches.
function buildItemCategory(it) {
  if (it.category && getType(it.category) === 'string') {
    if (it.category.indexOf('/') !== -1) {
      var parts = [];
      var split = it.category.split('/');
      for (var s = 0; s < split.length; s++) if (split[s]) parts.push(split[s]);
      return parts.length > 0 ? parts.join(' | ') : undefined;
    }
    return it.category;
  }
  // Shoptet's currentCategory / defaultCategory can be an array (FE-template parity).
  // Without explicit array handling, '' + ['A','B'] would yield 'A,B' instead of 'A | B'.
  if (it.currentCategory) {
    return getType(it.currentCategory) === 'array'
      ? it.currentCategory.join(' | ')
      : '' + it.currentCategory;
  }
  if (it.defaultCategory) {
    return getType(it.defaultCategory) === 'array'
      ? it.defaultCategory.join(' | ')
      : '' + it.defaultCategory;
  }
  var ee = [];
  if (it.item_category)  ee.push(it.item_category);
  if (it.item_category2) ee.push(it.item_category2);
  if (it.item_category3) ee.push(it.item_category3);
  if (it.item_category4) ee.push(it.item_category4);
  if (it.item_category5) ee.push(it.item_category5);
  return ee.length > 0 ? ee.join(' | ') : undefined;
}

// SAFETY: only map ALREADY-HASHED sha256_* variants. The template's contract is
// "we never hash"; raw email/phone/name/address from GA4 would leak unhashed PII
// over the wire to Seznam, which expects SHA-256-of-normalized inputs.
// Raw PII auto-mapping is OUT OF SCOPE for v2.2.0 — would require sha256Sync,
// normalization, and dedicated tests as a separate feature.
function extractGa4UserData(ev) {
  var out = {};
  var ud = (getType(ev.user_data) === 'object') ? ev.user_data : {};
  var addrRaw = ud.address;
  var addr = {};
  if (getType(addrRaw) === 'object') addr = addrRaw;
  else if (getType(addrRaw) === 'array' && addrRaw.length > 0) addr = addrRaw[0] || {};

  if (ud.sha256_email_address) out.em = ud.sha256_email_address;
  if (ud.sha256_phone_number)  out.ph = ud.sha256_phone_number;
  if (addr.sha256_first_name)  out.fn = addr.sha256_first_name;
  if (addr.sha256_last_name)   out.ln = addr.sha256_last_name;
  // Address fields (city/region/postal/country/street) are also PII per Seznam
  // schema — they require hashing too. Skip auto-mapping in v2.2.0.
  return out;
}

function extractFromEventData(data, ev) {
  var blank = { eventData: {}, userData: {}, eventUrl: '', eventId: '', resolvedEventName: '' };
  if (!data.enableGa4AutoMap) return blank;
  if (getType(ev) !== 'object') return blank;

  var out = { eventData: {}, userData: {}, eventUrl: '', eventId: '', resolvedEventName: '' };

  // event_url / event_id are always extracted when auto-map is on — they are
  // top-level payload fields, not gated by the per-section sub-toggles.
  if (ev.page_location) out.eventUrl = ev.page_location;
  var ga4EventId = getFirstValue([ev.event_id, ev.transaction_id], 'id');
  if (ga4EventId !== undefined) out.eventId = ga4EventId;

  if (data.autoMapEventName && ev.event_name) {
    if (GA4_EVENT_NAME_MAP.hasOwnProperty(ev.event_name)) {
      out.resolvedEventName = GA4_EVENT_NAME_MAP[ev.event_name];
    } else {
      warn('GA4 event ' + ev.event_name + ' has no SEM mapping');
    }
  }

  // Explicit-false check: defaultValue=true may not hydrate into existing instances
  // on template upgrade. Treat undefined as default ON when master toggle is enabled.
  if (data.autoMapEventData !== false) {
    // Static 1:1 fields (currency, tax→value_tax, shipping→delivery_price, etc.)
    for (var k in GA4_EVENT_DATA_MAP) {
      if (GA4_EVENT_DATA_MAP.hasOwnProperty(k) && ev.hasOwnProperty(k) && !isMissing(ev[k])) {
        out.eventData[GA4_EVENT_DATA_MAP[k]] = ev[k];
      }
    }

    // Multi-source order_id: transaction_id (GA4 standard) || id || orderNo (Shoptet).
    var effectiveOrderId = getFirstValue([ev.transaction_id, ev.id, ev.orderNo], 'id');
    if (effectiveOrderId !== undefined) out.eventData.order_id = effectiveOrderId;

    // items[] → contents, in the GA4 layer: object/field/override contents (even []) replace them.
    if (getType(ev.items) === 'array' && ev.items.length > 0) {
      var skipped = 0;
      var contents = [];
      for (var i = 0; i < ev.items.length; i++) {
        var it = ev.items[i];
        if (!it) { skipped++; continue; }
        // Multi-source item id: item_id (GA4 EE) || id (Shoptet/legacy).
        var itemId = getFirstValue([it.item_id, it.id], 'id');
        if (itemId === undefined) { skipped++; continue; }
        var c = { id: itemId };

        var itemName = getFirstValue([it.item_name, it.name], 'text');
        if (itemName !== undefined) c.content_name = itemName;

        // Multi-source unit_price: price || priceWithVat || fullPrice.
        var price = getFirstValue([it.price, it.priceWithVat, it.fullPrice], 'number');
        if (price !== undefined) c.unit_price = roundTo2(price);

        // Quantity is passed through as sent; normalizeContents() defaults a missing one to 1
        // and drops the item when it is present but invalid.
        if (!isMissing(it.quantity)) c.quantity = it.quantity;

        var cat = buildItemCategory(it);
        if (cat) c.content_category = cat;

        contents.push(c);
      }
      if (contents.length > 0) out.eventData.contents = contents;
      if (skipped > 0) {
        warn(skipped + ' GA4 items skipped (missing item_id)');
      }
    }

    // Multi-source value: value (GA4 standard) || revenue || totalWithoutVat.
    // No fallback to the item prices: unit_price includes VAT, value excludes it (rtgconv.json).
    var effectiveValue = getFirstValue([ev.value, ev.revenue, ev.totalWithoutVat], 'number');
    if (effectiveValue !== undefined) out.eventData.value = roundTo2(effectiveValue);
  }

  // Explicit-false check: see comment above on autoMapEventData.
  if (data.autoMapUserData !== false) out.userData = extractGa4UserData(ev);
  return out;
}

/*******************************************************************************
 * sznaiid cookie + URL extraction
 ******************************************************************************/

// Try one URL; return sznaiid value or '' if not found / preview ping / unparseable.
function extractFromSingleUrl(url) {
  if (!url) return '';
  // FB CAPI ref pattern for preview-ping guard (sandbox-safe; matches at offset 0).
  if (url.lastIndexOf('https://gtm-msr.appspot.com/', 0) === 0) return '';
  var parsed = parseUrl(url);
  if (!parsed || !parsed.searchParams) return '';
  var v = parsed.searchParams.sznaiid;
  if (getType(v) === 'array') v = v[0];
  return v || '';
}

// Try BOTH sources independently — page_location may exist but lack sznaiid
// (e.g. SPA route change), in which case referer (the original landing URL)
// is more likely to carry the click ID. First non-empty wins.
//
// EXCEPTION: when page_location indicates a GTM preview ping, treat the WHOLE
// event as preview-context and short-circuit — do not fall back to referer.
// Otherwise a preview hit on a real page with ?sznaiid=... in referer would
// write a real attribution cookie during a debug session.
function extractSznaiidFromUrl(ev) {
  var pageLoc = (getType(ev) === 'object' && ev.page_location) ? ev.page_location : '';
  if (pageLoc && pageLoc.lastIndexOf('https://gtm-msr.appspot.com/', 0) === 0) return '';
  return extractFromSingleUrl(pageLoc) ||
         extractFromSingleUrl(getRequestHeader('referer')) ||
         '';
}

// Plans the sznaiid value to inject into the payload from one of three sources,
// in order: cookie (if persistence enabled and cookie exists), URL (always tried),
// returning value '' if none.
//
// No side effects: `writeCookie` is true when persistSznaiidCookie=true AND a fresh
// sznaiid is in the URL (first_touch / last_touch mode). The caller writes the cookie
// only after the payload has passed validation.
//
// IMPORTANT: when persistSznaiidCookie=false, no cookie is read or written —
// but URL-extracted sznaiid is STILL returned and injected into event_data.sznaiid.
// Disabling cookie persistence does not disable URL-based attribution capture.
function planSznaiid(ev) {
  var fromUrl = extractSznaiidFromUrl(ev);
  // Explicit-false check: GTM may not hydrate the new parameter's defaultValue=true
  // into existing tag instances on template upgrade. Treat undefined as default ON.
  if (data.persistSznaiidCookie === false) return { value: fromUrl, writeCookie: false };

  var existing = getFirstCookie('sznaiid');
  var writeCookie = !!fromUrl &&
    (data.persistSznaiidCookieMode === 'last_touch' || !existing);

  return { value: writeCookie ? fromUrl : (existing || fromUrl), writeCookie: writeCookie };
}

function writeSznaiidCookie(value) {
  var maxAge = makeNumber(data.sznaiidCookieMaxAge);
  if (!maxAge || maxAge <= 0) maxAge = 7776000;

  // Option names as documented for setCookie: sameSite ('strict' | 'lax' | 'none') and httpOnly.
  setCookie('sznaiid', value, {
    domain: 'auto',
    path: '/',
    sameSite: 'lax',
    secure: true,
    'max-age': maxAge,
    httpOnly: false
  });
}

/*******************************************************************************
 * Payload builders
 ******************************************************************************/

function buildPayload(data, parsed, consent, sznaiidValue) {
  var eventTime = normalizeEventTime(data.eventTime);
  var eventUrl = data.eventUrl || ga4.eventUrl || getRequestHeader('referer') || '';

  // Spec-conformance WARN: docs mark event_url as required.
  if (!eventUrl) {
    warn('event_url is empty (no eventUrl, ga4.eventUrl, or referer); docs mark it required');
  }

  var eventData = buildEventData(data, parsed, sznaiidValue);

  var payload = {
    event_name: resolvedEventName,
    schema_version: 'v2',
    event_type: 'rtgconv',
    event_time: eventTime,
    event_source: data.eventSource || 'web',
    event_url: eventUrl,
    event_data: eventData,
    api: {
      name: 'gtm-server-template',
      version: API_CLIENT_VERSION,
      template_version: TEMPLATE_VERSION
    }
  };

  var eventId = {};
  addLayerValue(eventId, '', 'event_id', ga4.eventId);
  addLayerValue(eventId, '', 'event_id', data.eventId);
  setNormalized(payload, 'event_id', 'id', eventId.event_id, 'event_id');

  if (hasProperties(consent.mode)) {
    payload.consent_mode = consent.mode;
  }

  addIfPresent(payload, 'consent_string', consent.string);

  var userData = buildUserData(data, parsed.userData.value);
  if (hasProperties(userData)) {
    payload.user_ids = { user_data: userData };
  } else {
    // Spec-conformance WARN: docs mark user_ids as required.
    warn('payload has no user_ids.user_data (no valid sid/udid/hashed PII is present); ' +
      'hit is sent without user_ids');
  }

  if (data.sendS2sHeaders &&
      consent.mode.ad_storage === 'granted' &&
      consent.mode.ad_user_data === 'granted') {
    var s2sHeaders = buildS2sHeaders();
    if (hasProperties(s2sHeaders)) {
      payload.s2s_headers = s2sHeaders;
    }
  }

  return payload;
}

// event_time is a positive integer in milliseconds. Anything else (0, negative,
// non-numeric, non-finite) falls back to server time with a WARN.
function normalizeEventTime(rawValue) {
  if (isMissing(rawValue)) {
    return getTimestampMillis();
  }
  var num = toNumber(rawValue);
  // Auto-detect seconds vs ms: values < 10000000000 (year 2286 in seconds) are seconds, upscale to ms.
  var ms = num === undefined ? 0 : Math.round(num < 10000000000 ? num * 1000 : num);
  if (ms < 1) {
    warn('eventTime is not a positive number of seconds or milliseconds; using server time');
    return getTimestampMillis();
  }
  return ms;
}

function buildS2sHeaders() {
  var headers = {};

  // Client IP: take first entry from x-forwarded-for
  var xff = getRequestHeader('x-forwarded-for');
  if (xff) {
    var firstIp = xff.split(',')[0];
    if (firstIp) headers.client_ip_address = firstIp.trim();
  }

  addIfPresent(headers, 'user_agent', getRequestHeader('user-agent'));
  addIfPresent(headers, 'sec_ch_ua', getRequestHeader('sec-ch-ua'));
  addIfPresent(headers, 'sec_ch_ua_mobile', getRequestHeader('sec-ch-ua-mobile'));
  addIfPresent(headers, 'sec_ch_ua_model', getRequestHeader('sec-ch-ua-model'));
  addIfPresent(headers, 'sec_ch_ua_platform', getRequestHeader('sec-ch-ua-platform'));
  addIfPresent(headers, 'sec_ch_ua_platform_version', getRequestHeader('sec-ch-ua-platform-version'));

  return headers;
}

// USER_DATA_ALIAS_MAP is declared near the top (before the main execution flow) so it
// is initialized before buildUserData() runs. See note there.

function isAliasKey(key) {
  for (var i = 0; i < USER_DATA_ALIAS_MAP.length; i++) {
    if (USER_DATA_ALIAS_MAP[i].alias === key) return true;
  }
  return false;
}

// Builds a fresh normalized object from a userDataObject input.
// - Non-alias keys are copied verbatim (Pass 1).
// - Alias keys are NEVER copied to output; they are translated to canonical (Pass 2).
// - WARN logs once per alias key that is present AND non-empty, regardless of
//   whether canonical wins — this helps users discover canonical names.
// - Canonical wins when supplied (uses isUnset: a placeholder canonical value loses).
function normalizeUserDataObject(source) {
  if (!source) return source;
  var out = {};

  // Pass 1: copy non-alias keys verbatim — canonical values land first.
  for (var key in source) {
    if (!source.hasOwnProperty(key)) continue;
    if (isAliasKey(key)) continue;
    out[key] = source[key];
  }

  // Pass 2: process aliases in array order (deterministic).
  for (var i = 0; i < USER_DATA_ALIAS_MAP.length; i++) {
    var entry = USER_DATA_ALIAS_MAP[i];
    if (!source.hasOwnProperty(entry.alias)) continue;
    var aliasVal = source[entry.alias];
    if (isUnset(aliasVal)) continue;
    warn('userDataObject.' + entry.alias + ' is a frontend-template alias - prefer canonical key "' +
      entry.canonical + '" for clarity');
    if (isUnset(out[entry.canonical])) {
      out[entry.canonical] = aliasVal;
    }
  }

  return out;
}

function buildUserData(data, parsedUserDataObject) {
  var merged = {};

  // Layer 0: GA4 auto-mapped sha256_* fields (no-op when auto-map disabled).
  mergeObject(merged, ga4.userData, 'user_data.');

  // Layer 1: object variable, with FE-template alias normalization.
  if (parsedUserDataObject) {
    mergeObject(merged, normalizeUserDataObject(parsedUserDataObject), 'user_data.');
  }

  // Layer 2: individual fields
  addLayerValue(merged, 'user_data.', 'sid', data.sid);
  addLayerValue(merged, 'user_data.', 'em', data.userEmail);
  addLayerValue(merged, 'user_data.', 'ph', data.userPhone);
  addLayerValue(merged, 'user_data.', 'fn', data.userFirstName);
  addLayerValue(merged, 'user_data.', 'ln', data.userLastName);
  addLayerValue(merged, 'user_data.', 'ge', data.userGender);
  addLayerValue(merged, 'user_data.', 'db', data.userDob);
  addLayerValue(merged, 'user_data.', 'ct', data.userCity);
  // `userState` retained as deprecated runtime fallback (UI renamed to `userRegion`, wire key `region`).
  // It applies only when userRegion is not supplied; a supplied invalid userRegion stays authoritative.
  addLayerValue(merged, 'user_data.', 'region', isUnset(data.userRegion) ? data.userState : data.userRegion);
  addLayerValue(merged, 'user_data.', 'zp', data.userZip);
  addLayerValue(merged, 'user_data.', 'sr', data.userStreet);
  addLayerValue(merged, 'user_data.', 'country', data.userCountry);
  addLayerValue(merged, 'user_data.', 'subscription_id', data.userSubscriptionId);
  addLayerValue(merged, 'user_data.', 'udid', data.userUdid);

  // Layer 3: override table
  applyOverrides(merged, data.userDataOverrides, 'user_data.');

  // One typed normalization pass: unknown keys are dropped, every value is a non-empty string.
  var userData = {};
  for (var key in merged) {
    if (!merged.hasOwnProperty(key)) continue;
    if (!contains(USER_DATA_KEYS, key)) {
      warn('user_data.' + key + ' is not a Seznam field, dropping');
      continue;
    }
    if (key === 'sid' || key === 'udid') continue;
    setNormalized(userData, key, 'id', merged[key], 'user_data.' + key);
  }

  // Layer 4: sid / udid, with the request cookies as the LOWEST-priority source.
  identity.sid = resolveIdentity(userData, 'sid', merged.sid);
  identity.udid = resolveIdentity(userData, 'udid', merged.udid);
  if (identity.sid === 'missing') {
    warn('no valid sid (tag fields, User Data Object, overrides or sid cookie); ' +
      'Seznam can match this hit only on the other identifiers');
  }

  return userData;
}

// sid and udid follow one shape rule whatever their source. The explicit value (object, field or
// override) is checked first; a malformed one is dropped with a WARN, so a valid request cookie
// can still fill the gap. Sets userData[name] and returns the source: 'tag', 'cookie' or 'missing'.
// Cookie fallback notes:
// - Explicit-false check: defaultValue=true may not hydrate into existing instances on
//   template upgrade, so treat undefined as ON.
// - The 'sid' cookie value contains '=' (id=...|...|c=...); getCookieValues splits on the
//   first '=' only, so the full SID string is returned intact.
// - The 'udid' cookie carries a '<uuid>@<timestamp>' suffix (set by sul.js); only the uuid
//   part is the canonical udid sent S2S (matches sem.js cookie-read behaviour). The same
//   normalization applies to an explicit udid.
// - Seznam SID is NEVER read from GA4 event_data: GA4's 'sid' query param is the GA4 session
//   id, not the Seznam SID. Cookie 'sid' is the only auto-source here.
function resolveIdentity(userData, name, explicitValue) {
  var explicit = isMissing(explicitValue) ? undefined : normalizeValue('id', explicitValue, 'user_data.' + name);
  if (explicit !== undefined && name === 'udid') explicit = normalizeUdid(explicit);
  if (explicit !== undefined) {
    if (isValidIdentity(name, explicit)) {
      userData[name] = explicit;
      return 'tag';
    }
    warn('ignoring malformed ' + name + ' from the tag configuration');
  }

  if (data.autoMapIdsFromCookies !== false) {
    var cookieValue = getFirstCookie(name);
    if (name === 'udid') cookieValue = normalizeUdid(cookieValue);
    if (cookieValue && isValidIdentity(name, cookieValue)) {
      userData[name] = cookieValue;
      return 'cookie';
    }
    if (cookieValue) warn('ignoring malformed ' + name + ' cookie');
  }
  return 'missing';
}

function isValidIdentity(name, value) {
  return name === 'sid' ? isValidSid(value) : isValidUdid(value);
}

function buildEventData(data, parsed, sznaiidValue) {
  var merged = {};

  // Layer 0: GA4 auto-mapped fields, including contents from items[] (no-op when auto-map disabled).
  mergeObject(merged, ga4.eventData, 'event_data.');

  // Layer 1: object variable
  mergeObject(merged, parsed.eventData.value, 'event_data.');

  // Layer 1b: sznaiid fallback from cookie / URL.
  // Manual data.sznaiid (Layer 2 below) overrides this.
  if (sznaiidValue && isMissing(merged.sznaiid)) merged.sznaiid = sznaiidValue;

  // Layer 2: individual fields. Values are converted to their wire types below.
  addLayerValue(merged, 'event_data.', 'sznaiid', data.sznaiid);
  addLayerValue(merged, 'event_data.', 'currency', data.currency);
  addLayerValue(merged, 'event_data.', 'value', data.value);
  addLayerValue(merged, 'event_data.', 'value_tax', data.valueTax);
  addLayerValue(merged, 'event_data.', 'order_id', data.orderId);
  addLayerValue(merged, 'event_data.', 'content_type', data.contentType);
  addLayerValue(merged, 'event_data.', 'delivery_price', data.deliveryPrice);
  addLayerValue(merged, 'event_data.', 'delivery_type', data.deliveryType);
  addLayerValue(merged, 'event_data.', 'payment_type', data.paymentType);
  addLayerValue(merged, 'event_data.', 'other_costs', data.otherCosts);
  addLayerValue(merged, 'event_data.', 'predicted_ltv', data.predictedLtv);
  addLayerValue(merged, 'event_data.', 'goods_intention', data.goodsIntention);
  addLayerValue(merged, 'event_data.', 'goods_phase', data.goodsPhase);
  addLayerValue(merged, 'event_data.', 'search_string', data.searchString);
  addLayerValue(merged, 'event_data.', 'review_email', data.reviewEmail); // NOT hashed - intentional (Zbozi.cz survey).
  addLayerValue(merged, 'event_data.', 'product_ids', parsed.productIds.value);
  addLayerValue(merged, 'event_data.', 'contents', parsed.contents.value);

  // status: `statusEnabled` distinguishes "not set" from false. The value is converted by the
  // same boolean normalizer as the other layers; enabled without a value sends false (historic).
  if (data.statusEnabled) {
    merged.status = isUnset(data.status) ? false : data.status;
  }

  // Layer 3: override table
  applyOverrides(merged, data.eventDataOverrides, 'event_data.');

  // One typed normalization pass over the merged layers: unknown keys are dropped, every
  // value is converted to its wire type, invalid optional values are omitted with a WARN.
  var ed = {};
  for (var key in merged) {
    if (!merged.hasOwnProperty(key) || key === 'sem_id') continue;
    if (!EVENT_DATA_TYPES.hasOwnProperty(key)) {
      warn('event_data.' + key + ' is not a Seznam field, dropping');
      continue;
    }
    setNormalized(ed, key, EVENT_DATA_TYPES[key], merged[key], 'event_data.' + key);
  }

  if (ed.currency !== undefined && ed.currency !== 'CZK') {
    warn('currency=' + ed.currency + ' - Seznam SEM currently supports only CZK');
  }

  // SEM requires content_type whenever contents is present. Checkout/cart payloads
  // with product arrays should use product; explicit values still win.
  // Contents emptied by dropped items are omitted, so no content_type is generated for them.
  if (ed.contents !== undefined && ed.content_type === undefined) {
    ed.content_type = 'product';
    warn('contents present without content_type; defaulting content_type=product');
  }

  // FE-parity convenience: CompleteRegistration defaults to status=true only when NO layer
  // supplied a status (object → individual → overrides). False from any layer is kept, and an
  // invalid status (e.g. 'no') is omitted with a WARN rather than turned into true.
  if (resolvedEventName === 'CompleteRegistration' && merged.status === undefined) {
    ed.status = true;
  }

  // sem_id is an invariant: always the configured S2S SEM ID, set after every input layer.
  ed.sem_id = data.semId;

  return ed;
}

// Converts one present value to its wire type (see EVENT_DATA_TYPES). Returns undefined,
// with a WARN naming the field and the received type, when the value does not fit.
function normalizeValue(type, value, path) {
  if (type === 'contents') return normalizeContents(value, path);
  if (type === 'product_ids') return normalizeProductIds(value, path);
  var out;
  var expected = type;
  if (type === 'id' || type === 'text') {
    out = toText(value, type === 'id');
    expected = 'string or number';
  } else if (type === 'number') {
    out = toNumber(value);
  } else if (type === 'integer') {
    out = toNumber(value);
    if (out !== undefined && out !== Math.floor(out)) out = undefined;
  } else if (type === 'boolean') {
    out = toBoolean(value);
    expected = 'boolean (true/false, 1/0)';
  } else if (type === 'content_type') {
    out = toText(value, true);
    if (out !== undefined && !contains(CONTENT_TYPES, out)) out = undefined;
    expected = 'one of ' + CONTENT_TYPES.join(', ');
  }
  if (out === undefined) {
    warn(path + ': expected ' + expected + ', got ' + describeType(value) + '; omitting');
  }
  return out;
}

// Sets obj[key] to the normalized value. Missing values are skipped; invalid ones are omitted.
function setNormalized(obj, key, type, value, path) {
  if (isMissing(value)) return;
  var normalized = normalizeValue(type, value, path);
  if (normalized !== undefined) obj[key] = normalized;
}

// Contents from every source (GA4 items, object, field, overrides). A missing quantity, or the
// placeholder 'undefined'/'null' (R7), becomes 1;
// an item whose quantity is present but not an integer >= 1 (0, negative, fractional,
// non-numeric, non-finite) is dropped with a WARN and the other items are kept. An explicit []
// stays []; when dropping empties a non-empty list, contents are omitted.
function normalizeContents(list, path) {
  if (getType(list) !== 'array') {
    warn(path + ': expected array, got ' + getType(list) + '; omitting');
    return undefined;
  }
  var out = [];
  for (var i = 0; i < list.length; i++) {
    var item = list[i];
    var itemPath = path + '[' + i + ']';
    if (getType(item) !== 'object') {
      warn(itemPath + ': expected object, got ' + getType(item) + '; dropping the item');
      continue;
    }
    var content = { quantity: 1 };
    var keep = true;
    for (var key in item) {
      if (!item.hasOwnProperty(key) || isUnsupplied(itemPath + '.' + key, key, item[key])) continue;
      if (!CONTENT_ITEM_TYPES.hasOwnProperty(key)) {
        warn(itemPath + '.' + key + ' is not a Seznam field, dropping');
      } else if (key === 'quantity') {
        var quantity = toNumber(item.quantity);
        if (quantity === undefined || quantity < 1 || quantity !== Math.floor(quantity)) {
          warn(itemPath + '.quantity: expected integer >= 1, got ' + describeType(item.quantity) + '; dropping the item');
          keep = false;
          break;
        }
        content.quantity = quantity;
      } else {
        setNormalized(content, key, CONTENT_ITEM_TYPES[key], item[key], itemPath + '.' + key);
      }
    }
    if (keep) out.push(content);
  }
  if (list.length > 0 && out.length === 0) {
    warn(path + ': every item was dropped; omitting contents');
    return undefined;
  }
  return out;
}

// product_ids from every source: integers >= 0; invalid entries are skipped with a WARN.
function normalizeProductIds(list, path) {
  if (getType(list) !== 'array') {
    warn(path + ': expected array, got ' + getType(list) + '; omitting');
    return undefined;
  }
  var out = [];
  for (var i = 0; i < list.length; i++) {
    var n = toNumber(list[i]);
    if (n === undefined || n < 0 || n !== Math.floor(n)) {
      warn(path + '[' + i + ']: expected integer >= 0, got ' + describeType(list[i]) + '; skipping');
      continue;
    }
    out.push(n);
  }
  return (list.length > 0 && out.length === 0) ? undefined : out;
}

/*******************************************************************************
 * Shared utilities
 ******************************************************************************/

// Parse a field that may be an object, a JSON string, or missing (isMissing). Returns {value, error}.
// Other values, including false and 0, are input errors.
// Callers decide severity (WARN vs. fail) based on strictEventValidation.
// Note: sandboxed JS does not support try/catch, but JSON.parse returns undefined on invalid input.
function parseJsonObjectField(fieldName, rawValue) {
  if (isMissing(rawValue)) return { value: null, error: null };
  if (getType(rawValue) === 'object') return { value: rawValue, error: null };
  if (getType(rawValue) === 'string') {
    var parsed = JSON.parse(rawValue);
    if (parsed === undefined) {
      return { value: null, error: fieldName + ': invalid JSON, got string' };
    }
    if (getType(parsed) === 'object') return { value: parsed, error: null };
    return { value: null, error: fieldName + ': expected a JSON object, got string' };
  }
  return { value: null, error: fieldName + ': expected object or JSON string, got ' + getType(rawValue) };
}

// Parse a field that may be an array, a JSON string of an array, or empty. Returns {value, error}.
function parseJsonArray(fieldName, rawValue) {
  if (isMissing(rawValue)) return { value: null, error: null };
  if (getType(rawValue) === 'array') return { value: rawValue, error: null };
  if (getType(rawValue) === 'string') {
    var parsed = JSON.parse(rawValue);
    if (parsed === undefined) {
      return { value: null, error: fieldName + ': invalid JSON, got string' };
    }
    if (getType(parsed) === 'array') return { value: parsed, error: null };
    return { value: null, error: fieldName + ': expected a JSON array, got string' };
  }
  return { value: null, error: fieldName + ': expected array or JSON string, got ' + getType(rawValue) };
}

// The one "not supplied" rule for every input: undefined, null and blank strings.
// false, 0 and [] are values.
function isMissing(v) {
  return v === undefined || v === null || (getType(v) === 'string' && v.trim() === '');
}

// Strings a broken variable mapping produces. They count as missing for IDs, numbers and consent,
// never for free text.
function isPlaceholder(v) {
  return getType(v) === 'string' && (v.trim() === 'undefined' || v.trim() === 'null');
}

function isUnset(v) {
  return isMissing(v) || isPlaceholder(v);
}

// Type description for WARN/ERROR lines; never includes the value itself.
function describeType(v) {
  return isPlaceholder(v) ? 'the placeholder string "' + v.trim() + '"' : getType(v);
}

// Strings are trimmed and finite numbers become strings (numeric order or event IDs).
// Returns undefined for other types, for empty strings and, for IDs, for placeholders.
function toText(v, isId) {
  var s;
  if (getType(v) === 'string') s = v.trim();
  else if (getType(v) === 'number' && v - v === 0) s = '' + v;
  else return undefined;
  if (s === '' || (isId && isPlaceholder(s))) return undefined;
  return s;
}

// Canonical finite numbers only: a number, or a plain decimal string such as '1234.50' or '-5'.
// No locale guessing: '1,234', '1 234', '1e3', '0x10' and 'Infinity' return undefined.
// `n - n === 0` is false for NaN and ±Infinity.
function toNumber(v) {
  var n;
  if (getType(v) === 'number') n = v;
  else if (getType(v) === 'string' && isDecimalString(v.trim())) n = makeNumber(v.trim());
  else return undefined;
  return n - n === 0 ? n : undefined;
}

function isDecimalString(s) {
  var digits = 0;
  var dots = 0;
  for (var i = 0; i < s.length; i++) {
    var c = s.charAt(i);
    if (c === '-' && i === 0) continue;
    if (c === '.') dots++;
    else if ('0123456789'.indexOf(c) !== -1) digits++;
    else return false;
  }
  return digits > 0 && dots <= 1;
}

function toBoolean(v) {
  if (contains(TRUE_VALUES, v)) return true;
  if (contains(FALSE_VALUES, v)) return false;
  return undefined;
}

// Strict-equality membership test (true and 'true' are different entries).
function contains(list, v) {
  for (var i = 0; i < list.length; i++) {
    if (list[i] === v) return true;
  }
  return false;
}

function warn(message) {
  logToConsole('Seznam SEM [WARN]: ' + message + ' | trace=' + traceId);
}

function addIfPresent(obj, key, value) {
  if (!isMissing(value)) {
    obj[key] = value;
  }
}

// Returns the first value of an inbound request cookie, or '' when absent.
function getFirstCookie(name) {
  var values = getCookieValues(name);
  return (getType(values) === 'array' && values.length > 0) ? values[0] : '';
}

// The 'udid' cookie set by sul.js is '<uuid>@<timestamp>'; the canonical udid sent S2S is
// only the uuid part (matches sem.js cookie-read behaviour). Empty input returns ''.
function normalizeUdid(v) {
  if (!v) return '';
  var parts = v.split('@');
  return parts[0] || v;
}

// Cookie values are user-controllable and explicit values can be mis-mapped, so sid/udid from
// every source are shape-checked before forwarding. Structural checks only (split / indexOf /
// length); the charset is left to the Seznam server.

// UUID shape via segment lengths: 8-4-4-4-12.
function isValidUdid(v) {
  if (!v) return false;
  var p = v.split('-');
  return p.length === 5 &&
         p[0].length === 8 && p[1].length === 4 && p[2].length === 4 &&
         p[3].length === 4 && p[4].length === 12;
}

// Seznam SID shape (matches sem.js `sn`): id=...|t=...|te=...|c=<32 chars>.
function isValidSid(v) {
  if (!v) return false;
  var parts = v.split('|');
  if (parts.length !== 4) return false;
  if (parts[0].indexOf('id=') !== 0 || parts[0].length <= 3) return false;
  if (parts[1].indexOf('t=') !== 0 || parts[1].length <= 2) return false;
  if (parts[2].indexOf('te=') !== 0 || parts[2].length <= 3) return false;
  var c = parts[3].split('=');
  return c.length === 2 && c[0] === 'c' && c[1].length === 32;
}

// Full ^[0-9a-z]{24}$ check. charAt and indexOf are documented sandbox String methods;
// charCodeAt is not (the v2.1.0 check that used it crashed in deployment).
function isValidSemId(id) {
  if (getType(id) !== 'string' || id.length !== 24) return false;
  for (var i = 0; i < id.length; i++) {
    if (SEM_ID_CHARS.indexOf(id.charAt(i)) === -1) return false;
  }
  return true;
}

// Override rows: later rows win, with the layer rule of addLayerValue(); false and 0 are values.
// Values keep their raw type here and are converted by the normalization pass.
function applyOverrides(obj, table, prefix) {
  if (!table) return;
  for (var i = 0; i < table.length; i++) {
    var row = table[i];
    if (row && row.name) addLayerValue(obj, prefix, row.name, row.value);
  }
}

// Copies the supplied values of `source` onto `target` (see addLayerValue).
function mergeObject(target, source, prefix) {
  if (!source) return;
  for (var key in source) {
    if (source.hasOwnProperty(key)) addLayerValue(target, prefix, key, source[key]);
  }
}

// The merge contract (R8): a value that is not supplied never erases an earlier layer. Genuinely
// invalid supplied values still override and are then normalized and validated.
function addLayerValue(target, prefix, key, value) {
  if (!isUnsupplied(prefix + key, key, value)) target[key] = value;
}

// Not supplied: missing, or a placeholder ('undefined'/'null') in any key except free text.
// A skipped placeholder is reported, because it points at a broken variable mapping.
function isUnsupplied(path, key, value) {
  if (isMissing(value)) return true;
  if (isPlaceholder(value) && !contains(FREE_TEXT_KEYS, key)) {
    warn(path + ' is the placeholder string "' + value.trim() + '"; treating it as missing');
    return true;
  }
  return false;
}

// Iterates with hasOwnProperty, which v2.3 already depends on. The server API offers
// require('Object').keys; switching to it is deferred to v3 (review N3).
function hasProperties(obj) {
  if (!obj) return false;
  for (var key in obj) {
    if (obj.hasOwnProperty(key)) {
      return true;
    }
  }
  return false;
}

function log(message) {
  if (data.testMode) {
    logToConsole(JSON.stringify(message));
  }
}

function logHttpError(result) {
  var bodySnippet = result.body ? JSON.stringify(result.body).substring(0, 200) : 'n/a';
  var requestId = result.headers ? result.headers['x-request-id'] : undefined;
  // Seznam answers 401/403 for an invalid SEM ID or an endpoint the account cannot use (s2s.html).
  var hint = (result.statusCode === 401 || result.statusCode === 403)
    ? ' | hint=Seznam rejected the SEM ID or the endpoint access: use the S2S SEM ID from Sklik ' +
      '(advanced account settings), not the sul.js SEM ID'
    : '';
  logToConsole('Seznam SEM [ERROR]: HTTP ' + result.statusCode +
    ' | event=' + resolvedEventName +
    ' | semId=' + data.semId +
    ' | request_id=' + requestId +
    ' | trace=' + traceId +
    ' | body=' + bodySnippet + hint);
}

function logToBigQuery(requestInfo, responseInfo) {
  if (data.bigQueryLogType !== 'always') return;

  var bqRow = {
    tag_name: 'Seznam SEM',
    event_name: resolvedEventName,
    request_method: 'POST',
    request_url: requestInfo.url,
    request_body: JSON.stringify(requestInfo.body),
    timestamp: getTimestampMillis()
  };

  if (responseInfo) {
    bqRow.request_id = responseInfo.headers ? responseInfo.headers['x-request-id'] : undefined;
    bqRow.response_status_code = responseInfo.statusCode;
    bqRow.response_headers = JSON.stringify(responseInfo.headers);
    bqRow.response_body = responseInfo.body;
  }

  BigQuery.insert(
    {
      projectId: data.logBigQueryProjectId,
      datasetId: data.logBigQueryDatasetId,
      tableId: data.logBigQueryTableId
    },
    [bqRow],
    { ignoreUnknownValues: true }
  ).catch(function(errors) {
    logToConsole('Seznam SEM [ERROR]: BigQuery insert failed: ' + JSON.stringify(errors));
  });
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "name" },
                  { "type": 1, "string": "domain" },
                  { "type": 1, "string": "path" },
                  { "type": 1, "string": "secure" },
                  { "type": 1, "string": "session" }
                ],
                "mapValue": [
                  { "type": 1, "string": "sznaiid" },
                  { "type": 1, "string": "*" },
                  { "type": 1, "string": "*" },
                  { "type": 1, "string": "any" },
                  { "type": 1, "string": "any" }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              { "type": 1, "string": "sznaiid" },
              { "type": 1, "string": "sid" },
              { "type": 1, "string": "udid" }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "trace-id"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "referer"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-forwarded-for"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "user-agent"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "sec-ch-ua"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "sec-ch-ua-mobile"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "sec-ch-ua-model"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "sec-ch-ua-platform"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "sec-ch-ua-platform-version"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParametersAllowed",
          "value": {
            "type": 8,
            "boolean": false
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://sem.seznam.cz/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_bigquery",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedTables",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "projectId" },
                  { "type": 1, "string": "datasetId" },
                  { "type": 1, "string": "tableId" },
                  { "type": 1, "string": "operation" }
                ],
                "mapValue": [
                  { "type": 1, "string": "*" },
                  { "type": 1, "string": "*" },
                  { "type": 1, "string": "*" },
                  { "type": 1, "string": "write" }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Purchase minimal valid - contents is optional (regression P0-3)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((resolve) => {
        resolve({ statusCode: 200, headers: {}, body: '' });
      });
    });
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      orderId: 'ORDER-1',
      currency: 'CZK',
      value: 100,
      useOptimisticScenario: false
    });
    callLater(() => {
      assertApi('gtmOnSuccess').wasCalled();
      assertThat(capturedBody.event_name).isEqualTo('Purchase');
    });

- name: Purchase missing orderId fails (synchronous validation)
  code: |-
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      currency: 'CZK',
      value: 100
    });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();

- name: event_time in seconds is upscaled to ms (regression P0-1)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      eventTime: 1700000000,
      useOptimisticScenario: false
    });
    // Payload capture is synchronous inside the mock; no callLater needed.
    assertThat(capturedBody.event_time).isEqualTo(1700000000000);

- name: event_time in ms is passed through
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      eventTime: 1700000000000,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_time).isEqualTo(1700000000000);

- name: userRegion maps to wire key region (regression P0-2)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userRegion: 'PR',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.region).isEqualTo('PR');
    assertThat(capturedBody.user_ids.user_data.st).isUndefined();

- name: userState legacy fallback still maps to region
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userState: 'PR',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.region).isEqualTo('PR');

- name: userRegion takes precedence over userState fallback
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userRegion: 'PR',
      userState: 'XX',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.region).isEqualTo('PR');

- name: api object is present in payload (regression P1-1)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.api.name).isEqualTo('gtm-server-template');
    assertThat(capturedBody.api.version).isDefined();
    assertThat(capturedBody.api.template_version).isDefined();

- name: Consent denied drops s2s_headers
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getRequestHeader', (name) => {
      if (name === 'x-forwarded-for') return '1.2.3.4';
      if (name === 'user-agent') return 'test-ua';
      return undefined;
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      consentModeObject: { ad_storage: 'denied', ad_user_data: 'denied' },
      sendS2sHeaders: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.s2s_headers).isUndefined();

- name: Unknown event + strict fails (synchronous validation)
  code: |-
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'from_variable',
      eventNameFromVariable: 'Foo',
      semId: 'abcdefghijklmnopqrstuvwx',
      strictEventValidation: true
    });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();

- name: 'v3: Unknown event with stored loose validation fails with the v2 hint (d.8)'
  code: |-
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'from_variable',
      eventNameFromVariable: 'Foo',
      semId: 'abcdefghijklmnopqrstuvwx',
      strictEventValidation: false,
      useOptimisticScenario: true
    });
    // v3 is always strict; the stored loose setting only adds the hint to the ERROR line.
    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
    assertApi('sendHttpRequest').wasNotCalled();
    assertThat(logged('Unknown event name: Foo')).isTrue();
    assertThat(logged('(v2 loose validation no longer applies)')).isTrue();

- name: 'v3: Invalid JSON in userDataObject is an ERROR, the object is omitted and the hit is sent (d.9)'
  code: |-
    runCode(tagData({ userDataObject: '{not json', strictEventValidation: true, logType: 'no' }));
    assertThat(sent().event_name).isEqualTo('PageView');
    assertThat(sent().user_ids).isUndefined();
    assertThat(logged('Seznam SEM [ERROR]: userDataObject: invalid JSON, got string; omitting it')).isTrue();
    assertSucceeded();

- name: 'v3: Invalid JSON in eventDataObject is an ERROR, the object is omitted and the hit is sent (d.9)'
  code: |-
    runCode(tagData({ eventDataObject: '{not json', strictEventValidation: true, logType: 'no' }));
    assertThat(sent().event_data).isEqualTo({ sem_id: SEM_ID });
    assertThat(logged('Seznam SEM [ERROR]: eventDataObject: invalid JSON, got string; omitting it')).isTrue();
    assertSucceeded();

- name: 'v3: Invalid JSON in the Contents field is omitted with a WARN and the hit is sent (d.9)'
  code: |-
    runCode(tagData({ contents: '{not json', strictEventValidation: true }));
    assertThat(sent().event_data.contents).isUndefined();
    assertThat(logged('event_data.contents: invalid JSON, got string; omitting')).isTrue();
    assertSucceeded();

- name: Invalid JSON in userDataObject warns under loose (does not crash)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userDataObject: '{not json',
      strictEventValidation: false,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_name).isEqualTo('PageView');
    callLater(() => { assertApi('gtmOnSuccess').wasCalled(); });

- name: status false is included in payload
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'CompleteRegistration',
      semId: 'abcdefghijklmnopqrstuvwx',
      statusEnabled: true,
      status: 'false',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.status).isEqualTo(false);

- name: value_tax first-class coerces to number
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      valueTax: '19.50',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.value_tax).isEqualTo(19.5);

- name: reviewEmail first-class is passed plain text
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      orderId: 'ORDER-1',
      currency: 'CZK',
      value: 100,
      reviewEmail: 'user@example.com',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.review_email).isEqualTo('user@example.com');

- name: productIds skips non-integer and negative entries
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      productIds: '["12","34","bad",-1]',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.product_ids).isEqualTo([12, 34]);

- name: userUdid maps to wire key udid
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userUdid: '019ef805-5dbe-7e8b-acd1-8caed14a91fa',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.udid).isEqualTo('019ef805-5dbe-7e8b-acd1-8caed14a91fa');

- name: sid is auto-mapped from the 'sid' request cookie when no explicit field
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getCookieValues', (name) => name === 'sid'
      ? ['id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79']
      : []);
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.sid).isEqualTo('id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79');

- name: udid cookie with uuid@timestamp suffix is normalized to the canonical uuid
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getCookieValues', (name) => name === 'udid'
      ? ['019ef805-5dbe-7e8b-acd1-8caed14a91fa@1782277561803']
      : []);
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.udid).isEqualTo('019ef805-5dbe-7e8b-acd1-8caed14a91fa');

- name: explicit sid/udid fields win over request cookies
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getCookieValues', (name) => {
      if (name === 'sid') return ['id=1|t=1.000|te=1.000|c=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'];
      if (name === 'udid') return ['11111111-2222-3333-4444-555555555555@123'];
      return [];
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      sid: 'id=2|t=2.000|te=2.000|c=BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
      userUdid: '019ef805-5dbe-7e8b-acd1-8caed14a91fa',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.sid).isEqualTo('id=2|t=2.000|te=2.000|c=BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB');
    assertThat(capturedBody.user_ids.user_data.udid).isEqualTo('019ef805-5dbe-7e8b-acd1-8caed14a91fa');

- name: cookie auto-map of sid/udid can be disabled
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getCookieValues', (name) => {
      if (name === 'sid') return ['id=COOKIE'];
      if (name === 'udid') return ['cookie-uuid@123'];
      return [];
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      autoMapIdsFromCookies: false,
      userEmail: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.sid).isUndefined();
    assertThat(capturedBody.user_ids.user_data.udid).isUndefined();

- name: User Data Object sid/udid win over request cookies
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getCookieValues', (name) => {
      if (name === 'sid') return ['id=1|t=1.000|te=1.000|c=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'];
      if (name === 'udid') return ['019ef805-5dbe-7e8b-acd1-8caed14a91fa@123'];
      return [];
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userDataObject: {
        sid: 'id=2|t=2.000|te=2.000|c=BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
        udid: '11111111-2222-3333-4444-555555555555'
      },
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.sid).isEqualTo('id=2|t=2.000|te=2.000|c=BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB');
    assertThat(capturedBody.user_ids.user_data.udid).isEqualTo('11111111-2222-3333-4444-555555555555');

- name: malformed sid/udid cookies are rejected, not forwarded
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getCookieValues', (name) => {
      if (name === 'sid') return ['not-a-valid-sid'];
      if (name === 'udid') return ['short@123'];
      // keep user_data non-empty so user_ids exists
      return [];
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userEmail: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.sid).isUndefined();
    assertThat(capturedBody.user_ids.user_data.udid).isUndefined();

- name: contents empty array is passed through
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'ViewContent',
      semId: 'abcdefghijklmnopqrstuvwx',
      contents: [],
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.contents).isEqualTo([]);

- name: contents without content_type defaults to product
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'InitiateCheckout',
      semId: 'abcdefghijklmnopqrstuvwx',
      currency: 'CZK',
      value: 494.21,
      contents: [{ id: '50118490', quantity: 1, unit_price: 123.14 }],
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.content_type).isEqualTo('product');
    assertThat(capturedBody.event_data.contents.length).isEqualTo(1);

- name: explicit content_type is preserved when contents is present
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      contentType: 'product_group',
      contents: [{ id: 'CATEGORY-1' }],
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.content_type).isEqualTo('product_group');

- name: Short semId + strict fails (length check, synchronous validation)
  code: |-
    // The local check enforces ^[0-9a-z]{24}$. 'BAD' fails it.
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'BAD',
      strictEventValidation: true
    });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();

- name: 'v3: Short semId with stored loose validation fails (d.8)'
  code: |-
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'BAD',
      strictEventValidation: false,
      useOptimisticScenario: true
    });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();
    assertThat(logged('semId must be 24 characters')).isTrue();
    assertThat(logged('(v2 loose validation no longer applies)')).isTrue();

- name: 'v3: SemId off pattern 24 chars fails without crashing (hotfix v211, d.8)'
  code: |-
    // Hotfix regression: the old charCodeAt-based charset check crashed with TypeError in the SGTM
    // sandbox. The charAt/indexOf check rejects an upper-case 24-char string; v3 always fails on it.
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 400 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'ABCDEFGHIJKLMNOPQRSTUVWX',
      strictEventValidation: false,
      useOptimisticScenario: true
    });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();

- name: Non-CZK currency sends with warning (regression P2-2)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      orderId: 'ORDER-1',
      currency: 'EUR',
      value: 100,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.currency).isEqualTo('EUR');
    callLater(() => { assertApi('gtmOnSuccess').wasCalled(); });

- name: sznaiid extracted from referer URL and injected into payload (v22 cookie-1)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    // page_location empty so referer fallback path is exercised.
    mock('getAllEventData', () => ({}));
    mock('getRequestHeader', (name) => name === 'referer' ? 'https://shop.example/lp?sznaiid=ABC123' : undefined);
    mock('getCookieValues', () => []);
    mock('setCookie', () => {});
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.sznaiid).isEqualTo('ABC123');

- name: sznaiid cookie written first_touch when none exists (v22 cookie-2)
  code: |-
    let capturedCookieWrite;
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    mock('getAllEventData', () => ({ page_location: 'https://shop.example/lp?sznaiid=NEWVAL' }));
    mock('getCookieValues', () => []);
    mock('setCookie', (name, value, options) => { capturedCookieWrite = { name: name, value: value, options: options }; });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      useOptimisticScenario: false
    });
    assertThat(capturedCookieWrite.name).isEqualTo('sznaiid');
    assertThat(capturedCookieWrite.value).isEqualTo('NEWVAL');
    assertThat(capturedCookieWrite.options.sameSite).isEqualTo('lax');
    assertThat(capturedCookieWrite.options.httpOnly).isEqualTo(false);
    assertThat(capturedCookieWrite.options.secure).isEqualTo(true);

- name: 'v3: sznaiid cookie is overwritten by a new click whatever the stored mode (v22 cookie-3, d.3)'
  code: |-
    let capturedCookieWrite;
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    mock('getAllEventData', () => ({ page_location: 'https://shop.example/lp?sznaiid=NEWVAL' }));
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['EXISTING'] : []);
    mock('setCookie', (name, value, options) => { capturedCookieWrite = { name: name, value: value, options: options }; });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      useOptimisticScenario: false
    });
    assertThat(capturedCookieWrite.value).isEqualTo('NEWVAL');
    assertThat(capturedCookieWrite.options['max-age']).isEqualTo(2592000);

- name: sznaiid cookie overwritten under last_touch mode (v22 cookie-4)
  code: |-
    let capturedCookieWrite;
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    mock('getAllEventData', () => ({ page_location: 'https://shop.example/lp?sznaiid=NEWVAL' }));
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['EXISTING'] : []);
    mock('setCookie', (name, value, options) => { capturedCookieWrite = { name: name, value: value, options: options }; });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'last_touch',
      sznaiidCookieMaxAge: '7776000',
      useOptimisticScenario: false
    });
    assertThat(capturedCookieWrite.value).isEqualTo('NEWVAL');

- name: Manual data sznaiid wins over cookie value (v22 cookie-5)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({}));
    mock('getRequestHeader', () => undefined);
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['FROM_COOKIE'] : []);
    mock('setCookie', () => {});
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      sznaiid: 'MANUAL_VAL',
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.sznaiid).isEqualTo('MANUAL_VAL');

- name: URL with no sznaiid + cookie present - cookie value injected (v22 cookie-6)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({ page_location: 'https://shop.example/lp' }));
    mock('getRequestHeader', () => undefined);
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['COOKIE_ONLY'] : []);
    mock('setCookie', () => {});
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.sznaiid).isEqualTo('COOKIE_ONLY');

- name: persistSznaiidCookie disabled - URL value still injected, setCookie not called (v22 cookie-7)
  code: |-
    let setCookieCalled = false;
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({ page_location: 'https://shop.example/lp?sznaiid=URLONLY' }));
    mock('getCookieValues', () => []);
    mock('setCookie', () => { setCookieCalled = true; });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      persistSznaiidCookie: false,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.sznaiid).isEqualTo('URLONLY');
    assertThat(setCookieCalled).isEqualTo(false);

- name: gtm-msr preview URL - sznaiid not extracted, cookie not written (v22 cookie-8)
  code: |-
    let setCookieCalled = false;
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({ page_location: 'https://gtm-msr.appspot.com/preview?sznaiid=PREVIEW' }));
    mock('getRequestHeader', () => undefined);
    mock('getCookieValues', () => []);
    mock('setCookie', () => { setCookieCalled = true; });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.sznaiid).isUndefined();
    assertThat(setCookieCalled).isEqualTo(false);

- name: page_location lacks sznaiid but referer has it - referer value used (v22 cookie-9)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({ page_location: 'https://shop.example/cart' }));
    mock('getRequestHeader', (name) => name === 'referer' ? 'https://shop.example/lp?sznaiid=FROMREF' : undefined);
    mock('getCookieValues', () => []);
    mock('setCookie', () => {});
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.sznaiid).isEqualTo('FROMREF');

- name: gtm-msr page_location short-circuits referer fallback (v22 cookie-10)
  code: |-
    let setCookieCalled = false;
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    // page_location is a preview ping; referer happens to carry a real sznaiid.
    // The whole event is preview-context — must NOT inject or write the cookie.
    mock('getAllEventData', () => ({ page_location: 'https://gtm-msr.appspot.com/preview' }));
    mock('getRequestHeader', (name) => name === 'referer' ? 'https://shop.example/lp?sznaiid=REAL_BUT_PREVIEW' : undefined);
    mock('getCookieValues', () => []);
    mock('setCookie', () => { setCookieCalled = true; });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.sznaiid).isUndefined();
    assertThat(setCookieCalled).isEqualTo(false);

- name: Auto-map disabled by default - GA4 fields ignored (v22 automap-1)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      currency: 'CZK', value: 999, transaction_id: 'TX-IGNORED',
      items: [{ item_id: 'X', price: 999, quantity: 1 }]
    }));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.currency).isUndefined();
    assertThat(capturedBody.event_data.value).isUndefined();
    assertThat(capturedBody.event_data.order_id).isUndefined();
    assertThat(capturedBody.event_data.contents).isUndefined();

- name: Auto-map Purchase - GA4 transaction_id maps to order_id, items array maps to contents (v22 automap-2)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      event_name: 'purchase',
      currency: 'CZK', value: 1234, transaction_id: 'TX-AUTO',
      items: [
        { item_id: 'A', item_name: 'Phone', item_category: 'electronics', price: '1234', quantity: '1' }
      ]
    }));
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.order_id).isEqualTo('TX-AUTO');
    assertThat(capturedBody.event_data.currency).isEqualTo('CZK');
    assertThat(capturedBody.event_data.value).isEqualTo(1234);
    assertThat(capturedBody.event_data.contents.length).isEqualTo(1);
    assertThat(capturedBody.event_data.contents[0].id).isEqualTo('A');
    assertThat(capturedBody.event_data.contents[0].content_name).isEqualTo('Phone');
    assertThat(capturedBody.event_data.contents[0].unit_price).isEqualTo(1234);
    assertThat(capturedBody.event_data.contents[0].quantity).isEqualTo(1);

- name: Auto-map respects manual override - manual orderId wins over GA4 transaction_id (v22 automap-3)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({ transaction_id: 'TX-AUTO' }));
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      orderId: 'MANUAL-ORDER',
      currency: 'CZK',
      value: 100,
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.order_id).isEqualTo('MANUAL-ORDER');

- name: Auto-map view_item maps to ViewContent when eventNameSelect is auto (v22 automap-4)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({ event_name: 'view_item' }));
    runCode({
      eventNameSelect: 'auto',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventName: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_name).isEqualTo('ViewContent');

- name: Auto-map skips items without item_id and warns (v22 automap-5)
  code: |-
    let capturedBody;
    let warns = [];
    mock('logToConsole', (msg) => { warns.push(msg); });
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      items: [
        { item_id: 'GOOD', price: 10, quantity: 1 },
        { item_name: 'no-id-item', price: 20, quantity: 1 }
      ]
    }));
    runCode({
      eventNameSelect: 'ViewContent',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.contents.length).isEqualTo(1);
    assertThat(capturedBody.event_data.contents[0].id).isEqualTo('GOOD');
    var foundWarn = false;
    for (var i = 0; i < warns.length; i++) {
      if (warns[i].indexOf('GA4 items skipped (missing item_id)') !== -1) { foundWarn = true; break; }
    }
    assertThat(foundWarn).isEqualTo(true);

- name: Auto-map Purchase passes validate when manual orderId currency value blank (v22 automap-6)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      currency: 'CZK', value: 555, transaction_id: 'TX-VAL'
    }));
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertApi('sendHttpRequest').wasCalled();
    assertThat(capturedBody.event_data.order_id).isEqualTo('TX-VAL');
    assertThat(capturedBody.event_data.value).isEqualTo(555);

- name: Auto-map PII safety - raw email_address NOT propagated, only sha256 fields forwarded (v22 automap-7)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      user_data: {
        email_address: 'raw@example.com',
        phone_number: '+420606000000',
        sha256_email_address: 'HASHED_EM',
        address: { first_name: 'RAW', sha256_first_name: 'HASHED_FN' }
      }
    }));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapUserData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.em).isEqualTo('HASHED_EM');
    assertThat(capturedBody.user_ids.user_data.fn).isEqualTo('HASHED_FN');
    // Raw values must NEVER appear:
    assertThat(JSON.stringify(capturedBody)).contains('HASHED_EM');
    // Negative assertion: raw 'raw@example.com' is not in the payload anywhere.
    var body = JSON.stringify(capturedBody);
    var hasRawEmail = body.indexOf('raw@example.com') !== -1;
    var hasRawPhone = body.indexOf('+420606000000') !== -1;
    var hasRawFirstName = body.indexOf('"RAW"') !== -1;
    assertThat(hasRawEmail).isEqualTo(false);
    assertThat(hasRawPhone).isEqualTo(false);
    assertThat(hasRawFirstName).isEqualTo(false);

- name: WARN logged when event_url empty (v22 spec-1)
  code: |-
    let warns = [];
    mock('logToConsole', (msg) => { warns.push(msg); });
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    // No eventUrl, no ga4.eventUrl (auto-map off), no referer header.
    mock('getRequestHeader', (name) => name === 'trace-id' ? 'TRC' : undefined);
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      useOptimisticScenario: false
    });
    var found = false;
    for (var i = 0; i < warns.length; i++) {
      if (warns[i].indexOf('event_url is empty') !== -1) { found = true; break; }
    }
    assertThat(found).isEqualTo(true);

- name: WARN logged when user_ids empty (v22 spec-2)
  code: |-
    let warns = [];
    mock('logToConsole', (msg) => { warns.push(msg); });
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      useOptimisticScenario: false
    });
    var found = false;
    for (var i = 0; i < warns.length; i++) {
      if (warns[i].indexOf('no user_ids.user_data') !== -1) { found = true; break; }
    }
    assertThat(found).isEqualTo(true);

- name: 'v3: Outgoing request includes X-Client-Id and X-Client-Version 3.0.0 (v221 headers-1, d.12)'
  code: |-
    let capturedOpts;
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedOpts = opts;
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      useOptimisticScenario: false
    });
    assertThat(capturedOpts.headers['X-Client-Id']).isEqualTo('gtm-server-template-seznam-sem');
    assertThat(capturedOpts.headers['X-Client-Version']).isEqualTo('3.0.0');
    assertThat(capturedBody.api.template_version).isEqualTo('3.0.0');

- name: userDataObject with FE aliases - email phone fname mapped to em ph fn (v221 alias-1)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userDataObject: { email: 'HASH_EM', phone: 'HASH_PH', fname: 'HASH_FN' },
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.em).isEqualTo('HASH_EM');
    assertThat(capturedBody.user_ids.user_data.ph).isEqualTo('HASH_PH');
    assertThat(capturedBody.user_ids.user_data.fn).isEqualTo('HASH_FN');
    // Alias keys must NOT appear in payload at all.
    var bodyStr = JSON.stringify(capturedBody);
    assertThat(bodyStr.indexOf('"email"') === -1).isEqualTo(true);
    assertThat(bodyStr.indexOf('"phone"') === -1).isEqualTo(true);
    assertThat(bodyStr.indexOf('"fname"') === -1).isEqualTo(true);

- name: userDataObject canonical key wins over alias - email A em B sends em B (v221 alias-2)
  code: |-
    let capturedBody;
    let warns = [];
    mock('logToConsole', (msg) => { warns.push(msg); });
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userDataObject: { email: 'A', em: 'B' },
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.em).isEqualTo('B');
    // WARN still fires for alias presence regardless of canonical winning.
    var foundWarn = false;
    for (var i = 0; i < warns.length; i++) {
      if (warns[i].indexOf('userDataObject.email') !== -1) { foundWarn = true; break; }
    }
    assertThat(foundWarn).isEqualTo(true);

- name: userDataObject alias triggers WARN log (v221 alias-3)
  code: |-
    let warns = [];
    mock('logToConsole', (msg) => { warns.push(msg); });
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userDataObject: { phone: 'HASH_VALUE' },
      useOptimisticScenario: false
    });
    var foundWarn = false;
    for (var i = 0; i < warns.length; i++) {
      var m = warns[i];
      if (m.indexOf('userDataObject.phone') !== -1 && m.indexOf('"ph"') !== -1) {
        foundWarn = true;
        break;
      }
    }
    assertThat(foundWarn).isEqualTo(true);

- name: Auto-map order_id falls back to id then orderNo (v221 automap-8)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    // Case 1: only `id` present
    mock('getAllEventData', () => ({ id: 'FROM_ID' }));
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      currency: 'CZK',
      value: 100,
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.order_id).isEqualTo('FROM_ID');

- name: Auto-map order_id prefers transaction_id over orderNo (v221 automap-8b)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({ transaction_id: 'TX', orderNo: 'NO' }));
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      currency: 'CZK',
      value: 100,
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.order_id).isEqualTo('TX');

- name: Auto-map order_id falls back to orderNo when transaction_id and id absent (v221 automap-8c)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({ orderNo: 'SHOPTET_ORDER_42' }));
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      currency: 'CZK',
      value: 100,
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.order_id).isEqualTo('SHOPTET_ORDER_42');

- name: Auto-map value falls back to revenue when value missing (v221 automap-9)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({ revenue: 250 }));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.value).isEqualTo(250);

- name: Auto-map value falls back to totalWithoutVat when value and revenue missing (v221 automap-9b)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({ totalWithoutVat: 175 }));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.value).isEqualTo(175);

- name: Auto-map does not derive value from the contents (v221 automap-10)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      items: [
        { item_id: 'A', price: 10, quantity: 2 },
        { item_id: 'B', price: 5,  quantity: 1 }
      ]
    }));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    // unit_price includes VAT and value excludes it, so the template never sums the items.
    assertThat(capturedBody.event_data.value).isUndefined();
    assertThat(capturedBody.event_data.contents.length).isEqualTo(2);

- name: Auto-map Purchase without a value source fails even with zero-priced contents (v221 automap-10b)
  code: |-
    // Free items: unit_price 0. The contents are not a value source, so the Purchase has no value.
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    mock('getAllEventData', () => ({
      items: [
        { item_id: 'FREE_A', price: 0, quantity: 1 },
        { item_id: 'FREE_B', price: 0, quantity: 2 }
      ]
    }));
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'abcdefghijklmnopqrstuvwx',
      currency: 'CZK',
      orderId: 'FREE_ORDER',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();

- name: Auto-map item id name and price fall back to aliases (v221 automap-11)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      items: [
        { id: 'SHOPTET_ID', name: 'Shoptet Item', priceWithVat: 99, quantity: 1 }
      ]
    }));
    runCode({
      eventNameSelect: 'ViewContent',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.contents[0].id).isEqualTo('SHOPTET_ID');
    assertThat(capturedBody.event_data.contents[0].content_name).isEqualTo('Shoptet Item');
    assertThat(capturedBody.event_data.contents[0].unit_price).isEqualTo(99);

- name: Auto-map quantity defaults to 1 when missing and an invalid quantity drops the item (v221 automap-12)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      items: [
        { item_id: 'NOQTY', price: 10 },
        { item_id: 'BADQTY', price: 10, quantity: 'abc' },
        { item_id: 'STRQTY', price: 10, quantity: '3' }
      ]
    }));
    runCode({
      eventNameSelect: 'ViewContent',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    // BADQTY has a present but invalid quantity: the item is dropped, never sent as 1.
    assertThat(capturedBody.event_data.contents).isEqualTo([
      { id: 'NOQTY', unit_price: 10, quantity: 1 },
      { id: 'STRQTY', unit_price: 10, quantity: 3 }
    ]);

- name: Auto-map joins item_category through item_category5 with pipe separator (v221 automap-13)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      items: [
        { item_id: 'GA4', item_category: 'A', item_category2: 'B', item_category3: 'C' },
        { item_id: 'SLASH', category: 'X/Y/Z' },
        { item_id: 'SHOPTET', currentCategory: 'CurrentCat' }
      ]
    }));
    runCode({
      eventNameSelect: 'ViewContent',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.contents[0].content_category).isEqualTo('A | B | C');
    assertThat(capturedBody.event_data.contents[1].content_category).isEqualTo('X | Y | Z');
    assertThat(capturedBody.event_data.contents[2].content_category).isEqualTo('CurrentCat');

- name: Auto-map Shoptet currentCategory array joins with pipe separator (v221 automap-13b)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      items: [
        { item_id: 'SHOPTET_ARR', currentCategory: ['Electronics', 'Phones', 'Smartphones'] },
        { item_id: 'SHOPTET_DEF_ARR', defaultCategory: ['Books', 'Fiction'] }
      ]
    }));
    runCode({
      eventNameSelect: 'ViewContent',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.contents[0].content_category).isEqualTo('Electronics | Phones | Smartphones');
    assertThat(capturedBody.event_data.contents[1].content_category).isEqualTo('Books | Fiction');

- name: Auto-map rounds value and unit_price to 2 decimals (v221 automap-14)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    mock('getAllEventData', () => ({
      value: 19.4567,
      items: [{ item_id: 'A', price: 9.999, quantity: 1 }]
    }));
    runCode({
      eventNameSelect: 'ViewContent',
      semId: 'abcdefghijklmnopqrstuvwx',
      enableGa4AutoMap: true,
      autoMapEventData: true,
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.value).isEqualTo(19.46);
    assertThat(capturedBody.event_data.contents[0].unit_price).isEqualTo(10);

- name: CompleteRegistration without statusEnabled defaults status to true (v221 status-1)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'CompleteRegistration',
      semId: 'abcdefghijklmnopqrstuvwx',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.event_data.status).isEqualTo(true);

- name: CompleteRegistration with explicit statusEnabled false keeps false (v221 status-2)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'CompleteRegistration',
      semId: 'abcdefghijklmnopqrstuvwx',
      statusEnabled: true,
      status: 'false',
      useOptimisticScenario: false
    });
    // Layer 2 set ed.status = false; default check sees ed.status defined → does NOT fire.
    assertThat(capturedBody.event_data.status).isEqualTo(false);

- name: P0 purchase - object-only trio is sent
  code: |-
    runCode(tagData({
      eventNameSelect: 'Purchase',
      eventDataObject: { order_id: 'O-1', currency: 'CZK', value: 100 }
    }));
    assertThat(sent().event_data).isEqualTo({ order_id: 'O-1', currency: 'CZK', value: 100, sem_id: SEM_ID });
    assertSucceeded();

- name: P0 purchase - override-only trio is sent with a numeric value
  code: |-
    runCode(tagData({
      eventNameSelect: 'Purchase',
      eventDataOverrides: [
        { name: 'order_id', value: 'O-2' },
        { name: 'currency', value: 'CZK' },
        { name: 'value', value: '100.50' }
      ]
    }));
    assertThat(sent().event_data).isEqualTo({ order_id: 'O-2', currency: 'CZK', value: 100.5, sem_id: SEM_ID });
    assertSucceeded();

- name: P0 purchase - missing values in the object do not erase valid GA4 values
  code: |-
    mock('getAllEventData', { transaction_id: 'TX-1', currency: 'CZK', value: 250 });
    runCode(tagData({
      eventNameSelect: 'Purchase',
      enableGa4AutoMap: true,
      eventDataObject: { order_id: null, currency: undefined, value: '' }
    }));
    assertThat(sent().event_data).isEqualTo({ order_id: 'TX-1', currency: 'CZK', value: 250, sem_id: SEM_ID });
    assertSucceeded();

- name: P0 purchase - value 0 is a valid value
  code: |-
    runCode(tagData({ eventNameSelect: 'Purchase', orderId: 'O-3', currency: 'CZK', value: 0 }));
    assertThat(sent().event_data.value).isStrictlyEqualTo(0);
    assertSucceeded();

- name: P0 purchase - an invalid final value in the object fails without a request
  code: |-
    runCode(tagData({
      eventNameSelect: 'Purchase',
      eventDataObject: { order_id: 'O-4', currency: 'CZK', value: 'abc' }
    }));
    assertFailedWithoutRequest();
    assertThat(logged('Purchase requires: value')).isTrue();

- name: P0 purchase - a locale-formatted value field fails without a request
  code: |-
    runCode(tagData({ eventNameSelect: 'Purchase', orderId: 'O-5', currency: 'CZK', value: '1 234,50' }));
    assertFailedWithoutRequest();

- name: P0 purchase - GA4 items without a value do not synthesize one and the Purchase fails
  code: |-
    mock('getAllEventData', {
      transaction_id: 'TX-2',
      currency: 'CZK',
      items: [{ item_id: 'A', price: 121, quantity: 1 }]
    });
    runCode(tagData({ eventNameSelect: 'Purchase', enableGa4AutoMap: true }));
    assertFailedWithoutRequest();
    assertThat(logged('Purchase requires: value')).isTrue();

- name: P0 value fallback - GA4 items on ViewContent do not synthesize a value
  code: |-
    mock('getAllEventData', { items: [{ item_id: 'A', price: 10, quantity: 2 }] });
    runCode(tagData({ eventNameSelect: 'ViewContent', enableGa4AutoMap: true }));
    assertThat(sent().event_data.value).isUndefined();
    assertThat(sent().event_data.contents).isEqualTo([{ id: 'A', unit_price: 10, quantity: 2 }]);
    assertSucceeded();

- name: P0 precedence - object contents win over GA4 items
  code: |-
    mock('getAllEventData', { items: [{ item_id: 'GA4', price: 20, quantity: 1 }] });
    runCode(tagData({
      eventNameSelect: 'ViewContent',
      enableGa4AutoMap: true,
      eventDataObject: { contents: [{ id: 'MANUAL', quantity: 2, unit_price: 10 }] }
    }));
    assertThat(sent().event_data.contents).isEqualTo([{ id: 'MANUAL', quantity: 2, unit_price: 10 }]);

- name: P0 precedence - an explicit empty contents array is kept over GA4 items
  code: |-
    mock('getAllEventData', { items: [{ item_id: 'GA4', price: 20, quantity: 1 }] });
    runCode(tagData({ eventNameSelect: 'ViewContent', enableGa4AutoMap: true, eventDataObject: { contents: [] } }));
    assertThat(sent().event_data.contents).isEqualTo([]);

- name: P0 precedence - override tables win over the objects
  code: |-
    runCode(tagData({
      eventDataObject: { currency: 'EUR', value: 100 },
      eventDataOverrides: [{ name: 'currency', value: 'CZK' }, { name: 'value', value: '50' }],
      userDataObject: { em: 'HASH_OBJECT' },
      userDataOverrides: [{ name: 'em', value: 'HASH_OVERRIDE' }]
    }));
    assertThat(sent().event_data.currency).isEqualTo('CZK');
    assertThat(sent().event_data.value).isStrictlyEqualTo(50);
    assertThat(sent().user_ids.user_data.em).isEqualTo('HASH_OVERRIDE');

- name: P0 identity - malformed explicit sid is dropped and the valid sid cookie fills the gap
  code: |-
    mock('getCookieValues', (name) => name === 'sid' ? [VALID_SID] : []);
    runCode(tagData({ sid: 'not-a-sid' }));
    assertThat(sent().user_ids.user_data.sid).isEqualTo(VALID_SID);
    assertThat(logged('ignoring malformed sid from the tag configuration')).isTrue();

- name: P0 identity - malformed explicit udid is dropped and the valid udid cookie fills the gap
  code: |-
    mock('getCookieValues', (name) => name === 'udid' ? [VALID_UDID + '@1782277561803'] : []);
    runCode(tagData({ userDataObject: { udid: 'object-uuid' } }));
    assertThat(sent().user_ids.user_data.udid).isEqualTo(VALID_UDID);
    assertThat(logged('ignoring malformed udid from the tag configuration')).isTrue();

- name: P0 identity - valid explicit sid and udid win over valid cookies and share the udid rule
  code: |-
    mock('getCookieValues', (name) => {
      if (name === 'sid') return ['id=1|t=1.000|te=1.000|c=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'];
      if (name === 'udid') return ['11111111-2222-3333-4444-555555555555@1782277561803'];
      return [];
    });
    runCode(tagData({ sid: VALID_SID, userUdid: VALID_UDID + '@1782277561803' }));
    assertThat(sent().user_ids.user_data).isEqualTo({ sid: VALID_SID, udid: VALID_UDID });

- name: P0 identity - missing sid is warned even when other identifiers exist
  code: |-
    runCode(tagData({ userEmail: 'HASH_EM', userUdid: VALID_UDID }));
    assertThat(sent().user_ids.user_data).isEqualTo({ em: 'HASH_EM', udid: VALID_UDID });
    assertThat(logged('no valid sid')).isTrue();

- name: P0 types - numeric order_id, event_id and content ids are sent as strings
  code: |-
    runCode(tagData({
      eventNameSelect: 'Purchase',
      orderId: 123,
      currency: 'CZK',
      value: 100,
      eventId: 456,
      contents: [{ id: 789, quantity: 1, unit_price: 100 }]
    }));
    assertThat(sent().event_data.order_id).isStrictlyEqualTo('123');
    assertThat(sent().event_id).isStrictlyEqualTo('456');
    assertThat(sent().event_data.contents[0].id).isStrictlyEqualTo('789');

- name: P0 types - invalid optional numbers are omitted with a WARN
  code: |-
    runCode(tagData({
      valueTax: '1234,50',
      deliveryPrice: 'abc',
      otherCosts: 'Infinity',
      eventDataObject: { predicted_ltv: 1 / 0, goods_intention: 0 / 0, goods_phase: 2.5, value: '19.90' }
    }));
    assertThat(sent().event_data).isEqualTo({ value: 19.9, sem_id: SEM_ID });
    assertThat(logged('event_data.value_tax: expected number')).isTrue();
    assertThat(logged('event_data.goods_phase: expected integer')).isTrue();

- name: P0 types - status override string false is sent as boolean false
  code: |-
    runCode(tagData({
      eventNameSelect: 'CompleteRegistration',
      eventDataOverrides: [{ name: 'status', value: 'false' }]
    }));
    assertThat(sent().event_data.status).isStrictlyEqualTo(false);

- name: P0 types - status 0 from the object is sent as boolean false
  code: |-
    runCode(tagData({ eventNameSelect: 'CompleteRegistration', eventDataObject: { status: 0 } }));
    assertThat(sent().event_data.status).isStrictlyEqualTo(false);

- name: P0 types - an override with boolean false is not ignored
  code: |-
    runCode(tagData({
      eventNameSelect: 'CompleteRegistration',
      eventDataObject: { status: true },
      eventDataOverrides: [{ name: 'status', value: false }]
    }));
    assertThat(sent().event_data.status).isStrictlyEqualTo(false);

- name: P0 types - object product_ids are normalized like the field
  code: |-
    runCode(tagData({ eventDataObject: { product_ids: ['12', 'bad', -1, 3.5, 7] } }));
    assertThat(sent().event_data.product_ids).isEqualTo([12, 7]);
    assertThat(logged('event_data.product_ids[1]')).isTrue();

- name: P0 unknown keys and placeholder IDs are dropped with a WARN
  code: |-
    runCode(tagData({
      eventDataObject: {
        unexpected: 'x',
        order_id: 'undefined',
        currency: 'CZK',
        contents: [{ id: 'A', quantity: 1, color: 'red' }]
      },
      userDataObject: { em: 'HASH_EM', foo: 'bar', ph: 'null' }
    }));
    assertThat(sent().event_data).isEqualTo({
      currency: 'CZK',
      contents: [{ id: 'A', quantity: 1 }],
      content_type: 'product',
      sem_id: SEM_ID
    });
    assertThat(sent().user_ids.user_data).isEqualTo({ em: 'HASH_EM' });
    assertThat(logged('event_data.unexpected is not a Seznam field')).isTrue();
    assertThat(logged('user_data.foo is not a Seznam field')).isTrue();
    assertThat(logged('event_data.contents[0].color is not a Seznam field')).isTrue();
    assertThat(logged('event_data.order_id is the placeholder string')).isTrue();
    assertThat(logged('user_data.ph is the placeholder string')).isTrue();

- name: P0 quantity - GA4 items keep valid quantities and drop invalid ones
  code: |-
    mock('getAllEventData', {
      items: [
        { item_id: 'MISSING' },
        { item_id: 'ZERO', quantity: 0 },
        { item_id: 'NEGATIVE', quantity: -1 },
        { item_id: 'HALF', quantity: 0.5 },
        { item_id: 'FRACTION', quantity: 1.9 },
        { item_id: 'STRING', quantity: '2' },
        { item_id: 'INFINITE', quantity: 'Infinity' }
      ]
    });
    runCode(tagData({ eventNameSelect: 'AddToCart', enableGa4AutoMap: true }));
    assertThat(sent().event_data.contents).isEqualTo([{ id: 'MISSING', quantity: 1 }, { id: 'STRING', quantity: 2 }]);
    assertThat(logged('event_data.contents[1].quantity')).isTrue();
    assertSucceeded();

- name: P0 quantity - object contents drop items with an invalid quantity
  code: |-
    runCode(tagData({
      eventNameSelect: 'AddToCart',
      eventDataObject: {
        contents: [{ id: 'A', quantity: 0 }, { id: 'B', quantity: '3' }, { id: 'C', quantity: 1 / 0 }, { id: 'D' }]
      }
    }));
    assertThat(sent().event_data.contents).isEqualTo([{ id: 'B', quantity: 3 }, { id: 'D', quantity: 1 }]);

- name: P0 quantity - contents field drops items with an invalid quantity
  code: |-
    runCode(tagData({ eventNameSelect: 'AddToCart', contents: '[{"id":"A","quantity":-2},{"id":"B","quantity":1}]' }));
    assertThat(sent().event_data.contents).isEqualTo([{ id: 'B', quantity: 1 }]);

- name: P0 quantity - dropping every item omits contents and the generated content_type
  code: |-
    runCode(tagData({ eventNameSelect: 'AddToCart', contents: [{ id: 'A', quantity: 0 }] }));
    assertThat(sent().event_data.contents).isUndefined();
    assertThat(sent().event_data.content_type).isUndefined();
    assertThat(logged('every item was dropped')).isTrue();
    assertSucceeded();

- name: P0 quantity - dropping every item keeps an explicit content_type
  code: |-
    runCode(tagData({ eventNameSelect: 'AddToCart', contentType: 'product', contents: [{ id: 'A', quantity: 0.5 }] }));
    assertThat(sent().event_data.contents).isUndefined();
    assertThat(sent().event_data.content_type).isEqualTo('product');

- name: P0 event_time - fractional milliseconds are rounded to an integer
  code: |-
    runCode(tagData({ eventTime: 1700000000000.7 }));
    assertThat(sent().event_time).isStrictlyEqualTo(1700000000001);

- name: P0 event_time - zero falls back to server time with a WARN
  code: |-
    mock('getTimestampMillis', 1790000000000);
    runCode(tagData({ eventTime: 0 }));
    assertThat(sent().event_time).isStrictlyEqualTo(1790000000000);
    assertThat(logged('eventTime')).isTrue();

- name: P0 event_time - a negative value falls back to server time with a WARN
  code: |-
    mock('getTimestampMillis', 1790000000000);
    runCode(tagData({ eventTime: -5 }));
    assertThat(sent().event_time).isStrictlyEqualTo(1790000000000);
    assertThat(logged('eventTime')).isTrue();

- name: P0 event_time - a non-numeric value falls back to server time with a WARN
  code: |-
    mock('getTimestampMillis', 1790000000000);
    runCode(tagData({ eventTime: 'abc' }));
    assertThat(sent().event_time).isStrictlyEqualTo(1790000000000);
    assertThat(logged('eventTime')).isTrue();

- name: P0 event_time - Infinity falls back to server time with a WARN
  code: |-
    mock('getTimestampMillis', 1790000000000);
    runCode(tagData({ eventTime: 1 / 0 }));
    assertThat(sent().event_time).isStrictlyEqualTo(1790000000000);
    assertThat(logged('eventTime')).isTrue();

- name: P0 consent - enumerated values are normalized to granted and denied
  code: |-
    runCode(tagData({
      consentModeObject: {
        ad_storage: true,
        ad_user_data: 1,
        ad_personalization: '1',
        analytics_storage: 'false',
        functionality_storage: 0
      }
    }));
    assertThat(sent().consent_mode).isEqualTo({
      ad_storage: 'granted',
      ad_user_data: 'granted',
      ad_personalization: 'granted',
      functionality_storage: 'denied',
      analytics_storage: 'denied'
    });

- name: P0 consent - a JSON string is parsed and normalized
  code: |-
    runCode(tagData({ consentModeObject: '{"ad_storage":"true","ad_user_data":"granted","ad_personalization":"0"}' }));
    assertThat(sent().consent_mode).isEqualTo({ ad_storage: 'granted', ad_user_data: 'granted', ad_personalization: 'denied' });

- name: P0 consent - a partial v1 object is forwarded without filling missing keys
  code: |-
    runCode(tagData({ consentModeObject: { ad_storage: 'granted', analytics_storage: 'denied', wait_for_update: 500 } }));
    assertThat(sent().consent_mode).isEqualTo({ ad_storage: 'granted', analytics_storage: 'denied' });
    assertSucceeded();

- name: P0 consent - no consent signal at all is sent with a WARN
  code: |-
    runCode(tagData({}));
    assertThat(sent().consent_mode).isUndefined();
    assertThat(sent().consent_string).isUndefined();
    assertThat(logged('no consent signal')).isTrue();
    assertSucceeded();

- name: P0 consent M2 - unparseable consent JSON fails without request or cookie write
  code: |-
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=CLICK' });
    runCode(tagData({ consentModeObject: '{ad_storage: granted' }));
    assertFailedWithoutRequest();
    assertThat(logs).contains('Seznam SEM [ERROR]: consentModeObject: expected object with granted/denied values, got string');

- name: P0 consent M2 - a wrapper object without consent keys fails
  code: |-
    runCode(tagData({ consentModeObject: { consent_mode: { ad_storage: 'granted', ad_user_data: 'granted' } } }));
    assertFailedWithoutRequest();
    assertThat(logged('consentModeObject: no supported consent key')).isTrue();

- name: P0 consent M2 - Granted with a capital G fails and the value is not logged
  code: |-
    runCode(tagData({ consentModeObject: { ad_storage: 'Granted', ad_user_data: 'granted' } }));
    assertFailedWithoutRequest();
    assertThat(logs).contains('Seznam SEM [ERROR]: consentModeObject.ad_storage: expected granted/denied (or true/false, 1/0), got string');
    assertThat(logged('Granted')).isFalse();

- name: P0 consent M2 - yes on a recognized key fails
  code: |-
    runCode(tagData({ consentModeObject: { ad_storage: 'granted', ad_user_data: 'yes' } }));
    assertFailedWithoutRequest();
    assertThat(logged('consentModeObject.ad_user_data: expected granted/denied')).isTrue();

- name: P0 consent M2 - a number other than 0 and 1 on a recognized key fails
  code: |-
    runCode(tagData({ consentModeObject: { ad_storage: 2 } }));
    assertFailedWithoutRequest();
    assertThat(logs).contains('Seznam SEM [ERROR]: consentModeObject.ad_storage: expected granted/denied (or true/false, 1/0), got number');

- name: P0 consent R1 - null on a recognized key counts as missing and is not filled
  code: |-
    mockClientHeaders();
    runCode(tagData({ sendS2sHeaders: true, consentModeObject: { ad_storage: null, ad_user_data: 'granted' } }));
    assertThat(sent().consent_mode).isEqualTo({ ad_user_data: 'granted' });
    assertThat(sent().s2s_headers).isUndefined();
    assertThat(logged('consentModeObject.ad_storage is null')).isTrue();
    assertSucceeded();

- name: P0 consent R1 - all recognized keys null in parsed JSON omit consent_mode with a WARN
  code: |-
    runCode(tagData({ consentModeObject: '{"ad_storage":null,"ad_user_data":null}' }));
    assertThat(sent().consent_mode).isUndefined();
    assertThat(logged('no consent signal')).isTrue();
    assertSucceeded();

- name: P0 TCF - a valid TCF v2 string is forwarded
  code: |-
    runCode(tagData({ consentString: TCF_STRING, consentModeObject: { ad_storage: 'granted' } }));
    assertThat(sent().consent_string).isEqualTo(TCF_STRING);
    assertSucceeded();

- name: P0 TCF - the placeholder string undefined counts as absent
  code: |-
    runCode(tagData({ consentString: 'undefined', consentModeObject: { ad_storage: 'denied' } }));
    assertThat(sent().consent_string).isUndefined();
    assertSucceeded();

- name: P0 TCF - an empty string counts as absent
  code: |-
    runCode(tagData({ consentString: '', consentModeObject: { ad_storage: 'denied' } }));
    assertThat(sent().consent_string).isUndefined();
    assertSucceeded();

- name: P0 TCF - a CookieConsent-style JSON value fails without request or cookie write
  code: |-
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=CLICK' });
    runCode(tagData({ consentString: '{stamp:%27abc%27%2Cnecessary:true%2Cmarketing:true}' }));
    assertFailedWithoutRequest();
    assertThat(logs).contains('Seznam SEM [ERROR]: consentString: expected IAB TCF v2 string (starts with C; letters, digits, _ . -), got string');

- name: P0 TCF - C followed by invalid characters fails
  code: |-
    runCode(tagData({ consentString: 'C!!!!' }));
    assertFailedWithoutRequest();

- name: P0 headers - granted ad_storage and ad_user_data send s2s_headers
  code: |-
    mockClientHeaders();
    runCode(tagData({ sendS2sHeaders: true, consentModeObject: { ad_storage: 'granted', ad_user_data: 'granted' } }));
    assertThat(sent().s2s_headers).isEqualTo({ client_ip_address: '1.2.3.4', user_agent: 'test-ua' });

- name: P0 headers - normalized true and 1 open the header gate
  code: |-
    mockClientHeaders();
    runCode(tagData({ sendS2sHeaders: true, consentModeObject: { ad_storage: true, ad_user_data: 1 } }));
    assertThat(sent().s2s_headers).isEqualTo({ client_ip_address: '1.2.3.4', user_agent: 'test-ua' });

- name: P0 headers - one denied key suppresses s2s_headers
  code: |-
    mockClientHeaders();
    runCode(tagData({ sendS2sHeaders: true, consentModeObject: { ad_storage: 'granted', ad_user_data: 'denied' } }));
    assertThat(sent().s2s_headers).isUndefined();

- name: P0 headers - missing consent suppresses s2s_headers
  code: |-
    mockClientHeaders();
    runCode(tagData({ sendS2sHeaders: true }));
    assertThat(sent().s2s_headers).isUndefined();

- name: P0 headers - TCF-only consent suppresses s2s_headers
  code: |-
    mockClientHeaders();
    runCode(tagData({ sendS2sHeaders: true, consentString: TCF_STRING }));
    assertThat(sent().s2s_headers).isUndefined();
    assertThat(sent().consent_string).isEqualTo(TCF_STRING);

- name: P0 headers - undefined sendS2sHeaders suppresses s2s_headers
  code: |-
    mockClientHeaders();
    runCode(tagData({ consentModeObject: { ad_storage: 'granted', ad_user_data: 'granted' } }));
    assertThat(sent().s2s_headers).isUndefined();

- name: 'v3: sznaiid - cookie uses sameSite lax, httpOnly false and the fixed 30-day lifetime (d.3)'
  code: |-
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=CLICK' });
    mock('getCookieValues', () => []);
    runCode(tagData({ sznaiidCookieMaxAge: '7776000' }));
    assertApi('setCookie').wasCalledWith('sznaiid', 'CLICK', {
      domain: 'auto',
      path: '/',
      sameSite: 'lax',
      secure: true,
      'max-age': 2592000,
      httpOnly: false
    });
    assertThat(sent().event_data.sznaiid).isEqualTo('CLICK');

- name: P0 sznaiid - cookie is not written when the tag fails validation
  code: |-
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=CLICK' });
    runCode(tagData({ eventNameSelect: 'Purchase', orderId: 'O-6', currency: 'CZK' }));
    assertFailedWithoutRequest();

- name: P0 transport - request goes to rtgconv with a 5 s timeout and 2xx succeeds
  code: |-
    runCode(tagData({}));
    assertThat(requests[0].url).isEqualTo('https://sem.seznam.cz/rtgconv');
    assertThat(requests[0].options.timeout).isEqualTo(5000);
    assertSucceeded();

- name: P0 transport - 400 fails the tag and logs the status
  code: |-
    httpResult = { statusCode: 400, headers: { 'x-request-id': 'REQ-400' }, body: '{"error":"bad"}' };
    runCode(tagData({}));
    assertFailedAfterResponse();
    callLater(() => { assertThat(logged('HTTP 400')).isTrue(); });

- name: P0 transport - 401 fails the tag and logs the S2S SEM ID hint
  code: |-
    httpResult = { statusCode: 401, headers: {}, body: '' };
    runCode(tagData({}));
    assertFailedAfterResponse();
    callLater(() => { assertThat(logged('not the sul.js SEM ID')).isTrue(); });

- name: P0 transport - 503 fails the tag and logs the status
  code: |-
    httpResult = { statusCode: 503, headers: {}, body: '' };
    runCode(tagData({}));
    assertFailedAfterResponse();
    callLater(() => { assertThat(logged('HTTP 503')).isTrue(); });

- name: P0 transport - a rejected request fails the tag and logs the reason
  code: |-
    httpResult = 'reject';
    runCode(tagData({}));
    assertFailedAfterResponse();
    callLater(() => { assertThat(logged('request to Seznam failed: timed_out')).isTrue(); });

- name: P0 transport - optimistic mode succeeds once on 2xx
  code: |-
    runCode(tagData({ useOptimisticScenario: true }));
    assertApi('gtmOnSuccess').wasCalled();
    callLater(() => { assertApi('gtmOnFailure').wasNotCalled(); });

- name: P0 transport - optimistic mode succeeds once on 403 and logs the hint
  code: |-
    httpResult = { statusCode: 403, headers: {}, body: '' };
    runCode(tagData({ useOptimisticScenario: true }));
    assertApi('gtmOnSuccess').wasCalled();
    callLater(() => {
      assertApi('gtmOnFailure').wasNotCalled();
      assertThat(logged('not the sul.js SEM ID')).isTrue();
    });

- name: P0 transport - optimistic mode succeeds once on 5xx and logs the status
  code: |-
    httpResult = { statusCode: 500, headers: {}, body: '' };
    runCode(tagData({ useOptimisticScenario: true }));
    assertApi('gtmOnSuccess').wasCalled();
    callLater(() => {
      assertApi('gtmOnFailure').wasNotCalled();
      assertThat(logged('HTTP 500')).isTrue();
    });

- name: P0 transport - optimistic mode succeeds once on rejection and logs the reason
  code: |-
    httpResult = 'reject';
    runCode(tagData({ useOptimisticScenario: true }));
    assertApi('gtmOnSuccess').wasCalled();
    callLater(() => {
      assertApi('gtmOnFailure').wasNotCalled();
      assertThat(logged('request to Seznam failed: timed_out')).isTrue();
    });

- name: P0 sem_id - wrong charset fails under Strict without a request
  code: |-
    runCode(tagData({ semId: 'ABCDEFGHIJKLMNOPQRSTUVWX', strictEventValidation: true }));
    assertFailedWithoutRequest();
    assertThat(logged('semId must be 24 characters')).isTrue();

- name: 'v3: sem_id - wrong charset fails even without Strict Event Validation (d.8)'
  code: |-
    runCode(tagData({ semId: 'abcdefghijklmnopqrstuvw-' }));
    assertFailedWithoutRequest();
    assertThat(logged('semId must be 24 characters')).isTrue();
    assertThat(logged('(v2 loose validation no longer applies)')).isFalse();

- name: P0 sem_id - the object and overrides cannot replace the configured SEM ID
  code: |-
    runCode(tagData({
      eventDataObject: { sem_id: 'zzzzzzzzzzzzzzzzzzzzzzzz' },
      eventDataOverrides: [{ name: 'sem_id', value: 'yyyyyyyyyyyyyyyyyyyyyyyy' }]
    }));
    assertThat(sent().event_data.sem_id).isEqualTo(SEM_ID);

- name: 'v3: diagnostics - logType always logs the consent summary, raw x-ga-gcs and identity sources in production (d.7)'
  code: |-
    containerVersion = { debugMode: false, previewMode: false };
    mock('getAllEventData', { 'x-ga-gcs': 'G111' });
    mock('getCookieValues', (name) => name === 'sid' ? [VALID_SID] : []);
    runCode(tagData({ logType: 'always', consentModeObject: { ad_storage: 'granted' }, consentString: TCF_STRING }));
    let requestLine = '';
    for (let n = 0; n < logs.length; n++) {
      if (logs[n].indexOf('"Type":"Request"') !== -1) requestLine = logs[n];
    }
    assertThat(requestLine).contains('"x_ga_gcs":"G111"');
    assertThat(requestLine).contains('"consent_string":"present"');
    assertThat(requestLine).contains('"sid":"cookie"');
    assertThat(requestLine).contains('"udid":"missing"');
- name: P0 R4 - GA4 order_id skips objects, booleans and arrays and the Purchase fails
  code: |-
    mock('getAllEventData', { transaction_id: { oops: 1 }, id: true, orderNo: ['A', 'B'], currency: 'CZK', value: 100 });
    runCode(tagData({ eventNameSelect: 'Purchase', enableGa4AutoMap: true }));
    assertFailedWithoutRequest();
    assertThat(logged('Purchase requires: order_id')).isTrue();

- name: P0 R4 - GA4 order_id skips NaN and Infinity and takes the next alias
  code: |-
    mock('getAllEventData', { transaction_id: 0 / 0, id: 1 / 0, orderNo: 'NO-1', currency: 'CZK', value: 100 });
    runCode(tagData({ eventNameSelect: 'Purchase', enableGa4AutoMap: true }));
    assertThat(sent().event_data.order_id).isEqualTo('NO-1');
    assertSucceeded();

- name: 'v3: R4 - GA4 transaction_id and item_id 0 are sent as the string 0, transaction_id is not an event_id (d.2)'
  code: |-
    mock('getAllEventData', {
      transaction_id: 0,
      currency: 'CZK',
      value: 10,
      items: [{ item_id: 0, quantity: 1 }]
    });
    runCode(tagData({ eventNameSelect: 'Purchase', enableGa4AutoMap: true }));
    assertThat(sent().event_data.order_id).isStrictlyEqualTo('0');
    assertThat(sent().event_id).isUndefined();
    assertThat(sent().event_data.contents).isEqualTo([{ id: '0', quantity: 1 }]);
    assertSucceeded();

- name: P0 R4 - GA4 item id and name skip non-scalar values and use the alias
  code: |-
    mock('getAllEventData', {
      items: [
        { item_id: { x: 1 }, id: 'B', item_name: { a: 1 }, name: 'Real name', quantity: 1 },
        { item_id: true, quantity: 1 },
        { item_id: ['A', 'B'], quantity: 1 }
      ]
    });
    runCode(tagData({ eventNameSelect: 'ViewContent', enableGa4AutoMap: true }));
    assertThat(sent().event_data.contents).isEqualTo([{ id: 'B', content_name: 'Real name', quantity: 1 }]);
    assertThat(logged('2 GA4 items skipped')).isTrue();

- name: P0 R7 - placeholder quantities in GA4 items count as missing
  code: |-
    mock('getAllEventData', {
      items: [{ item_id: 'A', quantity: 'null' }, { item_id: 'B', quantity: 'undefined' }]
    });
    runCode(tagData({ eventNameSelect: 'AddToCart', enableGa4AutoMap: true }));
    assertThat(sent().event_data.contents).isEqualTo([{ id: 'A', quantity: 1 }, { id: 'B', quantity: 1 }]);
    assertThat(logged('event_data.contents[0].quantity is the placeholder string')).isTrue();

- name: P0 R7 - a placeholder quantity in the object counts as missing, abc still drops the item
  code: |-
    runCode(tagData({
      eventNameSelect: 'AddToCart',
      eventDataObject: { contents: [{ id: 'A', quantity: 'null' }, { id: 'X', quantity: 'abc' }] }
    }));
    assertThat(sent().event_data.contents).isEqualTo([{ id: 'A', quantity: 1 }]);

- name: P0 R7 - a placeholder quantity in the Contents field counts as missing
  code: |-
    runCode(tagData({ eventNameSelect: 'AddToCart', contents: [{ id: 'A', quantity: 'undefined' }] }));
    assertThat(sent().event_data.contents).isEqualTo([{ id: 'A', quantity: 1 }]);

- name: P0 R7 - a placeholder quantity in an override row counts as missing
  code: |-
    runCode(tagData({
      eventNameSelect: 'AddToCart',
      eventDataOverrides: [{ name: 'contents', value: [{ id: 'A', quantity: 'null' }] }]
    }));
    assertThat(sent().event_data.contents).isEqualTo([{ id: 'A', quantity: 1 }]);

- name: P0 R8 - placeholder strings in later layers do not erase GA4 values
  code: |-
    mock('getAllEventData', { transaction_id: 'TX-8', currency: 'CZK', value: 80 });
    runCode(tagData({
      eventNameSelect: 'Purchase',
      enableGa4AutoMap: true,
      eventDataObject: { order_id: 'null', value: 'undefined' },
      eventDataOverrides: [{ name: 'currency', value: 'undefined' }]
    }));
    assertThat(sent().event_data).isEqualTo({ order_id: 'TX-8', currency: 'CZK', value: 80, sem_id: SEM_ID });
    assertThat(logged('event_data.order_id is the placeholder string')).isTrue();
    assertSucceeded();

- name: P0 R8 - free-text keys keep the literal words null and undefined
  code: |-
    runCode(tagData({
      eventNameSelect: 'Search',
      eventDataObject: {
        search_string: 'null',
        contents: [{ id: 'A', content_name: 'undefined', content_category: 'null' }]
      }
    }));
    assertThat(sent().event_data.search_string).isEqualTo('null');
    assertThat(sent().event_data.contents).isEqualTo([
      { id: 'A', content_name: 'undefined', content_category: 'null', quantity: 1 }
    ]);

- name: P0 R8 - placeholder user data and event ID fall back to earlier sources
  code: |-
    mock('getAllEventData', { event_id: 'EV-1', user_data: { sha256_phone_number: 'HASH_PH' } });
    runCode(tagData({
      enableGa4AutoMap: true,
      eventId: 'undefined',
      userDataObject: { em: 'null', email: 'HASH_ALIAS' },
      userPhone: 'undefined'
    }));
    assertThat(sent().event_id).isEqualTo('EV-1');
    assertThat(sent().user_ids.user_data).isEqualTo({ em: 'HASH_ALIAS', ph: 'HASH_PH' });

- name: P0 R9 - consent values are trimmed before matching
  code: |-
    runCode(tagData({ consentModeObject: { ad_storage: ' granted ', ad_user_data: ' 0 ' } }));
    assertThat(sent().consent_mode).isEqualTo({ ad_storage: 'granted', ad_user_data: 'denied' });
    assertSucceeded();

- name: P0 R9 - a trimmed Granted still fails the tag
  code: |-
    runCode(tagData({ consentModeObject: { ad_storage: ' Granted ' } }));
    assertFailedWithoutRequest();

- name: P0 R10 - the Status field goes through the boolean normalizer
  code: |-
    runCode(tagData({ eventNameSelect: 'Subscribe', statusEnabled: true, status: '1' }));
    assertThat(sent().event_data.status).isStrictlyEqualTo(true);

- name: P0 R10 - an enabled Status field without a value still sends false
  code: |-
    runCode(tagData({ eventNameSelect: 'CompleteRegistration', statusEnabled: true }));
    assertThat(sent().event_data.status).isStrictlyEqualTo(false);

- name: P0 R10 - CompleteRegistration gets no default when a layer sent an invalid status
  code: |-
    runCode(tagData({
      eventNameSelect: 'CompleteRegistration',
      eventDataOverrides: [{ name: 'status', value: 'no' }]
    }));
    assertThat(sent().event_data.status).isUndefined();
    assertThat(logged('event_data.status: expected boolean')).isTrue();

- name: P0 R11 - an invalid content_type is omitted and the product default applies
  code: |-
    runCode(tagData({ eventDataObject: { content_type: 'Produkt', contents: [{ id: 'A' }] } }));
    assertThat(sent().event_data.content_type).isEqualTo('product');
    assertThat(logged('event_data.content_type: expected one of page, product, product_group, search')).isTrue();

- name: P0 R11 - an invalid override content_type without contents is omitted
  code: |-
    runCode(tagData({ eventDataOverrides: [{ name: 'content_type', value: 'category' }] }));
    assertThat(sent().event_data.content_type).isUndefined();

- name: P0 R12 - whitespace-only JSON fields count as missing under Strict
  code: |-
    runCode(tagData({ strictEventValidation: true, eventDataObject: '   ', contents: '  ' }));
    assertThat(sent().event_data).isEqualTo({ sem_id: SEM_ID });
    assertSucceeded();

- name: 'v3: R12 - boolean false in a JSON object field is an ERROR and the hit is sent (d.9)'
  code: |-
    runCode(tagData({ strictEventValidation: true, userDataObject: false }));
    assertThat(sent().event_name).isEqualTo('PageView');
    assertThat(logged('Seznam SEM [ERROR]: userDataObject: expected object or JSON string, got boolean; omitting it')).isTrue();
    assertSucceeded();

- name: P0 contents - native items without an id are kept
  code: |-
    runCode(tagData({
      eventNameSelect: 'AddToCart',
      contents: [
        { quantity: 2, unit_price: 100 },
        { content_name: 'Name only' },
        { content_category: 'Category only' },
        { id: 'ID-only' }
      ]
    }));
    assertThat(sent().event_data.contents).isEqualTo([
      { quantity: 2, unit_price: 100 },
      { content_name: 'Name only', quantity: 1 },
      { content_category: 'Category only', quantity: 1 },
      { id: 'ID-only', quantity: 1 }
    ]);

- name: P0 contents - GA4-shaped keys in manual contents are stripped with WARNs
  code: |-
    runCode(tagData({ eventNameSelect: 'AddToCart', contents: [{ item_id: 'X', price: 10, quantity: 2 }] }));
    assertThat(sent().event_data.contents).isEqualTo([{ quantity: 2 }]);
    assertThat(logged('event_data.contents[0].item_id is not a Seznam field')).isTrue();
    assertThat(logged('event_data.contents[0].price is not a Seznam field')).isTrue();
- name: P0 V-R2 - a placeholder userRegion falls back to userState
  code: |-
    runCode(tagData({ userRegion: 'null', userState: 'HASH_STATE', userEmail: 'HASH_EM' }));
    assertThat(sent().user_ids.user_data.region).isEqualTo('HASH_STATE');

- name: P0 V-R2 - a blank userRegion falls back to userState
  code: |-
    runCode(tagData({ userRegion: '   ', userState: 'HASH_STATE', userEmail: 'HASH_EM' }));
    assertThat(sent().user_ids.user_data.region).isEqualTo('HASH_STATE');

- name: P0 V-R2 - userRegion 0 is a value and is sent as the string 0
  code: |-
    runCode(tagData({ userRegion: 0, userState: 'HASH_STATE' }));
    assertThat(sent().user_ids.user_data.region).isStrictlyEqualTo('0');

- name: P0 V-R2 - a valid userRegion wins over userState
  code: |-
    runCode(tagData({ userRegion: 'HASH_REGION', userState: 'HASH_STATE' }));
    assertThat(sent().user_ids.user_data.region).isEqualTo('HASH_REGION');

- name: P0 V-R2 - an invalid supplied userRegion is omitted without falling back
  code: |-
    runCode(tagData({ userRegion: true, userState: 'HASH_STATE', userEmail: 'HASH_EM' }));
    assertThat(sent().user_ids.user_data.region).isUndefined();
    assertThat(logged('user_data.region: expected string or number')).isTrue();
- name: upgrade fixture - tag 20
  code: |-
    // Playground tag 20 "SEM - purchase" (review/gtm-verification/baseline-v2.3.md) as v2.3 stored it:
    // Individual fields, Status true, consent from the Data Client consent_state, BigQuery logging on.
    // `expected` is the body P0 v2.3.1 (1195cb4) sent for exactly these inputs and mocks.
    let bigQueryRows = [];
    mockObject('BigQuery', {
      insert: (connection, rows) => {
        bigQueryRows = rows;
        return Promise.create((resolve) => resolve());
      }
    });
    mock('getTimestampMillis', 1793000000000);
    mock('getRequestHeader', (name) => ({
      'trace-id': 'TRACE-20',
      referer: 'https://www.semdemo.xyz/objednavka/krok-3/',
      'x-forwarded-for': '203.0.113.7, 10.0.0.1',
      'user-agent': 'Mozilla/5.0 (request header)',
      'sec-ch-ua': '"Chromium";v="141"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"macOS"'
    })[name]);
    mock('getCookieValues', (name) => ({
      sid: ['id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79'],
      udid: ['019ef805-5dbe-7e8b-acd1-8caed14a91fa@1782277561803'],
      sznaiid: ['CLICK-20-OLD']
    })[name] || []);
    mock('getAllEventData', {
      event_name: 'purchase',
      page_location: 'https://www.semdemo.xyz/objednavka/dekujeme/',
      ip_override: '198.51.100.20',
      user_agent: 'Mozilla/5.0 (event data)'
    });
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'hjqrj33mlq8phxinul9fmdo6',
      eventSource: 'web',
      eventUrl: 'https://www.semdemo.xyz/objednavka/dekujeme/',
      eventId: 'evt-20-0001',
      eventTime: 1793001234567,
      enableGa4AutoMap: false,
      autoMapEventName: false,
      autoMapUserData: true,
      autoMapEventData: true,
      consentModeObject: {
        ad_storage: true,
        ad_user_data: true,
        ad_personalization: false,
        analytics_storage: true,
        functionality_storage: true
      },
      userDataInputMode: 'fields',
      userEmail: 'b38f4d7a3bd7bd18fe99987bc73d29c98516c1d688c682ec33e2845bf5c292b5',
      userPhone: '80e8e7fbf80bfa0767a68adab6d514571310be1caf88c6252624109e478c2ed3',
      userFirstName: '6a0ac0fd972c325d6ca5512b67a5e0ad996c4a3e9b59971d125164e6d4db1a1c',
      userLastName: '64118260ecb916c23621d8f2768d8dc75d1f5710b1b7e4f2c41ad41e6bc4d688',
      userCity: 'f377db9f1f0af132866afd5c4381512a5c9a3b3a32e9ca2f88f0aced18264568',
      userZip: '8597f1e3043654da36e26467d59c6c6bbc9c44d498cc15ab2f91fc84440bbc35',
      userStreet: '99b1963027845d9412b4c112878f98e28a35df9b7a86849555b7b64cc34e8b1f',
      autoMapIdsFromCookies: true,
      eventDataInputMode: 'fields',
      currency: 'CZK',
      value: '1652.89',
      orderId: 'OBJ-2026-0042',
      contentType: 'product',
      contents: [
        { id: 'SKU-1', quantity: 2, unit_price: 500, content_name: 'Mixér' },
        { id: 'SKU-2', quantity: 1, unit_price: 1000 }
      ],
      valueTax: '347.11',
      statusEnabled: true,
      status: 'true',
      testMode: false,
      useOptimisticScenario: true,
      strictEventValidation: false,
      sendS2sHeaders: true,
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      bigQueryLogType: 'always',
      logBigQueryProjectId: 'matej-playground-460011',
      logBigQueryDatasetId: 'demo_sem',
      logBigQueryTableId: 'sem_log'
    });
    const expected = {
      event_name: 'Purchase',
      schema_version: 'v2',
      event_type: 'rtgconv',
      event_time: 1793001234567,
      event_source: 'web',
      event_url: 'https://www.semdemo.xyz/objednavka/dekujeme/',
      event_data: {
        sznaiid: 'CLICK-20-OLD',
        currency: 'CZK',
        value: 1652.89,
        value_tax: 347.11,
        order_id: 'OBJ-2026-0042',
        content_type: 'product',
        contents: [
          { quantity: 2, id: 'SKU-1', unit_price: 500, content_name: 'Mixér' },
          { quantity: 1, id: 'SKU-2', unit_price: 1000 }
        ],
        status: true,
        sem_id: 'hjqrj33mlq8phxinul9fmdo6'
      },
      api: { name: 'gtm-server-template', version: '1', template_version: '2.3.1' },
      event_id: 'evt-20-0001',
      consent_mode: {
        ad_storage: 'granted',
        ad_user_data: 'granted',
        ad_personalization: 'denied',
        functionality_storage: 'granted',
        analytics_storage: 'granted'
      },
      user_ids: {
        user_data: {
          em: 'b38f4d7a3bd7bd18fe99987bc73d29c98516c1d688c682ec33e2845bf5c292b5',
          ph: '80e8e7fbf80bfa0767a68adab6d514571310be1caf88c6252624109e478c2ed3',
          fn: '6a0ac0fd972c325d6ca5512b67a5e0ad996c4a3e9b59971d125164e6d4db1a1c',
          ln: '64118260ecb916c23621d8f2768d8dc75d1f5710b1b7e4f2c41ad41e6bc4d688',
          ct: 'f377db9f1f0af132866afd5c4381512a5c9a3b3a32e9ca2f88f0aced18264568',
          zp: '8597f1e3043654da36e26467d59c6c6bbc9c44d498cc15ab2f91fc84440bbc35',
          sr: '99b1963027845d9412b4c112878f98e28a35df9b7a86849555b7b64cc34e8b1f',
          sid: 'id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79',
          udid: '019ef805-5dbe-7e8b-acd1-8caed14a91fa'
        }
      },
      s2s_headers: {
        client_ip_address: '203.0.113.7',
        user_agent: 'Mozilla/5.0 (request header)',
        sec_ch_ua: '"Chromium";v="141"',
        sec_ch_ua_mobile: '?0',
        sec_ch_ua_platform: '"macOS"'
      }
    };
    // v3 differences allowed by V3-SPEC (e): d.12 version; d.4 IP and User-Agent from the event data.
    expected.api.template_version = '3.0.0';
    expected.s2s_headers.client_ip_address = '198.51.100.20';
    expected.s2s_headers.user_agent = 'Mozilla/5.0 (event data)';
    assertThat(sent()).isEqualTo(expected);
    assertThat(requests[0].raw).isEqualTo(JSON.stringify(expected));
    assertApi('gtmOnSuccess').wasCalled();
    assertApi('setCookie').wasNotCalled();
    assertThat(legacyLines().length).isEqualTo(1);
    assertThat(legacyLines()[0]).contains('in use: userEmail→user_data.em, userPhone→user_data.ph, ' +
      'userFirstName→user_data.fn, userLastName→user_data.ln, userCity→user_data.ct, userZip→user_data.zp, ' +
      'userStreet→user_data.sr, currency→event_data.currency, value→event_data.value, ' +
      'valueTax→event_data.value_tax, orderId→event_data.order_id, contentType→event_data.content_type, ' +
      'contents→event_data.contents, statusEnabled→event_data.status;');
    callLater(() => {
      assertThat(bigQueryRows.length).isEqualTo(1);
      assertThat(bigQueryRows[0].request_body).isEqualTo(requests[0].raw);
    });

- name: upgrade fixture - tag 17
  code: |-
    // Playground tag 17 (Auto from GA4 with auto-map, BigQuery on, no consent object) on a GA4
    // add_to_cart landing hit with a Sklik click. `expected` is the P0 v2.3.1 (1195cb4) body.
    mockObject('BigQuery', { insert: () => Promise.create((resolve) => resolve()) });
    mock('getTimestampMillis', 1793000000000);
    mock('getRequestHeader', (name) => ({
      'trace-id': 'TRACE-17',
      'x-forwarded-for': '203.0.113.17',
      'user-agent': 'Mozilla/5.0 (request header)'
    })[name]);
    mock('getCookieValues', (name) => ({
      sid: ['id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79'],
      udid: ['019ef805-5dbe-7e8b-acd1-8caed14a91fa@1782277561803']
    })[name] || []);
    mock('getAllEventData', {
      event_name: 'add_to_cart',
      page_location: 'https://www.semdemo.xyz/mixer-pro/?sznaiid=CLICK-17&utm_source=sklik',
      currency: 'CZK',
      value: 1000,
      items: [
        { item_id: 'SKU-1', item_name: 'Mixér Pro', item_category: 'Kuchyň', item_category2: 'Mixéry', price: 1210, quantity: 1 }
      ],
      user_data: { sha256_email_address: 'b38f4d7a3bd7bd18fe99987bc73d29c98516c1d688c682ec33e2845bf5c292b5' },
      'x-ga-gcs': 'G100',
      ip_override: '198.51.100.17',
      user_agent: 'Mozilla/5.0 (event data)'
    });
    runCode({
      eventNameSelect: 'auto',
      semId: 'hjqrj33mlq8phxinul9fmdo6',
      eventSource: 'web',
      enableGa4AutoMap: true,
      autoMapEventName: true,
      autoMapUserData: true,
      autoMapEventData: true,
      userDataInputMode: 'object',
      autoMapIdsFromCookies: true,
      eventDataInputMode: 'object',
      statusEnabled: false,
      testMode: false,
      useOptimisticScenario: true,
      strictEventValidation: false,
      sendS2sHeaders: true,
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      bigQueryLogType: 'always',
      logBigQueryProjectId: 'matej-playground-460011',
      logBigQueryDatasetId: 'demo_sem',
      logBigQueryTableId: 'sem_log'
    });
    const expected = {
      event_name: 'AddToCart',
      schema_version: 'v2',
      event_type: 'rtgconv',
      event_time: 1793000000000,
      event_source: 'web',
      event_url: 'https://www.semdemo.xyz/mixer-pro/?sznaiid=CLICK-17&utm_source=sklik',
      event_data: {
        currency: 'CZK',
        contents: [
          {
            quantity: 1,
            id: 'SKU-1',
            content_name: 'Mixér Pro',
            unit_price: 1210,
            content_category: 'Kuchyň | Mixéry'
          }
        ],
        value: 1000,
        sznaiid: 'CLICK-17',
        content_type: 'product',
        sem_id: 'hjqrj33mlq8phxinul9fmdo6'
      },
      api: { name: 'gtm-server-template', version: '1', template_version: '2.3.1' },
      user_ids: {
        user_data: {
          em: 'b38f4d7a3bd7bd18fe99987bc73d29c98516c1d688c682ec33e2845bf5c292b5',
          sid: 'id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79',
          udid: '019ef805-5dbe-7e8b-acd1-8caed14a91fa'
        }
      }
    };
    // v3 differences allowed by V3-SPEC (e): d.12 version; d.3 fixed 30-day cookie lifetime.
    expected.api.template_version = '3.0.0';
    const expectedCookie = { domain: 'auto', path: '/', sameSite: 'lax', secure: true, 'max-age': 2592000, httpOnly: false };
    assertThat(sent()).isEqualTo(expected);
    assertThat(requests[0].raw).isEqualTo(JSON.stringify(expected));
    assertApi('setCookie').wasCalledWith('sznaiid', 'CLICK-17', expectedCookie);
    assertApi('gtmOnSuccess').wasCalled();
    assertThat(legacyLines()).isEqualTo(['Seznam SEM [WARN]: v2.x settings in use: sznaiidCookieMaxAge; ' +
      'move them to the v3 tables/settings (README "Přechod na v3") | trace=TRACE-17']);

- name: upgrade fixture - every legacy field filled
  code: |-
    // Every v2.3 individual field, both override tables, both objects and GA4 prefill at once. The
    // body asserts the precedence winners (override > field > object > GA4), not that every value
    // survives. `expected` is the P0 v2.3.1 (1195cb4) body.
    mock('getTimestampMillis', 1793000000000);
    mock('getRequestHeader', (name) => ({
      'trace-id': 'TRACE-ALL',
      'x-forwarded-for': '203.0.113.9',
      'user-agent': 'Mozilla/5.0 (request header)'
    })[name]);
    mock('getCookieValues', (name) => ({
      sid: ['id=1111111111111111111|t=1769429094.692|te=1782303169.389|c=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'],
      udid: ['11111111-2222-3333-4444-555555555555@1782277561803']
    })[name] || []);
    mock('getAllEventData', {
      event_name: 'purchase',
      page_location: 'https://shop.example/dekujeme/?sznaiid=URL-CLICK',
      transaction_id: 'GA4-ORDER',
      currency: 'EUR',
      value: 1,
      shipping: 49,
      items: [{ item_id: 'GA4-ITEM', price: 1, quantity: 1 }],
      user_data: {
        sha256_email_address: '388cb31f82c8dc5c715c863cd508ecc43e03a2bd3ecbfc73d05a17ebf08ebc71',
        sha256_phone_number: '8a67585a46f7f2a291796258a52874925bae26c40f3aa4825a40ec43a15fa94e'
      }
    });
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'hjqrj33mlq8phxinul9fmdo6',
      eventSource: 'web',
      eventUrl: 'https://shop.example/dekujeme/',
      eventId: 'evt-all-0001',
      eventTime: 1793001234567,
      enableGa4AutoMap: true,
      autoMapEventName: false,
      autoMapUserData: true,
      autoMapEventData: true,
      consentModeObject: { ad_storage: 'granted', ad_user_data: 'granted' },
      userDataInputMode: 'fields',
      userDataObject: {
        em: 'bddcdeafb06cbf470e7244cbc57cb4e822c81b1c5e3dca5b5322ccb53f98ca85',
        region: 'bddcdeafb06cbf470e7244cbc57cb4e822c81b1c5e3dca5b5322ccb53f98ca85'
      },
      sid: 'id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79',
      userUdid: '019ef805-5dbe-7e8b-acd1-8caed14a91fa',
      userEmail: 'b38f4d7a3bd7bd18fe99987bc73d29c98516c1d688c682ec33e2845bf5c292b5',
      userPhone: '80e8e7fbf80bfa0767a68adab6d514571310be1caf88c6252624109e478c2ed3',
      userFirstName: '6a0ac0fd972c325d6ca5512b67a5e0ad996c4a3e9b59971d125164e6d4db1a1c',
      userLastName: '64118260ecb916c23621d8f2768d8dc75d1f5710b1b7e4f2c41ad41e6bc4d688',
      userGender: '62c66a7a5dd70c3146618063c344e531e6d4b59e379808443ce962b3abd63c5a',
      userDob: '5e0c46f17ed189d65863756df0241071eb2b1e24e8ec842d3e0618b2ff8eb8b7',
      userCity: 'f377db9f1f0af132866afd5c4381512a5c9a3b3a32e9ca2f88f0aced18264568',
      userRegion: '40d1b48a5440bd369733421ca5f7d0035a49ba7f49f01eb42bb7006ec815e681',
      userState: '8f8206795facc7796edb6cb9d50175a1e0c0be79fb444bbd30720e463f792ca6',
      userZip: '8597f1e3043654da36e26467d59c6c6bbc9c44d498cc15ab2f91fc84440bbc35',
      userStreet: '99b1963027845d9412b4c112878f98e28a35df9b7a86849555b7b64cc34e8b1f',
      userCountry: 'c4e98e070d2cdcd8b6486826223be4f528c54306c9e9c7191a5af6628ffb32e9',
      userSubscriptionId: 'SUB-42',
      autoMapIdsFromCookies: true,
      eventDataInputMode: 'fields',
      eventDataObject: { order_id: 'OBJECT-ORDER', currency: 'EUR', delivery_type: 'OBJECT-DELIVERY' },
      sznaiid: 'FIELD-SZNAIID',
      currency: 'CZK',
      value: '1000.50',
      orderId: 'FIELD-ORDER',
      contentType: 'product',
      contents: '[{"id":"FIELD-1","quantity":2,"unit_price":250}]',
      deliveryPrice: '99',
      deliveryType: 'PPL',
      paymentType: 'card',
      otherCosts: '10',
      predictedLtv: '5000',
      valueTax: '210.10',
      reviewEmail: 'jan.novak@example.cz',
      productIds: '[123, 456]',
      goodsIntention: '0.8',
      goodsPhase: '2',
      searchString: 'mixér',
      statusEnabled: true,
      status: 'false',
      userDataOverrides: [{ name: 'em', value: '93676a064a97784539fd436267ee4c8dd88017834c29c3269f38f3515edcb07f' }],
      eventDataOverrides: [{ name: 'value', value: '1200' }, { name: 'delivery_type', value: 'Zásilkovna' }],
      testMode: false,
      useOptimisticScenario: false,
      strictEventValidation: false,
      sendS2sHeaders: true,
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      bigQueryLogType: 'no'
    });
    const expected = {
      event_name: 'Purchase',
      schema_version: 'v2',
      event_type: 'rtgconv',
      event_time: 1793001234567,
      event_source: 'web',
      event_url: 'https://shop.example/dekujeme/',
      event_data: {
        currency: 'CZK',
        delivery_price: 99,
        order_id: 'FIELD-ORDER',
        contents: [{ quantity: 2, id: 'FIELD-1', unit_price: 250 }],
        value: 1200,
        delivery_type: 'Zásilkovna',
        sznaiid: 'FIELD-SZNAIID',
        value_tax: 210.1,
        content_type: 'product',
        payment_type: 'card',
        other_costs: 10,
        predicted_ltv: 5000,
        goods_intention: 0.8,
        goods_phase: 2,
        search_string: 'mixér',
        review_email: 'jan.novak@example.cz',
        product_ids: [123, 456],
        status: false,
        sem_id: 'hjqrj33mlq8phxinul9fmdo6'
      },
      api: { name: 'gtm-server-template', version: '1', template_version: '2.3.1' },
      event_id: 'evt-all-0001',
      consent_mode: { ad_storage: 'granted', ad_user_data: 'granted' },
      user_ids: {
        user_data: {
          em: '93676a064a97784539fd436267ee4c8dd88017834c29c3269f38f3515edcb07f',
          ph: '80e8e7fbf80bfa0767a68adab6d514571310be1caf88c6252624109e478c2ed3',
          region: '40d1b48a5440bd369733421ca5f7d0035a49ba7f49f01eb42bb7006ec815e681',
          fn: '6a0ac0fd972c325d6ca5512b67a5e0ad996c4a3e9b59971d125164e6d4db1a1c',
          ln: '64118260ecb916c23621d8f2768d8dc75d1f5710b1b7e4f2c41ad41e6bc4d688',
          ge: '62c66a7a5dd70c3146618063c344e531e6d4b59e379808443ce962b3abd63c5a',
          db: '5e0c46f17ed189d65863756df0241071eb2b1e24e8ec842d3e0618b2ff8eb8b7',
          ct: 'f377db9f1f0af132866afd5c4381512a5c9a3b3a32e9ca2f88f0aced18264568',
          zp: '8597f1e3043654da36e26467d59c6c6bbc9c44d498cc15ab2f91fc84440bbc35',
          sr: '99b1963027845d9412b4c112878f98e28a35df9b7a86849555b7b64cc34e8b1f',
          country: 'c4e98e070d2cdcd8b6486826223be4f528c54306c9e9c7191a5af6628ffb32e9',
          subscription_id: 'SUB-42',
          sid: 'id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79',
          udid: '019ef805-5dbe-7e8b-acd1-8caed14a91fa'
        }
      },
      s2s_headers: { client_ip_address: '203.0.113.9', user_agent: 'Mozilla/5.0 (request header)' }
    };
    // v3 differences allowed by V3-SPEC (e): d.12 version; d.3 fixed 30-day cookie lifetime.
    expected.api.template_version = '3.0.0';
    const expectedCookie = { domain: 'auto', path: '/', sameSite: 'lax', secure: true, 'max-age': 2592000, httpOnly: false };
    assertThat(sent()).isEqualTo(expected);
    assertThat(requests[0].raw).isEqualTo(JSON.stringify(expected));
    assertApi('setCookie').wasCalledWith('sznaiid', 'URL-CLICK', expectedCookie);
    assertSucceeded();

- name: upgrade fixture - parameters absent in older saved tags
  code: |-
    // A tag saved before v2.2/v2.3 has no value for the parameters those releases added
    // (autoMapIdsFromCookies, the input modes, GA4 auto-map, the sznaiid cookie settings, eventSource,
    // statusEnabled, BigQuery). Their runtime defaults apply. `expected` is the P0 v2.3.1 (1195cb4) body.
    mock('getTimestampMillis', 1793000000000);
    mock('getRequestHeader', (name) => ({
      'trace-id': 'TRACE-OLD',
      referer: 'https://shop.example/produkt/?sznaiid=OLD-CLICK',
      'x-forwarded-for': '203.0.113.21',
      'user-agent': 'Mozilla/5.0 (request header)'
    })[name]);
    mock('getCookieValues', (name) => ({
      sid: ['id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79'],
      udid: ['019ef805-5dbe-7e8b-acd1-8caed14a91fa@1782277561803']
    })[name] || []);
    mock('getAllEventData', {});
    runCode({
      eventNameSelect: 'Purchase',
      semId: 'hjqrj33mlq8phxinul9fmdo6',
      eventUrl: 'https://shop.example/dekujeme/',
      orderId: 'OLD-1',
      currency: 'CZK',
      value: 500,
      contents: '[{"id":"A","quantity":1,"unit_price":605}]',
      userEmail: 'b38f4d7a3bd7bd18fe99987bc73d29c98516c1d688c682ec33e2845bf5c292b5',
      consentModeObject: { ad_storage: 'granted', ad_user_data: 'granted' },
      testMode: false,
      useOptimisticScenario: false,
      strictEventValidation: false,
      sendS2sHeaders: true
    });
    const expected = {
      event_name: 'Purchase',
      schema_version: 'v2',
      event_type: 'rtgconv',
      event_time: 1793000000000,
      event_source: 'web',
      event_url: 'https://shop.example/dekujeme/',
      event_data: {
        sznaiid: 'OLD-CLICK',
        currency: 'CZK',
        value: 500,
        order_id: 'OLD-1',
        contents: [{ quantity: 1, id: 'A', unit_price: 605 }],
        content_type: 'product',
        sem_id: 'hjqrj33mlq8phxinul9fmdo6'
      },
      api: { name: 'gtm-server-template', version: '1', template_version: '2.3.1' },
      consent_mode: { ad_storage: 'granted', ad_user_data: 'granted' },
      user_ids: {
        user_data: {
          em: 'b38f4d7a3bd7bd18fe99987bc73d29c98516c1d688c682ec33e2845bf5c292b5',
          sid: 'id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79',
          udid: '019ef805-5dbe-7e8b-acd1-8caed14a91fa'
        }
      },
      s2s_headers: { client_ip_address: '203.0.113.21', user_agent: 'Mozilla/5.0 (request header)' }
    };
    // v3 differences allowed by V3-SPEC (e): d.12 version; d.3 fixed 30-day cookie lifetime.
    expected.api.template_version = '3.0.0';
    const expectedCookie = { domain: 'auto', path: '/', sameSite: 'lax', secure: true, 'max-age': 2592000, httpOnly: false };
    assertThat(sent()).isEqualTo(expected);
    assertThat(requests[0].raw).isEqualTo(JSON.stringify(expected));
    assertApi('setCookie').wasCalledWith('sznaiid', 'OLD-CLICK', expectedCookie);
    assertSucceeded();

- name: v3 tables - event and user data table rows build the payload
  code: |-
    runCode(tagData({
      eventNameSelect: 'Purchase',
      eventDataTable: rows({ order_id: 'O-1', currency: 'CZK', value: '100.50', status: 'true', goods_phase: '2' }),
      userDataTable: rows({ em: 'HASH_EM', sid: VALID_SID, udid: VALID_UDID + '@1782277561803' })
    }));
    assertThat(sent().event_data).isEqualTo({
      order_id: 'O-1',
      currency: 'CZK',
      value: 100.5,
      status: true,
      goods_phase: 2,
      sem_id: SEM_ID
    });
    assertThat(sent().user_ids.user_data).isEqualTo({ em: 'HASH_EM', sid: VALID_SID, udid: VALID_UDID });
    assertThat(legacyLines()).isEqualTo([]);
    assertSucceeded();

- name: v3 legacy F1 - each of the 14 legacy user fields maps to its user_data key
  code: |-
    // Independent parameter -> wire table (MIGRATION section 3, rows 16-29).
    const FIELDS = [
      ['sid', 'sid', VALID_SID],
      ['userUdid', 'udid', VALID_UDID],
      ['userEmail', 'em', 'HASH_EM'],
      ['userPhone', 'ph', 'HASH_PH'],
      ['userFirstName', 'fn', 'HASH_FN'],
      ['userLastName', 'ln', 'HASH_LN'],
      ['userGender', 'ge', 'HASH_GE'],
      ['userDob', 'db', 'HASH_DB'],
      ['userCity', 'ct', 'HASH_CT'],
      ['userRegion', 'region', 'HASH_REGION'],
      ['userZip', 'zp', 'HASH_ZP'],
      ['userStreet', 'sr', 'HASH_SR'],
      ['userCountry', 'country', 'HASH_COUNTRY'],
      ['userSubscriptionId', 'subscription_id', 'SUB-1']
    ];
    const fields = {};
    for (let i = 0; i < FIELDS.length; i++) fields[FIELDS[i][0]] = FIELDS[i][2];
    runCode(legacyTagData(fields));
    const userData = sent().user_ids.user_data;
    const line = legacyLines()[0];
    for (let i = 0; i < FIELDS.length; i++) {
      assertThat(userData[FIELDS[i][1]], FIELDS[i][0]).isEqualTo(FIELDS[i][2]);
      assertThat(line).contains(FIELDS[i][0] + '→user_data.' + FIELDS[i][1]);
    }
    assertThat(legacyLines().length).isEqualTo(1);

- name: v3 legacy F1 - each of the 17 legacy event fields maps to its event_data key
  code: |-
    // Independent parameter -> wire table (MIGRATION section 3, rows 33-49): field, key, input, sent value.
    const FIELDS = [
      ['sznaiid', 'sznaiid', 'SZN-1', 'SZN-1'],
      ['currency', 'currency', 'CZK', 'CZK'],
      ['value', 'value', '100.5', 100.5],
      ['orderId', 'order_id', 'O-1', 'O-1'],
      ['contentType', 'content_type', 'product_group', 'product_group'],
      ['contents', 'contents', '[{"id":"A","quantity":2}]', [{ id: 'A', quantity: 2 }]],
      ['deliveryPrice', 'delivery_price', '99', 99],
      ['deliveryType', 'delivery_type', 'PPL', 'PPL'],
      ['paymentType', 'payment_type', 'card', 'card'],
      ['otherCosts', 'other_costs', '10', 10],
      ['predictedLtv', 'predicted_ltv', '5000', 5000],
      ['valueTax', 'value_tax', '21', 21],
      ['reviewEmail', 'review_email', 'jan@example.cz', 'jan@example.cz'],
      ['productIds', 'product_ids', '[1,2]', [1, 2]],
      ['goodsIntention', 'goods_intention', '0.5', 0.5],
      ['goodsPhase', 'goods_phase', '3', 3],
      ['searchString', 'search_string', 'mixér', 'mixér']
    ];
    const fields = {};
    for (let i = 0; i < FIELDS.length; i++) fields[FIELDS[i][0]] = FIELDS[i][2];
    runCode(legacyTagData(fields));
    const eventData = sent().event_data;
    const line = legacyLines()[0];
    for (let i = 0; i < FIELDS.length; i++) {
      assertThat(eventData[FIELDS[i][1]], FIELDS[i][0]).isEqualTo(FIELDS[i][3]);
      assertThat(line).contains(FIELDS[i][0] + '→event_data.' + FIELDS[i][1]);
    }

- name: v3 legacy F2 - event data precedence is table, override, field, object, GA4
  code: |-
    mock('getAllEventData', {
      currency: 'EUR',
      value: 1,
      transaction_id: 'GA4-ORDER',
      items: [{ item_id: 'GA4-ITEM', quantity: 1 }]
    });
    runCode(legacyTagData({
      eventNameSelect: 'Purchase',
      enableGa4AutoMap: true,
      eventDataObject: { value: 2, currency: 'USD', order_id: 'OBJECT-ORDER', status: true, delivery_type: 'OBJECT' },
      value: '3',
      currency: 'GBP',
      orderId: 'FIELD-ORDER',
      goodsPhase: '2',
      deliveryType: '',
      eventDataOverrides: [
        { name: 'value', value: '4' },
        { name: 'currency', value: 'CZK' },
        { name: 'delivery_type', value: 'OVERRIDE' }
      ],
      eventDataTable: [
        { key: 'value', value: '5' },
        { key: 'currency', value: 'undefined' },
        { key: 'status', value: false },
        { key: 'goods_phase', value: 0 },
        { key: 'contents', value: [] }
      ]
    }));
    assertThat(sent().event_data).isEqualTo({
      currency: 'CZK',
      order_id: 'FIELD-ORDER',
      contents: [],
      value: 5,
      status: false,
      delivery_type: 'OVERRIDE',
      goods_phase: 0,
      content_type: 'product',
      sem_id: SEM_ID
    });
    assertThat(logged('event_data.currency is the placeholder string')).isTrue();

- name: v3 legacy F2 - user data precedence is table, override, field, object, GA4
  code: |-
    mock('getAllEventData', { user_data: { sha256_email_address: 'GA4_EM', sha256_phone_number: 'GA4_PH' } });
    runCode(legacyTagData({
      enableGa4AutoMap: true,
      userDataObject: { em: 'OBJECT_EM', ph: 'OBJECT_PH', fn: 'OBJECT_FN', ct: 'OBJECT_CT' },
      userEmail: 'FIELD_EM',
      userPhone: 'FIELD_PH',
      userFirstName: '   ',
      userCity: 'null',
      userDataOverrides: [{ name: 'em', value: 'OVERRIDE_EM' }, { name: 'ph', value: 'OVERRIDE_PH' }],
      userDataTable: [{ key: 'em', value: 'TABLE_EM' }, { key: 'ph', value: 'null' }]
    }));
    assertThat(sent().user_ids.user_data).isEqualTo({
      em: 'TABLE_EM',
      ph: 'OVERRIDE_PH',
      fn: 'OBJECT_FN',
      ct: 'OBJECT_CT'
    });

- name: v3 legacy F3 - Include status decides whether the legacy Status field applies
  code: |-
    runCode(legacyTagData({ eventNameSelect: 'Subscribe', statusEnabled: true }));
    runCode(legacyTagData({ eventNameSelect: 'Subscribe', statusEnabled: true, status: 'false' }));
    runCode(legacyTagData({ eventNameSelect: 'Subscribe', statusEnabled: false, status: 'true' }));
    assertThat(requests.length).isEqualTo(3);
    assertThat(requests[0].body.event_data.status).isStrictlyEqualTo(false);
    assertThat(requests[1].body.event_data.status).isStrictlyEqualTo(false);
    assertThat(requests[2].body.event_data.status).isUndefined();
    const lines = legacyLines();
    assertThat(lines.length).isEqualTo(2);
    assertThat(lines[0]).contains('statusEnabled→event_data.status');

- name: v3 legacy F3 - CompleteRegistration gets status true only when no layer supplies one
  code: |-
    runCode(tagData({ eventNameSelect: 'CompleteRegistration' }));
    runCode(tagData({ eventNameSelect: 'CompleteRegistration', eventDataTable: rows({ status: 'false' }) }));
    runCode(legacyTagData({ eventNameSelect: 'CompleteRegistration', statusEnabled: true }));
    assertThat(requests[0].body.event_data.status).isStrictlyEqualTo(true);
    assertThat(requests[1].body.event_data.status).isStrictlyEqualTo(false);
    assertThat(requests[2].body.event_data.status).isStrictlyEqualTo(false);

- name: v3 legacy F4 - userState applies and is reported only while userRegion is unset
  code: |-
    runCode(legacyTagData({ userRegion: 'null', userState: 'HASH_STATE', userEmail: 'HASH_EM' }));
    runCode(legacyTagData({ userRegion: 'HASH_REGION', userState: 'HASH_STATE' }));
    assertThat(requests[0].body.user_ids.user_data.region).isEqualTo('HASH_STATE');
    assertThat(requests[1].body.user_ids.user_data.region).isEqualTo('HASH_REGION');
    const lines = legacyLines();
    assertThat(lines[0]).contains('userState→user_data.region');
    assertThat(lines[0]).doesNotContain('userRegion');
    assertThat(lines[1]).contains('userRegion→user_data.region');
    assertThat(lines[1]).doesNotContain('userState');

- name: v3 legacy F5 - aliases keep the P0 payload and are reported
  code: |-
    runCode(tagData({ userDataObject: { email: 'HASH_EM', phone: 'HASH_PH', em: 'HASH_CANONICAL', zip: 'HASH_ZP' } }));
    assertThat(sent().user_ids.user_data).isEqualTo({ em: 'HASH_CANONICAL', ph: 'HASH_PH', zp: 'HASH_ZP' });
    assertThat(legacyLines()[0]).contains('alias email→em, alias phone→ph, alias zip→zp');

- name: v3 legacy F5 - GA4 platform keys keep the P0 payload and are reported once each
  code: |-
    mock('getAllEventData', {
      id: 'SHOPTET-ORDER',
      revenue: 250,
      items: [
        { id: 'A', name: 'Name A', priceWithVat: 121, category: 'X/Y', quantity: 1 },
        { id: 'B', name: 'Name B', priceWithVat: 60.5, quantity: 2 },
        { item_id: 'C', fullPrice: 10, currentCategory: 'Current', quantity: 1 },
        { item_id: 'D', price: 5, defaultCategory: ['Books', 'Fiction'], quantity: 1 }
      ]
    });
    runCode(tagData({ eventNameSelect: 'AddToCart', enableGa4AutoMap: true }));
    assertThat(sent().event_data).isEqualTo({
      order_id: 'SHOPTET-ORDER',
      contents: [
        { id: 'A', content_name: 'Name A', unit_price: 121, quantity: 1, content_category: 'X | Y' },
        { id: 'B', content_name: 'Name B', unit_price: 60.5, quantity: 2 },
        { id: 'C', unit_price: 10, quantity: 1, content_category: 'Current' },
        { id: 'D', unit_price: 5, quantity: 1, content_category: 'Books | Fiction' }
      ],
      value: 250,
      content_type: 'product',
      sem_id: SEM_ID
    });
    const line = legacyLines()[0];
    assertThat(line).contains('ga4.id, ga4.items.id, ga4.items.name, ga4.items.priceWithVat, ga4.items.category, ' +
      'ga4.items.fullPrice, ga4.items.currentCategory, ga4.items.defaultCategory, ga4.revenue');
    assertThat(line.split('ga4.items.priceWithVat').length).isEqualTo(2);

- name: v3 legacy F5 - GA4 orderNo and totalWithoutVat are reported
  code: |-
    mock('getAllEventData', { orderNo: 'NO-1', totalWithoutVat: 175, currency: 'CZK' });
    runCode(tagData({ eventNameSelect: 'Purchase', enableGa4AutoMap: true }));
    assertThat(sent().event_data).isEqualTo({ currency: 'CZK', order_id: 'NO-1', value: 175, sem_id: SEM_ID });
    assertThat(legacyLines()[0]).contains('ga4.orderNo, ga4.totalWithoutVat');

- name: v3 legacy F6 - one aggregated WARN per execution, without values, in the fixed order
  code: |-
    mock('getRequestHeader', (name) => name === 'trace-id' ? 'TRACE-6' : undefined);
    mock('getAllEventData', { orderNo: 'NO-1' });
    runCode(legacyTagData({
      testMode: true,
      enableGa4AutoMap: true,
      orderId: 'ORDER-SECRET',
      userEmail: 'HASH_SECRET',
      userDataObject: { email: 'HASH_ALIAS_SECRET' },
      userDataOverrides: [{ name: 'ph', value: 'HASH_OVERRIDE_SECRET' }]
    }));
    assertThat(legacyLines()).isEqualTo([
      'Seznam SEM [WARN]: v2.x settings in use: userEmail→user_data.em, orderId→event_data.order_id, ' +
      'userDataOverrides, alias email→em, ga4.orderNo, testMode; move them to the v3 tables/settings ' +
      '(README "Přechod na v3") | trace=TRACE-6'
    ]);
    assertThat(legacyLines()[0]).doesNotContain('SECRET');
    assertSucceeded();

- name: v3 legacy F6 - default-valued v2.x settings and the fresh v3 defaults report nothing
  code: |-
    runCode(legacyTagData({}));
    runCode(freshTagDefaults({ eventDataTable: rows({ currency: 'CZK' }) }));
    runCode(legacyTagData({ statusEnabled: false, status: 'true', userDataOverrides: [{ name: 'em', value: '' }] }));
    assertThat(requests.length).isEqualTo(3);
    assertThat(legacyLines()).isEqualTo([]);

- name: v3 legacy F7 - testMode forces diagnostics even with logType no
  code: |-
    containerVersion = { debugMode: false, previewMode: false };
    runCode(legacyTagData({ testMode: true, logType: 'no', currency: 'EUR' }));
    assertThat(logged('"Type":"Request"')).isTrue();
    assertThat(logged('currency=EUR')).isTrue();
    assertThat(legacyLines()[0]).contains('testMode');
    callLater(() => { assertThat(logged('"Type":"Response"')).isTrue(); });

- name: v3 legacy F7 - logType debug in production logs no WARN or diagnostics, ERROR always
  code: |-
    containerVersion = { debugMode: false, previewMode: false };
    runCode(tagData({ logType: 'debug', userDataObject: '{bad', eventDataTable: rows({ currency: 'EUR' }) }));
    assertThat(sent().event_data.currency).isEqualTo('EUR');
    assertThat(logged('[WARN]')).isFalse();
    assertThat(logged('"Type":"Request"')).isFalse();
    assertThat(logged('[ERROR]: userDataObject: invalid JSON')).isTrue();
    callLater(() => { assertThat(logged('"Type":"Response"')).isFalse(); });

- name: v3 legacy F9 - stored loose validation adds the hint to an incomplete Purchase ERROR
  code: |-
    runCode(legacyTagData({ eventNameSelect: 'Purchase', orderId: 'O-1', currency: 'CZK' }));
    assertFailedWithoutRequest();
    assertThat(logged('Purchase requires: value')).isTrue();
    assertThat(logged('(v2 loose validation no longer applies)')).isTrue();

- name: v3 legacy F9 - Strict Event Validation on or unset adds no hint
  code: |-
    runCode(tagData({ eventNameSelect: 'from_variable', eventNameFromVariable: 'Foo', strictEventValidation: true }));
    runCode(tagData({ eventNameSelect: 'from_variable', eventNameFromVariable: 'Foo' }));
    assertThat(requests.length).isEqualTo(0);
    assertThat(logged('Unknown event name: Foo')).isTrue();
    assertThat(logged('(v2 loose validation no longer applies)')).isFalse();

- name: v3 d.1 - Auto from GA4 maps the 13 one-to-one names without GA4 prefill
  code: |-
    const NAMES = [
      ['page_view', 'PageView'], ['view_item', 'ViewContent'], ['search', 'Search'],
      ['view_search_results', 'Search'], ['add_to_cart', 'AddToCart'], ['add_to_wishlist', 'AddToWishlist'],
      ['begin_checkout', 'InitiateCheckout'], ['add_payment_info', 'AddPaymentInfo'], ['purchase', 'Purchase'],
      ['generate_lead', 'Lead'], ['sign_up', 'CompleteRegistration'], ['subscribe', 'Subscribe'],
      ['contact', 'Contact']
    ];
    for (let i = 0; i < NAMES.length; i++) {
      mock('getAllEventData', { event_name: NAMES[i][0] });
      runCode(tagData({ eventNameSelect: 'auto', eventDataTable: rows({ order_id: 'O-1', currency: 'CZK', value: 1 }) }));
    }
    assertThat(requests.length).isEqualTo(NAMES.length);
    for (let i = 0; i < NAMES.length; i++) {
      assertThat(requests[i].body.event_name, NAMES[i][0]).isEqualTo(NAMES[i][1]);
    }

- name: v3 d.1 - the removed GA4 names fail with Unknown event name, even with the v2.3 auto-map settings
  code: |-
    const REMOVED = ['login', 'add_shipping_info', 'view_item_list', 'select_item', 'view_promotion'];
    for (let i = 0; i < REMOVED.length; i++) {
      mock('getAllEventData', { event_name: REMOVED[i] });
      runCode(legacyTagData({ eventNameSelect: 'auto', enableGa4AutoMap: true, autoMapEventName: true }));
      assertThat(logged('Unknown event name: ga4:' + REMOVED[i]), REMOVED[i]).isTrue();
    }
    assertThat(requests.length).isEqualTo(0);

- name: v3 d.1 O6 - Auto from GA4 without prefill maps the name but fills no payload fields
  code: |-
    mock('getAllEventData', {
      event_name: 'purchase',
      page_location: 'https://shop.example/ga4-page',
      transaction_id: 'GA4-ORDER',
      currency: 'EUR',
      value: 999,
      items: [{ item_id: 'GA4', quantity: 1 }]
    });
    runCode(tagData({
      eventNameSelect: 'auto',
      eventUrl: '',
      eventDataTable: rows({ order_id: 'TABLE-ORDER', currency: 'CZK', value: '100' })
    }));
    assertThat(sent().event_name).isEqualTo('Purchase');
    assertThat(sent().event_url).isUndefined();
    assertThat(sent().event_data).isEqualTo({ order_id: 'TABLE-ORDER', currency: 'CZK', value: 100, sem_id: SEM_ID });

- name: v3 O6 - an explicit event name wins over the GA4 event_name with prefill on
  code: |-
    mock('getAllEventData', { event_name: 'purchase', currency: 'CZK' });
    runCode(tagData({ eventNameSelect: 'PageView', enableGa4AutoMap: true }));
    assertThat(sent().event_name).isEqualTo('PageView');
    assertThat(sent().event_data.currency).isEqualTo('CZK');

- name: v3 O6 - an unsupported auto name fails once without request or cookie
  code: |-
    mock('getAllEventData', { event_name: 'login', page_location: 'https://shop.example/?sznaiid=CLICK' });
    runCode(tagData({ eventNameSelect: 'auto', enableGa4AutoMap: true }));
    assertFailedWithoutRequest();
    assertThat(logged('Seznam SEM [ERROR]: Unknown event name: ga4:login')).isTrue();

- name: v3 O6 - auto with no inbound event_name fails without request
  code: |-
    mock('getAllEventData', {});
    runCode(tagData({ eventNameSelect: 'auto' }));
    assertFailedWithoutRequest();
    assertThat(logged('Seznam SEM [ERROR]: eventName is required')).isTrue();

- name: v3 d.2 - transaction_id is not used as event_id and the gap is warned
  code: |-
    mock('getAllEventData', { transaction_id: 'TX-1', currency: 'CZK', value: 10 });
    runCode(tagData({ eventNameSelect: 'Purchase', enableGa4AutoMap: true }));
    assertThat(sent().event_id).isUndefined();
    assertThat(sent().event_data.order_id).isEqualTo('TX-1');
    assertThat(logged('transaction_id is no longer used as event_id; set Event ID')).isTrue();

- name: v3 d.2 - GA4 event_id or an explicit Event ID silence the transaction_id WARN
  code: |-
    mock('getAllEventData', { event_id: 'EV-1', transaction_id: 'TX-1', currency: 'CZK', value: 10 });
    runCode(tagData({ eventNameSelect: 'Purchase', enableGa4AutoMap: true }));
    mock('getAllEventData', { transaction_id: 'TX-2', currency: 'CZK', value: 10 });
    runCode(tagData({ eventNameSelect: 'Purchase', enableGa4AutoMap: true, eventId: 'Purchase__TX-2' }));
    assertThat(requests[0].body.event_id).isEqualTo('EV-1');
    assertThat(requests[1].body.event_id).isEqualTo('Purchase__TX-2');
    assertThat(logged('transaction_id is no longer used as event_id')).isFalse();

- name: v3 d.4 - IP and User-Agent come from the event data first, Client Hints from the headers
  code: |-
    mock('getRequestHeader', (name) => ({
      'x-forwarded-for': '1.2.3.4, 10.0.0.1',
      'user-agent': 'header-ua',
      'sec-ch-ua': '"Chromium";v="141"'
    })[name]);
    mock('getAllEventData', { ip_override: ' 198.51.100.1 ', user_agent: 'event-ua' });
    runCode(tagData({ sendS2sHeaders: true, consentModeObject: { ad_storage: 'granted', ad_user_data: 'granted' } }));
    assertThat(sent().s2s_headers).isEqualTo({
      client_ip_address: '198.51.100.1',
      user_agent: 'event-ua',
      sec_ch_ua: '"Chromium";v="141"'
    });

- name: v3 d.4 - blank event data values fall back to the request headers, consent still gates them
  code: |-
    mockClientHeaders();
    mock('getAllEventData', { ip_override: '  ', user_agent: '' });
    runCode(tagData({ sendS2sHeaders: true, consentModeObject: { ad_storage: 'granted', ad_user_data: 'granted' } }));
    runCode(tagData({ sendS2sHeaders: true, consentModeObject: { ad_storage: 'granted', ad_user_data: 'denied' } }));
    assertThat(requests[0].body.s2s_headers).isEqualTo({ client_ip_address: '1.2.3.4', user_agent: 'test-ua' });
    assertThat(requests[1].body.s2s_headers).isUndefined();

- name: v3 d.5 - an unset Use Optimistic Scenario waits for Seznam's answer
  code: |-
    httpResult = { statusCode: 500, headers: {}, body: '' };
    const fields = tagData({});
    fields.useOptimisticScenario = undefined;
    runCode(fields);
    assertApi('gtmOnSuccess').wasNotCalled();
    assertFailedAfterResponse();

- name: v3 d.5 - a stored true stays optimistic
  code: |-
    httpResult = { statusCode: 500, headers: {}, body: '' };
    runCode(legacyTagData({ useOptimisticScenario: true }));
    assertApi('gtmOnSuccess').wasCalled();
    callLater(() => { assertApi('gtmOnFailure').wasNotCalled(); });

- name: v3 d.7 - fresh defaults in production drop WARN lines, Preview keeps them
  code: |-
    containerVersion = { debugMode: false, previewMode: false };
    runCode(freshTagDefaults({ eventDataTable: rows({ currency: 'EUR' }) }));
    const productionLogs = logs.length;
    containerVersion = { debugMode: false, previewMode: true };
    runCode(freshTagDefaults({ eventDataTable: rows({ currency: 'EUR' }) }));
    assertThat(requests.length).isEqualTo(2);
    assertThat(productionLogs).isEqualTo(0);
    assertThat(logged('currency=EUR')).isTrue();

- name: v3 d.7 - an unavailable container version counts as production for logType debug
  code: |-
    containerVersion = undefined;
    runCode(tagData({ logType: 'debug', eventDataTable: rows({ currency: 'EUR' }) }));
    assertThat(sent().event_data.currency).isEqualTo('EUR');
    assertThat(logged('[WARN]')).isFalse();

- name: v3 O4 - logging matrix of logType, container mode and testMode
  code: |-
    // Each run has an ordinary WARN (EUR), the always-on ERROR of a malformed object and an active
    // legacy field. WARN lines and diagnostics follow the level; ERROR and the legacy line never do.
    const LEVELS = ['no', 'debug', 'always'];
    const MODES = [
      { debugMode: false, previewMode: false },
      { debugMode: true, previewMode: false },
      { debugMode: false, previewMode: true }
    ];
    for (let l = 0; l < LEVELS.length; l++) {
      for (let m = 0; m < MODES.length; m++) {
        for (let t = 0; t < 2; t++) {
          containerVersion = MODES[m];
          const start = logs.length;
          runCode(legacyTagData({
            logType: LEVELS[l],
            testMode: t === 1,
            userDataObject: '{bad',
            userEmail: 'HASH_EM',
            currency: 'EUR'
          }));
          const runLogs = logs.slice(start);
          const label = LEVELS[l] + '/' + m + '/testMode=' + (t === 1);
          const expectVerbose = t === 1 || LEVELS[l] === 'always' || (LEVELS[l] === 'debug' && m > 0);
          let warns = 0;
          let requestLines = 0;
          let errors = 0;
          let legacy = 0;
          for (let n = 0; n < runLogs.length; n++) {
            if (runLogs[n].indexOf('v2.x settings in use') !== -1) legacy++;
            else if (runLogs[n].indexOf('[WARN]') !== -1) warns++;
            if (runLogs[n].indexOf('"Type":"Request"') !== -1) requestLines++;
            if (runLogs[n].indexOf('[ERROR]: userDataObject') !== -1) errors++;
          }
          assertThat(warns > 0, label + ' WARN').isEqualTo(expectVerbose);
          assertThat(requestLines, label + ' diagnostics').isEqualTo(expectVerbose ? 1 : 0);
          assertThat(errors, label + ' ERROR').isEqualTo(1);
          assertThat(legacy, label + ' legacy line').isEqualTo(1);
        }
      }
    }
    assertThat(requests.length).isEqualTo(18);

- name: v3 O4 - a literal hasOwnProperty key is an ordinary unknown key
  code: |-
    runCode(tagData({
      eventNameSelect: 'AddToCart',
      userDataObject: { hasOwnProperty: 'x', em: 'HASH_EM' },
      eventDataObject: { hasOwnProperty: 1, currency: 'CZK', contents: [{ id: 'A', hasOwnProperty: 2 }] },
      consentModeObject: { hasOwnProperty: 'x', ad_storage: 'granted' },
      userDataTable: [{ key: 'hasOwnProperty', value: 'y' }]
    }));
    assertThat(sent().user_ids.user_data).isEqualTo({ em: 'HASH_EM' });
    assertThat(sent().event_data).isEqualTo({
      currency: 'CZK',
      contents: [{ id: 'A', quantity: 1 }],
      content_type: 'product',
      sem_id: SEM_ID
    });
    assertThat(sent().consent_mode).isEqualTo({ ad_storage: 'granted' });
    assertThat(logged('user_data.hasOwnProperty is not a Seznam field')).isTrue();
    assertThat(logged('event_data.hasOwnProperty is not a Seznam field')).isTrue();
    assertThat(logged('event_data.contents[0].hasOwnProperty is not a Seznam field')).isTrue();
    assertSucceeded();

- name: v3 O1 - fresh v3 defaults with a landing click report no cookie tuning
  code: |-
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=CLICK' });
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['OLD'] : []);
    runCode(freshTagDefaults({}));
    assertApi('setCookie').wasCalledWith('sznaiid', 'CLICK', {
      domain: 'auto',
      path: '/',
      sameSite: 'lax',
      secure: true,
      'max-age': 2592000,
      httpOnly: false
    });
    assertThat(legacyLines()).isEqualTo([]);

- name: v3 O1 - upgraded first_touch and 90-day settings are reported when the click replaces a cookie
  code: |-
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=CLICK' });
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['OLD'] : []);
    runCode(legacyTagData({}));
    assertThat(legacyLines()[0]).contains('persistSznaiidCookieMode, sznaiidCookieMaxAge');
    assertApi('setCookie').wasCalled();

- name: v3 O1 - first_touch is not reported without an existing cookie, the lifetime is
  code: |-
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=CLICK' });
    mock('getCookieValues', () => []);
    runCode(legacyTagData({}));
    assertThat(legacyLines()[0]).contains('sznaiidCookieMaxAge');
    assertThat(legacyLines()[0]).doesNotContain('persistSznaiidCookieMode');

- name: v3 O1 - a repeated identical click refreshes the cookie and reports first_touch
  code: |-
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=SAME' });
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['SAME'] : []);
    runCode(legacyTagData({ sznaiidCookieMaxAge: '2592000' }));
    assertApi('setCookie').wasCalledWith('sznaiid', 'SAME', {
      domain: 'auto',
      path: '/',
      sameSite: 'lax',
      secure: true,
      'max-age': 2592000,
      httpOnly: false
    });
    assertThat(legacyLines()[0]).contains('persistSznaiidCookieMode');
    assertThat(legacyLines()[0]).doesNotContain('sznaiidCookieMaxAge');

- name: v3 O1 - no cookie write, persistence off or a preview ping report no cookie tuning
  code: |-
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['OLD'] : []);
    mock('getAllEventData', { page_location: 'https://shop.example/no-click' });
    runCode(legacyTagData({ sznaiidCookieMaxAge: 'abc' }));
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=CLICK' });
    runCode(legacyTagData({ persistSznaiidCookie: false, sznaiidCookieMaxAge: 'abc' }));
    mock('getAllEventData', { page_location: 'https://gtm-msr.appspot.com/render?sznaiid=CLICK' });
    runCode(legacyTagData({ sznaiidCookieMaxAge: 'abc' }));
    assertThat(requests.length).isEqualTo(3);
    assertApi('setCookie').wasNotCalled();
    assertThat(legacyLines()).isEqualTo([]);

- name: v3 O1 - a non-numeric stored lifetime is reported when a cookie is written
  code: |-
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=CLICK' });
    mock('getCookieValues', () => []);
    runCode(legacyTagData({ sznaiidCookieMaxAge: 'abc' }));
    assertThat(legacyLines()[0]).contains('sznaiidCookieMaxAge');

- name: v3 O1 O2 - a failed hit plans no cookie write and reports no cookie tuning
  code: |-
    mock('getAllEventData', { page_location: 'https://shop.example/lp?sznaiid=CLICK' });
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['OLD'] : []);
    runCode(legacyTagData({ eventNameSelect: 'Purchase', orderId: 'O-1', currency: 'CZK', logType: 'no' }));
    assertFailedWithoutRequest();
    assertThat(legacyLines()).isEqualTo(['Seznam SEM [WARN]: v2.x settings in use: currency→event_data.currency, ' +
      'orderId→event_data.order_id; move them to the v3 tables/settings (README "Přechod na v3") | trace=undefined']);

- name: v3 O2 - an incomplete Purchase flushes the legacy line once with logType no
  code: |-
    containerVersion = { debugMode: false, previewMode: false };
    mock('getAllEventData', { orderNo: 'NO-1', items: [{ id: 'A', quantity: 1 }, { id: 'B', quantity: 1 }] });
    runCode(legacyTagData({
      eventNameSelect: 'Purchase',
      logType: 'no',
      enableGa4AutoMap: true,
      userEmail: 'HASH_EM',
      currency: 'CZK'
    }));
    assertFailedWithoutRequest();
    assertThat(legacyLines().length).isEqualTo(1);
    assertThat(legacyLines()[0]).contains('userEmail→user_data.em, currency→event_data.currency, ga4.orderNo, ga4.items.id;');
    assertThat(logged('[WARN]: Purchase')).isFalse();
    assertThat(logged('Seznam SEM [ERROR]: Purchase requires: value')).isTrue();

- name: v3 O2 - an invalid SEM ID flushes the legacy line once
  code: |-
    runCode(legacyTagData({ semId: 'BAD', logType: 'no', orderId: 'O-1' }));
    assertFailedWithoutRequest();
    assertThat(legacyLines().length).isEqualTo(1);
    assertThat(legacyLines()[0]).contains('orderId→event_data.order_id');

- name: v3 O2 - a consent failure reports only the legacy items resolved before it
  code: |-
    runCode(legacyTagData({ testMode: true, userEmail: 'HASH_EM', consentModeObject: { ad_storage: 'yes' } }));
    assertFailedWithoutRequest();
    assertThat(legacyLines().length).isEqualTo(1);
    assertThat(legacyLines()[0]).contains('in use: testMode;');
    assertThat(logs).contains('Seznam SEM [ERROR]: consentModeObject.ad_storage: expected granted/denied (or true/false, 1/0), got string');

- name: v3 O3 - a broken Contents string wins over valid GA4 contents and is omitted
  code: |-
    mock('getAllEventData', { items: [{ item_id: 'GA4', quantity: 1 }] });
    runCode(tagData({ eventNameSelect: 'AddToCart', enableGa4AutoMap: true, contents: '[broken' }));
    assertThat(sent().event_data.contents).isUndefined();
    assertThat(logged('event_data.contents: invalid JSON, got string; omitting')).isTrue();
    assertSucceeded();

- name: v3 O3 - table array values accept native arrays, JSON strings and an explicit empty list
  code: |-
    mock('getAllEventData', { items: [{ item_id: 'GA4', quantity: 1 }] });
    runCode(tagData({ enableGa4AutoMap: true, eventDataTable: [{ key: 'contents', value: [{ id: 'A', quantity: '2' }] }] }));
    runCode(tagData({ enableGa4AutoMap: true, eventDataTable: rows({ contents: '[{"id":"B"}]', product_ids: '[1,"2"]' }) }));
    runCode(tagData({ enableGa4AutoMap: true, eventDataTable: rows({ contents: '[]' }) }));
    assertThat(requests[0].body.event_data.contents).isEqualTo([{ id: 'A', quantity: 2 }]);
    assertThat(requests[1].body.event_data.contents).isEqualTo([{ id: 'B', quantity: 1 }]);
    assertThat(requests[1].body.event_data.product_ids).isEqualTo([1, 2]);
    assertThat(requests[2].body.event_data.contents).isEqualTo([]);

- name: v3 O3 - malformed, wrong-shape, false and 0 array values are omitted without restoring lower layers
  code: |-
    const BAD = ['[broken', '{"id":"A"}', false, 0, '"text"'];
    for (let i = 0; i < BAD.length; i++) {
      runCode(tagData({
        eventDataObject: { contents: [{ id: 'OBJECT', quantity: 1 }], product_ids: [7] },
        eventDataTable: [{ key: 'contents', value: BAD[i] }, { key: 'product_ids', value: BAD[i] }]
      }));
      assertThat(requests[i].body.event_data.contents, 'contents ' + i).isUndefined();
      assertThat(requests[i].body.event_data.product_ids, 'product_ids ' + i).isUndefined();
    }
    assertThat(logged('event_data.contents: invalid JSON, got string; omitting')).isTrue();
    assertThat(logged('event_data.contents: expected array, got object; omitting')).isTrue();
    assertThat(logged('event_data.product_ids: expected array, got boolean; omitting')).isTrue();

- name: v3 O3 - duplicate table keys use the last row, unknown keys and sem_id are dropped
  code: |-
    runCode(tagData({
      eventDataTable: [
        { key: 'currency', value: 'EUR' },
        { key: 'currency', value: 'CZK' },
        { key: 'unknown_key', value: 'x' },
        { key: 'sem_id', value: 'zzzzzzzzzzzzzzzzzzzzzzzz' },
        { key: '', value: 'no key' }
      ]
    }));
    assertThat(sent().event_data).isEqualTo({ currency: 'CZK', sem_id: SEM_ID });
    assertThat(logged('event_data.unknown_key is not a Seznam field')).isTrue();

- name: v3 O3 d.9 - a malformed Event Data Object does not stop a valid GA4 Purchase
  code: |-
    mock('getAllEventData', { transaction_id: 'TX-1', currency: 'CZK', value: 100 });
    runCode(tagData({ eventNameSelect: 'Purchase', enableGa4AutoMap: true, eventDataObject: '{"order_id":' }));
    assertThat(sent().event_data).isEqualTo({ currency: 'CZK', order_id: 'TX-1', value: 100, sem_id: SEM_ID });
    assertThat(logged('[ERROR]: eventDataObject: invalid JSON, got string; omitting it')).isTrue();
    assertSucceeded();

- name: v3 O3 d.9 - an object-only Purchase with a malformed object fails final validation
  code: |-
    runCode(tagData({ eventNameSelect: 'Purchase', eventDataObject: '{"order_id":"O-1","currency":"CZK"' }));
    assertFailedWithoutRequest();
    assertThat(logged('[ERROR]: eventDataObject: invalid JSON, got string; omitting it')).isTrue();
    assertThat(logged('Purchase requires: order_id, currency, value')).isTrue();

- name: v3 O7 d.14 - a blank or placeholder Event URL falls back to page_location and the Referer
  code: |-
    mock('getRequestHeader', (name) => name === 'referer' ? 'https://shop.example/from-referer' : undefined);
    runCode(tagData({ eventUrl: '   ' }));
    mock('getAllEventData', { page_location: 'https://shop.example/from-ga4' });
    runCode(tagData({ eventUrl: 'undefined', enableGa4AutoMap: true }));
    runCode(tagData({ eventUrl: { href: 'https://shop.example/object' } }));
    assertThat(requests[0].body.event_url).isEqualTo('https://shop.example/from-referer');
    assertThat(requests[1].body.event_url).isEqualTo('https://shop.example/from-ga4');
    assertThat(requests[2].body.event_url).isEqualTo('https://shop.example/from-referer');

- name: v3 O7 d.14 - without any URL source event_url is not serialized
  code: |-
    runCode(tagData({ eventUrl: undefined }));
    assertThat(requests[0].raw.indexOf('event_url')).isEqualTo(-1);
    assertThat(logged('event_url is empty')).isTrue();
    assertSucceeded();
setup: |-
  // Sandboxed test code has no JSON, Promise or callLater globals; require them like the template does.
  const JSON = require('JSON');
  const Promise = require('Promise');
  const callLater = require('callLater');

  const SEM_ID = 'abcdefghijklmnopqrstuvwx';
  const VALID_SID = 'id=8889818589302544222|t=1769429094.692|te=1782303169.389|c=DE30F59D28F565B4F191F9E56A38BC79';
  const VALID_UDID = '019ef805-5dbe-7e8b-acd1-8caed14a91fa';
  const TCF_STRING = 'CQGzWAAQGzWAAAHABBENBKFsAP_gAEPgAAAAKZtV_G__bXlv-X736ftkeY1f9_h77sQxBhfJs.4FzLvW_JwX32EzNE36tqYKmRIAu3bBIQNtHJjUTVChaogVrzDsak2coTtKJ-BkiHMRe2dY';

  // Every outgoing request (parsed body and raw serialized body) and console line of the scenario.
  // Set httpResult to change the response, or to 'reject' to simulate a transport failure.
  let requests = [];
  let logs = [];
  let httpResult = { statusCode: 200, headers: { 'x-request-id': 'REQ-1' }, body: '' };

  mock('sendHttpRequest', (url, options, body) => {
    requests.push({ url: url, options: options, body: JSON.parse(body), raw: body });
    return Promise.create((resolve, reject) => {
      if (httpResult === 'reject') reject({ reason: 'timed_out' });
      else resolve(httpResult);
    });
  });
  mock('logToConsole', (message) => { logs.push(message); });
  mock('setCookie', () => {});

  // Scenarios run as in GTM Preview, where logType 'debug' logs WARN lines. Set containerVersion to a
  // production container (or undefined) to test the logging levels.
  let containerVersion = { debugMode: false, previewMode: true };
  mock('getContainerVersion', () => containerVersion);

  // Fields of a v3 tag for a valid PageView that waits for the API response; event and user data go
  // into the tables (rows()). `extra` adds or replaces fields.
  function tagData(extra) {
    const fields = {
      eventNameSelect: 'PageView',
      semId: SEM_ID,
      eventUrl: 'https://shop.example/',
      useOptimisticScenario: false
    };
    for (const key in extra) fields[key] = extra[key];
    return fields;
  }

  // Key-value table rows of eventDataTable / userDataTable, in the order of `values`.
  function rows(values) {
    const list = [];
    for (const key in values) list.push({ key: key, value: values[key] });
    return list;
  }

  // A tag as v2.3 stored it with its defaults and Individual fields (the legacy group in v3). Only
  // useOptimisticScenario differs from the v2.3 default, so the scenario sees Seznam's answer.
  function legacyTagData(extra) {
    const fields = {
      eventNameSelect: 'PageView',
      semId: SEM_ID,
      eventUrl: 'https://shop.example/',
      eventSource: 'web',
      enableGa4AutoMap: false,
      autoMapEventName: false,
      autoMapUserData: true,
      autoMapEventData: true,
      userDataInputMode: 'fields',
      eventDataInputMode: 'fields',
      autoMapIdsFromCookies: true,
      statusEnabled: false,
      testMode: false,
      useOptimisticScenario: false,
      strictEventValidation: false,
      sendS2sHeaders: true,
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      bigQueryLogType: 'no'
    };
    for (const key in extra) fields[key] = extra[key];
    return fields;
  }

  // A freshly created v3 tag: every defaultValue of ___TEMPLATE_PARAMETERS___, plus the SEM ID and URL.
  function freshTagDefaults(extra) {
    const fields = {
      eventNameSelect: 'PageView',
      semId: SEM_ID,
      eventUrl: 'https://shop.example/',
      enableGa4AutoMap: false,
      autoMapUserData: true,
      autoMapEventData: true,
      autoMapIdsFromCookies: true,
      sendS2sHeaders: true,
      persistSznaiidCookie: true,
      useOptimisticScenario: false,
      eventSource: 'web',
      logType: 'debug',
      bigQueryLogType: 'no',
      autoMapEventName: false,
      statusEnabled: false,
      testMode: false,
      strictEventValidation: false,
      persistSznaiidCookieMode: 'last_touch',
      sznaiidCookieMaxAge: ''
    };
    for (const key in extra) fields[key] = extra[key];
    return fields;
  }

  // Parsed body of the request; asserts that exactly one request was made.
  function sent() {
    assertThat(requests.length, 'number of requests').isEqualTo(1);
    return requests[0].body;
  }

  // The aggregated v2.x legacy WARN lines of the scenario.
  function legacyLines() {
    const found = [];
    for (let n = 0; n < logs.length; n++) {
      if (logs[n].indexOf('v2.x settings in use') !== -1) found.push(logs[n]);
    }
    return found;
  }

  function logged(fragment) {
    for (let n = 0; n < logs.length; n++) {
      if (logs[n].indexOf(fragment) !== -1) return true;
    }
    return false;
  }

  function mockClientHeaders() {
    mock('getRequestHeader', (name) => {
      if (name === 'x-forwarded-for') return '1.2.3.4, 10.0.0.1';
      if (name === 'user-agent') return 'test-ua';
      return undefined;
    });
  }

  function assertSucceeded() {
    callLater(() => {
      assertThat(requests.length, 'number of requests').isEqualTo(1);
      assertApi('gtmOnSuccess').wasCalled();
      assertApi('gtmOnFailure').wasNotCalled();
    });
  }

  function assertFailedAfterResponse() {
    callLater(() => {
      assertThat(requests.length, 'number of requests').isEqualTo(1);
      assertApi('gtmOnFailure').wasCalled();
      assertApi('gtmOnSuccess').wasNotCalled();
    });
  }

  // Configuration and validation failures stop the tag synchronously: no request, no cookie write.
  function assertFailedWithoutRequest() {
    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
    assertApi('sendHttpRequest').wasNotCalled();
    assertApi('setCookie').wasNotCalled();
  }


___NOTES___

v2.3.1 — Correctness patch: one assemble/normalize/validate pass on the final payload,
consent validation (malformed configured consent fails the tag), invalid-quantity items
dropped, no value derived from item prices, sid/udid shape rule for explicit values,
full SEM ID charset check, 5 s timeout. See CHANGELOG.md, including the upgrade notes.
v2.3.0 — sid/udid cookie fallback, Object / Individual fields input modes, rebrand to
"Seznam SEM (Server-Side)". See CHANGELOG.md.
v2.2.1 — Polish on v2.2 line: broadened GA4 Auto-Map (multi-source order_id /
value / item field aliases, multi-level item_category2..5 join, MeasureHive
slash categories, Shoptet currentCategory/defaultCategory, quantity default 1,
value and unit_price 2-decimal rounding, sum-of-contents value fallback);
CompleteRegistration auto status=true (post-Layer-3; object/field false preserved; override table caveats documented);
userDataObject alias normalization (FE-template aliases email/phone/fname/lname/
gender/g/birth/birthDate/postalCode/zip/subscription/subscriptionId translated
to canonical em/ph/fn/ln/ge/db/zp/subscription_id with WARN log; canonical
wins when non-empty; alias keys never reach payload); X-Client-Id /
X-Client-Version HTTP headers (diagnostic correlation with Seznam); S2S SEM ID
wording; sul.js (was sem.js) correction; Custom event option REMOVED and replaced
with "From variable" wiring (resolved value still validated against the 18-event
allowlist; non-allowlist values are NOT supported by Seznam);
Event ID dedup guidance; FE-vs-server doc section. No payload schema change,
no new permissions. Auto-map remains opt-in.
v2.2.0 — Added opt-in GA4 Auto-Map (off by default) and default-on sznaiid 1P cookie.
Reintroduced read_event_data permission. NOTE: read_event_data is consumed even
when GA4 Auto-Map is OFF, because the cookie path always calls getAllEventData()
to read page_location. Added set_cookies/get_cookies permissions for sznaiid only.
GA4 user_data auto-map covers ONLY sha256_* variants — raw PII auto-mapping is
deliberately out of scope (template never hashes; would leak unhashed PII to Seznam).
Added 2 spec-conformance WARN logs (event_url empty, user_ids empty) per S2S docs.
v2.1.2 — Defaults content_type=product when contents is present without content_type.
v2.1.1 — Hotfix for SGTM sandbox compatibility (charCodeAt removed).
All Seznam payload fields are explicit template parameters.
GA4 coupling is opt-in via Auto-Map (introduced v2.2.0); default behavior reads data.* only.
PII hashing is the frontend's responsibility; server-side template is pass-through
(exception: review_email is plain text by design).
