//
//  BCAMessageEditViewController.h
//  CameraApp
//
//  Created by 横田 英樹 on 2014/04/12.
//  Copyright (c) 2014年 Hermit Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

// import progress library
#include "MBProgressHUD.h"

@interface BCAMessageEditViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
- (IBAction)touchCancelItem:(UIBarButtonItem *)sender;
- (IBAction)touchCameraItem:(UIBarButtonItem *)sender;

@end
@protocol BCAMessageEditViewDelegate

- (void) didPostMessage:(NSString *)messages sender:(id)sender;
- (void) didCancel:(id)sender;

@end
