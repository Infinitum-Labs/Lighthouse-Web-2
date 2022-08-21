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

class Auth {}

class RequestObject {
    jsonData = {
        "headers": {
            "Authorization": "Bearer JWT",
            "slug": ""
        },
        "body": {
            "payload": {}
        }
    };
    constructor(json) {
        this.jsonData.body = json['body'];
        this.jsonData.headers.Authorization = json['headers']['Authorization'];
        this.jsonData.headers.slug = json['slug'];
    }
}

class ResponseObject {
    jsonData = {
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Authorization": "Bearer JWT"
        },
        "body": {
            "status": {
                "code": 200,
                "msg": "OK"
            },
            "payload": {
                "test": true,
            }
        }
    };

}

class Payload {
    static assert(requestObject, key) {
        return (key in requestObject.jsonData.body.payload ? true : new ServerException(400, `Key $key not included in request.`, requestObject));
    }
}

class ServerException {
    statusCode;
    msg;
    info;

    constructor(statusCode, msg, info) {
        this.statusCode = statusCode;
        this.msg = msg;
        this.info = info;
    }
}

////////////////////////////////////////
////////////////////////////////////////

////////////////////
// ENDPOINTS
////////////////////

// GET

export function get_session(request) {
    request = new RequestObject(request);
    var res = new ResponseObject();
    try {
        Payload.assert(request, 'username');
        Payload.assert(request, 'password');
        return ok(res.jsonData);
    } catch (e) {
        res.jsonData.statusCode = e.statusCode;
        res.jsonData.body.err = {
            'msg': e.msg,
            'request': e.request
        }
        return response(res.jsonData);
    }
}

export function get_auth(request) {
    request = new RequestObject(request);
    var response = new ResponseObject();
    response.jsonData.body.payload.test = true;
    return ok(response.jsonData);
}

export function use_test(request) {
    console.log(`test request:${request.path[0]}}`);
    let options = {
        "headers": {
            "Access-Control-Allow-Origin": request.headers.origin,
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Allow-Methods": "GET, POST, PUT, PATCH, DELETE, OPTIONS"
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