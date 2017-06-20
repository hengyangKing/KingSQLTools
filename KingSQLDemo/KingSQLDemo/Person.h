//
//  Person.h
//  KingSQLDemo
//
//  Created by J on 2017/6/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KingModelToolProtocol.h"
@interface Person : NSObject
+(instancetype _Nullable )createPersonWithNum:(NSInteger)num andName:(NSString *_Nullable)name andAge:(NSInteger)age andScore:(float)score;

@property(nonatomic,assign)NSInteger num;
@property(nonatomic,copy)NSString * _Nullable name;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,assign)float score;

@property(nonnull,retain)NSMutableDictionary *dic;
@property(nonnull,retain)NSMutableArray *arr;


@end
