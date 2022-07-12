import { ok, notFound, serverError, badRequest, created, forbidden, response } from 'wix-http-functions';
import wixData from 'wix-data';
import { getSecret } from 'wix-secrets-backend';

// https://infinitumlabsinc.editorx.io/lighthousecloud/_functions/functionName

////////////////////
// TYPES
////////////////////
const Slug = {
	auth: Symbol('auth'),
	get: Symbol('get'),
	put: Symbol('put'),
	delete: Symbol('delete')
}


////////////////////
// TOOLS
////////////////////
const JWT_secret = 'JWT';

class JWT {
    static createPayload(name, userId) {
        return {
            'name': name,
            'userId': userId
        };
    }

    static createHeaders() {
        return {
            'alg': 'RS256',
            'typ': 'JWT'
        };
    }
}

class Auth { }

class RequestObject {
    constructor(json = {}) {
        this.jsonData = json;
    }

    get jwtString() {
        return this.jsonData.headers.auth.jwt;
    }

    get slug() {
        return this.jsonData.headers.auth;
    }

    setSlug(slug) {
        this.jsonData.headers.slug = slug;
    }

    setJwtString(jwtString) {
        this.jsonData.headers.auth.jwt = jwtString;
    }

    setPayload(payload) {
        return this.jsonData.body.payload = payload;
    }
}

class ResponseObject {
    constructor(json = {}) {
        this.jsonData = json;
    }

    get statusCode() {
        return this.jsonData.body.status.code;
    }

    get statusMsg() {
        return this.jsonData.body.status.msg;
    }

    get jwtString() {
        return this.jsonData.headers.auth.jwt;
    }

    get payload() {
        return this.jsonData.body.payload;
    }

}


////////////////////////////////////////
////////////////////////////////////////

////////////////////
// ENDPOINTS
////////////////////

// GET

export function get_auth(request) {
    request = new RequestObject(request);
    var response = new ResponseObject({
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": {
            "payload": {
                "test": true,
            }
        }
    });
    return ok(response.jsonData);
}

export function use_test(request) {
    console.log(`test request:${request.headers.origin}`);
    let options = {
        "headers":{
            "Access-Control-Allow-Origin": request.headers.origin,
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Allow-Headers":
                "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods":
                "GET, POST, PUT, PATCH, DELETE, OPTIONS"
          },
        "body": {
            "payload": {
                "msg": request['headers']
            }
        }
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
        "body": {
            "payload": {
                "test": true,
            }
        }
    };
    return ok(options);
}

// DELETE

////////////////////////////////////////
////////////////////////////////////////
