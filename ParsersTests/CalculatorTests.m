#import <XCTest/XCTest.h>
#import "Calculator.h"
#import "Lexer.h"

@interface CalculatorTests : XCTestCase

@property (nonatomic, strong) Calculator *calculator;
@end

@implementation CalculatorTests

- (void)setUp
{
    [super setUp];
    self.calculator = [[Calculator alloc] init];
}

- (id)parse:(NSString *)input
{
    Lexer *lexer = [[Lexer alloc] init];
    NSArray *tokens = [lexer tokenize:input];
    id result = [self.calculator parseExpression:tokens];
    return result;
}

- (void)testExample
{
    NSString *input = @"1";
    id result= [self parse:input];
    XCTAssertEqualObjects(result, @1);
}


- (void)testAddition
{
    NSString *input = @"1 + 2";
    id result= [self parse:input];
    XCTAssertEqualObjects(result, @3);

}

- (void)testMultiplication
{
    NSString *input = @"1 + 2 * 3";
    id result= [self parse:input];
    XCTAssertEqualObjects(result, @7);
}

- (void)testParentheses
{
    NSString *input = @"(1 + 2) * 3";
    id result= [self parse:input];
    XCTAssertEqualObjects(result, @9);
}

@end
