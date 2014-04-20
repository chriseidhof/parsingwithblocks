//
// Created by chris on 12.01.14.
//

#import "SmalltalkLexer.h"


@implementation SmalltalkLexer


- (NSArray *)lex:(NSString *)string
{

    self.operators = @[@".", @":=", @":", @"(", @")", @"|"];
    NSScanner *scanner = [NSScanner scannerWithString:string];

    NSMutableArray*tokens = [NSMutableArray array];

    scanner.charactersToBeSkipped = nil;
    while(![scanner isAtEnd]) {
        NSUInteger startLocation = scanner.scanLocation;
        for(NSString*operator in self.operators) {
            if ([scanner scanString:operator intoString:NULL]) {
                [tokens addObject:[Token operator:operator]];
            }
        }
        NSString *result = nil;
        if ([scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&result]) {
            NSString *rest = nil;
            [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&rest];
            NSString *value = [result stringByAppendingString:rest ?: @""];
            Token *token = islower([value characterAtIndex:0]) ? [Token identifier:value] : [Token classIdentifier:value];
            [tokens addObject:token];
        }
        double doubleResult = 0;
        if ([scanner scanDouble:&doubleResult]) {
            [tokens addObject:@(doubleResult)];
        }
        [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:NULL];
        NSAssert(scanner.scanLocation != startLocation, @"Should have made progress: %lu", scanner.scanLocation);
    }
    return tokens;
}
@end

@implementation Token

- (id)initWithValue:(id)value type:(TokenType)type
{
    self = [super init];
    if (self) {
        self.value = value;
        self.type=type;
    }
    return self;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"%d", self.type];
    [description appendString:[self.value description] ];
    [description appendString:@">"];
    return description;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
            return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
            return NO;
    }

    return [self isEqualToToken:other];
}

- (BOOL)isEqualToToken:(Token *)token
{
    if (self == token) {
            return YES;
    }
    if (token == nil) {
            return NO;
    }
    if (self.value != token.value && ![self.value isEqual:token.value]) {
            return NO;
    }
    if (self.type != token.type) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash
{
    return [self.value hash];
}

+ (id)identifier:(NSString *)value
{
    return [[self alloc] initWithValue:value type:(TokenTypeIdentifier)];
}

+ (instancetype)classIdentifier:(NSString *)value
{
    return [[self alloc] initWithValue:value type:(TokenTypeClassIdentifier)];
}

+ (instancetype)operator:(NSString *)value
{
    return [[self alloc] initWithValue:value type:(TokenTypeOperator)];
}

@end
