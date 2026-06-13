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
  "displayName": "Seznam SEM Conversion API",
  "categories": [
    "ADVERTISING",
    "CONVERSIONS",
    "MARKETING"
  ],
  "brand": {
    "id": "seznam_sem",
    "displayName": "Seznam SEM"
  },
  "description": "Server-side Google Tag Manager template for sending events to Seznam.cz SEM (Seznam Event Measurement) API. Variable-driven — assign GTM variables to each field.",
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
    "help": "Your S2S SEM ID — visible in Sklik account settings under 'Show advanced settings'. This is a SEPARATE identifier from the SEM ID used by the frontend sul.js script. Required for S2S tracking.",
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
    "help": "Unique event ID for deduplication. To dedupe across frontend and server tracking, the SAME event_id MUST be used on both sides. The FE template (Šabatka) auto-generates 'Purchase__' + order_id for Purchase events when no explicit eventId is provided — to align, set the same value here (or a shared variable) for Purchase events."
  },
  {
    "type": "TEXT",
    "name": "eventTime",
    "displayName": "Event Time (optional)",
    "simpleValueType": true,
    "help": "Event timestamp in milliseconds. Seconds input is auto-upscaled to ms. Falls back to server time if empty."
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
        "help": "Reads inbound GA4 event and pre-fills SEM event_data, contents, event_url, event_id, and hashed sha256_* user_data only. Raw PII (email/phone/name/address) is never auto-forwarded — the template does not hash. Explicit fields below always override (Layer 0 precedence). Off by default to preserve v2.0 GA4 decoupling."
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
        "help": "A GTM variable resolving to a consent_mode object. Supported keys: ad_storage, ad_user_data, ad_personalization, functionality_storage, analytics_storage. Unsupported keys are automatically stripped. Boolean values (true/false) are normalized to 'granted'/'denied'."
      },
      {
        "type": "TEXT",
        "name": "consentString",
        "displayName": "Consent String (IAB TCF)",
        "simpleValueType": true,
        "help": "IAB TCF consent string from your CMP, if available."
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
        "type": "TEXT",
        "name": "userDataObject",
        "displayName": "User Data Object (optional)",
        "simpleValueType": true,
        "help": "A GTM variable resolving to an object with user data fields. SEM-native keys (em, ph, fn, ln, ge, db, ct, region, zp, sr, country, subscription_id, udid) are used as-is. Frontend-template aliases (email, phone, fname, lname, gender / g, birth / birthDate, postalCode / zip, subscription / subscriptionId) are translated to canonical names with a WARN log. All values must already be SHA-256 hashed — the server template never hashes. Individual fields below override keys from this object."
      },
      {
        "type": "TEXT",
        "name": "sid",
        "displayName": "SID (Seznam Identity)",
        "simpleValueType": true,
        "help": "Seznam SID cookie value — primary user identifier for S2S. Obtain via window.sznIVA.IS.getIdentity('sid') after loading sul.js. Forward to SGTM as a GTM variable."
      },
      {
        "type": "TEXT",
        "name": "userEmail",
        "displayName": "Email (em)",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of the normalized email (lowercase + trim). Hashing must be done on the frontend — the server-side template does not hash."
      },
      {
        "type": "TEXT",
        "name": "userPhone",
        "displayName": "Phone (ph)",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of the phone in E.164 format (e.g. +420606666666). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userFirstName",
        "displayName": "First Name (fn)",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of the normalized first name (lowercase + trim). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userLastName",
        "displayName": "Last Name (ln)",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of the normalized last name (lowercase + trim). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userGender",
        "displayName": "Gender (ge)",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of 'm' / 'f' / 'o'. Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userDob",
        "displayName": "Date of Birth (db)",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of YYYYMMDD. Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userCity",
        "displayName": "City (ct)",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of the normalized city (lowercase + trim). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userRegion",
        "displayName": "Region / State (region)",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of the normalized region/state (lowercase + trim). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userZip",
        "displayName": "Postal Code (zp)",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of the trimmed ZIP/postal code. Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userStreet",
        "displayName": "Street (sr)",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of the normalized street (lowercase + trim). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userCountry",
        "displayName": "Country",
        "simpleValueType": true,
        "help": "Expected SHA-256 hash of ISO 3166-1 alpha-2 code (lowercase). Hashing must be done on the frontend."
      },
      {
        "type": "TEXT",
        "name": "userSubscriptionId",
        "displayName": "Subscription ID",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userUdid",
        "displayName": "UDID (udid)",
        "simpleValueType": true,
        "help": "Unique user/device ID (cookie value from sul.js). Server-side template does not hash this value."
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
        "type": "TEXT",
        "name": "eventDataObject",
        "displayName": "Event Data Object (optional)",
        "simpleValueType": true,
        "help": "A GTM variable resolving to an object with event data fields (currency, value, order_id, etc.). Individual fields below override keys from this object."
      },
      {
        "type": "TEXT",
        "name": "sznaiid",
        "displayName": "sznaiid (click-through ID)",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "currency",
        "displayName": "Currency",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "value",
        "displayName": "Value",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "orderId",
        "displayName": "Order ID",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "contentType",
        "displayName": "Content Type",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "contents",
        "displayName": "Contents (array variable or JSON string)",
        "simpleValueType": true,
        "help": "Assign a GTM variable resolving to an array of SEM-native content objects [{id, quantity, unit_price, content_name, content_category}], or a JSON string in the same shape. When contents is present, content_type is required by SEM; if omitted, this template defaults it to product. No GA4 items mapping is performed — convert upstream."
      },
      {
        "type": "TEXT",
        "name": "deliveryPrice",
        "displayName": "Delivery Price",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "deliveryType",
        "displayName": "Delivery Type",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "paymentType",
        "displayName": "Payment Type",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "otherCosts",
        "displayName": "Other Costs",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "predictedLtv",
        "displayName": "Predicted LTV",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "valueTax",
        "displayName": "Value Tax (value_tax)",
        "simpleValueType": true,
        "help": "Tax portion of value. Numeric."
      },
      {
        "type": "TEXT",
        "name": "reviewEmail",
        "displayName": "Review Email (review_email, UNHASHED)",
        "simpleValueType": true,
        "help": "Zboží.cz satisfaction survey email. MUST be sent as plain text, NOT hashed. Only send with user consent."
      },
      {
        "type": "TEXT",
        "name": "productIds",
        "displayName": "Product IDs (product_ids, array)",
        "simpleValueType": true,
        "help": "GTM variable resolving to an array of Zboží.cz product IDs (non-negative integers), or JSON string. Non-integer or negative entries are skipped with a warning."
      },
      {
        "type": "TEXT",
        "name": "goodsIntention",
        "displayName": "Goods Intention (goods_intention)",
        "simpleValueType": true,
        "help": "User intent weight. Numeric."
      },
      {
        "type": "TEXT",
        "name": "goodsPhase",
        "displayName": "Goods Phase (goods_phase)",
        "simpleValueType": true,
        "help": "User interest phase. Integer — non-integer values are passed through with a warning."
      },
      {
        "type": "TEXT",
        "name": "searchString",
        "displayName": "Search String (search_string)",
        "simpleValueType": true,
        "help": "Search query text (e.g. for Search event)."
      },
      {
        "type": "CHECKBOX",
        "name": "statusEnabled",
        "checkboxText": "Include status field",
        "simpleValueType": true,
        "defaultValue": false,
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
        "help": "Returns success to GTM immediately without waiting for the API response. Warning: 4xx/5xx responses are logged as errors but GTM still reports success. Disable for higher observability during rollout or for critical conversion tags."
      },
      {
        "type": "CHECKBOX",
        "name": "strictEventValidation",
        "checkboxText": "Strict Event Validation",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "When enabled, unknown event names and invalid JSON in object/array fields cause the tag to fail (and call gtmOnFailure) instead of just logging. Recommended for production hardening. When disabled, such issues are logged but the tag reports success."
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
        "help": "Catch-all override table for user data fields. Overrides both the object variable and individual fields above."
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
        "help": "Catch-all override table for event data fields. Values for known numeric keys (value, value_tax, delivery_price, other_costs, predicted_ltv, goods_intention, goods_phase) are auto-coerced to numbers."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const JSON = require('JSON');
const Math = require('Math');
const Promise = require('Promise');
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

const NUMERIC_KEYS = [
  'value', 'value_tax', 'delivery_price', 'other_costs',
  'predicted_ltv', 'goods_intention', 'goods_phase'
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
// (value: value/revenue/totalWithoutVat/sum-of-contents; order_id: transaction_id/id/orderNo).
const GA4_EVENT_DATA_MAP = {
  currency: 'currency',
  tax: 'value_tax',
  shipping: 'delivery_price',
  payment_type: 'payment_type',
  shipping_tier: 'delivery_type',
  search_term: 'search_string'
};

const traceId = getRequestHeader('trace-id');

// Auto-map: gather GA4-derived values once at top-level. Returns a `blank` shape when
// enableGa4AutoMap=false, so downstream code can always read ga4.* without null-checks.
const ga4 = extractFromEventData(data);

const resolvedEventName = data.eventNameSelect === 'from_variable'
  ? data.eventNameFromVariable
  : (data.eventNameSelect === 'auto' ? ga4.resolvedEventName : data.eventNameSelect);

const apiUrl = 'https://sem.seznam.cz/rtgconv';

// Seznam telemetry: `api.version` tracks the integration client version (bump on contract/behavior changes).
// `api.template_version` tracks our CHANGELOG release version. These are independent of the
// GTM ___INFO___.version field, which is a GTM-internal stability flag constrained to 0 or 1.
const API_CLIENT_VERSION = '1';
const TEMPLATE_VERSION = '2.2.1';

// Parse JSON object/array fields once, up-front. `validate` decides severity, `buildPayload` consumes values.
const parsed = {
  consent:    parseJsonObjectField('consentModeObject', data.consentModeObject),
  userData:   parseJsonObjectField('userDataObject',    data.userDataObject),
  eventData:  parseJsonObjectField('eventDataObject',   data.eventDataObject),
  contents:   parseJsonArray('contents',   data.contents),
  productIds: parseJsonArray('productIds', data.productIds)
};

// Preflight validation
const validationError = validate(data, parsed, ga4);
if (validationError) {
  logToConsole('Seznam SEM [ERROR]: ' + validationError +
    ' | event=' + resolvedEventName + ' | trace=' + traceId);
  logToBigQuery({ url: apiUrl }, { body: validationError });
  data.gtmOnFailure();
  return;
}

// Build and send
const payload = buildPayload(data, parsed);

log({
  Name: 'Seznam SEM',
  Type: 'Request',
  TraceId: traceId,
  EventName: resolvedEventName,
  RequestMethod: 'POST',
  RequestUrl: apiUrl,
  RequestBody: payload
});

sendHttpRequest(
  apiUrl,
  {
    headers: {
      'content-type': 'application/json',
      'X-Client-Id': 'gtm-server-template-seznam-sem',
      'X-Client-Version': TEMPLATE_VERSION
    },
    method: 'POST'
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
}).catch(function() {
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

function validate(data, parsed, ga4) {
  if (!resolvedEventName) return 'eventName is required';
  if (!data.semId) return 'semId is required';

  // sem_id shape check: non-empty 24-character string.
  // Full pattern `^[0-9a-z]{24}$` is enforced server-side — a stricter local charset check
  // would need sandbox-safe string primitives we cannot verify without deploying.
  if (!isValidSemId(data.semId)) {
    var semIdMsg = 'semId must be a non-empty 24-character string; expected server-side pattern is ^[0-9a-z]{24}$';
    if (data.strictEventValidation) {
      return semIdMsg;
    }
    logToConsole('Seznam SEM [WARN]: ' + semIdMsg + ' | semId=' + data.semId + ' | trace=' + traceId);
  }

  // Event name allowlist check
  var isKnown = false;
  for (var i = 0; i < ALLOWED_EVENTS.length; i++) {
    if (ALLOWED_EVENTS[i] === resolvedEventName) {
      isKnown = true;
      break;
    }
  }
  if (!isKnown) {
    var msg = 'Unknown event name: ' + resolvedEventName;
    if (data.strictEventValidation) {
      return msg;
    }
    logToConsole('Seznam SEM [WARN]: ' + msg + ' | trace=' + traceId);
  }

  // JSON parse errors: consent is always a WARN (optional field);
  // userData/eventData/contents fail under strictEventValidation, WARN otherwise.
  if (parsed.consent.error) {
    logToConsole('Seznam SEM [WARN]: ' + parsed.consent.error + ' | trace=' + traceId);
  }
  var fatalFields = [
    { result: parsed.userData,   label: 'userDataObject' },
    { result: parsed.eventData,  label: 'eventDataObject' },
    { result: parsed.contents,   label: 'contents' },
    { result: parsed.productIds, label: 'productIds' }
  ];
  for (var f = 0; f < fatalFields.length; f++) {
    var entry = fatalFields[f];
    if (entry.result.error) {
      if (data.strictEventValidation) {
        return entry.result.error;
      }
      logToConsole('Seznam SEM [ERROR]: ' + entry.result.error + ' | trace=' + traceId);
    }
  }

  // Purchase-specific required fields (per rtgconv.json: value, currency, order_id).
  // `contents` is recommended for retargeting/attribution but not required by the schema.
  // GA4 auto-mapped values count toward satisfying these requirements — otherwise
  // a Purchase event with all fields auto-filled from GA4 would falsely fail validation.
  if (resolvedEventName === 'Purchase') {
    var missing = [];
    var effectiveOrderId = data.orderId || ga4.eventData.order_id;
    var effectiveCurrency = data.currency || ga4.eventData.currency;
    var hasManualValue = data.value !== undefined && data.value !== null && data.value !== '';
    var effectiveValue = hasManualValue ? data.value : ga4.eventData.value;
    if (!effectiveOrderId) missing.push('orderId');
    if (!effectiveCurrency) missing.push('currency');
    if (effectiveValue === undefined || effectiveValue === null || effectiveValue === '') missing.push('value');
    if (missing.length > 0) {
      return 'Purchase requires: ' + missing.join(', ');
    }
    if (!data.contents && !ga4.contents) {
      logToConsole('Seznam SEM [WARN]: Purchase without contents is accepted by the API but strongly recommended for retargeting/attribution | trace=' + traceId);
    }
  }

  return undefined;
}

/*******************************************************************************
 * GA4 Auto-Map (opt-in)
 ******************************************************************************/

// Sandbox-safe NaN-detection: NaN !== NaN is the canonical NaN test.
function isFiniteNumber(n) {
  return n !== undefined && n !== null && n === n;
}

// FE-parity helper: returns first defined value from candidates array, optionally
// coerced to a target type. undefined, null, '', and values that fail numeric
// coercion (NaN) are SKIPPED so fallback candidates can be tried.
function getFirstValue(candidates, targetType) {
  for (var i = 0; i < candidates.length; i++) {
    var v = candidates[i];
    if (v === undefined || v === null || v === '') continue;
    if (targetType === 'string') return '' + v;
    if (targetType === 'number') {
      var num = makeNumber(v);
      if (isFiniteNumber(num)) return num;
      continue;
    }
    if (targetType === 'integer') {
      var n = makeNumber(v);
      if (isFiniteNumber(n)) return Math.floor(n);
      continue;
    }
    return v;
  }
  return undefined;
}

// FE-parity helper: round to 2 decimal places. Returns undefined for invalid
// input so callers don't accidentally forward a non-number to the wire
// (JSON.stringify drops undefined keys).
function roundTo2(n) {
  if (n === undefined || n === null) return undefined;
  var num = makeNumber(n);
  if (!isFiniteNumber(num)) return undefined;
  return Math.round(num * 100) / 100;
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

function extractFromEventData(data) {
  var blank = { eventData: {}, userData: {}, contents: null, eventUrl: '', eventId: '', resolvedEventName: '' };
  if (!data.enableGa4AutoMap) return blank;
  var ev = getAllEventData();
  if (getType(ev) !== 'object') return blank;

  var out = { eventData: {}, userData: {}, contents: null, eventUrl: '', eventId: '', resolvedEventName: '' };

  // event_url / event_id are always extracted when auto-map is on — they are
  // top-level payload fields, not gated by the per-section sub-toggles.
  if (ev.page_location) out.eventUrl = ev.page_location;
  if (ev.event_id) out.eventId = ev.event_id;
  else if (ev.transaction_id) out.eventId = ev.transaction_id;

  if (data.autoMapEventName && ev.event_name) {
    if (GA4_EVENT_NAME_MAP.hasOwnProperty(ev.event_name)) {
      out.resolvedEventName = GA4_EVENT_NAME_MAP[ev.event_name];
    } else {
      logToConsole('Seznam SEM [WARN]: GA4 event ' + ev.event_name +
        ' has no SEM mapping | trace=' + traceId);
    }
  }

  // Explicit-false check: defaultValue=true may not hydrate into existing instances
  // on template upgrade. Treat undefined as default ON when master toggle is enabled.
  if (data.autoMapEventData !== false) {
    // Static 1:1 fields (currency, tax→value_tax, shipping→delivery_price, etc.)
    for (var k in GA4_EVENT_DATA_MAP) {
      if (GA4_EVENT_DATA_MAP.hasOwnProperty(k) && ev.hasOwnProperty(k) &&
          ev[k] !== undefined && ev[k] !== null && ev[k] !== '') {
        out.eventData[GA4_EVENT_DATA_MAP[k]] = ev[k];
      }
    }

    // Multi-source order_id: transaction_id (GA4 standard) || id || orderNo (Shoptet).
    var effectiveOrderId = getFirstValue([ev.transaction_id, ev.id, ev.orderNo], 'string');
    if (effectiveOrderId) out.eventData.order_id = effectiveOrderId;

    // Items first (needed for sum-of-contents value fallback below).
    if (getType(ev.items) === 'array' && ev.items.length > 0) {
      var skipped = 0;
      var contents = [];
      for (var i = 0; i < ev.items.length; i++) {
        var it = ev.items[i];
        if (!it) { skipped++; continue; }
        // Multi-source item id: item_id (GA4 EE) || id (Shoptet/legacy).
        var itemId = getFirstValue([it.item_id, it.id], 'string');
        if (!itemId) { skipped++; continue; }
        var c = { id: itemId };

        var itemName = getFirstValue([it.item_name, it.name], 'string');
        if (itemName) c.content_name = itemName;

        // Multi-source unit_price: price || priceWithVat || fullPrice.
        var price = getFirstValue([it.price, it.priceWithVat, it.fullPrice], 'number');
        if (price !== undefined) {
          var rounded = roundTo2(price);
          if (rounded !== undefined) c.unit_price = rounded;
        }

        // Quantity defaults to 1 when missing or non-numeric.
        c.quantity = getFirstValue([it.quantity, 1], 'integer');

        var cat = buildItemCategory(it);
        if (cat) c.content_category = cat;

        contents.push(c);
      }
      if (contents.length > 0) out.contents = contents;
      if (skipped > 0) {
        logToConsole('Seznam SEM [WARN]: ' + skipped +
          ' GA4 items skipped (missing item_id) | trace=' + traceId);
      }
    }

    // Multi-source value: value (GA4 standard) || revenue || totalWithoutVat.
    // If still undefined and contents are auto-mapped, sum unit_price * quantity.
    // sum=0 is a legitimate value (matches validate()'s Purchase check that allows 0).
    var effectiveValue = getFirstValue([ev.value, ev.revenue, ev.totalWithoutVat], 'number');
    if (effectiveValue === undefined && out.contents) {
      var sum = 0;
      var summed = false;
      for (var ci = 0; ci < out.contents.length; ci++) {
        var contItem = out.contents[ci];
        if (contItem.unit_price !== undefined && contItem.quantity !== undefined) {
          sum += contItem.unit_price * contItem.quantity;
          summed = true;
        }
      }
      if (summed) effectiveValue = sum;
    }
    if (effectiveValue !== undefined) {
      var roundedValue = roundTo2(effectiveValue);
      if (roundedValue !== undefined) out.eventData.value = roundedValue;
    }
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
function extractSznaiidFromUrl() {
  var ev = getAllEventData();
  var pageLoc = (getType(ev) === 'object' && ev.page_location) ? ev.page_location : '';
  if (pageLoc && pageLoc.lastIndexOf('https://gtm-msr.appspot.com/', 0) === 0) return '';
  return extractFromSingleUrl(pageLoc) ||
         extractFromSingleUrl(getRequestHeader('referer')) ||
         '';
}

// Resolves the sznaiid value to inject into payload from one of three sources,
// in order: cookie (if persistence enabled and cookie exists), URL (always tried),
// returning '' if none.
//
// Side effect: when persistSznaiidCookie=true AND a fresh sznaiid is in the URL,
// writes the cookie according to first_touch / last_touch mode.
//
// IMPORTANT: when persistSznaiidCookie=false, no cookie is read or written —
// but URL-extracted sznaiid is STILL returned and injected into event_data.sznaiid.
// Disabling cookie persistence does not disable URL-based attribution capture.
function resolveSznaiidFromCookieOrUrl() {
  var fromUrl = extractSznaiidFromUrl();
  // Explicit-false check: GTM may not hydrate the new parameter's defaultValue=true
  // into existing tag instances on template upgrade. Treat undefined as default ON.
  if (data.persistSznaiidCookie === false) return fromUrl || '';

  var cookieVals = getCookieValues('sznaiid');
  var existing = (getType(cookieVals) === 'array' && cookieVals.length > 0) ? cookieVals[0] : '';

  var maxAge = makeNumber(data.sznaiidCookieMaxAge);
  if (!maxAge || maxAge <= 0) maxAge = 7776000;

  var shouldWrite = !!fromUrl &&
    (data.persistSznaiidCookieMode === 'last_touch' || !existing);

  if (shouldWrite) {
    setCookie('sznaiid', fromUrl, {
      domain: 'auto',
      path: '/',
      samesite: 'Lax',
      secure: true,
      'max-age': maxAge,
      HttpOnly: false
    });
    return fromUrl;
  }
  return existing || fromUrl || '';
}

/*******************************************************************************
 * Payload builders
 ******************************************************************************/

function buildPayload(data, parsed) {
  var eventTime = normalizeEventTime(data.eventTime);
  var eventUrl = data.eventUrl || ga4.eventUrl || getRequestHeader('referer') || '';

  // Spec-conformance WARN: docs mark event_url as required.
  if (!eventUrl) {
    logToConsole('Seznam SEM [WARN]: event_url is empty (no eventUrl, ga4.eventUrl, or referer); ' +
      'docs mark it required | trace=' + traceId);
  }

  var payload = {
    event_name: resolvedEventName,
    schema_version: 'v2',
    event_type: 'rtgconv',
    event_time: eventTime,
    event_source: data.eventSource || 'web',
    event_url: eventUrl,
    event_data: buildEventData(data, parsed.eventData.value, parsed.contents.value, parsed.productIds.value),
    api: {
      name: 'gtm-server-template',
      version: API_CLIENT_VERSION,
      template_version: TEMPLATE_VERSION
    }
  };

  addIfPresent(payload, 'event_id', data.eventId || ga4.eventId);

  var consentMode = buildConsentMode(parsed.consent.value);
  if (hasProperties(consentMode)) {
    payload.consent_mode = consentMode;
  }

  addIfPresent(payload, 'consent_string', data.consentString);

  var userData = buildUserData(data, parsed.userData.value);
  if (hasProperties(userData)) {
    payload.user_ids = { user_data: userData };
  } else {
    // Spec-conformance WARN: docs mark user_ids as required.
    logToConsole('Seznam SEM [WARN]: payload has no user_ids.user_data ' +
      '(no sid/udid/hashed-PII present); Seznam may reject or down-rank | trace=' + traceId);
  }

  if (data.sendS2sHeaders &&
      consentMode.ad_storage === 'granted' &&
      consentMode.ad_user_data === 'granted') {
    var s2sHeaders = buildS2sHeaders();
    if (hasProperties(s2sHeaders)) {
      payload.s2s_headers = s2sHeaders;
    }
  }

  return payload;
}

function normalizeEventTime(rawValue) {
  if (!rawValue && rawValue !== 0) {
    return getTimestampMillis();
  }
  var num = makeNumber(rawValue);
  if (!num && num !== 0) {
    logToConsole('Seznam SEM [WARN]: eventTime is not numeric, using server time | trace=' + traceId);
    return getTimestampMillis();
  }
  // Auto-detect seconds vs ms: values < 10000000000 (year 2286 in seconds) are seconds, upscale to ms.
  if (num < 10000000000) {
    return num * 1000;
  }
  return num;
}

function buildConsentMode(parsedConsent) {
  var ALLOWED_CONSENT_KEYS = [
    'ad_storage', 'ad_user_data', 'ad_personalization',
    'functionality_storage', 'analytics_storage'
  ];

  var raw = parsedConsent || {};

  // Keep only supported keys and normalize booleans
  var consent = {};
  for (var i = 0; i < ALLOWED_CONSENT_KEYS.length; i++) {
    var key = ALLOWED_CONSENT_KEYS[i];
    if (raw.hasOwnProperty(key)) {
      var val = raw[key];
      if (val === true) val = 'granted';
      else if (val === false) val = 'denied';
      consent[key] = val;
    }
  }
  return consent;
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

// Local helper: treats undefined, null, and '' as "not defined".
// Used for alias precedence ("canonical wins when non-empty").
function isUserDataDefined(v) {
  return v !== undefined && v !== null && v !== '';
}

// Maps FE-template alias keys → canonical SEM wire keys.
// Use an ordered ARRAY (not an object) because order matters when multiple
// aliases resolve to the same canonical (e.g. gender vs g): the entry listed
// FIRST wins. Object iteration order in the GTM sandbox is "should-be-stable"
// but an explicit array removes the should.
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
// - Canonical wins when non-empty (uses isUserDataDefined).
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
    if (!isUserDataDefined(aliasVal)) continue;
    logToConsole('Seznam SEM [WARN]: userDataObject.' + entry.alias +
      ' is a frontend-template alias - prefer canonical key "' + entry.canonical +
      '" for clarity | trace=' + traceId);
    if (!isUserDataDefined(out[entry.canonical])) {
      out[entry.canonical] = aliasVal;
    }
  }

  return out;
}

function buildUserData(data, parsedUserDataObject) {
  var userData = {};

  // Layer 0: GA4 auto-mapped sha256_* fields (no-op when auto-map disabled).
  mergeObject(userData, ga4.userData);

  // Layer 1: object variable, with FE-template alias normalization.
  if (parsedUserDataObject) {
    mergeObject(userData, normalizeUserDataObject(parsedUserDataObject));
  }

  // Layer 2: individual fields
  addIfPresent(userData, 'sid', data.sid);
  addIfPresent(userData, 'em', data.userEmail);
  addIfPresent(userData, 'ph', data.userPhone);
  addIfPresent(userData, 'fn', data.userFirstName);
  addIfPresent(userData, 'ln', data.userLastName);
  addIfPresent(userData, 'ge', data.userGender);
  addIfPresent(userData, 'db', data.userDob);
  addIfPresent(userData, 'ct', data.userCity);
  // `userState` retained as deprecated runtime fallback (UI renamed to `userRegion`, wire key `region`).
  addIfPresent(userData, 'region', data.userRegion || data.userState);
  addIfPresent(userData, 'zp', data.userZip);
  addIfPresent(userData, 'sr', data.userStreet);
  addIfPresent(userData, 'country', data.userCountry);
  addIfPresent(userData, 'subscription_id', data.userSubscriptionId);
  addIfPresent(userData, 'udid', data.userUdid);

  // Layer 3: override table
  applyOverrides(userData, data.userDataOverrides);

  return userData;
}

function buildEventData(data, parsedEventDataObject, parsedContents, parsedProductIds) {
  var ed = {};

  // Layer 0: GA4 auto-mapped fields (no-op when auto-map disabled).
  mergeObject(ed, ga4.eventData);

  // Layer 1: object variable
  if (parsedEventDataObject) {
    mergeObject(ed, parsedEventDataObject);
  }

  // Layer 1b: sznaiid fallback from cookie / URL.
  // Manual data.sznaiid (Layer 2 below) overrides this.
  var cookieSznaiid = resolveSznaiidFromCookieOrUrl();
  if (cookieSznaiid && !ed.sznaiid) ed.sznaiid = cookieSznaiid;

  // Always set sem_id
  ed.sem_id = data.semId;

  // Layer 2: individual fields
  addIfPresent(ed, 'sznaiid', data.sznaiid);
  addIfPresent(ed, 'currency', data.currency);
  if (data.currency && data.currency !== 'CZK') {
    logToConsole('Seznam SEM [WARN]: currency=' + data.currency +
      ' - Seznam SEM currently supports only CZK | trace=' + traceId);
  }
  addIfNumber(ed, 'value', data.value);
  addIfNumber(ed, 'value_tax', data.valueTax);
  addIfPresent(ed, 'order_id', data.orderId);
  addIfPresent(ed, 'content_type', data.contentType);
  addIfNumber(ed, 'delivery_price', data.deliveryPrice);
  addIfPresent(ed, 'delivery_type', data.deliveryType);
  addIfPresent(ed, 'payment_type', data.paymentType);
  addIfNumber(ed, 'other_costs', data.otherCosts);
  addIfNumber(ed, 'predicted_ltv', data.predictedLtv);
  addIfNumber(ed, 'goods_intention', data.goodsIntention);
  addIfPresent(ed, 'search_string', data.searchString);
  addIfPresent(ed, 'review_email', data.reviewEmail); // NOT hashed - intentional (Zbozi.cz survey).

  // goods_phase: schema says integer; pass-through but warn for non-integers.
  if (data.goodsPhase !== undefined && data.goodsPhase !== null && data.goodsPhase !== '') {
    var phase = makeNumber(data.goodsPhase);
    ed.goods_phase = phase;
    if (!isValidInteger(phase)) {
      logToConsole('Seznam SEM [WARN]: goods_phase=' + data.goodsPhase +
        ' is not an integer | trace=' + traceId);
    }
  }

  // status: boolean; `statusEnabled` flag distinguishes "not set" from false.
  if (data.statusEnabled) {
    ed.status = (data.status === 'true' || data.status === true);
  }

  // product_ids: integers >= 0; invalid entries skipped with warning.
  var validProductIds = coerceIntegerArray(parsedProductIds, 'productIds');
  if (validProductIds) {
    ed.product_ids = validProductIds;
  }

  // Contents: already parsed upstream. Empty array is schema-valid and passed through.
  // GA4 auto-mapped contents act as Layer 0 fallback when no manual contents provided.
  if (parsedContents !== null && parsedContents !== undefined) {
    ed.contents = parsedContents;
  } else if (ga4.contents) {
    ed.contents = ga4.contents;
  }

  // Layer 3: override table (with typed coercion for numeric keys)
  applyOverrides(ed, data.eventDataOverrides);

  // SEM requires content_type whenever contents is present. Checkout/cart payloads
  // with product arrays should use product; explicit values still win.
  if (ed.contents !== undefined && ed.contents !== null && !ed.content_type) {
    ed.content_type = 'product';
    logToConsole('Seznam SEM [WARN]: contents present without content_type; defaulting content_type=product | trace=' + traceId);
  }

  // FE-parity convenience: CompleteRegistration defaults to status=true when
  // nothing in any layer has set it. Fires AFTER all layers (object → individual → overrides).
  // CAVEAT (override table behavior): applyOverrides() drops rows where row.value is
  // falsy AND does not boolean-coerce. Consequences for this default:
  //   - Override row with row.value = "false" (string) suppresses the default but is
  //     sent as the STRING "false", not boolean false.
  //   - Override row with row.value = false (boolean) is dropped entirely → default fires.
  // To explicitly send status:false to Seznam, use eventDataObject (Layer 1) or the
  // statusEnabled+status template fields (Layer 2) — both are boolean-correct.
  if (resolvedEventName === 'CompleteRegistration' && ed.status === undefined) {
    ed.status = true;
  }

  return ed;
}

/*******************************************************************************
 * Shared utilities
 ******************************************************************************/

// Parse a field that may be an object, a JSON string, or empty. Returns {value, error}.
// Callers decide severity (WARN vs. fail) based on strictEventValidation.
// Note: sandboxed JS does not support try/catch, but JSON.parse returns undefined on invalid input.
function parseJsonObjectField(fieldName, rawValue) {
  if (!rawValue) return { value: null, error: null };
  if (getType(rawValue) === 'object') return { value: rawValue, error: null };
  if (getType(rawValue) === 'string') {
    var parsed = JSON.parse(rawValue);
    if (parsed === undefined) {
      return { value: null, error: 'invalid JSON in ' + fieldName };
    }
    if (getType(parsed) === 'object') return { value: parsed, error: null };
    return { value: null, error: fieldName + ' is not a JSON object' };
  }
  return { value: null, error: fieldName + ' has unsupported type: ' + getType(rawValue) };
}

// Parse a field that may be an array, a JSON string of an array, or empty. Returns {value, error}.
function parseJsonArray(fieldName, rawValue) {
  if (!rawValue) return { value: null, error: null };
  if (getType(rawValue) === 'array') return { value: rawValue, error: null };
  if (getType(rawValue) === 'string') {
    var parsed = JSON.parse(rawValue);
    if (parsed === undefined) {
      return { value: null, error: 'invalid JSON in ' + fieldName };
    }
    if (getType(parsed) === 'array') return { value: parsed, error: null };
    return { value: null, error: fieldName + ' is not a JSON array' };
  }
  return { value: null, error: fieldName + ' has unsupported type: ' + getType(rawValue) };
}

function addIfPresent(obj, key, value) {
  if (value) {
    obj[key] = value;
  }
}

// NaN fails all comparisons, so `n === Math.floor(n)` returns false for NaN.
function isValidInteger(n) {
  return n !== undefined && n !== null && n === Math.floor(n);
}

// Local shape check only: non-empty 24-character string.
// Full charset pattern ^[0-9a-z]{24}$ is enforced server-side. A stricter local
// charset check (charCodeAt / charAt+indexOf) is avoided here: GTM sandbox
// dropped charCodeAt in deploy, and we are not willing to assume other
// String.prototype methods without proof that they work in this sandbox.
function isValidSemId(id) {
  if (!id) return false;
  return getType(id) === 'string' && id.length === 24;
}

function coerceIntegerArray(arr, fieldName) {
  if (!arr) return undefined;
  var out = [];
  for (var i = 0; i < arr.length; i++) {
    var n = makeNumber(arr[i]);
    if (!isValidInteger(n) || n < 0) {
      logToConsole('Seznam SEM [WARN]: ' + fieldName + '[' + i + ']=' + arr[i] +
        ' is not a non-negative integer, skipping | trace=' + traceId);
      continue;
    }
    out.push(n);
  }
  return out.length > 0 ? out : undefined;
}

function addIfNumber(obj, key, value) {
  if (value !== undefined && value !== null && value !== '') {
    obj[key] = makeNumber(value);
  }
}

function applyOverrides(obj, table) {
  if (!table) return;
  for (var i = 0; i < table.length; i++) {
    var row = table[i];
    if (row.name && row.value) {
      var isNumeric = false;
      for (var j = 0; j < NUMERIC_KEYS.length; j++) {
        if (NUMERIC_KEYS[j] === row.name) {
          isNumeric = true;
          break;
        }
      }
      obj[row.name] = isNumeric ? makeNumber(row.value) : row.value;
    }
  }
}

function mergeObject(target, source) {
  for (var key in source) {
    if (source.hasOwnProperty(key)) {
      target[key] = source[key];
    }
  }
}

// Object.keys is not available in sandboxed JS, so we iterate manually
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
  logToConsole('Seznam SEM [ERROR]: HTTP ' + result.statusCode +
    ' | event=' + resolvedEventName +
    ' | semId=' + data.semId +
    ' | trace=' + traceId +
    ' | body=' + bodySnippet);
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
              { "type": 1, "string": "sznaiid" }
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

- name: Unknown event + loose still sends (optimistic - synchronous gtmOnSuccess)
  code: |-
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'from_variable',
      eventNameFromVariable: 'Foo',
      semId: 'abcdefghijklmnopqrstuvwx',
      strictEventValidation: false,
      useOptimisticScenario: true
    });
    // Optimistic mode calls gtmOnSuccess synchronously (before the HTTP response).
    assertApi('gtmOnSuccess').wasCalled();
    assertApi('sendHttpRequest').wasCalled();

- name: Invalid JSON in userDataObject fails under strict (synchronous validation)
  code: |-
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      userDataObject: '{not json',
      strictEventValidation: true
    });
    assertApi('gtmOnFailure').wasCalled();

- name: Invalid JSON in eventDataObject fails under strict (synchronous validation)
  code: |-
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      eventDataObject: '{not json',
      strictEventValidation: true
    });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();

