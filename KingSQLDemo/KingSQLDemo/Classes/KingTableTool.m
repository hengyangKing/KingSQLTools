//
//  KingTableTool.m
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingTableTool.h"
#import "KingSqliteTool.h"
@implementation KingTableTool
+(NSArray *)tableSortedColumnNames:(Class)cls UserId:(NSString *)uid
{
    if (!cls) {
        return nil;
    }
    NSString *tableName = [self tableName:cls];
    //查询系统表
    NSString *queryCreateSql=[NSString stringWithFormat:@"select sql from sqlite_master where type='table' and name= '%@'",tableName];
    
    NSMutableDictionary *resultDic= [KingSqliteTool querySql:queryCreateSql andUserId:uid].firstObject;
    NSString *createTable=[resultDic[@"sql"] lowercaseString];
    if (!createTable.length) {
        //该表不存在
        return nil;
    }
    createTable = [createTable stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    
    createTable = [createTable stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createTable = [createTable stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createTable = [createTable stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSString *nameType=[createTable componentsSeparatedByString:@"("][1];
    
    NSArray *nameTypeArray=[nameType componentsSeparatedByString:@","];
    NSMutableArray *names=[NSMutableArray array];
    for (NSString *nameType in nameTypeArray) {
        if ([nameType containsString:@"primary"]) {
            continue;
        }
        NSString *name=[[nameType componentsSeparatedByString:@" "] firstObject];
        [names addObject:name];
    }
    //排序
    [names sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    return names;
}
@end
