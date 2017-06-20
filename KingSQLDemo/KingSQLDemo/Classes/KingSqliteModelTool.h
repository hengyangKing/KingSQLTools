//
//  KingSqliteModelTool.h
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KingSqliteModelTool : NSObject

/**
 创建表

 @param cls 类名-->用作表名
 @param uid userid
 */
+(BOOL)createTable:(Class)cls andUserId:(NSString *)uid;


/**
 是否需要更新表

 @param cls 表名称
 @param uid uid
 @return 返回是否需要更新表
 */
+(BOOL)isTableRequiredUpdateClass:(Class)cls andUserId:(NSString *)uid;



/**
 更新表格

 @param cls 表名称
 @param uid uid
 @return 返回是否更新成功
 */
+(BOOL)upDataTable:(Class )cls andUserId:(NSString *)uid;


// 保存/ 已经存在, 更新
+ (BOOL)saveModel:(id)model andUserId:(NSString *)uid;




@end
