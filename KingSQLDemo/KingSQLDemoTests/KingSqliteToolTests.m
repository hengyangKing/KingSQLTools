//
//  KingSqliteToolTests.m
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KingSqliteTool.h"
#import "Person.h"
@interface KingSqliteToolTests : XCTestCase

@end

@implementation KingSqliteToolTests

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
- (void)testDeal {
    NSString *sql=@"create table if not exists t_stu(id integer primary key autoincrement,name text not null,age integer,score real)";
    BOOL result = [KingSqliteTool dealSql:sql andUserId:nil];
    XCTAssertEqual(result, YES);

}
-(void)testQuery {
    NSString *sql=@"select *from t_stu";
    NSMutableArray *result=[KingSqliteTool querySql:sql andUserId:@"1"];
    
    XCTAssertEqual(result, NULL);
    NSMutableArray *result2=[KingSqliteTool querySql:sql andUserId:nil];
    NSLog(@"result2==%@",result2);
}




@end