- name: Invalid JSON in contents fails under strict (synchronous validation)
  code: |-
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      contents: '{not json',
      strictEventValidation: true
    });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();

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
      userUdid: 'abc123',
      useOptimisticScenario: false
    });
    assertThat(capturedBody.user_ids.user_data.udid).isEqualTo('abc123');

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
    // Local check is now length-only (24 chars). 'BAD' = 3 chars fails locally.
    // Full ^[0-9a-z]{24}$ pattern is enforced server-side.
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'BAD',
      strictEventValidation: true
    });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();

- name: Short semId + loose still sends with warning (length check)
  code: |-
    // Local check is now length-only (24 chars). 'BAD' = 3 chars triggers WARN but hit still goes out.
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'BAD',
      strictEventValidation: false,
      useOptimisticScenario: true
    });
    assertApi('sendHttpRequest').wasCalled();

- name: SemId off pattern 24 chars does not crash regression hotfix v211
  code: |-
    // Hotfix regression: the old charCodeAt-based charset check crashed with TypeError
    // in the SGTM sandbox. Local validation now only checks length == 24. An off-pattern
    // 24-char string passes local validation; backend response (e.g. 400) is asserted
    // irrelevant here — we only verify the tag did not crash and attempted the request.
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 400 })));
    runCode({
      eventNameSelect: 'PageView',
      semId: 'ABCDEFGHIJKLMNOPQRSTUVWX',
      strictEventValidation: false,
      useOptimisticScenario: true
    });
    assertApi('sendHttpRequest').wasCalled();

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
    mock('setCookie', (name, value, options) => { capturedCookieWrite = { name, value, options }; });
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
    assertThat(capturedCookieWrite.options.samesite).isEqualTo('Lax');
    assertThat(capturedCookieWrite.options.secure).isEqualTo(true);

