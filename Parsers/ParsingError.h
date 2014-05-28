//
// Created by chris on 28.05.14.
//

#import <Foundation/Foundation.h>


@interface ParsingError : NSObject <NSCopying>

@property (nonatomic,copy,readonly) NSString* message;
@property (nonatomic,assign,readonly) NSUInteger location;

- (instancetype)initWithMessage:(NSString *)message location:(NSUInteger)location;
+ (instancetype)errorWithMessage:(NSString *)message location:(NSUInteger)location;

@end
