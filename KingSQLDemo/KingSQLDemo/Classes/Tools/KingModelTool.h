//
//  KingModelTool.h
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KingBaseTool.h"
@interface KingModelTool : KingBaseTool

/**
 得到所有的成员变量 以及成员变量对应的类型

 @param cls 类
 @return 得到所有的成员变量 以及成员变量对应的类型
 */
+(NSDictionary *)classIvarNameTypeDic:(Class)cls;

/**
 得到所有的成员变量 以及成员变量映射到sql保存的对应类型
 
 @param cls 类
 @return 得到所有的成员变量 以及成员变量对应的类型
 */
+(NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls;

/**
 得到构建表sql类型表名称

 @param cls 类名称
 @return 返回字符串
 */
+(NSString *)columnNameAndTypesStr:(Class)cls;


/**
 得到所有该模型排序后的所有属性名称数组

 @return 返回排序后的所有属性名称数组
 */
+(NSArray *)allTableSortedIvarNames:(Class)cls;

@end
