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
    }];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

- (void)testGetRequestWithQueryString { 
    [self prepare];
    [Tin get:@"http://httpbin.org/" query:@"get" success:^(NSArray *data) {
        //GHAssertNotNil(data, @"We should get something back from the server");
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetRequestWithQueryString)];
    }];
     [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}



@end