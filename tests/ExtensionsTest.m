#import <GHUnitIOS/GHUnit.h> 

#import "Tin+Extensions.h"

@interface ExtensionsTest : GHTestCase { }
@end

@implementation ExtensionsTest

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

- (void)testDictWithStringsToQuery {       
    NSDictionary *simpleDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"Tin", @"string", nil];
    GHAssertEqualObjects(@"?string=Tin", [simpleDict toQueryString], nil);
}

- (void)testEscapingTextInDictionary {
    NSDictionary *simpleDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Tin Is Nit Backwards", @"string", nil];
    GHAssertEqualObjects(@"?string=Tin%20Is%20Nit%20Backwards", [simpleDict toQueryString], nil);
}

- (void)testDictWithNumber {
    NSDictionary *simpleDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:1], @"numberOne",
                                [NSNumber numberWithInt:1334], @"numberTwo",
                                nil];
    GHAssertEqualObjects(@"?numberTwo=1334&numberOne=1", [simpleDict toQueryString], nil);
}
@end