//
// Created by chris on 10.01.14.
//

#import <Foundation/Foundation.h>

@protocol Tokens <NSObject, NSCopying>

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)sourceLocationOfTokenAtIndex:(NSUInteger)idx;
- (NSUInteger)count;
- (id)copy;

@end

@class Parser;
@class ParsingError;

typedef Parser *(^Rule)(Parser *p);


@interface Parser : NSObject

@property (nonatomic, strong) id result;
@property (nonatomic) BOOL failed;
@property (nonatomic, copy) NSString *errorMessage;

@property (nonatomic, copy) Parser *(^token)(NSString *);
@property (nonatomic, copy) Parser *(^identifier)();
@property (nonatomic, copy) Parser *(^yield)(id (^)());
@property (nonatomic, copy) Parser *(^bind)(void(^)(id result));
@property (nonatomic, copy) Parser *(^many)(Rule);
@property (nonatomic, copy) Parser *(^manySepBy)(Rule,Rule);
@property (nonatomic, copy) Parser *(^optional)(Rule);
@property (nonatomic, copy) Parser * (^eof)();
@property (nonatomic, copy) Parser *(^rule)(Rule);
@property (nonatomic, copy) Parser *(^map)(id (^)(id));
@property (nonatomic, copy) Parser *(^oneOf)(NSArray *);
@property (nonatomic, copy) Parser *(^number)();
@property (nonatomic, copy) Parser * (^tokenWithCondition)(BOOL (^condition)(id));


+ (instancetype)parserWithTokens:(id <Tokens>)tokens;
- (NSString *)peek;

- (ParsingError *)error;
@end