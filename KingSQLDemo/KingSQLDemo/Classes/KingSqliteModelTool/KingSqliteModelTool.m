//
//  KingSqliteModelTool.m
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingSqliteModelTool.h"
#import "KingModelTool.h"
#import "KingSqliteTool.h"
#import "KingModelToolProtocol.h"
@implementation KingSqliteModelTool
#pragma mark Create
+(BOOL)createTable:(Class)cls andUserId:(NSString *)uid
{
    //表明
    NSString *tableName=[KingBaseTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];

    
    //获取模型内所有的字段
    NSString *createTableSql=[NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, [KingModelTool columnNameAndTypesStr:cls], primaryKey];
    
    // 2. 执行
    return [KingSqliteTool dealSql:createTableSql andUserId:uid];
}
#pragma mark Private
/**
 枚举 -> sql 逻辑运算符 映射表
 */
+ (NSDictionary *)relationTypeSQLRelation {
    
    return @{
             @(KingSqliteToolRelationTypeIsEqual) : @"=",
             @(KingSqliteToolRelationTypeIsGreater) : @">",
             @(KingSqliteToolRelationTypeIsLess) : @"<",
             @(KingSqliteToolRelationTypeIsEG) : @">=",
             @(KingSqliteToolRelationTypeIsEL) : @"<=",
             @(KingSqliteToolRelationTypeIsNotEqual) : @"!="
             };
}

+ (NSDictionary *)nexusTypeSQLRelation {
    
    return @{
             @(KingSqliteToolNexusTypeIsNot) : @"not",
             @(KingSqliteToolNexusTypeIsAnd) : @"and",
             @(KingSqliteToolNexusTypeIsOr) : @"or"
             };
}




@end
