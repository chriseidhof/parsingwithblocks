//
// Created by chris on 10.01.14.
//

#import "ConstraintParser.h"
#import "Parser.h"

@implementation ConstraintParser

#define to(x) (^(id result) { x = result; })

- (id)parseConstraint:(NSArray *)tokens views:(NSDictionary *)views
{
    const NSDictionary* properties = @{
            @"left": @(NSLayoutAttributeLeft),
            @"right":@(NSLayoutAttributeRight),
            @"top": @(NSLayoutAttributeTop),
            @"bottom": @(NSLayoutAttributeBottom),
            @"leading": @(NSLayoutAttributeLeading),
            @"trailing": @(NSLayoutAttributeTrailing),
            @"width": @(NSLayoutAttributeWidth),
            @"height": @(NSLayoutAttributeHeight),
            @"centerX": @(NSLayoutAttributeCenterX),
            @"centerY": @(NSLayoutAttributeCenterY),
            @"baseline": @(NSLayoutAttributeBaseline),
    };

    const NSDictionary *operators = @{
      @"=": @(NSLayoutRelationEqual),
      @">=": @(NSLayoutRelationGreaterThanOrEqual),
      @"<=": @(NSLayoutRelationLessThanOrEqual),
    };

    Rule operatorRule = optionsWithDictionary(operators);
    Rule attribute = optionsWithDictionary(properties);
    Rule constantRule = ^Parser *(Parser *p)
    {
        return p.token(@"+").number();
    };
    Rule multiplierRule = ^Parser *(Parser *p)
    {
        return p.token(@"*").number();
    };
    Rule side = ^(Parser * p) {
       __block NSString* name = nil;
       __block NSString* lhsProperty = nil;
       __block NSNumber* constant = nil;
       __block NSNumber* multiplier = nil;

        return p.identifier().bind(to(name)).token(@".").
               rule(attribute).bind(to(lhsProperty)).
               optional(multiplierRule).bind(to(multiplier)).
               optional(constantRule).bind(to(constant)).
               yield(^id
       {
           return @[name, lhsProperty, multiplier ?: @1, constant ?: @0];
       });
    };
    Rule rule = ^Parser *(Parser *state)
    {
        __block id lhs = nil;
        __block id rhs = nil;
        __block id operator = nil;
        return state.rule(side).bind(to(lhs)).rule(operatorRule).bind(to(operator)).rule(side).bind(to(rhs)).yield(^id
        {
            return @[lhs, operator, rhs];
        });
    };
    Parser *start = [Parser stateWithTokens:tokens];
    Parser* parseResult = rule(start).eof();
    if (parseResult.failed) {
        NSLog(@"result didn't parse: %@", parseResult.errorMessage);
        return nil;
    } else {
        NSArray* result = parseResult.result;
        NSArray* lhs = result[0];
        NSInteger relation = [result[1] integerValue];
        NSArray* rhs = result[2];

        double multiplier = [rhs[2] doubleValue] / [lhs[2] doubleValue];
        double constant = [rhs[3] doubleValue] - [lhs[3] doubleValue];
        NSInteger attribute1 = [lhs[1] integerValue];
        NSInteger attribute2 = [rhs[1] integerValue];
        return [NSLayoutConstraint constraintWithItem:views[lhs[0]] attribute:attribute1 relatedBy:relation toItem:views[rhs[0]] attribute:attribute2 multiplier:multiplier constant:constant];
    }
}


@end
