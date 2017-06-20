//
//  KingSqliteTool.h
//  KingSQLDemo
//
//  Created by J on 2017/6/19.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KingSqliteTool : NSObject

/**
 执行语句

 @param sql 语句
 @param uid 用户id nil 则为common.db 通用数据库
 @return 返回执行结果
 */
+(BOOL)dealSql:(NSString *)sql andUserId:(NSString *)uid;


/**
 查询语句

 @param sql 语句
 @param uid 用户id nil 则为common.db 通用数据库
 @return 字典组成的数组 没个数组都是查询到的结果

 */
+(NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql andUserId:(NSString *)uid;




/**
 批量执行语句

 @param sqls 数组内字符串为sql语句
 
 @param uid uid
 @return 返回是否执行成功
 */
+(BOOL)dealSqls:(NSArray <NSString *>*)sqls andUserId:(NSString *)uid;



@end
