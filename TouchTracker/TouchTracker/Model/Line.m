//
//  Line.m
//  TouchTracker
//
//  Created by zhaoqihao on 14-8-27.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "Line.h"

@implementation Line
@synthesize begin=_begin,end=_end;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSValue *beginValue=[NSValue valueWithCGPoint:self.begin];
    NSValue *endValue=[NSValue valueWithCGPoint:self.end];
    
    [aCoder encodeObject:beginValue forKey:@"begin"];
    [aCoder encodeObject:endValue forKey:@"end"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if(self){
        NSValue *beginValue=[aDecoder decodeObjectForKey:@"begin"];
        NSValue *endValue=[aDecoder decodeObjectForKey:@"end"];
        
        self.begin=[beginValue CGPointValue];
        self.end=[endValue CGPointValue];
    }
    
    return self;
}

@end
