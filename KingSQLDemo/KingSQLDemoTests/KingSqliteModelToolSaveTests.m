//
//  KingSqliteModelToolSaveTests.m
//  KingSQLDemo
//
//  Created by J on 2017/6/21.
//  Copyright © 2017年 J. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KingSqliteModelTool+Save.h"
#import "Person.h"

@interface KingSqliteModelToolSaveTests : XCTestCase

@end

@implementation KingSqliteModelToolSaveTests

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
-(void)testUpDataTable {
    BOOL result = [KingSqliteModelTool upDataTable:[Person class] andUserId:nil];
    XCTAssertEqual(result, YES);
    
}
-(void)testSaveModel {
    
    for (NSInteger i=0; i<10; i++) {
        
        Person *person=[Person createPersonWithNum:i andName:[NSString stringWithFormat:@"name_%@",@(i)] andAge:arc4random_uniform(4)+15+i andScore:arc4random_uniform(60)+i];
        [KingSqliteModelTool saveOrUpdateModel:person andUserId:@"3"];
    }
}
-(void)testSaveAndUpdateModel
{
    Person *person=[Person createPersonWithNum:1 andName:[NSString stringWithFormat:@"name_%@",@(666)] andAge:99 andScore:998];
    person.dic=@{@"key":@"value",@"key1":@"value1"}.mutableCopy;
    person.arr=@[@(1)].mutableCopy;
    BOOL result =[KingSqliteModelTool saveOrUpdateModel:person andUserId:@"3"];
    XCTAssertEqual(result, YES);
}

@end
