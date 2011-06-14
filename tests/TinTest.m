#import <GHUnitIOS/GHUnit.h> 
#import "OCMock.h"
#import "Tin.h"
#import "TinResponse.h"
#import "ASIHTTPRequest.h"

@interface TinTest : GHTestCase { }
@end

@implementation TinTest

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


// NOT WORKING YET
- (void)testGetRequest {
    // create a nice mock
    id request = [OCMockObject niceMockForClass:[ASIHTTPRequest class]];
    NSString *responseString = @"iets";
    
    [[[(id)request stub] andReturn:responseString] responseString];

    // keep the completion block upon setting
    __block ASIBasicBlock requestBlock;

    [[(id)request expect] setCompletionBlock:    [OCMArg checkWithBlock:^(id value) { 
        requestBlock = [value copy]; 
        return YES;
    }]];
//    
    // start the delayed call response
    [[[(id)request stub] andDo:^(NSInvocation *invocation) {
//       // RunAfterDelay(3, ^{
            requestBlock();
//            [requestBlock release];
//       // });
    }] startAsynchronous];
    [Tin get:@"apple.com" success:^(TinResponse *response) {
        NSLog(@"%@", response.response);
    }];
    
}
@end