#import <GHUnitIOS/GHUnit.h> 

#import "Tin.h"

@interface Tin (Testing)
- (void)setOptionsOnRequest:(ASIHTTPRequest *)request;
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

#pragma mark - URL
- (void)testUsernameSetter {
	tinInstance.username = @"Jake";
	ASIHTTPRequest *aRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://iets.com"]];
	[tinInstance setOptionsOnRequest:aRequest];
	GHAssertEqualObjects(@"Jake", aRequest.username, nil);
}

- (void)testPasswordSetter {
	tinInstance.password = @"password";
	ASIHTTPRequest *aRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://iets.com"]];
	[tinInstance setOptionsOnRequest:aRequest];
	GHAssertEqualObjects(@"password", aRequest.password, nil);
}

- (void)testTimeOutInSeconds {
	tinInstance.timeoutSeconds = 20;
	ASIHTTPRequest *aRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://iets.com"]];
	[tinInstance setOptionsOnRequest:aRequest];
	GHAssertTrue(20 == aRequest.timeOutSeconds, nil);
}

- (void)testBaseURIWihtoutHTTPURL {
    tinInstance.baseURI = @"apple.com";
    GHAssertEqualObjects(@"http://apple.com", [tinInstance normalizeURL:@"" withQuery:nil], nil);
}

- (void)testBaseURIEnabledURL {
    tinInstance.baseURI = @"http://apple.com";
    GHAssertEqualObjects(@"http://apple.com", [tinInstance normalizeURL:@"" withQuery:nil], nil);
}

- (void)testBaseURIWithEndpoint {
    tinInstance.baseURI = @"apple.com";
    GHAssertEqualObjects(@"http://apple.com/products/ipad", [tinInstance normalizeURL:@"/products/ipad" withQuery:nil], nil);
}

- (void)testNonPrefixedURL {       
    GHAssertEqualObjects(@"http://apple.com", [tinInstance normalizeURL:@"apple.com" withQuery:nil], nil);
}

- (void)testPrefixedURL {       
    GHAssertEqualObjects(@"http://apple.com", [tinInstance normalizeURL:@"http://apple.com" withQuery:nil], nil);
}

- (void)testHTTPSPrefixedURL {       
    GHAssertEqualObjects(@"https://apple.com", [tinInstance normalizeURL:@"https://apple.com" withQuery:nil], nil);
}

- (void)testWithNSDictQuery {
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Tin", @"string", nil];
    GHAssertEqualObjects(@"http://apple.com?string=Tin", [tinInstance normalizeURL:@"apple.com" withQuery:queryDict], nil);
}

- (void)testWithNSStringQuery {
    GHAssertEqualObjects(@"http://apple.com?string=Tin", [tinInstance normalizeURL:@"apple.com" withQuery:@"string=Tin"], nil);
}

@end