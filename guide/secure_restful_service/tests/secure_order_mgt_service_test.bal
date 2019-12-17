import ballerina/test;
import ballerina/http;

@test:BeforeSuite
function beforeFunc() {
    // Start the 'order_mgt' service before running the test.
    _ = test:startServices("secure_restful_service");
}

endpoint http:Client clientEPUnauthenticated {
    url:"http://localhost:9090/ordermgt"
};

endpoint http:Client clientEPCounter {
    url:"http://localhost:9090/ordermgt",
    auth: {scheme: "oauth",
        accessToken: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjb3VudGVyIiwiaXNzIjo" +
        "iYmFsbGVyaW5hIiwiZXhwIjoyODE4NDE1MDE5LCJpYXQiOjE1MjQ1NzUwMTksImp0aSI6ImY1YWRlZDUwN" +
        "Tg1YzQ2ZjJiOGNhMjMzZDBjMmEzYzlkIiwiYXVkIjpbImJhbGxlcmluYSIsImJhbGxlcmluYS5vcmciLCJ" +
        "iYWxsZXJpbmEuaW8iXSwic2NvcGUiOiJhZGRfb3JkZXIifQ.Mu1FUEudWMSGEv37F9RABYPPW9j9DmhZJf" +
        "CLbpBTU_S0t5uzol-H2hKnhyBeimJLkDmne48IYgqX7EsQt37OUAR1lrK1_3i8yZHxyuFX3slwIjf65C44" +
        "E5koc9w8GrpRK1FsFsFgqUAuhjmuHkUw_JAjoaktDapD_fsnljlbaT4VFOJTKzYcLEZlEGyhR5Ftw48hSY" +
        "buuROx1Ayi9R1laJNrTt_IZFRn5dn1RmLI42f1uTgA6vCbnX7Mm_gLx5EJhGaQszwpjQBqge6H4wM66PzZ" +
        "-U35a27fVlV_J9mLm3CUAONSx4YMUck729-HIwQXFQY9eUxfotiZwacBexGgmg"
    }
};

endpoint http:Client clientEPAdmin {
    url:"http://localhost:9090/ordermgt",
    auth: {scheme: "oauth",
        accessToken: "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImlzcyI6ImJ" +
        "hbGxlcmluYSIsImV4cCI6MjgxODQxNTAxOSwiaWF0IjoxNTI0NTc1MDE5LCJqdGkiOiJmNWFkZWQ1MDU4" +
        "NWM0NmYyYjhjYTIzM2QwYzJhM2M5ZCIsImF1ZCI6WyJiYWxsZXJpbmEiLCJiYWxsZXJpbmEub3JnIiwiY" +
        "mFsbGVyaW5hLmlvIl0sInNjb3BlIjoiYWRkX29yZGVyIHVwZGF0ZV9vcmRlciBjYW5jZWxfb3JkZXIifQ" +
        ".VHyujz0IANhwqizWlAZDNT2PYEOx2KFtIVk9KN6tUR4NUKDKBjcIRCMajJRnJxAbhmK5_joMbE6_azB2" +
        "sibLK8QVIL4U23_UWabZrOQ09jXrd9uatnOlEY3BVZN9IOMNVL09qVQ_ZsbEKe53JJkMt8OhkEq-bzxMf" +
        "Th9v7HaiUD-fOu2pyncUkVsJzugQ9FHDpQEbnh_runF1vDky-2ajEZ_1yUKssbHSs4CahTy8gUljhwaii" +
        "e7aJYQesJJQk2_ga8UI88NLVlWRtzITa71lTBhi22J18hEZMcmb6dsioG9KsL2rjDSr4tdHYKxlAP21pO" +
        "6G_84v1kkeGfVuujG8A"
    }
};

// Unauthenticated invocations

