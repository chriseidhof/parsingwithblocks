//
// Created by chris on 28.05.14.
//

#import "ParsingError.h"

@interface ParsingError ()

@property (nonatomic,copy) NSString* message;
@property (nonatomic,assign) NSUInteger location;

@end

@implementation ParsingError

- (instancetype)initWithMessage:(NSString *)message location:(NSUInteger)location
{
    self = [super init];
    if (self) {
        _message = message;
        _location = location;
    }

    return self;
}

+ (instancetype)errorWithMessage:(NSString *)message location:(NSUInteger)location
{
    return [[self alloc] initWithMessage:message location:location];
}

- (id)copyWithZone:(NSZone *)zone
{
    ParsingError *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->_message = _message;
        copy->_location = _location;
    }

    return copy;
}


- (BOOL)isEqual:(id)other
{
    if (other == self) {
            return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
            return NO;
    }

    return [self isEqualToError:other];
}

- (BOOL)isEqualToError:(ParsingError *)error
{
    if (self == error) {
            return YES;
    }
    if (error == nil) {
            return NO;
    }
    if (self.message != error.message && ![self.message isEqualToString:error.message]) {
            return NO;
    }
    if (self.location != error.location) {
            return NO;
    }
    return YES;
}

- (NSUInteger)hash
{
    NSUInteger hash = [self.message hash];
    hash = hash * 31u + self.location;
    return hash;
}


- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.message=%@", self.message];
    [description appendFormat:@", self.location=%lu", self.location];
    [description appendString:@">"];
    return description;
}


@end
