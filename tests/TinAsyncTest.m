#import <GHUnitIOS/GHUnit.h> 

#import "Tin.h"

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
    [Tin get:@"http://httpbin.org/get" success:^(NSArray *data) {
        GHAssertNotNil(data, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testSimpleGetRequest)];
    } error:nil];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testGetRequestWithQueryString { 
    [self prepare];
    [Tin get:@"http://httpbin.org/" query:@"get" success:^(NSArray *data) {
        //GHAssertNotNil(data, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetRequestWithQueryString)];
    } error:nil];
     [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPostRequest {
    [self prepare];
    [Tin post:@"http://httpbin.org/post" body:nil success:^(NSArray *data) {
        GHTestLog(@"Response: %@", data);
        GHAssertNotNil(data, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPostRequest)];
    } error:nil];     
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPostRequestWithData {
    [self prepare];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"string",@"keyOne",
                              @"anotherString", @"keyTwo",nil];
    
    [Tin post:@"http://httpbin.org/post" body:postDict success:^(NSArray *data) {
        GHTestLog(@"Response: %@", data);
        GHAssertNotNil(data, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPostRequestWithData)];
    } error:nil];     
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPostRequestWithQueryData {
    [self prepare];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"string",@"keyOne",
                              @"anotherString", @"keyTwo",nil];
    
    [Tin post:@"http://httpbin.org/post" query:postDict body:nil success:^(NSArray *data) {
        GHTestLog(@"Response: %@", data);
        GHAssertNotNil(data, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPostRequestWithQueryData)];
    } error:nil];  
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPutRequest {
    [self prepare];
    [Tin put:@"http://httpbin.org/put" body:nil success:^(NSArray *data) {
        GHTestLog(@"Response: %@", data);
        GHAssertNotNil(data, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPutRequest)];
    } error:nil];     
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPutRequestWithData {
    [self prepare];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"string",@"keyOne",
                              @"anotherString", @"keyTwo",nil];
    
    [Tin put:@"http://httpbin.org/put" body:postDict success:^(NSArray *data) {
        GHTestLog(@"Response: %@", data);
        GHAssertNotNil(data, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPutRequestWithData)];
    } error:nil];     
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testPutRequestWithQueryData {
    [self prepare];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"string",@"keyOne",
                              @"anotherString", @"keyTwo",nil];
    
    [Tin put:@"http://httpbin.org/put" query:postDict body:nil success:^(NSArray *data) {
        GHTestLog(@"Response: %@", data);
        GHAssertNotNil(data, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testPutRequestWithQueryData)];
    } error:nil];  
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

@end