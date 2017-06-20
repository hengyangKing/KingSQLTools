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
@property(nonatomic,assign)NSInteger num;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,assign)float score;

@end
