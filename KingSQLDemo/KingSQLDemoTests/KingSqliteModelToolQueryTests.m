//
//  KingSqliteModelToolQueryTests.m
//  KingSQLDemo
//
//  Created by J on 2017/6/21.
//  Copyright © 2017年 J. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KingSqliteModelTool+Query.h"
#import "Person.h"
@interface KingSqliteModelToolQueryTests : XCTestCase

@end

@implementation KingSqliteModelToolQueryTests

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
-(void)testQuery{

    NSArray *array=[KingSqliteModelTool queryAllModels:[Person class] andUserId:@"3"];
    for (Person *person in array) {
        NSLog(@"num===%@",person.arr);
    }
}

@end
