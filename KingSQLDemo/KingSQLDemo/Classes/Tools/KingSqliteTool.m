//
//  KingSqliteTool.m
//  KingSQLDemo
//
//  Created by J on 2017/6/19.
//  Copyright © 2017年 J. All rights reserved.
//

#import "KingSqliteTool.h"
#import "KingBaseTool.h"
#import "sqlite3.h"//需要导入libsqlite3.0.tdb

#define KCachePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"SQLCaches"]

#define  FILEMANAGER [NSFileManager defaultManager]
@implementation KingSqliteTool
sqlite3 *ppDb=nil;
+(BOOL)dealSql:(NSString *)sql andUserId:(NSString *)uid
{
    if ([self openDB:uid]) {
        //执行语句
        BOOL result = ((sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil))==SQLITE_OK);
        [self closeDB];
        
        return result;
    }else{
        return NO;
    }
}
+(NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql andUserId:(NSString *)uid
{
    if ([self openDB:uid]) {
        //    准备语句（预处理语句）
        //    1.创建准备语句
        //    sqlite3 *db 已经打开的数据库
        //    const char *zSql 需要执行的sql的语句
        //    int nByte 取出多少字节长度 -1 为自动计算，找到\0结束符号
        //    sqlite3_stmt **ppStmt 准备语句
        //    const char **pzTail 通过参数3 取出参数2 的长度字节之后剩下的字符串
        sqlite3_stmt *ppStmt=nil;
        if (sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &ppStmt, nil)!=SQLITE_OK) {
            NSLog(@"准备语句编译失败");
            return nil;
        }else{
            //    2.绑定数据(省略)
            //    3.执行
            NSMutableArray *data=[NSMutableArray array];
            while (sqlite3_step(ppStmt)==SQLITE_ROW) {
                //一行记录
//                获取所有列的个数
               int columnCount = sqlite3_column_count(ppStmt);
//                遍历所有的列
                NSMutableDictionary *rowDic=[NSMutableDictionary dictionary];
                
                
                for (int i=0; i<columnCount; i++) {
                    //获取列名
                    const char *columnNameC=sqlite3_column_name(ppStmt, i);
                    NSString *columnName=[NSString stringWithUTF8String:columnNameC];
                    //获取列值(不同列的的值，类型不同，获取函数不同)
//                    获取类型
                    int type=sqlite3_column_type(ppStmt, i);
                    id value=nil;
                    switch (type) {
                        case SQLITE_INTEGER:
                            value=@(sqlite3_column_int(ppStmt, i));
                            break;
                        case SQLITE_FLOAT:
                            value=@(sqlite3_column_double(ppStmt, i));
                            break;
                        case SQLITE_BLOB:
                            //二进制
                            value=CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                            break;
                        case SQLITE_NULL:
                            value=@"";
                            break;
                        case SQLITE3_TEXT:
                            value=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(ppStmt, i)];
                            break;
                            
                        default:
                            break;
                    }
                    [rowDic setValue:value forKey:columnName];
                }
                [data addObject:rowDic];
            }
            //    4.重置(省略)
            //    5.释放资源
            sqlite3_finalize(ppStmt);
//                6.关闭
            [self closeDB];
            return data;
        }
    }else{
        return nil;
    }
}
+(BOOL)dealSqls:(NSArray <NSString *>*)sqls andUserId:(NSString *)uid
{
    [self beginTransaction:uid];
    for (NSString *sql in sqls) {
        BOOL result=[self dealSql:sql andUserId:uid];
        if (!result) {
            [self rollBackTransaction:uid];
            return  NO;
        }
    }
    [self commitTransaction:uid];
    return YES;
}
//将要执行
+(void)beginTransaction:(NSString *)uid{
    [self dealSql:@"begin transaction" andUserId:uid];
}
//提交执行
+(void)commitTransaction:(NSString *)uid{
    [self dealSql:@"commit transaction" andUserId:uid];
}
//回滚执行
+(void)rollBackTransaction:(NSString *)uid{
    [self dealSql:@"rollBack transaction" andUserId:uid];
}




#pragma mark private Func
//打开/创建一个数据库
+(BOOL)openDB:(NSString *)uid
{
    NSString *dbPath=[self cacheSqlitePathUserID:uid];
    return ((sqlite3_open(dbPath.UTF8String, &ppDb))==SQLITE_OK);
}
//关闭数据库
+(void)closeDB
{
    sqlite3_close(ppDb);
}

+(NSString *)cacheSqlitePathUserID:(NSString *)uid{
    
    [self hasLive:KCachePath];
    NSString *dbName=uid.length?[NSString stringWithFormat:@"%@.sqlite",uid]:@"common.sqlite";
    return  [KCachePath stringByAppendingPathComponent:dbName];
    
}
+ (BOOL)hasLive:(NSString *)path
{
    if (![FILEMANAGER fileExistsAtPath:path]){
        return [FILEMANAGER createDirectoryAtPath:path
                      withIntermediateDirectories:YES
                                       attributes:nil
                                            error:nil];
    }
    return NO;
}


@end
