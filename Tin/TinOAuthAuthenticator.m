//
//  TinOAuthAuthenticator.m
//  Created by Tom Adriaenssen on 09/02/12.
//
//  Based on asi-http-request-oauth, by Scott James Remnant
//  see: https://github.com/keybuk/asi-http-request-oauth
//

#import "TinOAuthAuthenticator.h"
#import "AFHTTPClient.h"
#include <sys/time.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSString (TinOAuthAuthenticator_Encoding)

- (NSString *)TO_encodeForURL;
- (NSString *)TO_decodeFromURL;

@end

@interface NSData (TinOAuthAuthenticator_Base64)

- (NSString *)TO_base64EncodedString;

@end

@interface TinOAuthAuthenticator ()

@property (nonatomic, retain) NSString *clientKey;
@property (nonatomic, retain) NSString *clientSecret;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *tokenSecret;
@property (nonatomic, assign) TinOAuthSignatureMethod method;
@property (nonatomic, retain) NSString *verifier;

- (NSArray*)oauthGenerateTimestampAndNonce;
- (NSString*)oauthBaseStringURI:(NSURL*)baseURI;
- (NSString*)query:(NSString*)query oauthRequestParameterString:(NSArray *)oauthParameters;
- (NSString*)oauthGenerateSignatureFor:(NSString*)baseString;
- (NSString*)oauthGeneratePlaintextSignatureFor:(NSString *)baseString withClientSecret:(NSString *)clientSecret andTokenSecret:(NSString *)tokenSecret;
- (NSString*)oauthGenerateHMAC_SHA1SignatureFor:(NSString *)baseString withClientSecret:(NSString *)clientSecret andTokenSecret:(NSString *)tokenSecret;
- (void)sortParameters:(NSMutableArray*)parameters;
- (NSArray *)oauthRequestExtractParametersFromQuery:(NSString**)pQuery;

@end

@implementation TinOAuthAuthenticator

// OAuth version implemented here
static const NSString *oauthVersion = @"1.0";

static const NSString *oauthSignatureMethodName[] = {
    @"PLAINTEXT",
    @"HMAC-SHA1",
};


@synthesize clientKey = _clientKey;
@synthesize clientSecret = _clientSecret;
@synthesize token = _token;
@synthesize tokenSecret = _tokenSecret;
@synthesize method = _method;
@synthesize verifier = _verifier;

- (id)initWithClientKey:(NSString*)clientKey clientSecret:(NSString*)clientSecret token:(NSString*)token tokenSecret:(NSString*)tokenSecret method:(TinOAuthSignatureMethod)method verifier:(NSString *)verifier {
    if ((self = [self init])) {
        self.clientKey = clientKey;
        self.clientSecret = clientSecret;
        self.token = token;
        self.tokenSecret = tokenSecret;
        self.method = method;
        self.verifier = verifier;
    }
    return self;
}

- (void)dealloc {
    self.clientKey = nil;
    self.clientSecret = nil;
    self.token = nil;
    self.tokenSecret = nil;
    self.verifier = nil;
}

- (NSString *)tin:(Tin *)tin applyAuthenticationOnClient:(AFHTTPClient *)client withMethod:(NSString*)method url:(NSString *)url query:(NSString *)query {
    NSMutableArray *params = [NSMutableArray arrayWithArray:[self oauthRequestExtractParametersFromQuery:&query]];
    
    // Add what we know now to the OAuth parameters
    //    if (client.authenticationRealm)
    //        [oauthParameters addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"realm", @"key", self.authenticationRealm, @"value", nil]];
    
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"oauth_version", @"key", oauthVersion, @"value", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"oauth_consumer_key", @"key", self.clientKey, @"value", nil]];
    if (self.token)
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"oauth_token", @"key", self.token, @"value", nil]];
    if (self.verifier)
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"oauth_verifier", @"key", self.verifier, @"value", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"oauth_signature_method", @"key", oauthSignatureMethodName[self.method], @"value", nil]];
    [params addObjectsFromArray:[self oauthGenerateTimestampAndNonce]];    
    
    // Construct the signature base string
    NSString *baseStringURI = [self oauthBaseStringURI:[NSURL URLWithString:url relativeToURL:[NSURL URLWithString:tin.baseURI]]];
    NSString *requestParameterString = [self query:query oauthRequestParameterString:params];
    NSString *baseString = [NSString stringWithFormat:@"%@&%@&%@", [method uppercaseString], [baseStringURI TO_encodeForURL], [requestParameterString TO_encodeForURL]];
    
    // Generate the signature
    NSString *signature = [self oauthGenerateSignatureFor:baseString];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"oauth_signature", @"key", signature, @"value", nil]];
    
    // Set the Authorization header
    [self sortParameters:params];
    NSMutableArray *oauthHeader = [NSMutableArray array];
    for (NSDictionary *param in params)
        [oauthHeader addObject:[NSString stringWithFormat:@"%@=\"%@\"", [[param objectForKey:@"key"] TO_encodeForURL], [[param objectForKey:@"value"] TO_encodeForURL]]];
    
    [client setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"OAuth %@", [oauthHeader componentsJoinedByString:@", "]]];
    
    return query;
}

