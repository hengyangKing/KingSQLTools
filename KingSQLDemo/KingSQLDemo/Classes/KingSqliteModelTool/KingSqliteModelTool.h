//
//  KingSqliteModelTool.h
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

//描述条件内关系
typedef NS_ENUM(NSUInteger,KingSqliteToolRelationType){
    KingSqliteToolRelationTypeIsEqual,
    KingSqliteToolRelationTypeIsGreater,
    KingSqliteToolRelationTypeIsLess,
    KingSqliteToolRelationTypeIsEG,
    KingSqliteToolRelationTypeIsEL,
    KingSqliteToolRelationTypeIsNotEqual,
};
//描述条件间关系
typedef NS_ENUM(NSUInteger,KingSqliteToolNexusType){
    KingSqliteToolNexusTypeIsNot,
    KingSqliteToolNexusTypeIsAnd,
    KingSqliteToolNexusTypeIsOr,
};

@interface KingSqliteModelTool : NSObject
/**
 枚举 -> sql 内部逻辑运算符 映射表
 */
+ (NSDictionary *)relationTypeSQLRelation;

/**
 枚举 -> sql 外部逻辑运算符 映射表
 */

+ (NSDictionary *)nexusTypeSQLRelation;
/**
 创建表

 @param cls 类名-->用作表名
 @param uid userid
 */
+(BOOL)createTable:(Class)cls andUserId:(NSString *)uid;


@end
