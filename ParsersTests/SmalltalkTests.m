//
// Created by chris on 12.01.14.
//


#import <XCTest/XCTest.h>
#import "SmalltalkLexer.h"

@interface SmalltalkLexerTests : XCTestCase

@property (nonatomic,strong) SmalltalkLexer *lexer;

@end

@implementation SmalltalkLexerTests

- (void)setUp
{
    self.lexer = [[SmalltalkLexer alloc] init];
}

- (void)testVariableName
{
    NSArray* result = [self.lexer lex:@"hello world"];
    XCTAssertEqualObjects(result, (@[[Token identifier:@"hello"], [Token identifier:@"world"]]));
}

- (void)testClassName
{
    NSArray *result = [self.lexer lex:@"NSString"];
    XCTAssertEqualObjects(result, (@[[Token classIdentifier:@"NSString"]]));
}

- (void)testClassIsNotIdentifier
{
    NSArray *result = [self.lexer lex:@"NSString"];
    XCTAssertNotEqualObjects(result, (@[[Token identifier:@"NSString"]]));
}

- (void)testOperators
{
    NSArray *result = [self.lexer lex:@"hello.:"];
    XCTAssertEqualObjects(result, (@[[Token identifier:@"hello"], [Token operator:@"."], [Token operator:@":"]]));
}



@end
