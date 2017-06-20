//
//  KingSqliteModelTool+Query.h
//  KingSQLDemo
//
//  Created by J on 2017/6/21.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingSqliteModelTool.h"

@interface KingSqliteModelTool (Query)

/**
 直接查询

 @param cls 表名称
 @param sql sql
 @param uid uid
 @return 结果
 */
+(NSArray *)queryModels:(Class)cls withSQL:(NSString *)sql  andUserId:(NSString *)uid;


/**
 条件查询

 @param cls 表名
 @param columnName 条件字段
 @param relationType 条件类型
 @param value 条件阀值
 @param uid uid
 @return 返回结果
 */
+(NSArray *)queryModels:(Class)cls columnName:(NSString *)columnName andRelationType:(KingSqliteToolRelationType)relationType andValue:(id)value andUserId:(NSString *)uid;

/**
 全量查询

 @param cls 表名称
 @param uid uid
 @return 返回全量
 */
+(NSArray *)queryAllModels:(Class)cls andUserId:(NSString *)uid;

@end
