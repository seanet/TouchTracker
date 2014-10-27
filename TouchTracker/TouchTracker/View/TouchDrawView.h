//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by zhaoqihao on 14-8-27.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Line;

@interface TouchDrawView : UIView<UIGestureRecognizerDelegate>
{
    NSMutableArray *completeLines;
    NSMutableDictionary *linesInProcess;
    
    UIPanGestureRecognizer *panGestureRecgnizer;
    UITapGestureRecognizer *tapRecognizer;
    UILongPressGestureRecognizer *longPressRecgnizer;
    UITapGestureRecognizer *doubleTap;
}

@property (nonatomic,weak)Line *selectedLine;

-(void)clearAll;
-(Line *)lineAtPoint:(CGPoint)p;

@end
