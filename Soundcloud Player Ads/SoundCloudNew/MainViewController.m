//
//  MainViewController.m
//  SoundCloudNew
//
//  Created by Trung Đức on 1/25/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "MainViewController.h"
#import "Constant.h"
#import "NowPlayingViewController.h"
#import "UIImage+Custom.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateColor)
                                                 name:@"ColorDidChange"
                                               object:nil];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kAppColor};
    
}


- (void)updateColor;
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kAppColor};
}

- (void)btnPlayingDidTouch;
{
    
}


@end
