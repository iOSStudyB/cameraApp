//
//  BCAMessageEditViewController.m
//  CameraApp
//
//  Created by 横田 英樹 on 2014/04/12.
//  Copyright (c) 2014年 Hermit Knight. All rights reserved.
//

#import "BCAMessageEditViewController.h"

@interface BCAMessageEditViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BCAMessageEditViewController
{
    // エディット済み画像を保存するまでの間格納しておく
    NSMutableArray *tempEditedImages;
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
    tempEditedImages = [[NSMutableArray alloc] init];
    [_imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_imageCollectionView setBackgroundColor:[UIColor whiteColor]];

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
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"title" delegate:self cancelButtonTitle:@"cancel"               destructiveButtonTitle:nil otherButtonTitles:@"camera",@"choose from library",@"editable camera",nil];
    [sheet showInView:self.view];
    
}

- (IBAction)touchSaveItem:(UIBarButtonItem *)sender {
    // 編集済み画像をカメラロールに保存する
    if ([tempEditedImages count] != 0) {
        for (UIImage *tempImage in tempEditedImages) {
            UIImageWriteToSavedPhotosAlbum(tempImage, nil, nil, nil);
        }
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
    }else if (buttonIndex == 2){
        DLCImagePickerController *picker = [[DLCImagePickerController alloc] init];
        picker.delegate = self;
        [self.navigationController presentViewController:picker animated:TRUE completion:nil];
    }
}

// カメラを使った場合
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 編集済み画像
    UIImage *editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    [tempEditedImages addObject: editedImage];
    // サムネイルを再描画する
    [_imageCollectionView reloadData];
    
    // 最初の画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *) createThumbnailImage:(UIImage *)editedImage
{
    int imageW = editedImage.size.width;
    int imageH = editedImage.size.height;
    
    // リサイズする倍率を作成する。縦横で長い方が80pixcelになるように倍率を求める
    float scale = (imageW > imageH ? 80.0f/imageW : 80.0f/imageH);
    
    // 比率に合わせてリサイズする。
    // ポイントはUIGraphicsXXとdrawInRectを用いて、リサイズ後のサイズで、
    // aImageを書き出し、書き出した画像を取得することで、
    // リサイズ後の画像を取得します。
    CGSize resizedSize = CGSizeMake(imageW * scale, imageH * scale);
    UIGraphicsBeginImageContext(resizedSize);
    [editedImage drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

//「Cancel」ボタンのデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 最初の画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];
}

//// ★下記のメソッドがうまく実装できな。。。★
//// 編集可能カメラ（DLCImagePickerController）を使った場合
//- (void)imagePickerController:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    // 画像データは info[@"data"] にNSDataオブジェクトとして格納されている
//    UIImage *image = [UIImage imageWithData:info[@"data"]];
//    
//    // UIImagePickerControllerも併用するのであればUIImagePickerControllerOriginalImage等にフォールバックする
//    if (!image) {
//        image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    }
//    
//    _imageView.image = image;
//    tempEditedImage = image;
//    // 最初の画面に戻る
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


#pragma mark -  UICollectionViewDelegate

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // セクションは常に１つ
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // エディット済み画像の配列の長さ
    return [tempEditedImages count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    UIImage *image = [tempEditedImages objectAtIndex:indexPath.row];
    NSLog(@"subview count %d", [cell.subviews count]);
    // 使いまわした前回のcellのsubviewに張り付いていた画像が残るため一度subviewをクリアする
    [cell.subviews[0] removeFromSuperview];
    [cell addSubview:(UIView *) [[UIImageView alloc] initWithImage:[self createThumbnailImage:image]]];
    return cell;
}

@end
