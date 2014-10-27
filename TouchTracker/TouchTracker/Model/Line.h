//
//  Line.h
//  TouchTracker
//
//  Created by zhaoqihao on 14-8-27.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject<NSCoding>

@property (nonatomic)CGPoint begin;
@property (nonatomic)CGPoint end;

@end