@test:Config
// Function to test POST resource 'addOrder' with no authentication.
function testResourceAddOrderUnauthenticated() {
    // Initialize the empty http request.
    http:Request request;
    // Construct the request payload.
    json payload = {"Order":{"ID":"100500", "Name":"XYZ", "Description":"Sample order."}};
    request.setJsonPayload(payload);
    // Send 'POST' request and obtain the response.
    http:Response response = check clientEPUnauthenticated -> post("/order", request = request);
    // Expected response code is 401.
    test:assertEquals(response.statusCode, 401,
        msg = "addOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    string resPayload = check response.getTextPayload();
    test:assertEquals(resPayload,
        "request failed: Authentication failure", msg = "Response mismatch!");
}


@test:Config {
    dependsOn:["testResourceAddOrderUnauthenticated"]
}
// Function to test PUT resource 'updateOrder' with no authentication.
function testResourceUpdateOrderUnauthenticated() {
    // Initialize empty http requests and responses.
    http:Request request;
    // Construct the request payload.
    json payload = {"Order":{"Name":"XYZ", "Description":"Updated order."}};
    request.setJsonPayload(payload);
    // Send 'PUT' request and obtain the response.
    http:Response response = check clientEPUnauthenticated -> put("/order/100500", request = request);
    // Expected response code is 401.
    test:assertEquals(response.statusCode, 401,
        msg = "updateOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    string resPayload = check response.getTextPayload();
    test:assertEquals(resPayload,
        "request failed: Authentication failure", msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceUpdateOrderUnauthenticated"]
}
// Function to test GET resource 'findOrder' with no authentication.
function testResourceFindOrderUnauthenticated() {
    // Initialize empty http requests and responses.
    http:Request request;
    // Send 'GET' request and obtain the response.
    http:Response response = check clientEPUnauthenticated -> get("/order/100500", request = request);
    // Expected response code is 500.
    test:assertEquals(response.statusCode, 404,
        msg = "findOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(), "Order : 100500 cannot be found.", msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceFindOrderUnauthenticated"]
}
// Function to test DELETE resource 'cancelOrder' with no authentication.
function testResourceCancelOrderUnauthenticated() {
    // Initialize empty http requests and responses.
    http:Request request;
    // Send 'DELETE' request and obtain the response.
    http:Response response = check clientEPUnauthenticated -> delete("/order/100500", request = request);
    // Expected response code is 401.
    test:assertEquals(response.statusCode, 401,
        msg = "cancelOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    string resPayload = check response.getTextPayload();
    test:assertEquals(resPayload,
        "request failed: Authentication failure", msg = "Response mismatch!");
}


// Counter user invocations

@test:Config
// Function to test POST resource 'addOrder' with counter user.
function testResourceAddOrderWithCounterUser() {
    // Initialize the empty http request.
    http:Request request;
    // Construct the request payload.
    json payload = {"Order":{"ID":"100501", "Name":"XYZ", "Description":"Sample order."}};
    request.setJsonPayload(payload);
    // Send 'POST' request and obtain the response.
    http:Response response = check clientEPCounter -> post("/order", request = request);
    // Expected response code is 201.
    test:assertEquals(response.statusCode, 201,
        msg = "addOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(),
        "{\"status\":\"Order Created.\",\"orderId\":\"100501\"}", msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceAddOrderWithCounterUser"]
}
// Function to test PUT resource 'updateOrder' with counter user.
function testResourceUpdateOrderWithCounterUser() {
    // Initialize empty http requests and responses.
    http:Request request;
    // Construct the request payload.
    json payload = {"Order":{"Name":"XYZ", "Description":"Updated order."}};
    request.setJsonPayload(payload);
    // Send 'PUT' request and obtain the response.
    http:Response response = check clientEPCounter -> put("/order/100501", request = request);
    // Expected response code is 403.
    test:assertEquals(response.statusCode, 403,
        msg = "updateOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    string resPayload = check response.getTextPayload();
    test:assertEquals(resPayload,
        "request failed: Authorization failure", msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceUpdateOrderWithCounterUser"]
}
// Function to test GET resource 'findOrder' with counter user.
function testResourceFindOrderWithCounterUser() {
    // Initialize empty http requests and responses.
    http:Request request;
    // Send 'GET' request and obtain the response.
    http:Response response = check clientEPCounter -> get("/order/100501", request = request);
    // Expected response code is 200.
    test:assertEquals(response.statusCode, 200,
        msg = "findOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(),
        "{\"Order\":{\"ID\":\"100501\",\"Name\":\"XYZ\",\"Description\":\"Sample order.\"}}",
        msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceFindOrderWithCounterUser"]
}
// Function to test DELETE resource 'cancelOrder' with counter user.
function testResourceCancelOrderWithCounterUser() {
    // Initialize empty http requests and responses.
    http:Request request;
    // Send 'DELETE' request and obtain the response.
    http:Response response = check clientEPCounter -> delete("/order/100501", request = request);
    // Expected response code is 403.
    test:assertEquals(response.statusCode, 403,
        msg = "cancelOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    string resPayload = check response.getTextPayload();
    test:assertEquals(resPayload,
        "request failed: Authorization failure", msg = "Response mismatch!");
}

// Admin user invocations

@test:Config
// Function to test POST resource 'addOrder' with admin user.
function testResourceAddOrderWithAdminUser() {
    // Initialize the empty http request.
    http:Request request;
    // Construct the request payload.
    json payload = {"Order":{"ID":"100502", "Name":"XYZ", "Description":"Sample order."}};
    request.setJsonPayload(payload);
    // Send 'POST' request and obtain the response.
    http:Response response = check clientEPAdmin -> post("/order", request = request);
    // Expected response code is 201.
    test:assertEquals(response.statusCode, 201,
        msg = "addOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(),
        "{\"status\":\"Order Created.\",\"orderId\":\"100502\"}", msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceAddOrderWithAdminUser"]
}
// Function to test PUT resource 'updateOrder' with admin user.
function testResourceUpdateOrderWithAdminUser() {
    // Initialize empty http requests and responses.
    http:Request request;
    // Construct the request payload.
    json payload = {"Order":{"Name":"XYZ", "Description":"Updated order."}};
    request.setJsonPayload(payload);
    // Send 'PUT' request and obtain the response.
    http:Response response = check clientEPAdmin -> put("/order/100502", request = request);
    // Expected response code is 200.
    test:assertEquals(response.statusCode, 200,
        msg = "updateOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(),
        "{\"Order\":{\"ID\":\"100502\",\"Name\":\"XYZ\",\"Description\":\"Updated order.\"}}",
        msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceUpdateOrderWithAdminUser"]
}
// Function to test GET resource 'findOrder' with admin user.
function testResourceFindOrderWithAdminUser() {
    // Initialize empty http requests and responses.
    http:Request request;
    // Send 'GET' request and obtain the response.
    http:Response response = check clientEPAdmin -> get("/order/100502", request = request);
    // Expected response code is 200.
    test:assertEquals(response.statusCode, 200,
        msg = "findOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(),
        "{\"Order\":{\"ID\":\"100502\",\"Name\":\"XYZ\",\"Description\":\"Updated order.\"}}",
        msg = "Response mismatch!");
}

@test:Config {
    dependsOn:["testResourceFindOrderWithAdminUser"]
}
// Function to test DELETE resource 'cancelOrder' with admin user.
function testResourceCancelOrderWithAdminUser() {
    // Initialize empty http requests and responses.
    http:Request request;
    // Send 'DELETE' request and obtain the response.
    http:Response response = check clientEPAdmin -> delete("/order/100502", request = request);
    // Expected response code is 200.
    test:assertEquals(response.statusCode, 200,
        msg = "cancelOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(), "Order : 100502 removed.",
        msg = "Response mismatch!");
}

@test:AfterSuite
function afterFunc() {
    // Stop the 'order_mgt' service after running the test.
    test:stopServices("secure_restful_service");
}
