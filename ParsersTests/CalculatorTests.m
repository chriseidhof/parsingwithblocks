#import <XCTest/XCTest.h>
#import "Calculator.h"
#import "Lexer.h"
#import "ParsingError.h"

@interface CalculatorTests : XCTestCase

@property (nonatomic, strong) Calculator *calculator;
@end

@implementation CalculatorTests

- (void)setUp
{
    [super setUp];
    self.calculator = [[Calculator alloc] init];
}

- (id)parse:(NSString *)input error:(ParsingError **)error
{
    Lexer *lexer = [[Lexer alloc] init];
    NSArray *tokens = [lexer tokenize:input];
    id result = [self.calculator parseExpression:tokens error:error];
    return result;
}

- (void)testExample
{
    NSString *input = @"1";
    id result= [self parse:input error:NULL];
    XCTAssertEqualObjects(result, @1);
}


- (void)testAddition
{
    NSString *input = @"1 + 2";
    id result= [self parse:input error:NULL];
    XCTAssertEqualObjects(result, @3);

}

- (void)testMultiplication
{
    NSString *input = @"1 + 2 * 3";
    id result= [self parse:input error:NULL];
    XCTAssertEqualObjects(result, @7);
}

- (void)testParentheses
{
    NSString *input = @"(1 + 2) * 3";
    id result= [self parse:input error:NULL];
    XCTAssertEqualObjects(result, @9);
}

- (void)testError
{
    NSString *input = @"1 + 2 (";
    ParsingError *error;
    ParsingError *expectedError = [ParsingError errorWithMessage:@"Expected EOF, saw: '('" location:5];
    id result = [self parse:input error:&error];
    XCTAssertNil(result);
    XCTAssertEqualObjects(error, expectedError, @"Should have a useful error mesage");
}

@end
