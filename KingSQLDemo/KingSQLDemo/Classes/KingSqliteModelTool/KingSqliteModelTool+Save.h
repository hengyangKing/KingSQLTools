//
//  KingSqliteModelTool+Save.h
//  KingSQLDemo
//
//  Created by J on 2017/6/21.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingSqliteModelTool.h"

@interface KingSqliteModelTool (Save)
/**
 更新表格
 
 @param cls 表名称
 @param uid uid
 @return 返回是否更新成功
 */
+(BOOL)upDataTable:(Class )cls andUserId:(NSString *)uid;


/**
 保存model/已经存在, 更新
 
 @param model model
 @param uid uid
 @return 返回结果
 */
+(BOOL)saveOrUpdateModel:(id)model andUserId:(NSString *)uid;

@end
