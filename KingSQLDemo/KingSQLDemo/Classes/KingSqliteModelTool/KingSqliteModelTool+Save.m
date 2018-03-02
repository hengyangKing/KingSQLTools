//
//  KingSqliteModelTool+Save.m
//  KingSQLDemo
//
//  Created by J on 2017/6/21.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingSqliteModelTool+Save.h"
#import "KingModelTool.h"
#import "KingSqliteTool.h"
#import "KingTableTool.h"
#import "KingModelToolProtocol.h"
@implementation KingSqliteModelTool (Save)
#pragma mark SAVE UPDATE
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
            //查找映射的旧字段名称
            previousName=updateNames[columnName];
        }
        //若不包含新的列名，且同时不包含旧列名
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


/**
 保存model/已经存在, 更新
 
 @param model model
 @param uid uid
 @return 返回结果
 */
+(BOOL)saveOrUpdateModel:(id)model andUserId:(NSString *)uid
{
    Class cls=[model class];
    //    判断表格是否存在
    if (![KingTableTool isTableExists:cls UserId:uid]) {
        if ([self createTable:cls andUserId:uid]) {
            NSLog(@"建表失败");
            return NO;
        }
    }
    //    表格是否需要更新
    if ([KingTableTool isTableRequiredUpdateClass:cls andUserId:uid]) {
        if (![self upDataTable:cls andUserId:uid]) {
            NSLog(@"更新数据库字段名失败");
            return NO;
        }
    }
    //    判断记录是否存在主键
    NSString *tableName=[KingBaseTool tableName:cls];
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [[model class] primaryKey];
    id primaryValue=[model valueForKeyPath:primaryKey];
    
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    
    NSArray *result = [KingSqliteTool querySql:checkSql andUserId:uid];
    
    //    字段名称数组
    NSArray *columnNames=[KingModelTool classIvarNameTypeDic:cls].allKeys;
    //    值数组
    // 值
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        
        id value = [model valueForKeyPath:columnName];
        if ([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSDictionary class]]) {
            //            字符串化
            NSData *data=[NSJSONSerialization dataWithJSONObject:value options:(NSJSONWritingPrettyPrinted) error:nil];
            value=[[NSString alloc]initWithData:data encoding:(NSUTF8StringEncoding)];
        }
        [values addObject:value];
    }
    NSUInteger count=columnNames.count;
    NSMutableArray *setValueArray=[NSMutableArray array];
    for (NSInteger i=0; i<count; i++) {
        NSString *name=columnNames[i];
        id value =values[i];
        NSString *setStr=[NSString stringWithFormat:@"%@='%@'",name,value];
        [setValueArray addObject:setStr];
    }
    
    //更新
    NSString *execSql=@"";
    if (result.count>0) {
        execSql = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'", tableName, [setValueArray componentsJoinedByString:@","], primaryKey, primaryValue];
    }else{
        execSql=[NSString stringWithFormat:@"insert into %@(%@) values ('%@')", tableName, [columnNames componentsJoinedByString:@","], [values componentsJoinedByString:@"','"]];
    }
    return  [KingSqliteTool dealSql:execSql andUserId:uid];
}

@end
