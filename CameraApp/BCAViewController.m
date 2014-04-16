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
    //MBProgressHUDオブジェクト作成
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    
    //表示させる文字列
    _progress.labelText = @"読み込み中...";
    
    //画面に追加
    [self.view addSubview:_progress];
    
    _progress.delegate = self;
    
    //表示させる
    [_progress show:YES];
    
    //3秒後にMBProgressHUDオブジェクトを非表示
    //通常はデータ読み込みが終わったなどの処理で。（テスト的に実装）
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(finishEvent:) userInfo:nil repeats:NO];
    
}

//3秒後に呼び出されるメソッド
- (void)finishEvent:(NSTimer *)timer
{
    //非表示にする
    [_progress hide:YES];
}

//MBProgressHUDが非表示になった後に呼びだされるデリゲートメソッド
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    //削除
    [_progress removeFromSuperview];
}

- (void) didCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES
completion:^{}];
}

@end
