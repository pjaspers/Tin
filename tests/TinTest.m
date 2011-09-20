#import <GHUnitIOS/GHUnit.h> 
#import "OCMock.h"
#import "Tin.h"
#import "TinResponse.h"
#import "ASIHTTPRequest.h"
#include <objc/runtime.h>

typedef void (^BasicBlock)(void);

void RunAfterDelay(NSTimeInterval delay, BasicBlock block) {
    [[[block copy] autorelease] performSelector:@selector(ps_callBlock) withObject:nil afterDelay:delay];
}

@implementation NSObject (BlocksAdditions)

- (void)ps_callBlock {
    void (^block)(void) = (id)self;
    block();
}

@end

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
typedef void(^BlockTypedef)(void);


- (ASIHTTPRequest *)mockRequest
{
    NSLog(@"USING ZE MOCK");
    // create a nice mock
    id request = [OCMockObject niceMockForClass:[ASIHTTPRequest class]];
    NSString *responseString = @"Some string";
    
    [[[(id)request stub] andReturn:responseString] responseString];
    
    [[(id)request expect] setCompletionBlock:[OCMArg checkWithBlock:^(id value) { 
        BlockTypedef myBlock = Block_copy(value);
        myBlock();
        Block_release(myBlock);
        return YES;
    }]];
    
    return [request retain];
}

- (void)testGetRequest {
    Method originalRequest = class_getClassMethod([Tin class], @selector(getRequestWithURL:));
    Method mockRequest = class_getInstanceMethod([self class], @selector(mockRequest));
    method_exchangeImplementations(originalRequest, mockRequest);

    [Tin get:@"apple.com" success:^(TinResponse *response) {
        NSLog(@"%@", response.response);
    }];
    
    method_exchangeImplementations(mockRequest, originalRequest);


    
}
@end