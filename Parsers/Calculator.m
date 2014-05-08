//
// Created by chris on 07.05.14.
//

#import "Calculator.h"
#import "Parser.h"

@interface Calculator ()

@end

static NSNumber* interpret(NSString* operator, NSNumber *lhs, NSNumber *rhs) {
    if ([operator isEqualToString:@"+"]) {
        return @(lhs.integerValue + rhs.integerValue);
    } else if ([operator isEqualToString:@"*"]) {
        return @(lhs.integerValue * rhs.integerValue);
    }
    assert(NO);
    return nil;
}

@implementation Calculator

#define to(x) (^(id _____result) { x = _____result; })

- (id)parseExpression:(NSArray*)tokens {

    __block id expr;

    Rule number = ^Parser *(Parser *p)
    {
        return p.number();
    };
    Rule parenthesized = ^Parser *(Parser *p)
    {
        __block id result;
        return p.token(@"(").rule(expr).bind(to(result)).token(@")").yield(^id
        {
            NSLog(@"result: %@", result);
            return result;
        });
    };
    Rule atom = ^Parser *(Parser *p)
    {
        return p.oneOf(@[number,parenthesized]);
    };

    Rule (^infixHelper)(NSString *, Rule) = ^(NSString *operator, Rule childRule) {
        return ^(Parser *p) {
            __block NSNumber *lhs;
            __block NSNumber *rhs;
            return p.rule(childRule).bind(to(lhs)).token(operator).rule(childRule).bind(to(rhs)).yield(^id
            {
                return interpret(operator, lhs, rhs);
            });
        };
    };

    Rule (^infix)(NSString *, Rule) = ^(NSString *operator, Rule childRule) {
        Rule helper = infixHelper(operator, childRule);
        return ^Parser *(Parser *p)
        {
            return p.oneOf(@[helper,childRule]);
        };
    };

    Rule multiplication = infix(@"*", atom);
    Rule sum = infix(@"+", multiplication);

    Parser *start = [Parser parserWithTokens:tokens];

    expr = sum;
    Parser* parseResult = start.rule(expr).eof();
    return parseResult.failed ? nil : parseResult.result;
}

@end
