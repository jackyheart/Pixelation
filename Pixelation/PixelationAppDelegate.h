//
//  PixelationAppDelegate.h
//  Pixelation
//
//  Created by Jacky on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PixelationViewController;

@interface PixelationAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet PixelationViewController *viewController;

@end
