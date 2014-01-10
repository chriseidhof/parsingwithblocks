//
// Created by chris on 10.01.14.
//

#import <Foundation/Foundation.h>


/*

Example usage:

    NSString *constraintString = @"viewOne.centerX *2 >= viewTwo.centerX + 10";
    NSArray* tokens = [Lexer lex:constraintString];
    ConstraintParser *parser = [[ConstraintParser alloc] init];
    id viewOne = [NSView new];
    id viewTwo = [NSTextView new];
    NSLayoutConstraint* constraint = [parser parseConstraint:tokens views:NSDictionaryOfVariableBindings(viewOne,viewTwo)]);

 */

@interface ConstraintParser : NSObject

- (NSLayoutConstraint *)parseConstraint:(NSArray *)tokens views:(NSDictionary*)views;

@end
