___INFO___

{
  "displayName": "iplytics",
  "description": "",
  "securityGroups": [],
  "id": "cvt_temp_public_id",
  "type": "TAG",
  "version": 1,
  "brand": {
    "displayName": "",
    "id": "brand_dummy"
  },
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___WEB_PERMISSIONS___

[
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
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_referrer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_pixel",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://api.iplytics.io/probe.js*"
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
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_metadata",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Enter your template code here.
var log = require('logToConsole');
log('data =', data);

//general permissions
const queryPermission = require('queryPermission');
const sendPixel = require('sendPixel');
const query = require('queryPermission');
const addEventCallback = require('addEventCallback');
const encodeUriComponent = require('encodeUriComponent');

//collect refferal domains
const getReferrerUrl = require('getReferrerUrl');
let referrer;
if (queryPermission('get_referrer', 'query')) {
  referrer = getReferrerUrl('queryParams');
}
log("refferer", referrer);
//save current url
const getUrl = require('getUrl');
if (query('get_url', 'host', 'gclid')) {
  var hostGclid = getUrl('host', false, null, 'gclid');
}
if (query('get_url', 'path', 'gclid')) {
  var pathGclid = getUrl('path', false, null, 'gclid');
}

if (query('get_url', 'extention', 'gclid')) {
  var extensionGclid = getUrl('extention', false, null, 'gclid');
}

log("actaul host", hostGclid);
log("actaul path", pathGclid);
log("actaul extension", extensionGclid);


// send event callback
addEventCallback(function(containerId, eventData) {
  //endpoint pixel get req
  sendPixel('https://api.iplytics.io/probe.js?' + "host=" + encodeUriComponent(hostGclid) + 		"&path=" + encodeUriComponent(pathGclid) + "&extension=" + encodeUriComponent(extensionGclid) + "&referrer=" + 		encodeUriComponent(referrer) );

});

// Call data.gtmOnSuccess when the tag is finished.
data.gtmOnSuccess();


___NOTES___

Created on 9/15/2019, 7:11:09 PM
