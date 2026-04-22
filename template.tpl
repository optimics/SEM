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
    "ANALYTICS",
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
      { "value": "custom", "displayValue": "— Custom —" }
    ],
    "simpleValueType": true,
    "defaultValue": "PageView",
    "help": "Select a Seznam event name, or choose Custom to enter your own.",
    "valueValidators": [{ "type": "NON_EMPTY" }]
  },
  {
    "type": "TEXT",
    "name": "eventNameCustom",
    "displayName": "Custom Event Name",
    "simpleValueType": true,
    "help": "Enter a custom event name. Used when 'Custom' is selected above.",
    "enablingConditions": [
      {
        "paramName": "eventNameSelect",
        "paramValue": "custom",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [{ "type": "NON_EMPTY" }]
  },
  {
    "type": "TEXT",
    "name": "semId",
    "displayName": "SEM ID (Sklik Advertiser ID)",
    "simpleValueType": true,
    "help": "Your SEM ID (shop ID in Sklik). Required for tracking.",
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
    "help": "Unique event ID for deduplication. Assign a GTM variable that resolves to the frontend event ID."
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
        "help": "A GTM variable resolving to an object with user data fields (em, ph, fn, ln, etc.). Individual fields below override keys from this object."
      },
      {
        "type": "TEXT",
        "name": "sid",
        "displayName": "SID (Seznam Identity)",
        "simpleValueType": true,
        "help": "Seznam SID cookie value — primary user identifier for S2S. Obtain via window.sznIVA.IS.getIdentity('sid') after loading sem.js. Forward to SGTM as a GTM variable."
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

const traceId = getRequestHeader('trace-id');

const resolvedEventName = data.eventNameSelect === 'custom'
  ? data.eventNameCustom
  : data.eventNameSelect;

const apiUrl = 'https://sem.seznam.cz/rtgconv';

// Seznam telemetry: `api.version` tracks the integration client version (bump on contract/behavior changes).
// `api.template_version` tracks our CHANGELOG release version. These are independent of the
// GTM ___INFO___.version field, which is a GTM-internal stability flag constrained to 0 or 1.
const API_CLIENT_VERSION = '1';
const TEMPLATE_VERSION = '2.1.2';

// Parse JSON object/array fields once, up-front. `validate` decides severity, `buildPayload` consumes values.
const parsed = {
  consent:    parseJsonObjectField('consentModeObject', data.consentModeObject),
  userData:   parseJsonObjectField('userDataObject',    data.userDataObject),
  eventData:  parseJsonObjectField('eventDataObject',   data.eventDataObject),
  contents:   parseJsonArray('contents',   data.contents),
  productIds: parseJsonArray('productIds', data.productIds)
};

// Preflight validation
const validationError = validate(data, parsed);
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
    headers: { 'content-type': 'application/json' },
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

function validate(data, parsed) {
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
  if (resolvedEventName === 'Purchase') {
    var missing = [];
    if (!data.orderId) missing.push('orderId');
    if (!data.currency) missing.push('currency');
    if (data.value === undefined || data.value === null || data.value === '') missing.push('value');
    if (missing.length > 0) {
      return 'Purchase requires: ' + missing.join(', ');
    }
    if (!data.contents) {
      logToConsole('Seznam SEM [WARN]: Purchase without contents is accepted by the API but strongly recommended for retargeting/attribution | trace=' + traceId);
    }
  }

  return undefined;
}

/*******************************************************************************
 * Payload builders
 ******************************************************************************/

function buildPayload(data, parsed) {
  var eventTime = normalizeEventTime(data.eventTime);
  var eventUrl = data.eventUrl || getRequestHeader('referer') || '';

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

  addIfPresent(payload, 'event_id', data.eventId);

  var consentMode = buildConsentMode(parsed.consent.value);
  if (hasProperties(consentMode)) {
    payload.consent_mode = consentMode;
  }

  addIfPresent(payload, 'consent_string', data.consentString);

  var userData = buildUserData(data, parsed.userData.value);
  if (hasProperties(userData)) {
    payload.user_ids = { user_data: userData };
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

function buildUserData(data, parsedUserDataObject) {
  var userData = {};

  // Layer 1: object variable
  if (parsedUserDataObject) {
    mergeObject(userData, parsedUserDataObject);
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

  // Layer 1: object variable
  if (parsedEventDataObject) {
    mergeObject(ed, parsedEventDataObject);
  }

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
  if (parsedContents !== null && parsedContents !== undefined) {
    ed.contents = parsedContents;
  }

  // Layer 3: override table (with typed coercion for numeric keys)
  applyOverrides(ed, data.eventDataOverrides);

  // SEM requires content_type whenever contents is present. Checkout/cart payloads
  // with product arrays should use product; explicit values still win.
  if (ed.contents !== undefined && ed.contents !== null && !ed.content_type) {
    ed.content_type = 'product';
    logToConsole('Seznam SEM [WARN]: contents present without content_type; defaulting content_type=product | trace=' + traceId);
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
      eventNameSelect: 'custom',
      eventNameCustom: 'Foo',
      semId: 'abcdefghijklmnopqrstuvwx',
      strictEventValidation: true
    });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();

- name: Unknown event + loose still sends (optimistic - synchronous gtmOnSuccess)
  code: |-
    mock('sendHttpRequest', () => Promise.create((r) => r({ statusCode: 200 })));
    runCode({
      eventNameSelect: 'custom',
      eventNameCustom: 'Foo',
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


___NOTES___

v2.1.2 — Defaults content_type=product when contents is present without content_type.
v2.1.1 — Hotfix for SGTM sandbox compatibility (charCodeAt removed).
All Seznam payload fields are explicit template parameters.
No GA4 coupling — template reads data.* only.
PII hashing is the frontend's responsibility; server-side template is pass-through
(exception: review_email is plain text by design).
