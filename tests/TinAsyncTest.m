#import <GHUnitIOS/GHUnit.h> 

#import "Tin.h"
#import "TinResponse.h"

@interface TinAsyncTest : GHAsyncTestCase  { }
@end

@implementation TinAsyncTest

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  

// Does go out and make the actual call
- (void)testSimpleGetRequest { 
    [self prepare];
    [Tin get:@"http://httpbin.org/get" success:^(TinResponse *response) {
        GHAssertNotNil(response, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testSimpleGetRequest)];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testGetRequestWithQueryString { 
    [self prepare];
    [Tin get:@"http://httpbin.org/" query:@"get" success:^(TinResponse *response) {
        //GHAssertNotNil(data, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetRequestWithQueryString)];
    }];
     [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPostRequest {
    [self prepare];
    [Tin post:@"http://httpbin.org/post" body:nil success:^(TinResponse *response) {
        GHTestLog(@"Response: %@", response);
        GHAssertNotNil(response, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPostRequest)];
    }];     
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPostRequestWithData {
    [self prepare];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"string",@"keyOne",
                              @"anotherString", @"keyTwo",nil];
    
    [Tin post:@"http://httpbin.org/post" body:postDict success:^(TinResponse *response) {
        GHTestLog(@"Response: %@", response);
        GHAssertNotNil(response, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPostRequestWithData)];
    }];     
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPostRequestWithQueryData {
    [self prepare];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"string",@"keyOne",
                              @"anotherString", @"keyTwo",nil];
    
    [Tin post:@"http://httpbin.org/post" query:postDict body:nil success:^(TinResponse *response) {
        GHTestLog(@"Response: %@", response);
        GHAssertNotNil(response, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPostRequestWithQueryData)];
    }];  
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPutRequest {
    [self prepare];
    [Tin put:@"http://httpbin.org/put" body:nil success:^(TinResponse *response) {
        GHTestLog(@"Response: %@", response);
        GHAssertNotNil(response, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPutRequest)];
    }];     
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPutRequestWithData {
    [self prepare];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"string",@"keyOne",
                              @"anotherString", @"keyTwo",nil];
    
    [Tin put:@"http://httpbin.org/put" body:postDict success:^(TinResponse *response) {
        GHTestLog(@"Response: %@", response);
        GHAssertNotNil(response, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPutRequestWithData)];
    }];     
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPutRequestWithQueryData {
    [self prepare];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"string",@"keyOne",
                              @"anotherString", @"keyTwo",nil];
    
    [Tin put:@"http://httpbin.org/put" query:postDict body:nil success:^(TinResponse *response) {
        GHTestLog(@"Response: %@", response);
        GHAssertNotNil(response, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPutRequestWithQueryData)];
    }];  
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testErroredRequest { 
    [self prepare];
	Tin *tin = [[Tin alloc] init];
	tin.username = @"bla";
	tin.password = @"haha";
    [tin get:@"http://httpbin.org/basic-auth/user/passwd" success:^(TinResponse *response) {
        GHTestLog(@"Response: %@", response);
		GHTestLog(@"Error: %@", response.error);
        GHAssertNotNil(response.error, @"We should receive an error");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testErroredRequest)];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testBasicAuthentication { 
    [self prepare];
	Tin *tin = [[Tin alloc] init];
	tin.username = @"user";
	tin.password = @"passwd";
    [tin get:@"http://httpbin.org/basic-auth/user/passwd" success:^(TinResponse *response) {
        GHTestLog(@"Response: %@", response);
        GHAssertNil(response.error, @"We should be authenticated");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testBasicAuthentication)];
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

@end