//
//  KingModelToolProtocol.h
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KingModelToolProtocol <NSObject>
/**
 返回sql需要的主查询键
 @return 主键字符串
 */
+ (NSString *)primaryKey;



@optional
/**
 返回不需要计入表的字段名称数组
 
 @return 装有属性变量的数组
 */
+(NSArray<NSString *> *)ignoreColumnNames;


@end
