//
//  AppDelegate.h
//  SoundCloudNew
//
//  Created by Trung Đức on 1/24/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property(nonatomic, strong) GADInterstitial *interstitial;

- (void)doSomethingAd;
- (void)prepareAdd;

@end

