//
// Created by chris on 12.01.14.
//

#import <XCTest/XCTest.h>
#import "Lexer.h"

@interface LexerTests : XCTestCase
@end

@interface LexerTests ()

@property (nonatomic, strong) Lexer *lexer;
@end

@implementation LexerTests

- (void)setUp
{
    [super setUp];
    self.lexer = [[Lexer alloc] init];
}


- (void)test_identifierCanContainNumericCharacters
{
    NSArray *array = [self.lexer tokenize:@"one1two"];
    XCTAssertEqualObjects(array[0], @"one1two");
}

- (void)testDouble
{
    NSArray *array = [self.lexer tokenize:@"123.4"];
    XCTAssertEqualObjects(array[0], @123.4);
}

- (void)testOperators
{
    Lexer* lexer = [Lexer lexerWithOperators:@[@"->", @"*" ,@"+"]];
    NSArray *result = [lexer tokenize:@"->+*"];
    XCTAssertEqualObjects((@[@"->", @"+", @"*"]), result );
}

@end
