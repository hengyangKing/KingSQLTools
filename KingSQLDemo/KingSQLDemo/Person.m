//
//  Person.m
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "Person.h"

@implementation Person
+ (NSString *)primaryKey
{
    return @"num";
}
+(NSArray <NSString *>*)ignoreColumnNames{

    return @[@"score"];
}
+(NSDictionary *)newNameToPreviousName
{
    return @{@"age":@"Age"};
}
@end
