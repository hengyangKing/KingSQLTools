//
//  KingSqliteModelTool+Delete.h
//  KingSQLDemo
//
//  Created by J on 2017/6/21.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingSqliteModelTool.h"

@interface KingSqliteModelTool (Delete)
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
