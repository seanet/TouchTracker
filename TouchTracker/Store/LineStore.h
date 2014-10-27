//
//  LineStore.h
//  TouchTracker
//
//  Created by zhaoqihao on 14-8-27.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"

@interface LineStore : NSObject
{
    NSMutableArray *allLines;
}

+(LineStore *)sharedStore;

-(NSArray *)allLines;
-(void)addLine:(Line *)line;
-(void)removeLine:(Line *)line;
-(BOOL)saveChanges;
-(void)clearAll;

@end
