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
{
    UIImage *tempEditedImage;
}

NSInteger countDown;

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

- (IBAction)touchSaveItem:(UIBarButtonItem *)sender {
    // 編集済み画像をカメラロールに保存する
    if (tempEditedImage != nil) {
        UIImageWriteToSavedPhotosAlbum(tempEditedImage, nil, nil, nil);
    }

    MBProgressHUD*	hud	= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.dimBackground = YES;
    
    [hud setLabelText:@"接続中"];// ラベル設定.

    // 3秒間 ウエイト（疑似接続中）

    // タイマーの生成
    NSTimer *tm =[NSTimer
        scheduledTimerWithTimeInterval:1.0f
        target:self
        selector:@selector(timerAction:)
        userInfo:nil
        repeats:YES
    ];
    
    // カウントダウン時間の設定
    countDown = 3;
    
    [tm fire];
    
}

-(void)timerAction:(NSTimer*)timer{
    if(countDown>0){
        countDown--;
    }else{
        [timer invalidate]; // タイマーを停止する
        NSLog(@"---------タイムオーバ-----------");
        
        // 画面を戻す処理
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     
                                 }];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"You have pressed the %@ button %d", [actionSheet buttonTitleAtIndex:buttonIndex], buttonIndex);
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    // カメラを利用できるかどうかチェックする
    if (buttonIndex == 0) {
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
    } else if (buttonIndex == 1) {// ライブラリから取得
        // フォトライブラリを利用できるかどうかチェックする
        if([UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary]) {
            // イメージピッカーコントローラを作る
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            //UIImagePickerControllerDelegate のデリゲートになる
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            // フォトライブラリから画像を取り込む設定にする
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // フォトライブラリから画像を選ぶ
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

// カメラを使った場合
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 編集済み画像
    UIImage *editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    // 最初の画面のイメージビューに編集済み画像を表示する
    // 可能であればtext view への埋め込み
    // 参考: http://blog.koogawa.com/entry/2013/12/24/202247
    _imageView.image = editedImage;
    tempEditedImage = editedImage;
    // 最初の画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];
}

//「Cancel」ボタンのデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 最初の画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
