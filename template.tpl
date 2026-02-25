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
    "help": "Event timestamp. Accepts seconds or milliseconds (auto-detected). Falls back to server time if empty."
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
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userPhone",
        "displayName": "Phone (ph)",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userFirstName",
        "displayName": "First Name (fn)",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userLastName",
        "displayName": "Last Name (ln)",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userGender",
        "displayName": "Gender (ge)",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userDob",
        "displayName": "Date of Birth (db)",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userCity",
        "displayName": "City (ct)",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userState",
        "displayName": "State (st)",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userZip",
        "displayName": "Postal Code (zp)",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userStreet",
        "displayName": "Street (sr)",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userCountry",
        "displayName": "Country",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "userSubscriptionId",
        "displayName": "Subscription ID",
        "simpleValueType": true
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
        "help": "Assign a GTM variable that resolves to an array of content objects, or provide a JSON string."
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
        "help": "Returns success immediately without waiting for the API response. Recommended to disable during initial rollout."
      },
      {
        "type": "CHECKBOX",
        "name": "strictEventValidation",
        "checkboxText": "Strict Event Validation",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "When enabled, unknown event names cause the tag to fail instead of just logging a warning. Recommended for production hardening."
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
        "help": "Catch-all override table for event data fields. Values for known numeric keys (value, delivery_price, other_costs, predicted_ltv) are auto-coerced to numbers."
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
  'value', 'delivery_price', 'other_costs', 'predicted_ltv'
];

const traceId = getRequestHeader('trace-id');

const resolvedEventName = data.eventNameSelect === 'custom'
  ? data.eventNameCustom
  : data.eventNameSelect;

const apiUrl = 'https://sem.seznam.cz/rtgconv';

// Preflight validation
const validationError = validate(data);
if (validationError) {
  logToConsole('Seznam SEM [ERROR]: ' + validationError +
    ' | event=' + resolvedEventName + ' | trace=' + traceId);
  logToBigQuery({ url: apiUrl }, { body: validationError });
  data.gtmOnFailure();
  return;
}

// Build and send
const payload = buildPayload(data);

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
      logToConsole('Seznam SEM [ERROR]: HTTP ' + result.statusCode +
        ' | event=' + resolvedEventName + ' | trace=' + traceId);
      data.gtmOnFailure();
    }
  } else if (result.statusCode < 200 || result.statusCode >= 300) {
    logToConsole('Seznam SEM [ERROR]: HTTP ' + result.statusCode +
      ' | event=' + resolvedEventName + ' | trace=' + traceId);
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

function validate(data) {
  if (!resolvedEventName) return 'eventName is required';
  if (!data.semId) return 'semId is required';

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

  // Purchase-specific required fields
  if (resolvedEventName === 'Purchase') {
    var missing = [];
    if (!data.orderId) missing.push('orderId');
    if (!data.currency) missing.push('currency');
    if (data.value === undefined || data.value === null || data.value === '') missing.push('value');
    if (!data.contents) missing.push('contents');
    if (missing.length > 0) {
      return 'Purchase requires: ' + missing.join(', ');
    }
  }

  return undefined;
}

/*******************************************************************************
 * Payload builders
 ******************************************************************************/

function buildPayload(data) {
  var eventTime = normalizeEventTime(data.eventTime);
  var eventUrl = data.eventUrl || getRequestHeader('referer') || '';

  var payload = {
    event_name: resolvedEventName,
    schema_version: 'v2',
    event_type: 'rtgconv',
    event_time: eventTime,
    event_source: data.eventSource || 'web',
    event_url: eventUrl,
    event_data: buildEventData(data)
  };

  addIfPresent(payload, 'event_id', data.eventId);

  var consentMode = buildConsentMode(data);
  if (hasProperties(consentMode)) {
    payload.consent_mode = consentMode;
  }

  addIfPresent(payload, 'consent_string', data.consentString);

  var userData = buildUserData(data);
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
    return Math.floor(getTimestampMillis() / 1000);
  }
  var num = makeNumber(rawValue);
  if (!num && num !== 0) {
    logToConsole('Seznam SEM [WARN]: eventTime is not numeric, using server time | trace=' + traceId);
    return Math.floor(getTimestampMillis() / 1000);
  }
  // Auto-detect milliseconds (value > ~2286 in seconds = year 2042)
  if (num > 9999999999) {
    return Math.floor(num / 1000);
  }
  return num;
}

function buildConsentMode(data) {
  var ALLOWED_CONSENT_KEYS = [
    'ad_storage', 'ad_user_data', 'ad_personalization',
    'functionality_storage', 'analytics_storage'
  ];

  var raw = {};
  if (data.consentModeObject) {
    var obj = data.consentModeObject;
    if (getType(obj) === 'string') {
      obj = JSON.parse(obj);
    }
    if (getType(obj) === 'object') {
      mergeObject(raw, obj);
    }
  }

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

function buildUserData(data) {
  var userData = {};

  // Layer 1: object variable
  if (data.userDataObject) {
    var obj = data.userDataObject;
    if (getType(obj) === 'string') {
      obj = JSON.parse(obj);
    }
    if (getType(obj) === 'object') {
      mergeObject(userData, obj);
    }
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
  addIfPresent(userData, 'st', data.userState);
  addIfPresent(userData, 'zp', data.userZip);
  addIfPresent(userData, 'sr', data.userStreet);
  addIfPresent(userData, 'country', data.userCountry);
  addIfPresent(userData, 'subscription_id', data.userSubscriptionId);

  // Layer 3: override table
  applyOverrides(userData, data.userDataOverrides);

  return userData;
}

function buildEventData(data) {
  var ed = {};

  // Layer 1: object variable
  if (data.eventDataObject) {
    var obj = data.eventDataObject;
    if (getType(obj) === 'string') {
      obj = JSON.parse(obj);
    }
    if (getType(obj) === 'object') {
      mergeObject(ed, obj);
    }
  }

  // Always set sem_id
  ed.sem_id = data.semId;

  // Layer 2: individual fields
  addIfPresent(ed, 'sznaiid', data.sznaiid);
  addIfPresent(ed, 'currency', data.currency);
  addIfNumber(ed, 'value', data.value);
  addIfPresent(ed, 'order_id', data.orderId);
  addIfPresent(ed, 'content_type', data.contentType);
  addIfNumber(ed, 'delivery_price', data.deliveryPrice);
  addIfPresent(ed, 'delivery_type', data.deliveryType);
  addIfPresent(ed, 'payment_type', data.paymentType);
  addIfNumber(ed, 'other_costs', data.otherCosts);
  addIfNumber(ed, 'predicted_ltv', data.predictedLtv);

  // Contents — handle array variable or JSON string
  var parsedContents = parseContents(data.contents);
  if (parsedContents) {
    ed.contents = parsedContents;
  }

  // Layer 3: override table (with typed coercion for numeric keys)
  applyOverrides(ed, data.eventDataOverrides);

  return ed;
}

function parseContents(raw) {
  if (!raw) return undefined;
  if (getType(raw) === 'array') return raw;
  if (getType(raw) === 'string') {
    var parsed = JSON.parse(raw);
    if (getType(parsed) === 'array') return parsed;
  }
  return undefined;
}

/*******************************************************************************
 * Shared utilities
 ******************************************************************************/

function addIfPresent(obj, key, value) {
  if (value) {
    obj[key] = value;
  }
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

scenarios: []


___NOTES___

v2.0.0 — Variable-driven redesign.
All Seznam payload fields are explicit template parameters.
No GA4 coupling — template reads data.* only.
