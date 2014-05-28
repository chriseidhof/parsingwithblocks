//
//  Lexer.m
//  Parsers
//
//  Created by Chris Eidhof on 09.01.14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

#import "Lexer.h"
#import "Tokens.h"

@interface Lexer ()

@property (nonatomic, copy) NSArray *operators;
@property (nonatomic, strong) NSMutableArray *tokens;
@property (nonatomic, strong) NSScanner *scanner;
@property (nonatomic, strong) NSMutableArray *tokenIndices;
@property (nonatomic) NSUInteger startLocation;
@end

@implementation Lexer

- (id)init
{
    self = [super init];
    if (self) {
        self.operators = @[@"=", @"+", @"*", @">=", @"<=", @".", @"(", @")"];
    }

    return self;
}


- (Tokens *)tokenize:(NSString *)contents
{
    self.scanner = [NSScanner scannerWithString:contents];
    self.tokens = [NSMutableArray array];
    self.tokenIndices = [NSMutableArray array];

    while (![self.scanner isAtEnd]) {
        self.startLocation = self.scanner.scanLocation;
        for (NSString *operator in self.operators) {
            if ([self.scanner scanString:operator intoString:NULL]) {
                [self addToken:operator];
            }
        }
        NSString *result = nil;
        if ([self.scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&result]) {
            NSString *rest = nil;
            [self.scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&rest];
            [self addToken:[result stringByAppendingString:rest ?: @""]];
        }
        double doubleResult = 0;
        if ([self.scanner scanDouble:&doubleResult]) {
            [self addToken:@(doubleResult)];
        }
        NSAssert(self.scanner.scanLocation != self.startLocation, @"Should have made progress: %lu", self.scanner.scanLocation);
    }
    return [Tokens tokensWithTokens:self.tokens tokenIndices:self.tokenIndices];
}

- (void)addToken:(id)token
{
    [self.tokens addObject:token];
    [self.tokenIndices addObject:@(self.startLocation)];
}

+ (instancetype)lexerWithOperators:(NSArray *)operators
{
    Lexer *lexer = [[self alloc] init];
    lexer.operators = operators;
    return lexer;
}
@end
