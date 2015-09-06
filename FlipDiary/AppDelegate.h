//
//  AppDelegate.h
//  FlipDiary
//
//  Created by shima on 2015/08/26.
//  Copyright (c) 2015年 shimashimasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
// 記事データの配列
@property (strong, nonatomic) NSMutableArray *articles;
// 記事データの配列（検索時にデータを保存する）
@property (strong, nonatomic) NSMutableArray *articles_save_for_search;
// 記事データの配列のIndex（表示用）
@property (assign, nonatomic) NSInteger articleIndex;


// このクラスにアクセスするためのメソッド
+(AppDelegate*)appDelegate;
// 新規記事を追加する
-(void)pushNewArticle;
// 検索開始する
-(void)searchStart;
// 検索文字列を受け取って検索する
-(void)searching:(NSString *)query;
// 検索終了する
-(void)searchEnd;

@end