+ (TinOAuthAuthenticator*)oauthAuthenticatorWithClientKey:(NSString*)key clientSecret:(NSString*)secret method:(TinOAuthSignatureMethod)method {
    return [[TinOAuthAuthenticator alloc] initWithClientKey:key clientSecret:secret token:nil tokenSecret:nil method:method verifier:nil];
}

+ (TinOAuthAuthenticator*)oauthAuthenticatorWithClientKey:(NSString*)key clientSecret:(NSString*)secret token:(NSString*)token tokenSecret:(NSString*)tokenSecret method:(TinOAuthSignatureMethod)method {
    return [[TinOAuthAuthenticator alloc] initWithClientKey:key clientSecret:secret token:token tokenSecret:tokenSecret method:method verifier:nil];
}

+ (TinOAuthAuthenticator*)oauthAuthenticatorWithClientKey:(NSString*)key clientSecret:(NSString*)secret token:(NSString*)token tokenSecret:(NSString*)tokenSecret method:(TinOAuthSignatureMethod)method verifier:(NSString *)verifier {
    return [[TinOAuthAuthenticator alloc] initWithClientKey:key clientSecret:secret token:token tokenSecret:tokenSecret method:method verifier:verifier];
}

#pragma mark - Timestamp and nonce handling

- (NSArray *)oauthGenerateTimestampAndNonce
{
    static time_t last_timestamp = -1;
    static NSMutableSet *nonceHistory = nil;
    
    // Make sure we never send the same timestamp and nonce
    if (!nonceHistory)
        nonceHistory = [[NSMutableSet alloc] init];
    
    struct timeval tv;
    NSString *timestamp, *nonce;
    do {
        // Get the time of day, for both the timestamp and the random seed
        gettimeofday(&tv, NULL);
        
        // Generate a random alphanumeric character sequence for the nonce
        char nonceBytes[16];
        srandom(tv.tv_sec | tv.tv_usec);
        for (int i = 0; i < 16; i++) {
            int byte = random() % 62;
            if (byte < 26)
                nonceBytes[i] = 'a' + byte;
            else if (byte < 52)
                nonceBytes[i] = 'A' + byte - 26;
            else
                nonceBytes[i] = '0' + byte - 52;
        }
        
        timestamp = [NSString stringWithFormat:@"%ld", tv.tv_sec];
        nonce = [NSString stringWithFormat:@"%.16s", nonceBytes];
    } while ((tv.tv_sec == last_timestamp) && [nonceHistory containsObject:nonce]);
    
    if (tv.tv_sec != last_timestamp) {
        last_timestamp = tv.tv_sec;
        [nonceHistory removeAllObjects];
    }
    [nonceHistory addObject:nonce];
    
    return [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"oauth_timestamp", @"key", timestamp, @"value", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"oauth_nonce", @"key", nonce, @"value", nil], nil];
}

#pragma mark - Signature base string construction

