//
//  KingBaseTool.m
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingBaseTool.h"


@implementation KingBaseTool
+(NSString *)tableName:(Class)cls
{
    return NSStringFromClass(cls);
}

+(NSString *)tmpTableName:(Class)cls
{
    return [NSStringFromClass(cls) stringByAppendingString:@"_tmp"];
}
@end
