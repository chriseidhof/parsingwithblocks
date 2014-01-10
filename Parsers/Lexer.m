//
//  Lexer.m
//  Parsers
//
//  Created by Chris Eidhof on 09.01.14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

#import "Lexer.h"

@implementation Lexer

+ (NSArray *)lex:(NSString *)contents
{
    Lexer *lexer = [[self alloc] init];
    return [lexer tokenize:contents];
}

- (NSArray *)tokenize:(NSString *)contents
{
    NSScanner *scanner = [NSScanner scannerWithString:contents];
    NSArray *operators = @[@"=", @"+", @"*", @">=", @"<=", @"."];
    NSMutableArray*tokens = [NSMutableArray array];
    NSCharacterSet *identifierSet = [NSCharacterSet letterCharacterSet];
    while(! [scanner isAtEnd]) {
        NSUInteger startLocation = scanner.scanLocation;
        for(NSString*operator in operators) {
            if ([scanner scanString:operator intoString:NULL]) {
                [tokens addObject:operator];
            }
        }
        NSString *result = nil;
        if ([scanner scanCharactersFromSet:identifierSet intoString:&result]) {
            [tokens addObject:result];
        }
        if ([scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&result]) {
            [tokens addObject:result];
        }
        NSAssert(scanner.scanLocation != startLocation, @"Should have made progress: %lu", scanner.scanLocation);
    }
    return tokens;
}
@end
