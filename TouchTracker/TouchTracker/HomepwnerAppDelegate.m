//
//  HomepwnerAppDelegate.m
//  TouchTracker
//
//  Created by zhaoqihao on 14-8-27.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import "HomepwnerAppDelegate.h"
#import "TouchViewController.h"
#import "LineStore.h"

@implementation HomepwnerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    TouchViewController *tc=[[TouchViewController alloc]initWithNibName:nil bundle:nil];
    [self.window setRootViewController:tc];
    
    [self.window makeKeyAndVisible];
    
#ifdef VIEW_DEBUG
//    NSLog(@"%@",[self.window performSelector:@selector(recursiveDescription)]);
#endif
    
    return YES;
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    if([[LineStore sharedStore]saveChanges]){
        NSLog(@"Save all lines successful");
    }else{
        NSLog(@"Save lines failed");
    }
}

@end
