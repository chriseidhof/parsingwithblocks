//
//  AppDelegate.m
//  Parsers
//
//  Created by Chris Eidhof on 09.01.14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

#import "AppDelegate.h"
#import "Lexer.h"
#import "ConstraintParser.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *contents = @"viewOne.centerX *2 >= viewTwo.centerX + 10";
    NSArray* tokens = [Lexer lex:contents];
    ConstraintParser *parser = [[ConstraintParser alloc] init];
    id viewOne = [NSView new];
    id viewTwo = [NSTextView new];
    NSLog(@"constraint: %@", [parser parseConstraint:tokens views:NSDictionaryOfVariableBindings(viewOne,viewTwo)]);
}

@end
