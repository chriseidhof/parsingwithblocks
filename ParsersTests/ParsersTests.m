//
//  ParsersTests.m
//  ParsersTests
//
//  Created by Chris Eidhof on 09.01.14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Parser.h"

@interface ParsersTests : XCTestCase

@end

@interface ParsersTests ()

@property (nonatomic, strong) Parser *parser;
@end

@implementation ParsersTests

- (void)setUp
{
    [super setUp];
    self.parser = [Parser parserWithTokens:@[]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmpty
{
    Parser *parser = self.parser.eof();
    XCTAssertFalse(parser.failed, @"eof Should succeed on an empty file");
}

@end
