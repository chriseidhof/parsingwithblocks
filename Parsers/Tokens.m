//
// Created by chris on 28.05.14.
//

#import "Tokens.h"

@interface Tokens ()
@property (nonatomic,copy) NSArray *tokens;
@property (nonatomic,copy) NSArray *tokenIndices;
@end

@implementation Tokens

- (instancetype)initWithTokens:(NSArray *)tokens tokenIndices:(NSArray *)tokenIndices
{
    NSParameterAssert(tokens.count == tokenIndices.count);
    self = [super init];
    if (self) {
        _tokens = tokens;
        _tokenIndices = tokenIndices;
    }

    return self;
}

+ (instancetype)tokensWithTokens:(NSArray *)tokens tokenIndices:(NSArray *)tokenIndices
{
    return [[self alloc] initWithTokens:tokens tokenIndices:tokenIndices];
}

- (NSUInteger)count
{
    return self.tokens.count;
}

- (NSUInteger)sourceLocationOfTokenAtIndex:(NSUInteger)idx
{
    return [self.tokenIndices[idx] unsignedIntegerValue];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return self.tokens[idx];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


@end
