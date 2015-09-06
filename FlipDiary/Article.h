//
//  Article.h
//  FlipDiary
//
//  Created by shima on 2015/08/26.
//  Copyright (c) 2015年 shimashimasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

// 記事クラス
@interface Article : NSObject

// 登録日時
@property (strong, nonatomic) NSDate *createDate;
// タイトル
@property (strong, nonatomic) NSString *title;
// 本文
@property (strong, nonatomic) NSString *body;

// 整形された日付とタイトルをSPACEで連結して返す
- (NSString *)dateAndTitle;
// 登録日時をYYYY/MM/DD HH:SS形式で返す
- (NSString *)yyyymmddAndHhss;

@end
