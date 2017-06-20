//
//  KingSqliteModelToolTests.m
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KingSqliteModelTool.h"
#import "Person.h"
@interface KingSqliteModelToolTests : XCTestCase

@end

@implementation KingSqliteModelToolTests

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

-(void)testIsTableRequiredUpdateClass {
    
    BOOL result = [KingSqliteModelTool isTableRequiredUpdateClass:[Person class] andUserId:@"1"];
    XCTAssertEqual(result, YES);
    
}

-(void)testUpDataTable {
    BOOL result = [KingSqliteModelTool upDataTable:[Person class] andUserId:nil];
    XCTAssertEqual(result, YES);

}

-(void)testSaveModel {
    
    for (NSInteger i=0; i<10; i++) {
        
        Person *person=[Person createPersonWithNum:i andName:[NSString stringWithFormat:@"name_%@",@(i)] andAge:arc4random_uniform(4)+15+i andScore:arc4random_uniform(60)+i];
        
        [KingSqliteModelTool saveModel:person andUserId:@"3"];
    }
}
-(void)testUpDateModel
{
    Person *person=[Person createPersonWithNum:1 andName:[NSString stringWithFormat:@"name_%@",@(666)] andAge:99 andScore:998];
    BOOL result =[KingSqliteModelTool saveModel:person andUserId:@"2"];
    XCTAssertEqual(result, YES);
    
}
-(void)testDeleteModel
{
    Person *person=[Person createPersonWithNum:1 andName:[NSString stringWithFormat:@"name_%@",@(666)] andAge:99 andScore:998];
    BOOL result =[KingSqliteModelTool deleteModel:person andUserId:@"2"];
    XCTAssertEqual(result, YES);

}
-(void)testDeleteModelForWhere{

    BOOL result =[KingSqliteModelTool deleteModel:[Person class] whereStr:@"age<17" andUserId:@"3"];
    XCTAssertEqual(result, YES);


}
-(void)testDeleteModelForRelation{
    BOOL result=[KingSqliteModelTool deleteModel:[Person class] columnName:@"age" andRelationType:(KingSqliteToolRelationTypeIsLess) andValue:@(17) andUserId:@"2"];
    
    XCTAssertEqual(result, YES);
}

-(void)testDeleteModelForRelations{
    
    BOOL result= [KingSqliteModelTool deleteModels:[Person class] columnNames:@[@"num",@"age"] andRelationTypes:@[@(KingSqliteToolRelationTypeIsLess),@(KingSqliteToolRelationTypeIsGreater)] andValues:@[@(4),@(20)] andNexusTypes:@[@(KingSqliteToolNexusTypeIsAnd)] andUserId:@"2"];
    XCTAssertEqual(result, YES);
}





@end
