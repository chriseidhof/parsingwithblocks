//
// Created by chris on 10.01.14.
//

#import "PatternMatchingParser.h"


@implementation PatternMatchingParser

- (void)parse
{
    NSArray* rules = @[
            @[@"@[1,_]", ^(NSArray *array) { NSLog(@"array with ones: %@", array); }],
            @[@"otherwise", ^(NSArray *array) { NSLog(@"other array: %@", array); }]
    ];
    [self executeRules:rules];
}

typedef void(^RuleBlock)(id match);

- (void)executeRules:(NSArray *)array
{
    for(NSArray* rule in rule) {
        NSAssert(rule.count == 2, @"Should have a predicate and a block");
        NSString* predicate = rule[0];
        RuleBlock block = rule[1];


    }
}

@end
