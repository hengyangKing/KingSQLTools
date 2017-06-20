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
 创建表

 @param cls 类名-->用作表名
 @param uid userid
 */
+(BOOL)createTable:(Class)cls andUserId:(NSString *)uid;


/**
 是否需要更新表

 @param cls 表名称
 @param uid uid
 @return 返回是否需要更新表
 */
+(BOOL)isTableRequiredUpdateClass:(Class)cls andUserId:(NSString *)uid;

/**
 更新表格

 @param cls 表名称
 @param uid uid
 @return 返回是否更新成功
 */
+(BOOL)upDataTable:(Class )cls andUserId:(NSString *)uid;


 /**
  保存/ 已经存在, 更新
  */
+ (BOOL)saveModel:(id)model andUserId:(NSString *)uid;


/**
 
 删除模型
 @param model model
 @param uid uid
 @return 返回是否更新成功
 */
+(BOOL)deleteModel:(id)model andUserId:(NSString *)uid;



/**
 删除模型遵守某种条件的条目

 @param cls 内部表名称
 @param wherestr 条件
 @param uid uid
 @return 返回是否更新成功
 */
+(BOOL)deleteModel:(Class)cls whereStr:(NSString *)wherestr andUserId:(NSString *)uid;




/**
 删除模型遵守某种条件的条目

 @param cls 表名称
 @param columnName 字段名
 @param relationType 条件
 @param uid uis
 @return 返回结果
 */
+(BOOL)deleteModel:(Class)cls columnName:(NSString *)columnName andRelationType:(KingSqliteToolRelationType)relationType andValue:(id)value andUserId:(NSString *)uid;


/**
 多条件关系删除表内数据
 @param cls class
 @param columnNames @[@"columnName",@"columnName"];
 @param relationTypes 条件内部关系@[@(relationType),@(relationType)];
 @param values @[id,id];
 @param nexusTypes 条件间关系@[@(nexusType),@(nexusType)];
 @param uid uid
 @return 返回结果
 */
+(BOOL)deleteModels:(Class)cls columnNames:(NSArray<NSString *>*)columnNames andRelationTypes:(NSArray<NSNumber *> *)relationTypes andValues:(NSArray <id>*)values andNexusTypes:(NSArray<NSNumber *> *)nexusTypes  andUserId:(NSString *)uid;
@end
