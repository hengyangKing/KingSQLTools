//
//  KingSqliteModelTool+Delete.m
//  KingSQLDemo
//
//  Created by J on 2017/6/21.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingSqliteModelTool+Delete.h"
#import "KingModelTool.h"
#import "KingSqliteTool.h"
#import "KingTableTool.h"
#import "KingModelToolProtocol.h"
@implementation KingSqliteModelTool (Delete)
#pragma mark DELETE
+(BOOL)deleteModel:(id)model andUserId:(NSString *)uid
{
    NSString *tableName=[KingBaseTool tableName:[model class]];
    
    if (![[model class] respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [[model class] primaryKey];
    
    NSString *deleteSql=[NSString stringWithFormat:@"delete from %@ where %@ = '%@'",tableName,primaryKey,[model valueForKeyPath:primaryKey]];
    
    return [KingSqliteTool dealSql:deleteSql andUserId:uid];
    
}
+(BOOL)deleteModel:(Class)cls whereStr:(NSString *)wherestr andUserId:(NSString *)uid
{
    NSString *tableName=[KingBaseTool tableName:cls];
    NSString *deleteSql=[NSString stringWithFormat:@"delete from %@",tableName];
    if (wherestr.length) {
        deleteSql = [deleteSql stringByAppendingFormat:@" where %@",wherestr];
    }
    return [KingSqliteTool dealSql:deleteSql andUserId:uid];
}
+(BOOL)deleteModel:(Class)cls columnName:(NSString *)columnName andRelationType:(KingSqliteToolRelationType)relationType andValue:(id)value andUserId:(NSString *)uid
{
    
    NSString *relation=[self.relationTypeSQLRelation objectForKey:[NSNumber numberWithInteger:relationType]];
    
    NSString *where=[NSString stringWithFormat:@"%@ %@ %@",columnName,relation,value];
    return [self deleteModel:cls whereStr:where andUserId:uid];
}

+(BOOL)deleteModels:(Class)cls columnNames:(NSArray<NSString *>*)columnNames andRelationTypes:(NSArray<NSNumber *> *)relationTypes andValues:(NSArray <id>*)values andNexusTypes:(NSArray<NSNumber *> *)nexusTypes  andUserId:(NSString *)uid
{
    NSMutableString *resultStr = [NSMutableString string];
    
    for (int i = 0; i < columnNames.count; i++) {
        
        NSString *key = columnNames[i];
        NSString *relationStr = self.relationTypeSQLRelation[relationTypes[i]];
        id value = values[i];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@ %@ %@", key, relationStr, value];
        
        [resultStr appendString:tempStr];
        
        if (i != columnNames.count - 1) {
            NSString *nexusStr = self.nexusTypeSQLRelation[nexusTypes[i]];
            [resultStr appendString:[NSString stringWithFormat:@" %@ ", nexusStr]];
        }
    }
    
    return [self deleteModel:cls whereStr:resultStr andUserId:uid];
}
@end
