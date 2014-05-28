//
// Created by chris on 10.01.14.
//

#import "Parser.h"
#import "ParsingError.h"

@interface Parser ()

@property (nonatomic, strong) id<Tokens> tokens;
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
        if (strongSelf.failed) return strongSelf;
        NSString* peek = strongSelf.peek;
        if ([token isEqual:peek]) {
            return [strongSelf next:peek];
        } else {
            NSString* msg = [NSString stringWithFormat:@"Expected '%@', saw '%@'", token, peek];
            return [strongSelf fail:msg];
        }
    };
    
    self.identifier = ^() {
        Parser *strongSelf = weakSelf;
        if (strongSelf.failed) return strongSelf;

        NSString* peek = strongSelf.peek;
        NSCharacterSet *characterSet = [NSCharacterSet letterCharacterSet];
        if([peek isKindOfClass:NSString.class] && [characterSet characterIsMember:[peek characterAtIndex:0]]) {
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
        if (strongSelf.failed) return strongSelf;
        block(strongSelf.result);
        return strongSelf;
    };

    self.many = ^(Rule block) {
        Parser *strongSelf = weakSelf;
        if (strongSelf.failed) return strongSelf;
        
        NSMutableArray *results = [NSMutableArray array];
        Parser *lastSuccessfulState = strongSelf;
        for(Parser * step = block(lastSuccessfulState); !step.failed; ) {
            [results addObject:step.result];
            lastSuccessfulState = step;
            step = block(lastSuccessfulState);
        }
        return [lastSuccessfulState updateWithResult:results];
    };

    self.manySepBy = ^(Rule block, Rule separator) {
        Parser *strongSelf = weakSelf;
        if (strongSelf.failed) return strongSelf;
        
        NSMutableArray *results = [NSMutableArray array];
        Parser *lastSuccessfulState = strongSelf;
        for(Parser * step = block(lastSuccessfulState); !step.failed; ) {
            [results addObject:step.result];
            lastSuccessfulState = step;
            step = separator(lastSuccessfulState).rule(block);
        }
        return [lastSuccessfulState updateWithResult:results];
    };

    self.optional = ^(Rule block) {
        Parser *strongSelf = weakSelf;
        if (strongSelf.failed) return strongSelf;
        Parser *step = block(strongSelf);
        if (step.failed) {
            return strongSelf;
        } else {
            return step;
        }
    };
    self.rule = ^(Rule block) {
        assert(block);
        Parser *strongSelf = weakSelf;
        if (strongSelf.failed) return strongSelf;

        return block(weakSelf);
    };
    self.eof = ^{
        Parser *strongSelf = weakSelf;
        if (strongSelf.failed) return strongSelf;

        BOOL atEnd = strongSelf.tokenIndex == strongSelf.tokens.count;
        return atEnd ? strongSelf : [strongSelf fail:[NSString stringWithFormat:@"Expected EOF, saw: '%@'", strongSelf.peek]];
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
        if (strongSelf.failed) return strongSelf;

        NSString *peek = strongSelf.peek;
        if ([peek isKindOfClass:[NSNumber class]]) {
            return [strongSelf next:peek];
        }
        NSString* msg = [NSString stringWithFormat:@"Expected a number, saw '%@'", peek];
        return [strongSelf fail:msg];
    };
    self.tokenWithCondition = ^(BOOL(^condition)(id)){
        Parser *strongSelf = weakSelf;
        if (strongSelf.failed) return strongSelf;

        id peek = strongSelf.peek;
        if (condition(peek)) {
            return [strongSelf next:peek];
        } else {
            return [strongSelf fail:@"Expected something else"]; // TODO improve error message
        }
    };
}


+ (instancetype)parserWithTokens:(id <Tokens>)tokens
{
    Parser *state = [[self alloc] init];
    state.tokens = tokens;
    state.tokenIndex = 0;
    [state setupBlocks];

    return state;
}



- (id)copy
{
    Parser *copy = [[[self class] alloc] init];

    if (copy != nil) {
        copy.tokens = [self.tokens copy];
        copy.tokenIndex = self.tokenIndex;
        copy.result = self.result;
        copy.failed = self.failed;
        copy.errorMessage = self.errorMessage;
        [copy setupBlocks]; // TODO: can this be removed?
    }

    return copy;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    for (NSString* propertyName in @[@"tokens", @"tokenIndex", @"result", @"failed", @"errorMessage"]) {
        id value = [self valueForKey:propertyName];
        [description appendFormat:@"%@ = %@", propertyName, value];
        [description appendString:@", "];
    }
    [description appendString:@">"];
    return description;
}


- (ParsingError *)error
{
    return [ParsingError errorWithMessage:self.errorMessage location:[self.tokens sourceLocationOfTokenAtIndex:self.tokenIndex]];
}
@end