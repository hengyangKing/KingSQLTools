//
//  KingSqliteModelTool+Query.m
//  KingSQLDemo
//
//  Created by J on 2017/6/21.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingSqliteModelTool+Query.h"
#import "KingBaseTool.h"
#import "KingSqliteTool.h"
#import "KingModelTool.h"
@implementation KingSqliteModelTool (Query)
+(NSArray *)queryAllModels:(Class)cls andUserId:(NSString *)uid
{
    NSString *tableName=[KingBaseTool tableName:cls];
    NSString *sql=[NSString stringWithFormat:@"select * from %@",tableName];
    NSArray <NSDictionary *>*results=[KingSqliteTool querySql:sql andUserId:uid];
    return [self parseResults:results withClass:cls];
}

+(NSArray *)queryModels:(Class)cls columnName:(NSString *)columnName andRelationType:(KingSqliteToolRelationType)relationType andValue:(id)value andUserId:(NSString *)uid
{
    NSString *tableName=[KingBaseTool tableName:cls];
    NSString *sql=[NSString stringWithFormat:@"select * from %@ where %@ %@ '%@'",tableName,columnName,self.relationTypeSQLRelation[@(relationType)],value];
    NSArray <NSDictionary *> *results=[KingSqliteTool querySql:sql andUserId:uid];
    return [self parseResults:results withClass:cls];
}

+(NSArray *)queryModels:(Class)cls withSQL:(NSString *)sql  andUserId:(NSString *)uid
{
    NSArray <NSDictionary *> *results=[KingSqliteTool querySql:sql andUserId:uid];
    return [self parseResults:results withClass:cls];
}

#pragma mark private
+(NSArray *)parseResults:(NSArray <NSDictionary *>*)results withClass:(Class)cls
{
    NSMutableArray *models=[NSMutableArray array];
    NSDictionary *nameTypeDic=[KingModelTool classIvarNameTypeDic:cls];
    for (NSDictionary *modelDic in results) {
        id model=[[cls alloc]init];
        [models addObject:model];
        
        [modelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *type=nameTypeDic[key];
            id resultValue=obj;
            if ([type isEqualToString:@"NSArray"]||[type isEqualToString:@"NSDictionary"]) {
                NSData *data=[obj dataUsingEncoding:NSUTF8StringEncoding];
                //转换成不可变
                resultValue=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
            }else if ([type isEqualToString:@"NSMutableArray"]||[type isEqualToString:@"NSMutableDictionary"])
            {
                NSData *data=[obj dataUsingEncoding:NSUTF8StringEncoding];
                //转换可变
                resultValue=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            }
            [model setValue:resultValue forKeyPath:key];
        }];
    } 
    return models;
}


@end
