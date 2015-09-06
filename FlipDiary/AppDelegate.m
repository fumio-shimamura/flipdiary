//
//  AppDelegate.m
//  FlipDiary
//
//  Created by shima on 2015/08/26.
//  Copyright (c) 2015年 shimashimasoft. All rights reserved.
//

#import "AppDelegate.h"
#import "Article.h"

#define CONST_FILENAME @"diary.dat"


@interface AppDelegate ()

@end

@implementation AppDelegate


/**
 * このクラスにアクセスするためのメソッド
 * @ AppDelegate* このクラス
 */
+(AppDelegate*)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 記事データの配列をロードする
    [self loadData];
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self searchEnd];
    // 記事データの配列をセーブする
    [self saveData];
}


/**
 * 新規記事を追加する
 *
 */
-(void)pushNewArticle{
    //空の記事をセットし、そのIndexをセットする
    Article *article = [Article new];
    article.createDate = [NSDate date];
    article.title = @"";
    article.body = @"";
    [self.articles addObject:article];
    self.articleIndex = self.articles.count - 1;
}


/**
 * 記事データの配列をロードする
 *
 */
- (void)loadData{
    
    if (self.articles){
        // データセット済みの場合は処理を終了する
        return;
    }
    // 読み込むファイルのパスを作成する
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:CONST_FILENAME];
    
    // ファイルを読み込み、NSData型のデータをアンアーカイブして配列（複数の記事）にセットする
    self.articles = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

    if (self.articles) {
    }else{
        // データが空の場合、初期化する
        self.articles = [NSMutableArray new];
    }
}


/**
 * 記事データの配列をセーブする
 *
 */
- (void)saveData{
    // 書き込むファイルのパスを作成する
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:CONST_FILENAME];
    
    // 配列（複数の記事）をNSData型にアーカイブしてファイルに書き込む
    BOOL successful = [NSKeyedArchiver archiveRootObject:self.articles toFile:filePath];
    if (successful) {
    }
}


/**
 * 検索開始する
 *
 */
-(void)searchStart{
    
    if ([self.articles_save_for_search count] == 0) {
        // shallow copy
        self.articles_save_for_search = [NSMutableArray arrayWithArray:self.articles];
    }
}


/**
 * 検索文字列を受け取って検索する
 * query 検索文字列
 */
-(void)searching:(NSString *)query{
    
    [self.articles removeAllObjects];
    for (Article *article in self.articles_save_for_search) {
        NSString *string = [article.title stringByAppendingFormat:@" %@",article.body];
        NSRange range = [string rangeOfString:query];
        if (range.location != NSNotFound) {
            [self.articles addObject:article];
        }
    }
}


/**
 * 検索終了する
 *
 */
-(void)searchEnd{
    
    if ([self.articles_save_for_search count] != 0) {
        // shallow copy のため、データ変更の影響がsave_for_searchに及ぶ。
        // そのためコピーすることで変更も元データに反映される
        self.articles = [NSMutableArray arrayWithArray:self.articles_save_for_search];
        [self.articles_save_for_search removeAllObjects];
    }
}


@end