- name: sznaiid cookie NOT overwritten on second event (first_touch) (v22 cookie-3)
  code: |-
    let setCookieCalled = false;
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    mock('getAllEventData', () => ({ page_location: 'https://shop.example/lp?sznaiid=NEWVAL' }));
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['EXISTING'] : []);
    mock('setCookie', () => { setCookieCalled = true; });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      persistSznaiidCookie: true,
      persistSznaiidCookieMode: 'first_touch',
      sznaiidCookieMaxAge: '7776000',
      useOptimisticScenario: false
    });
    assertThat(setCookieCalled).isEqualTo(false);

- name: sznaiid cookie overwritten under last_touch mode (v22 cookie-4)
  code: |-
    let capturedCookieWrite;
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    mock('getAllEventData', () => ({ page_location: 'https://shop.example/lp?sznaiid=NEWVAL' }));
    mock('getCookieValues', (name) => name === 'sznaiid' ? ['EXISTING'] : []);
    mock('setCookie', (name, value, options) => { capturedCookieWrite = { name, value, options }; });
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

- name: Outgoing request includes X-Client-Id and X-Client-Version headers (v221 headers-1)
  code: |-
    let capturedOpts;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedOpts = opts;
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    runCode({
      eventNameSelect: 'PageView',
      semId: 'abcdefghijklmnopqrstuvwx',
      useOptimisticScenario: false
    });
    assertThat(capturedOpts.headers['X-Client-Id']).isEqualTo('gtm-server-template-seznam-sem');
    assertThat(capturedOpts.headers['X-Client-Version']).isEqualTo('2.2.1');

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

- name: Auto-map value falls back to sum of contents when no value source (v221 automap-10)
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
    // 10*2 + 5*1 = 25
    assertThat(capturedBody.event_data.value).isEqualTo(25);

- name: Auto-map value sum of zero-priced contents emits value 0 not undefined (v221 automap-10b)
  code: |-
    let capturedBody;
    mock('sendHttpRequest', (url, opts, body) => {
      capturedBody = JSON.parse(body);
      return Promise.create((r) => r({ statusCode: 200 }));
    });
    // Free items: unit_price 0, quantity 1. Sum is 0, which is a legitimate value.
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
    assertThat(capturedBody.event_data.value).isEqualTo(0);

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

- name: Auto-map quantity defaults to 1 when missing or non-numeric (v221 automap-12)
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
    assertThat(capturedBody.event_data.contents[0].quantity).isEqualTo(1);
    assertThat(capturedBody.event_data.contents[1].quantity).isEqualTo(1);
    assertThat(capturedBody.event_data.contents[2].quantity).isEqualTo(3);

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


___NOTES___

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
