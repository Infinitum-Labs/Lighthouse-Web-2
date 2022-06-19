import { ok, notFound, serverError, badRequest, created, forbidden, response } from 'wix-http-functions';
import wixData from 'wix-data';
import { getSecret } from 'wix-secrets-backend';

// https://infinitumlabsinc.editorx.io/lighthousecloud/_functions/functionName

////////////////////
// TOOLS
////////////////////
const JWT_secret = 'JW'

class Auth {}

class ResponseObject {
  
    ResponseObject(jsonData = {}) {
        this.jsonData = jsonData;
    }
  
    get statusCode() {
        return this.jsonData['body']['status']['code'];
    }

    get statusMsg() {
        return this.jsonData['body']['status']['msg'];
    }

    get jwtString() {
        return this.jsonData['headers']['auth']['jwt'];
    }

    get payload() {
        return this.jsonData['body']['payload'];
    }
  }
  

////////////////////////////////////////
////////////////////////////////////////

////////////////////
// ENDPOINTS
////////////////////

// GET

export function get_test(request) {
    let options = {
        "headers": {
            "Content-Type": "application/json"
        },
        "body": request['headers']
    };
    return ok(options);
}

// POST

// PUT

export function put_testput(request) {
    let options = {
        "headers": {
            "Content-Type": "application/json"
        },
        "body": 'ok'
    };
    return ok(options);
}

// DELETE

////////////////////////////////////////
////////////////////////////////////////
