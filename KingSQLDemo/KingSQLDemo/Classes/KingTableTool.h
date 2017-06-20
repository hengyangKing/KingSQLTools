//
//  KingTableTool.h
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KingBaseTool.h"
//表操作专门类
@interface KingTableTool : KingBaseTool
//得到排序好的表名称
+(NSArray *)tableSortedColumnNames:(Class)cls UserId:(NSString *)uid;
@end
