//
//  Person.m
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "Person.h"

@implementation Person
+(instancetype)createPersonWithNum:(NSInteger)num andName:(NSString *)name andAge:(NSInteger)age andScore:(float)score
{
    Person *men=[[Person alloc]init];
    men.num=num;
    men.name=name;
    men.age=age;
    men.score=score;
    return men;
}

#pragma mark sqlDelegate
+ (NSString *)primaryKey
{
    return @"num";
}
+(NSArray <NSString *>*)ignoreColumnNames{

    return @[@"score"];
}
//新字段名称--->旧字段名称的映射
+(NSDictionary *)newNameToPreviousName
{
    return @{@"arr":@"",@"dic":@""};
}
@end
