//
//  KingBaseTool.h
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KingBaseTool : NSObject
/**
 获取表名称
 @param cls 类名作为表名称
 @return 表名称
 */
+(NSString *)tableName:(Class)cls;


/**
 获取临时表名称

 @param cls 类名作为表名称
 @return 表名称
 */
+(NSString *)tmpTableName:(Class)cls;

@end
