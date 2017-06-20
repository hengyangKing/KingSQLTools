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
 返回需要忽略的字段名称数组
 
 @return 装有属性变量的数组
 */
+(NSArray<NSString *> *)ignoreColumnNames;


/**
 需要更名的字段名称映射
 新字段名称--->旧字段名称的映射
 若需新添加字段则为 @"foo":@"" 格式
 @return 返回新老字段名称映射
 */
+(NSDictionary *)newNameToPreviousName;



@end
