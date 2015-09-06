//
//  DataViewController.h
//  FlipDiary
//
//  Created by shima on 2015/08/26.
//  Copyright (c) 2015年 shimashimasoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface DataViewController : UIViewController

// 記事の登録日時
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
//@property (strong, nonatomic) id dataObject;
// 記事の本文
@property (strong, nonatomic) IBOutlet UITextView *articleBody;
// 記事のタイトル
@property (strong, nonatomic) IBOutlet UITextField *articleTitle;

// 記事クラス
@property (strong, nonatomic) Article *articleObject;

@end

