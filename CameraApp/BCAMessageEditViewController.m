//
//  BCAMessageEditViewController.m
//  CameraApp
//
//  Created by 横田 英樹 on 2014/04/12.
//  Copyright (c) 2014年 Hermit Knight. All rights reserved.
//

#import "BCAMessageEditViewController.h"

@interface BCAMessageEditViewController ()

@end

@implementation BCAMessageEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)touchCancelItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
}

- (IBAction)touchCameraItem:(UIBarButtonItem *)sender {
    
    
    // TODO カメラが利用できるか、ライブラリが利用できるかをチェックして、表示するメニューを変える
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"title" delegate:self cancelButtonTitle:@"cancel"               destructiveButtonTitle:nil otherButtonTitles:@"camera", @"choose from library", nil];
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"You have pressed the %@ button", [actionSheet buttonTitleAtIndex:buttonIndex]);
    if (buttonIndex == 0) {
        return;
    }
    // カメラを利用できるかどうかチェックする
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // イメージピッカーコントローラを作る
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        //UIImagePickerControllerDelegate のデリゲートになる
        imagePicker.delegate = self;
        // カメラから画像を取り込む設定にする
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;//NO だとプレビューのみ
        
        // カメラを表示する
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    // TODO UIImagePickerControllerのデリゲートメソッド実装
}
@end
