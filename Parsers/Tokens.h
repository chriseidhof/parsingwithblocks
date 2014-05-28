//
// Created by chris on 28.05.14.
//

#import <Foundation/Foundation.h>
#import "Parser.h"


@interface Tokens : NSObject <Tokens>

+ (instancetype)tokensWithTokens:(NSArray *)tokens tokenIndices:(NSArray *)tokenIndices;

@end
