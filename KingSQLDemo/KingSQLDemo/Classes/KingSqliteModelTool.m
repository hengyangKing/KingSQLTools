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
#import "KingTableTool.h"
#import "KingModelToolProtocol.h"
@implementation KingSqliteModelTool
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
/**
 表格是否需要更新
 */
+(BOOL)isTableRequiredUpdateClass:(Class)cls andUserId:(NSString *)uid
{
    NSArray *modelKeys= [KingModelTool allTableSortedIvarNames:cls];
    
    NSArray *tableKeys= [KingTableTool tableSortedColumnNames:cls UserId:uid];
    
    return ![modelKeys isEqualToArray:tableKeys];
    
}

/**
 更新表格
 */
+(BOOL)upDataTable:(Class )cls andUserId:(NSString *)uid
{
//    1.创建一个拥有正确结构的临时表
    NSString *tmpTableName=[KingBaseTool tmpTableName:cls];
    
    NSString *tableName=[KingBaseTool tableName:cls];

    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    
    NSMutableArray *sqls=[NSMutableArray array];
    
    //获取模型内所有的字段
    NSString *createTableSql=[NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTableName, [KingModelTool columnNameAndTypesStr:cls], primaryKey];
    [sqls addObject:createTableSql];
    
    
    //根据主键插入数据
    NSString *insertPrimaryKey=[NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, tableName];
    //根据主键 把所有的数据更新进新表
    [sqls addObject:insertPrimaryKey];

    //老表键值
    NSArray *previousNames=[KingTableTool tableSortedColumnNames:cls UserId:uid];
    
    NSArray *newNames=[KingModelTool allTableSortedIvarNames:cls];
    
    
    //获取变更名称的字典
    NSDictionary *updateNames=@{};
    if ([cls respondsToSelector:@selector(newNameToPreviousName)]) {
        updateNames=[cls newNameToPreviousName];
    }
    
    
    for (NSString *columnName in newNames) {
        NSString *previousName=columnName;
        if ([updateNames[columnName] length]!=0) {
            //老字段名称有值
            previousName=updateNames[columnName];
        }
//        若不包含新的列名，且同时不包含旧列名
        if ((![previousNames containsObject:columnName] &&![previousNames containsObject:previousName])||[columnName isEqualToString:primaryKey]) {
            continue;
        }
        
        
        NSString *updateSql=[NSString stringWithFormat:@"update %@ set %@ =(select %@ from %@ where %@.%@ = %@.%@);",tmpTableName,columnName,previousName,tableName,tmpTableName,primaryKey,tableName,primaryKey];
        [sqls addObject:updateSql];
    }
    
    
    //删除老表
    NSString *deletePreviousTable=[NSString stringWithFormat:@"drop table if exists %@;", tableName];
    [sqls addObject:deletePreviousTable];
    
    //临时表改名
    NSString *renameTableName=[NSString stringWithFormat:@"alter table %@ rename to %@;", tmpTableName, tableName];
    [sqls addObject:renameTableName];
    
    //批量执行
    return [KingSqliteTool dealSqls:sqls andUserId:uid];
}
// 保存/ 已经存在, 更新
+ (BOOL)saveModel:(id)model andUserId:(NSString *)uid
{
    // 1. 检查表是否需要更新, 如果需要, 更新,
    // 表如果没有, 创建
    BOOL result = [self createTable:[model class] andUserId:uid];
    
    if (!result) {
        NSLog(@"表格错误");
        return NO;
    }
    
    // 2. 判断, 当前表里面, 是否存在这条记录
    NSString *tableName=[KingBaseTool tableName:[model class]];
    
    if (![[model class] respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [[model class] primaryKey];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, [model valueForKeyPath:primaryKey]];
    
    NSArray *res = [KingSqliteTool querySql:sql andUserId:uid];
    
    
    // 字段
    NSArray *columnNames=[KingTableTool tableSortedColumnNames:[model class] UserId:uid];

    // 值
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        
        id value = [model valueForKeyPath:columnName];
        [values addObject:value];

    }

    if (res.count > 0) {
        // 存在, ->更新
        
        NSMutableArray *tempResult = [NSMutableArray array];
        for(int i = 0; i < columnNames.count; i++) {
            NSString *columnName = columnNames[i];
            id value = values[i];
            NSString *str = [NSString stringWithFormat:@"%@ = '%@'", columnName, value];
            [tempResult addObject:str];
        }
        
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'", tableName, [tempResult componentsJoinedByString:@","], primaryKey, [model valueForKeyPath:primaryKey]];
        
        return [KingSqliteTool dealSql:updateSql andUserId:uid];
        
    }else {
        // 不存在, 插入
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@(%@) values ('%@')", tableName, [columnNames componentsJoinedByString:@","], [values componentsJoinedByString:@"','"]];
        return [KingSqliteTool dealSql:insertSql andUserId:uid];
    }
}


@end
