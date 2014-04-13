//
//  BCAViewController.h
//  CameraApp
//
//  Created by Hermit Knight on 2014/04/08.
//  Copyright (c) 2014年 Hermit Knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCAMessageEditViewController.h"

@interface BCAViewController : UIViewController <BCAMessageEditViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *postButton;
- (IBAction)pushPostButton:(id)sender;
@end
