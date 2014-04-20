//
// Created by chris on 12.01.14.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TokenType) {
  TokenTypeIdentifier,
  TokenTypeClassIdentifier,
  TokenTypeOperator,
};

@interface Token : NSObject

@property (nonatomic) TokenType type;
@property (nonatomic) id value;

+ (instancetype)identifier:(NSString*)value;
+ (instancetype)classIdentifier:(NSString*)value;
+ (instancetype)operator:(NSString*)value;

@end

@interface SmalltalkLexer : NSObject


@property (nonatomic, strong) id <NSFastEnumeration> operators;
- (NSArray *)lex:(NSString *)string;
@end
