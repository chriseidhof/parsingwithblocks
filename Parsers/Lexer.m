//
//  Lexer.m
//  Parsers
//
//  Created by Chris Eidhof on 09.01.14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

#import "Lexer.h"

@interface Lexer ()

@property (nonatomic, copy) NSArray *operators;
@end

@implementation Lexer

- (id)init
{
    self = [super init];
    if (self) {
        self.operators = @[@"=", @"+", @"*", @">=", @"<=", @"."];
    }

    return self;
}


- (NSArray *)tokenize:(NSString *)contents
{
    NSScanner *scanner = [NSScanner scannerWithString:contents];
    NSMutableArray *tokens = [NSMutableArray array];

    while (![scanner isAtEnd]) {
        NSUInteger startLocation = scanner.scanLocation;
        for (NSString *operator in self.operators) {
            if ([scanner scanString:operator intoString:NULL]) {
                [tokens addObject:operator];
            }
        }
        NSString *result = nil;
        if ([scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&result]) {
            NSString *rest = nil;
            [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&rest];
            [tokens addObject:[result stringByAppendingString:rest ?: @""]];
        }
        double doubleResult = 0;
        if ([scanner scanDouble:&doubleResult]) {
            [tokens addObject:@(doubleResult)];
        }
        NSAssert(scanner.scanLocation != startLocation, @"Should have made progress: %lu", scanner.scanLocation);
    }
    return tokens;
}

+ (instancetype)lexerWithOperators:(NSArray *)operators
{
    Lexer *lexer = [[self alloc] init];
    lexer.operators = operators;
    return lexer;
}
@end
