
//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by zhaoqihao on 14-8-27.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"
#import "LineStore.h"
#import <math.h>

@implementation TouchDrawView
{
    @private BOOL canTransfer;
    @private CGFloat drawWidth;
}
@synthesize selectedLine=_selectedLine;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        drawWidth=10.0;
        
        linesInProcess=[[NSMutableDictionary alloc]init];
        completeLines =[[NSMutableArray alloc]initWithArray:[[LineStore sharedStore]allLines]];
        
        self.backgroundColor=[UIColor whiteColor];
        [self setMultipleTouchEnabled:YES];
        
        tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delegate=self;
        [self addGestureRecognizer:tapRecognizer];
        
        doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        doubleTap.delegate=self;
        [self addGestureRecognizer:doubleTap];
        
        longPressRecgnizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPressRecgnizer.delegate=self;
        [self addGestureRecognizer:longPressRecgnizer];
        
        panGestureRecgnizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveLine:)];
        [panGestureRecgnizer setDelegate:self];
        [panGestureRecgnizer setCancelsTouchesInView:NO];
        [self addGestureRecognizer:panGestureRecgnizer];
    }
    return self;
}

-(void)dealloc
{
    tapRecognizer.delegate=nil;
    longPressRecgnizer.delegate=nil;
    panGestureRecgnizer.delegate=nil;
    doubleTap.delegate=nil;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, drawWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    [[UIColor blackColor]set];
    
    for(Line *line in completeLines){
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
        CGContextStrokePath(context);
    }
    
    [[UIColor redColor]set];
    for(NSValue *key in linesInProcess){
        Line *line=[linesInProcess objectForKey:key];
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
        CGContextStrokePath(context);
    }
    
    if(self.selectedLine){
        [[UIColor greenColor]set];
        CGContextMoveToPoint(context, self.selectedLine.begin.x, self.selectedLine.begin.y);
        CGContextAddLineToPoint(context, self.selectedLine.end.x, self.selectedLine.end.y);
        CGContextStrokePath(context);
    }
}

-(void)clearAll
{
    [linesInProcess removeAllObjects];
    [completeLines removeAllObjects];
    [[LineStore sharedStore]clearAll];
    [[UIMenuController sharedMenuController]setMenuVisible:NO animated:YES];
    
    [self setNeedsDisplay];
}

-(void)tap:(UIGestureRecognizer *)gr
{
    [linesInProcess removeAllObjects];
    
    CGPoint p=[gr locationInView:self];
    self.selectedLine=[self lineAtPoint:p];
    
    UIMenuController *menuController=[UIMenuController sharedMenuController];
    
    if(self.selectedLine){
        [self becomeFirstResponder];
        [menuController setTargetRect:CGRectMake(p.x, p.y, 0, 0) inView:self];
        [menuController setMenuVisible:YES animated:YES];
    }else{
        [menuController setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

-(void)longPress:(UIGestureRecognizer *)gr
{
    [linesInProcess removeAllObjects];
    
    if(gr.state==UIGestureRecognizerStateBegan){
        CGPoint p=[gr locationInView:self];
        self.selectedLine=[self lineAtPoint:p];
        canTransfer=YES;
    }else if(gr.state==UIGestureRecognizerStateEnded){
        self.selectedLine=nil;
        canTransfer=NO;
    }
    
    [self setNeedsDisplay];
}

-(void)moveLine:(UIPanGestureRecognizer *)gr
{
    if(!self.selectedLine||!canTransfer){
        return;
    }
    
    if(gr.state==UIGestureRecognizerStateChanged){
        [[UIMenuController sharedMenuController]setMenuVisible:NO animated:YES];
        
        CGPoint translation= [gr translationInView:self];
        
        CGPoint begin=self.selectedLine.begin;
        CGPoint end=self.selectedLine.end;
        
        begin.x+=translation.x;
        begin.y+=translation.y;
        end.x+=translation.x;
        end.y+=translation.y;
        
        self.selectedLine.begin=begin;
        self.selectedLine.end=end;

        [self setNeedsDisplay];
        [gr setTranslation:CGPointZero inView:self];
    }
}

-(void)doubleTap:(UIGestureRecognizer *)gr
{
    [self clearAll];
}

-(Line *)lineAtPoint:(CGPoint)p
{
    for(Line *l in completeLines){
        CGPoint begin=l.begin;
        CGPoint end=l.end;
        
        for(float t=0.0;t<1.0;t+=0.05){
            float x=begin.x+t*(end.x-begin.x);
            float y=begin.y+t*(end.y-begin.y);
            
            if(hypot(x-p.x, y-p.y)<10.0){
                return l;
            }
        }
    }
    
    return nil;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches){
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        
        CGPoint loc=[t locationInView:self];
        Line *newLine=[[Line alloc]init];
        newLine.begin=loc;
        newLine.end=loc;
        
        [linesInProcess setObject:newLine forKey:key];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *t in touches){
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        Line *theLine=[linesInProcess objectForKey:key];
        
        CGPoint loc=[t locationInView:self];
        theLine.end=loc;
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

-(void)endTouches:(NSSet *)touches
{
    for(UITouch *t in touches){
        NSValue *key =[NSValue valueWithNonretainedObject:t];
        Line *completeLine=[linesInProcess objectForKey:key];
        
        if(completeLine){
            [completeLines addObject:completeLine];
            [linesInProcess removeObjectForKey:key];
            [[LineStore sharedStore]addLine:completeLine];
        }
    }
    
    [self setNeedsDisplay];
}

#pragma mark - gesture delegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer==panGestureRecgnizer && otherGestureRecognizer==longPressRecgnizer){
        return YES;
    }
    
    return NO;
}

#pragma mark - uimenucontroller

-(void)delete:(id)sender
{
    [completeLines removeObjectIdenticalTo:self.selectedLine];
    [[LineStore sharedStore]removeLine:self.selectedLine];
    
    [self setNeedsDisplay];
}

@end
