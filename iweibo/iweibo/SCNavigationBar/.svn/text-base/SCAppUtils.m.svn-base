/*
 * Copyright (c) 2010-2010 Sebastian Celis
 * All rights reserved.
 */

#import "SCAppUtils.h"

@implementation SCAppUtils

+ (void)navigationController:(UINavigationController *)navController
                    setImage:(UIImage *)img
{
    UINavigationBar *navBar = [navController navigationBar];
    //[navBar setTintColor:kSCNavigationBarTintColor];
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [navBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavigationBarBackgroundImageTag];
        if( imageView != nil){
            [imageView removeFromSuperview];
        }
        
        imageView = [[UIImageView alloc] initWithImage:img];
        
        imageView.frame = CGRectMake(0.0f, 0.0f, navController.navigationBar.frame.size.width, navController.navigationBar.frame.size.height);
        imageView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [imageView setTag:kSCNavigationBarBackgroundImageTag];
        [navBar addSubview:imageView];
        [navBar sendSubviewToBack:imageView];
        [imageView release];
    }
}

@end
