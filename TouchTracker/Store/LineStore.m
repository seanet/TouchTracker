//
//  LineStore.m
//  TouchTracker
//
//  Created by zhaoqihao on 14-8-27.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "LineStore.h"

@implementation LineStore

+(LineStore *)sharedStore
{
    static LineStore *sharedStore=nil;
    if(!sharedStore){
        sharedStore=[[super allocWithZone:nil]init];
    }
    
    return sharedStore;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

-(id)init
{
    self=[super init];
    if(self){
        NSString *path=[self storePath];
        allLines=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(!allLines){
            allLines=[[NSMutableArray alloc]init];
        }
    }
    
    return self;
}

-(NSArray *)allLines
{
    return [allLines copy];
}

-(NSString *)storePath
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"lines.archive"];
}

-(BOOL)saveChanges
{
    NSString *path=[self storePath];
    return [NSKeyedArchiver archiveRootObject:allLines toFile:path];
}

-(void)addLine:(Line *)line
{
    [allLines addObject:line];
}

-(void)removeLine:(Line *)line
{
    [allLines removeObjectIdenticalTo:line];
}

-(void)clearAll
{
    [allLines removeAllObjects];
}

@end
