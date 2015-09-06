//
//  Article.m
//  FlipDiary
//
//  Created by shima on 2015/08/26.
//  Copyright (c) 2015年 shimashimasoft. All rights reserved.
//

#import "Article.h"

#define CONST_DATETIME @"YYYY/MM/dd HH:mm"
#define CONST_YYYYMMDD @"YYYY/MM/dd"
#define CONST_YYYY     @"YYYY"
#define CONST_MMDD     @"MM/dd"
#define CONST_HHMM     @"HH:mm"

@implementation Article

/**
 * NSCodingに準拠するために必要な関数
 * データのencodeを行う
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.createDate forKey:@"createDate"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.body forKey:@"body"];
}

/**
 * NSCodingに準拠するために必要な関数
 * データのdecodeを行う
 */
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.createDate = [aDecoder decodeObjectForKey:@"createDate"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.body = [aDecoder decodeObjectForKey:@"body"];
    }
    return (self);
}


/**
 * 整形された日付とタイトルをSPACEで連結して返す
 *
 * @return 整形された日付とタイトルをSPACEで連結
 */
- (NSString *)dateAndTitle{
    /// 日付を整形する（当日ならHH:MM, 当年ならMM/DD, それより過去ならYYYY/MM/DD）
    NSString *Datatime = [self formatDate];
    /// 整形された日付とタイトルをSPACEで連結する
    NSString *dateAndTitle = [Datatime stringByAppendingFormat:@"   %@",self.title];
    
    return dateAndTitle;
}


/**
 * 登録日時をYYYY/MM/DD HH:SS形式で返す
 *
 * @return YYYY/MM/DD HH:SS形式
 */
- (NSString *)yyyymmddAndHhss{
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat  = CONST_DATETIME;
    NSString *yyyymmddAndHhss = [df stringFromDate:self.createDate];
    return yyyymmddAndHhss;
}


/**
 * 整形された日付を返す（当日ならHH:MM, 当年ならMM/DD, それより過去ならYYYY/MM/DD）
 *
 * @return 整形された日付
 */
- (NSString *)formatDate
{
    NSDateFormatter *dfYymmdd = [NSDateFormatter new];
    NSDateFormatter *dfMmdd = [NSDateFormatter new];
    NSDateFormatter *dfHhmm = [NSDateFormatter new];
    dfYymmdd.dateFormat  = CONST_YYYYMMDD;
    dfMmdd.dateFormat  = CONST_MMDD;
    dfHhmm.dateFormat  = CONST_HHMM;
    
    NSString *formatDate = [NSString new];
    
    if ([self isSameDate:CONST_YYYYMMDD]){
        /// 同じ日時か判定する(YYYYMMDDが等しいか=当日か)
        /// 当日ならHH:MMを返す
        formatDate = [dfHhmm stringFromDate:self.createDate];
    }else if ([self isSameDate:CONST_YYYY]){
        /// 同じ年か判定する(YYYYが等しいか=当年か)
        /// 当年ならMM/DDを返す
        formatDate = [dfMmdd stringFromDate:self.createDate];
    }else{
        /// それより過去ならYYYY/MM/DDを返す
        formatDate = [dfYymmdd stringFromDate:self.createDate];
    }
    
    return formatDate;
}

/**
 * システム日付とcreateDateが同じ日時か判定する（フォーマットの形式で判定する）
 *
 * @param format フォーマットの形式
 * @return 同じ日時ならYES, 違うならNOを返す
 */
- (BOOL)isSameDate:(NSString *)format
{
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat  = format;
    
    NSDate *today = [NSDate date];
    /// 日付をフォーマットの形式に変換する（例：2015/07/31 12:34:56 を 2015/07/31 に変換）
    NSString *todayFormat = [df stringFromDate:today];
    NSString *checkDateFormat = [df stringFromDate:self.createDate];
    
    if ([todayFormat isEqualToString:checkDateFormat]) {
        return YES;
    }else{
        return NO;
    }
}

@end
