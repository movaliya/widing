//
//  AppDelegate.h
//  MyWedding
//
//  Created by kaushik on 01/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+(BOOL)connectedToNetwork;
+ (AppDelegate *)sharedInstance;
+(BOOL)IsValidEmail:(NSString *)checkString;

+ (void)showErrorMessageWithTitle:(NSString *)title
                          message:(NSString*)message
                         delegate:(id)delegate;

+(void)showInternetErrorMessageWithTitle:(NSString *)title delegate:(id)delegate;

@end