- (NSString *)oauthBaseStringURI:(NSURL*)baseURI
{
    NSAssert1([baseURI host] != nil, @"URL host missing: %@", [baseURI absoluteString]);
    
    // Port need only be present if it's not the default
    NSString *hostString;
    NSString* scheme = [baseURI.scheme lowercaseString];
    int port = [[baseURI port] integerValue];
    if (([baseURI port] == nil)
        || ([scheme isEqualToString:@"http"] && (port == 80))
        || ([scheme isEqualToString:@"https"] && (port == 443))) {
        hostString = [[baseURI host] lowercaseString];
    } 
    else {
        hostString = [NSString stringWithFormat:@"%@:%@", [[baseURI host] lowercaseString], [baseURI port]];
    }
    
    // Annoyingly [baseUri path] is decoded and has trailing slashes stripped, so we have to manually extract the path without the query or fragment
    NSString *pathString = [[baseURI absoluteString] substringFromIndex:[[baseURI scheme] length] + 3];
    NSRange pathStart = [pathString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    NSRange pathEnd = [pathString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?#"]];
    if (pathEnd.location != NSNotFound) {
        pathString = [pathString substringWithRange:NSMakeRange(pathStart.location, pathEnd.location - pathStart.location)];
    } else {
        pathString = [pathString substringFromIndex:pathStart.location];
    }
    
    return [NSString stringWithFormat:@"%@://%@%@", [[baseURI scheme] lowercaseString], hostString, pathString];
}

- (NSArray *)oauthRequestExtractParametersFromQuery:(NSString**)pQuery
{
    NSMutableArray *parameters = [NSMutableArray array];
    NSMutableArray *rest = [NSMutableArray array];
    NSString* query = *pQuery;
    
    // Decode the parameters given in the query string, and add their encoded counterparts
    if (query.length > 0 && [query characterAtIndex:0] == '?')
        query = [query substringFromIndex:1];
    
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSString *key, *value;
        NSRange separator = [pair rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
        if (separator.location != NSNotFound) {
            key = [[pair substringToIndex:separator.location] TO_decodeFromURL];
            value = [[pair substringFromIndex:separator.location + 1] TO_decodeFromURL];
        } else {
            key = [pair TO_decodeFromURL];
            value = @"";
        }
        
        if ([key hasPrefix:@"oauth_"])
            [parameters addObject:[NSDictionary dictionaryWithObjectsAndKeys:[key TO_encodeForURL], @"key", [value TO_encodeForURL], @"value", nil]];
        else
            [rest addObject:[NSString stringWithFormat:@"%@=%@", [key TO_encodeForURL], [value TO_encodeForURL]]];
    }

    
    *pQuery = [rest componentsJoinedByString:@"&"];
    return parameters;
}

- (NSString *)query:(NSString*)query oauthRequestParameterString:(NSArray *)oauthParameters
{
    NSMutableArray *parameters = [NSMutableArray array];
    
    // Decode the parameters given in the query string, and add their encoded counterparts
    if (query.length > 0 && [query characterAtIndex:0] == '?')
        query = [query substringFromIndex:1];
    
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSString *key, *value;
        NSRange separator = [pair rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
        if (separator.location != NSNotFound) {
            key = [[pair substringToIndex:separator.location] TO_decodeFromURL];
            value = [[pair substringFromIndex:separator.location + 1] TO_decodeFromURL];
        } else {
            key = [pair TO_decodeFromURL];
            value = @"";
        }
        
        [parameters addObject:[NSDictionary dictionaryWithObjectsAndKeys:[key TO_encodeForURL], @"key", [value TO_encodeForURL], @"value", nil]];
    }
    
    // Add the encoded counterparts of the parameters in the OAuth header
    for (NSDictionary *param in oauthParameters) {
        NSString *key = [param objectForKey:@"key"];
        if ([key hasPrefix:@"oauth_"]
            && ![key isEqualToString:@"oauth_signature"])
            [parameters addObject:[NSDictionary dictionaryWithObjectsAndKeys:[key TO_encodeForURL], @"key", [[param objectForKey:@"value"] TO_encodeForURL], @"value", nil]];
    }
    
//    // Add encoded counterparts of any additional parameters from the body
//    NSArray *postBodyParameters = [self oauthPostBodyParameters];
//    for (NSDictionary *param in postBodyParameters)
//        [parameters addObject:[NSDictionary dictionaryWithObjectsAndKeys:[[param objectForKey:@"key"] TO_encodeForURL], @"key", [[param objectForKey:@"value"] TO_encodeForURL], @"value", nil]];
//    
    // Sort by name and value
    
    [self sortParameters:parameters];
    
    // Join components together
    NSMutableArray *parameterStrings = [NSMutableArray array];
    for (NSDictionary *parameter in parameters) {
        if ([[parameter objectForKey:@"key"] length] == 0) continue;
        [parameterStrings addObject:[NSString stringWithFormat:@"%@=%@", [parameter objectForKey:@"key"], [parameter objectForKey:@"value"]]];
    }
    
    return [parameterStrings componentsJoinedByString:@"&"];
}

- (void)sortParameters:(NSMutableArray*)parameters {
    [parameters sortUsingComparator:^(id obj1, id obj2) {
        NSDictionary *val1 = obj1, *val2 = obj2;
        NSComparisonResult result = [[val1 objectForKey:@"key"] compare:[val2 objectForKey:@"key"] options:NSLiteralSearch];
        if (result != NSOrderedSame)
            return result;
        
        return [[val1 objectForKey:@"value"] compare:[val2 objectForKey:@"value"] options:NSLiteralSearch];
    }];
}

- (NSString*)oauthGenerateSignatureFor:(NSString*)baseString {
    switch (self.method) {
        case TinOAuthPlaintextSignatureMethod:
            return [self oauthGeneratePlaintextSignatureFor:baseString withClientSecret:self.clientSecret andTokenSecret:self.tokenSecret];
        case TinOAuthHMAC_SHA1SignatureMethod:
            return [self oauthGenerateHMAC_SHA1SignatureFor:baseString withClientSecret:self.clientSecret andTokenSecret:self.tokenSecret];
    }
    
    return @"";
}

#pragma mark - Signing algorithms

- (NSString *)oauthGeneratePlaintextSignatureFor:(NSString *)baseString withClientSecret:(NSString *)clientSecret andTokenSecret:(NSString *)tokenSecret
{
    return [NSString stringWithFormat:@"%@&%@", clientSecret ? [clientSecret TO_encodeForURL] : @"", tokenSecret ? [tokenSecret TO_encodeForURL] : @""];
}

- (NSString *)oauthGenerateHMAC_SHA1SignatureFor:(NSString *)baseString withClientSecret:(NSString *)clientSecret andTokenSecret:(NSString *)tokenSecret
{
	
    NSString *key = [self oauthGeneratePlaintextSignatureFor:baseString withClientSecret:clientSecret andTokenSecret:tokenSecret];
    
    const char *keyBytes = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *baseStringBytes = [baseString cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char digestBytes[CC_SHA1_DIGEST_LENGTH];
    
	CCHmacContext ctx;
    CCHmacInit(&ctx, kCCHmacAlgSHA1, keyBytes, strlen(keyBytes));
	CCHmacUpdate(&ctx, baseStringBytes, strlen(baseStringBytes));
	CCHmacFinal(&ctx, digestBytes);
    
	NSData *digestData = [NSData dataWithBytes:digestBytes length:CC_SHA1_DIGEST_LENGTH];
    return [digestData TO_base64EncodedString];
}


@end



@implementation NSString (TinOAuthAuthenticator_Encoding)

- (NSString *)TO_encodeForURL
{
    // See http://en.wikipedia.org/wiki/Percent-encoding and RFC3986
    // Hyphen, Period, Understore & Tilde are expressly legal
    const CFStringRef legalURLCharactersToBeEscaped = CFSTR("!*'();:@&=+$,/?#[]<>\"{}|\\`^% ");
    return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, legalURLCharactersToBeEscaped, kCFStringEncodingUTF8);
}


- (NSString *)TO_decodeFromURL
{
    NSString *decoded = (__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
    return [decoded stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

@end

#pragma mark - TinOAuthAuthenticator_Base64


//
//  NSData+Base64.m
//  base64
//
//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

// Mapping from 6 bit pattern to ASCII character.
static unsigned char TO_base64EncodeLookup[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//
// Fundamental sizes of the binary and base64 encode/decode units in bytes
//
#define BINARY_UNIT_SIZE 3
#define BASE64_UNIT_SIZE 4

// NewBase64Encode
//
// Encodes the arbitrary data in the inputBuffer as base64 into a newly malloced
// output buffer.
//
//  inputBuffer - the source data for the encode
//	length - the length of the input in bytes
//  separateLines - if zero, no CR/LF characters will be added. Otherwise
//		a CR/LF pair will be added every 64 encoded chars.
//	outputLength - if not-NULL, on output will contain the encoded length
//		(not including terminating 0 char)
//
// returns the encoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//
char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *buffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength)
{
	const unsigned char *inputBuffer = (const unsigned char *)buffer;
	
#define MAX_NUM_PADDING_CHARS 2
#define OUTPUT_LINE_LENGTH 64
#define INPUT_LINE_LENGTH ((OUTPUT_LINE_LENGTH / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE)
#define CR_LF_SIZE 2
	
	//
	// Byte accurate calculation of final buffer size
	//
	size_t outputBufferSize =
    ((length / BINARY_UNIT_SIZE)
     + ((length % BINARY_UNIT_SIZE) ? 1 : 0))
    * BASE64_UNIT_SIZE;
	if (separateLines)
	{
		outputBufferSize +=
        (outputBufferSize / OUTPUT_LINE_LENGTH) * CR_LF_SIZE;
	}
	
	//
	// Include space for a terminating zero
	//
	outputBufferSize += 1;
    
	//
	// Allocate the output buffer
	//
	char *outputBuffer = (char *)malloc(outputBufferSize);
	if (!outputBuffer)
	{
		return NULL;
	}
    
	size_t i = 0;
	size_t j = 0;
	const size_t lineLength = separateLines ? INPUT_LINE_LENGTH : length;
	size_t lineEnd = lineLength;
	
	while (true)
	{
		if (lineEnd > length)
		{
			lineEnd = length;
		}
        
		for (; i + BINARY_UNIT_SIZE - 1 < lineEnd; i += BINARY_UNIT_SIZE)
		{
			//
			// Inner loop: turn 48 bytes into 64 base64 characters
			//
			outputBuffer[j++] = TO_base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
			outputBuffer[j++] = TO_base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
                                                   | ((inputBuffer[i + 1] & 0xF0) >> 4)];
			outputBuffer[j++] = TO_base64EncodeLookup[((inputBuffer[i + 1] & 0x0F) << 2)
                                                   | ((inputBuffer[i + 2] & 0xC0) >> 6)];
			outputBuffer[j++] = TO_base64EncodeLookup[inputBuffer[i + 2] & 0x3F];
		}
		
		if (lineEnd == length)
		{
			break;
		}
		
		//
		// Add the newline
		//
		outputBuffer[j++] = '\r';
		outputBuffer[j++] = '\n';
		lineEnd += lineLength;
	}
	
	if (i + 1 < length)
	{
		//
		// Handle the single '=' case
		//
		outputBuffer[j++] = TO_base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = TO_base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
                                               | ((inputBuffer[i + 1] & 0xF0) >> 4)];
		outputBuffer[j++] = TO_base64EncodeLookup[(inputBuffer[i + 1] & 0x0F) << 2];
		outputBuffer[j++] =	'=';
	}
	else if (i < length)
	{
		//
		// Handle the double '=' case
		//
		outputBuffer[j++] = TO_base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = TO_base64EncodeLookup[(inputBuffer[i] & 0x03) << 4];
		outputBuffer[j++] = '=';
		outputBuffer[j++] = '=';
	}
	outputBuffer[j] = 0;
	
	//
	// Set the output length and return the buffer
	//
	if (outputLength)
	{
		*outputLength = j;
	}
	return outputBuffer;
}

@implementation NSData (TinOAuthAuthenticator_Base64)


//
// base64EncodedString
//
// Creates an NSString object that contains the base 64 encoding of the
// receiver's data. Lines are broken at 64 characters long.
//
// returns an autoreleased NSString being the base 64 representation of the
//	receiver.
//
- (NSString *)TO_base64EncodedString
{
	size_t outputLength;
	char *outputBuffer = NewBase64Encode([self bytes], [self length], true, &outputLength);
	NSString *result = [[NSString alloc] initWithBytes:outputBuffer length:outputLength encoding:NSASCIIStringEncoding];
	free(outputBuffer);
	return result;
}

@end

