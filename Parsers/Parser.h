//
// Created by chris on 10.01.14.
//

#import <Foundation/Foundation.h>

@class Parser;

typedef Parser *(^Rule)(Parser *state);


@interface Parser : NSObject

@property (nonatomic, copy) Parser *(^token)(NSString *);
@property (nonatomic, strong) id result;
@property (nonatomic) BOOL failed;
@property (nonatomic, copy) Parser *(^identifier)();
@property (nonatomic, copy) Parser *(^yield)(id (^)());
@property (nonatomic, copy) Parser *(^bind)(void(^)(id result));
@property (nonatomic, copy) Parser *(^many)(Rule);
@property (nonatomic, copy) Parser *(^optional)(Rule);
@property (nonatomic, copy) Parser * (^eof)();
@property (nonatomic, copy) Parser *(^rule)(Rule);
@property (nonatomic, copy) Parser *(^map)(id (^)(id));
@property (nonatomic, copy) Parser *(^oneOf)(NSArray *);
@property (nonatomic, copy) Parser *(^number)();

@property (nonatomic, copy) NSString *errorMessage;

+ (instancetype)stateWithTokens:(NSArray *)array;
- (NSString *)peek;

@end

extern Rule (^optionsWithDictionary)(NSDictionary*);