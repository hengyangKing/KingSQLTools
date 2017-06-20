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
+(void)saveModel:(id)model
{
    
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
    NSString *createTableSql=[NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tmpTableName, [KingModelTool columnNameAndTypesStr:cls], primaryKey];
    [sqls addObject:createTableSql];
    
        
    //根据主键插入数据
    NSString *insertPrimaryKey=[NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;",tmpTableName,primaryKey,primaryKey,tableName];
    //根据主键 把所有的数据更新进新表
    [sqls addObject:insertPrimaryKey];

    //老表键值
    NSArray *previousNames=[KingTableTool tableSortedColumnNames:cls UserId:uid];
    
    NSArray *newNames=[KingModelTool allTableSortedIvarNames:cls];
    
    for (NSString *columnName in newNames) {
        if (![previousNames containsObject:columnName]) {
            continue;
        }
        NSString *updateSql=[NSString stringWithFormat:@"update %@ set %@ =(select %@ from %@ where %@.%@ = %@.%@)",tmpTableName,columnName,columnName,tableName,tmpTableName,primaryKey,tableName,primaryKey];
        [sqls addObject:updateSql];

    }
    
    //删除老表
    NSString *deletePreviousTable=[NSString stringWithFormat:@"drop table if exsts %@",tableName];
    [sqls addObject:deletePreviousTable];
    
    //临时表改名
    NSString *renameTableName=[NSString stringWithFormat:@"alter table %@ rename to %@",tmpTableName,tableName];
    [sqls addObject:renameTableName];
    
    //批量执行
    return [KingSqliteTool dealSqls:sqls andUserId:uid];
}
@end
