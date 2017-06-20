//
//  KingModelTool.m
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingModelTool.h"
#import <objc/runtime.h>
#import "KingModelToolProtocol.h"

@implementation KingModelTool

+(NSDictionary *)classIvarNameTypeDic:(Class)cls
{
//    获取该类所有的变量和类型
    unsigned int outCount = 0;
    Ivar *varList = class_copyIvarList(cls, &outCount);
    NSMutableDictionary *nameTypeDic=[NSMutableDictionary dictionary];
    NSArray *ignoreNames=nil;
    if ([cls respondsToSelector:@selector(ignoreColumnNames)]) {
        //拿到忽略字段
        ignoreNames=[cls ignoreColumnNames];
    }
    
    for (int i=0; i<outCount; i++) {
        Ivar var=varList[i];
//        获取成员变量名称和类型
        NSString *ivarName=[NSString stringWithUTF8String:ivar_getName(var)];
        if ([ivarName hasPrefix:@"_"]) {
            ivarName=[ivarName substringFromIndex:1];
        }
        if ([ignoreNames containsObject:ivarName]) {
            //包含需要忽略结果跳过本次循环
            continue;
        }
        
        
        NSString *type=[NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        
        type=[type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];

        [nameTypeDic setObject:type forKey:ivarName];
    }
    return nameTypeDic;
}
+(NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[self classIvarNameTypeDic:cls]];
    NSDictionary *typeDic = [self objcTypeToSQLType];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]]&&[obj isKindOfClass:[NSString class]]) {
            NSString *keyStr=(NSString *)key;
            NSString *objStr=(NSString *)obj;
            dic[keyStr] = typeDic[objStr];
        }
    }];
    return dic;
}
+(NSString *)columnNameAndTypesStr:(Class)cls
{
    NSDictionary *dic=[self classIvarNameSqliteTypeDic:cls];
    NSMutableArray *result = [NSMutableArray array];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]]&&[obj isKindOfClass:[NSString class]]) {
            NSString *keyStr=(NSString *)key;
            NSString *objStr=(NSString *)obj;
            [result addObject:[NSString stringWithFormat:@"%@ %@", keyStr, objStr]];
        }
    }];
    return [result componentsJoinedByString:@","];
}
+(NSArray *)allTableSortedIvarNames:(Class)cls
{
    NSDictionary *dic=[self classIvarNameSqliteTypeDic:cls];
    NSMutableArray *keys=[NSMutableArray arrayWithArray:dic.allKeys];
    [keys sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    return keys;
}


#pragma mark private
+(NSDictionary *)objcTypeToSQLType{
    return @{@"d": @"real", // double
             @"f": @"real", // float
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             @"NSString": @"text"
             };
}
@end
