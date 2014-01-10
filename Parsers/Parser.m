//
// Created by chris on 10.01.14.
//

#import "Parser.h"
#import "NSObject+Properties.h"
#import "NSArray+Extras.h"

@interface Parser ()

@property (nonatomic, strong) NSArray *tokens;
@property (nonatomic) NSUInteger tokenIndex;

@end

@implementation Parser

- (id)init
{
    self = [super init];
    if (self) {
    }

    return self;
}

- (Parser *)next:(id)result
{
    if (self.failed) return self;
    Parser *next = [self copy];
    next.failed = NO;
    next.result = result;
    next.tokenIndex++;
    return next;
}

- (instancetype)fail:(NSString *)msg
{
    Parser *state = [self copy];
    state.failed = YES;
    state.errorMessage = msg;
    return state;
}

- (instancetype)updateWithResult:(id)value
{
    if(self.failed) return self;
    
    Parser *state = [self copy];
    state.result = value;
    return state;
}


- (NSString *)peek
{
    if (self.tokenIndex >= self.tokens.count) return nil;
    return self.tokens[self.tokenIndex];
}

typedef id(^YieldBlock)();


- (void)setupBlocks
{
    __weak id weakSelf = self;
    self.token = ^(NSString* token) {
        Parser *strongSelf = weakSelf;
        NSString* peek = strongSelf.peek;
        if ([token isEqualToString:peek]) {
            return [strongSelf next:peek];
        } else {
            NSString* msg = [NSString stringWithFormat:@"Expected '%@', saw '%@'", token, peek];
            return [strongSelf fail:msg];
        }
    };
    
    self.identifier = ^() {
        Parser *strongSelf = weakSelf;
        NSString* peek = strongSelf.peek;
        NSCharacterSet *characterSet = [NSCharacterSet letterCharacterSet];
        if([characterSet characterIsMember:[peek characterAtIndex:0]]) {
            return [strongSelf next:peek];
        } else {
            return [strongSelf fail:@"Expected identifier"];
        }
    };

    self.yield = ^(YieldBlock block){
        Parser *strongSelf = weakSelf;
        id result = strongSelf.failed ? nil : block();
        id updated = [strongSelf updateWithResult:result];
        return updated;
    };

    self.bind = ^(void(^block)(id)){
        Parser *strongSelf = weakSelf;
        block(strongSelf.result);
        return strongSelf;
    };

    self.many = ^(Rule block) {
        Parser *strongSelf = weakSelf;
        NSMutableArray *results = [NSMutableArray array];
        Parser *lastSuccessfulState = strongSelf;
        for(Parser * step = block(lastSuccessfulState); !step.failed; ) {
            [results addObject:step.result];
            lastSuccessfulState = step;
            step = block(lastSuccessfulState);
        }
        return [lastSuccessfulState updateWithResult:results];
    };

    self.optional = ^(Rule block) {
        Parser *strongSelf = weakSelf;
        Parser *step = block(strongSelf);
        if (step.failed) {
            return [strongSelf updateWithResult:nil];
        } else {
            return step;
        }
    };
    self.rule = ^(Rule block) {
        return block(weakSelf);
    };
    self.eof = ^{
        BOOL atEnd = self.tokenIndex == self.tokens.count;
        return atEnd ? self : [self fail:[NSString stringWithFormat:@"Expected EOF, saw: %@", self.peek]];
    };
    self.map = ^( id (^block)(id) ) {
        Parser *strongSelf = weakSelf;
        return [strongSelf updateWithResult:strongSelf.failed ? nil : block(strongSelf.result)];
    };
    self.oneOf = ^(NSArray *opts) {
        assert(opts.count > 0);
        Parser *strongSelf = weakSelf;
        Parser *result = nil;
        for(Rule rule in opts) {
            result = rule(strongSelf);
            if (!result.failed) break;
        }
        return result;
    };
    self.number = ^{
        Parser *strongSelf = weakSelf;
        NSString *peek = strongSelf.peek;
        if ([peek isEqualToString:@"0"] || peek.doubleValue != 0) { // TODO: check if all of it is numeric.
            return [strongSelf next:@(peek.doubleValue)];
        }
        NSString* msg = [NSString stringWithFormat:@"Expected a number, saw %@", peek];
        return [strongSelf fail:msg];
    };
}


+ (instancetype)stateWithTokens:(NSArray *)array
{
    Parser *state = [[self alloc] init];
    state.tokens = array;
    state.tokenIndex = 0;
    [state setupBlocks];

    return state;
}



- (id)copyWithZone:(NSZone *)zone
{
    Parser *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        [self copyAllPropertiesTo:copy];
        [copy setupBlocks];
    }

    return copy;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    for (NSString* propertyName in self.propertyNames) {
        id value = [self valueForKey:propertyName];
        [description appendFormat:@"%@ = %@", propertyName, value];
        [description appendString:@", "];
    }
    [description appendString:@">"];
    return description;
}


@end

#pragma mark Helper methods

Rule (^optionsWithDictionary)(NSDictionary*) = ^(NSDictionary *dict) {
    NSArray* recognizers = [dict.allKeys map:^id(NSString* name)  {
        return ^(Parser *s) {
            return s.token(name).map(^(id key){ return dict[key];});
        };
    }];
    return ^(Parser *p) {
        return p.oneOf(recognizers);
    };
};