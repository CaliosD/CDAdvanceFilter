//
//  XYDateUtils.h
//  bjsmxxKPI
//
//  Created by XY on 14-6-27.
//  Copyright (c) 2014年 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  Update: Fix all the DEPRECATED NS_OPTIONS. (Calios: 0622)
 */
@interface XYDateUtils : NSObject

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format;
+ (BOOL)isWeekEndWithDate:(NSDate *)date;
+ (NSString *)getShortWeekdaySymbolsFromDate:(NSDate *)date;
+ (NSString *)getStandaloneWeekdaySymbolsFromDate:(NSDate *)date;
+ (NSInteger)getWeekOfYearNumberFromDate:(NSDate *)date;
+ (NSInteger)getWeekOfMonthNumberFromDate:(NSDate *)date;
+ (NSString *)compareCurrentTime:(NSDate *)compareDate;
+ (NSString *)lastUpdateTimeWithRefreshKey:(NSString *)refreshKey;
+ (NSDate *)nextDayForDate:(NSDate *)date;
+ (NSString *)wechat_changeTheDateString:(NSString *)Str;

@end
