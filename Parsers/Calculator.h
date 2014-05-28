//
// Created by chris on 07.05.14.
//

#import <Foundation/Foundation.h>

@class ParsingError;


@interface Calculator : NSObject


- (id)parseExpression:(NSArray *)tokens error:(ParsingError **)error;
@end
