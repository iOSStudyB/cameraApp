//
//  BCAViewController.m
//  CameraApp
//
//  Created by Hermit Knight on 2014/04/08.
//  Copyright (c) 2014年 Hermit Knight. All rights reserved.
//

#import "BCAViewController.h"
#import "BCAMessageEditViewController.h"

@interface BCAViewController ()

@end

@implementation BCAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushPostButton:(id)sender {
    BCAMessageEditViewController *editView = [[BCAMessageEditViewController alloc] initWithNibName:@"BCAMessageEditView" bundle:nil];
//    [editView set]
    [self presentViewController:editView animated:YES completion:^{
    }];
    
}

#pragma mark MessageEditView のデリゲートメソッド
- (void) didPostMessage:(NSString *)messages sender:(id)sender
{
    
}
- (void) didCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES
completion:^{}];
}

@end
