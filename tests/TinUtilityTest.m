#import <GHUnitIOS/GHUnit.h> 

#import "Tin.h"
#import "AFHTTPClient.h"

@interface Tin (Testing)
- (void)setOptionsOnClient:(AFHTTPClient *)client;
- (NSString *)normalizeURL:(NSString *)aURL withQuery:(id)query;
@end

@interface TinUtilityTest : GHTestCase { }
@property (nonatomic, retain) Tin *tinInstance;
@end

@implementation TinUtilityTest
@synthesize tinInstance;

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
    tinInstance = [[Tin alloc] init];
}

- (void)tearDown {
    // Run after each test method
    [tinInstance release];
    tinInstance = nil;
}  

#pragma mark - Client

- (void)testAuthenticationSetter {
	tinInstance.username = @"Jake";
    tinInstance.password = @"TheSnake";
	AFHTTPClient *_client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://nog.iets.be"]];
	[tinInstance setOptionsOnClient:_client];
    GHAssertEqualStrings(@"Basic SmFrZTpUaGVTbmFrZQ==", [_client defaultValueForHeader:@"Authorization"], nil);
}

// TODO: set timeout
//- (void)testTimeOutInSeconds {
//	tinInstance.timeoutSeconds = 20;
//	ASIHTTPRequest *aRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://iets.com"]];
//	[tinInstance setOptionsOnRequest:aRequest];
//	GHAssertTrue(20 == aRequest.timeOutSeconds, nil);
//}

- (void)testWithNSDictQuery {
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Tin", @"string", nil];
    GHAssertEqualObjects(@"http://apple.com?string=Tin", [tinInstance normalizeURL:@"http://apple.com" withQuery:queryDict], nil);
}

- (void)testWithNSStringQuery {
    GHAssertEqualObjects(@"http://apple.com?string=Tin", [tinInstance normalizeURL:@"http://apple.com" withQuery:@"string=Tin"], nil);
}

@end