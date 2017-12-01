//
//  AppDelegate.m
//  SoundCloudNew
//
//  Created by Trung Đức on 1/24/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "AppDelegate.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Constant.h"
#import "Playlist.h"
#import "SoundCloudAPI.h"
#import "Genre.h"
#import "Constant.h"
#import <AVFoundation/AVFoundation.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()<GADInterstitialDelegate>

@end

@implementation AppDelegate

#define ADMOB_APP_ID @"ca-app-pub-3500145728441340/6764106796"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;

    [GADMobileAds configureWithApplicationID:ADMOB_APP_ID];

    self.interstitial = [self createAndLoadInterstitial];

    self.interstitial = [[GADInterstitial alloc]
                         initWithAdUnitID:ADMOB_APP_ID];
    self.interstitial.delegate = self;

    [self prepareAdd];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(0) forKey:@"playcount"];
    [defaults synchronize];

    NSNumber *playcount = [defaults valueForKey:@"playcount"];
    NSLog(@"Payment count ===============================================>%@",playcount);

    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //Set up CoreData
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:kDatabaseName];
    
    [self loadGenreIfNecessary];
    
    [self.window setTintColor: kAppColor];
    
    [Fabric with:@[[Crashlytics class]]];
    
    return YES;
}
- (void)prepareAdd {
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];

}
- (void)doSomethingAd {

    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self.window.rootViewController];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}
- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:ADMOB_APP_ID];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen");
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
//- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
//    NSLog(@"interstitialDidDismissScreen");
//}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //Save data when the user quits
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

- (void)loadGenreIfNecessary;
{
    
    if ([Playlist MR_countOfEntities] == 0) {
        //Creat history playlist
        [Playlist createPlaylistWithTitle:@"History"];
        
        //Set Appcolor
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:kAppDefaultColor];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"AppColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //Get data
    if ([Genre MR_countOfEntities] == 0)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Genres" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        NSError *error;
        NSArray *genres = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        for (NSDictionary *genre in genres) {
            [Genre creatWithJsonDict:genre];
        }
        
        //save data
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave,NSError* error) {
            if (contextDidSave) {
                NSLog(@"Data in default context SAVED");
            }
            if (error) {
                NSLog(@"Data in default context ERROR %@", error);
            }
        }];
    }
}



@end
