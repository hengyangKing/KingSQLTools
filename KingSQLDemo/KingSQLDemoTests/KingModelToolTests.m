//
//  KingModelToolTests.m
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KingModelTool.h"
#import "KingSqliteModelTool.h"
#import "Person.h"
@interface KingModelToolTests : XCTestCase

@end

@implementation KingModelToolTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
-(void)testClassIvarName{
    NSDictionary *dic= [KingModelTool classIvarNameTypeDic:[Person class]];
    NSLog(@"dic=%@",dic);
    
}

-(void)testClassSQLIvarName{
    
    NSDictionary *dic= [KingModelTool classIvarNameSqliteTypeDic:[Person class]];
    NSLog(@"dic=%@",dic);
    
}

-(void)testCreateTable {
    BOOL result = [KingSqliteModelTool  createTable:[Person class] andUserId:nil];
    XCTAssertEqual(result, YES);
}


@end
