//
//  TouchViewController.m
//  TouchTracker
//
//  Created by zhaoqihao on 14-8-27.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchDrawView.h"

@interface TouchViewController ()

@end

@implementation TouchViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view =[[TouchDrawView alloc]init];
}

@end
