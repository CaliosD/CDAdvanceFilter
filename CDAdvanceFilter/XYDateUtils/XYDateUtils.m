//
//  XYDateUtils.m
//  bjsmxxKPI
//
//  Created by XY on 14-6-27.
//  Copyright (c) 2014年 XY. All rights reserved.
//

//
//  NSDate+Utils.m
//  BloodSugar
//
//  Created by PeterPan on 13-12-27.
//  Copyright (c) 2013年 shake. All rights reserved.
//

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSWeekCalendarUnit |  NSCalendarUnitHour | NSCalendarUnitMinute | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

#define D_MINUTE 60
#define D_HOUR   3600
#define D_DAY    86400
#define D_WEEK   604800
#define D_YEAR   31556926

@implementation NSDate (WeChat)

+ (NSInteger)wechat_daysOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
    NSInteger days = [comps day];
    return days;
}

#pragma mark - Data component
- (NSInteger)wechat_year
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents year];
}

- (NSInteger)wechat_month
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents month];
}

- (NSInteger)wechat_day
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents day];
}

- (NSInteger)wechat_hour
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute  fromDate:self];
    return [dateComponents hour];
}

- (NSInteger)wechat_minute
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute  fromDate:self];
    return [dateComponents minute];
}

- (NSInteger)wechat_second
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute  fromDate:self];
    return [dateComponents second];
}

- (NSString *)wechat_weekday
{
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal)
                       fromDate:self];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    NSString *week = @"";
    switch (weekday) {
        case 1:
            week = @"星期日";
            break;
        case 2:
            week = @"星期一";
            break;
        case 3:
            week = @"星期二";
            break;
        case 4:
            week = @"星期三";
            break;
        case 5:
            week = @"星期四";
            break;
        case 6:
            week = @"星期五";
            break;
        case 7:
            week = @"星期六";
            break;
            
        default:
            break;
    }
    
    return week;
}

- (NSString *)wechat_stringMonthDay
{
    return [NSDate wechat_dateMonthDayWithDate:self];
}

- (NSString *)wechat_stringYearMonthDay
{
    return [NSDate wechat_stringYearMonthDayWithDate:self];
}

- (NSString *)wechat_stringYearMonthDayHourMinuteSecond
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *str = [formatter stringFromDate:self];
    return str;
    
}

- (NSString *)wechat_stringYearMonthDayCompareToday
{
    NSString *str;
    NSInteger chaDay = [self wechat_daysBetweenCurrentDateAndDate];
    if (chaDay == 0) {
        str = @"今天";
    }else if (chaDay == 1){
        str = @"明天";
    }else if (chaDay == -1){
        str = @"昨天";
    }else if (chaDay > -7 && chaDay <= -2){
        str = [self wechat_weekday];
    }else{
        str = [self wechat_stringYearMonthDay];
    }
    
    return str;
}

+ (NSString *)wechat_stringYearMonthDayWithDate:(NSDate *)date
{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy/MM/dd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSString *)wechat_dateMonthDayWithDate:(NSDate *)date
{
    if (date == nil) {
        date = [NSDate date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSString *)wechat_timestampFormatString {
    return @"yyyy-MM-dd HH:mm:ss";
}

+ (NSString *)wechat_timestampFormatStringSubSeconds
{
    return @"yyyy-MM-dd HH:mm";
}


+ (NSDate *) wechat_dateStandardFormatTimeZeroWithDate: (NSDate *) aDate{
    NSString *str = [[NSDate wechat_stringYearMonthDayWithDate:aDate]stringByAppendingString:@" 00:00:00"];
    NSDate *date = [NSDate wechat_dateFromString:str];
    return date;
}

- (NSInteger) wechat_daysBetweenCurrentDateAndDate
{
    //只取年月日比较
    NSDate *dateSelf = [NSDate wechat_dateStandardFormatTimeZeroWithDate:self];
    NSTimeInterval timeInterval = [dateSelf timeIntervalSince1970];
    NSDate *dateNow = [NSDate wechat_dateStandardFormatTimeZeroWithDate:nil];
    NSTimeInterval timeIntervalNow = [dateNow timeIntervalSince1970];
    
    NSTimeInterval cha = timeInterval - timeIntervalNow;
    CGFloat chaDay = cha / 86400.0;
    NSInteger day = chaDay * 1;
    return day;
}

+ (NSDate *)wechat_dateFromString:(NSString *)string {
    return [NSDate wechat_dateFromString:string withFormat:[NSDate wechat_dbFormatString]];
}

+ (NSDate *)wechat_dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}
+ (NSString *)wechat_dbFormatString {
    return [NSDate wechat_timestampFormatString];
}
@end

#import "XYDateUtils.h"

@implementation XYDateUtils

+ (NSString *)stringFromDate:(NSDate *)date
                  withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDate = [dateFormatter stringFromDate:date];
    return destDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString
                withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];// @"yyyy-MM-dd HH:mm:ss"
    NSDate *destDate = [[NSDate alloc] init];
    destDate = [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (BOOL)isWeekEndWithDate:(NSDate *)date
{
    BOOL isWeekEnd = NO;
    if (date) {
        
        NSCalendar *calendar         = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags          = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:unitFlags fromDate:date];
        NSUInteger weekday           = [components weekday];
        if (weekday == 1 || weekday == 7) {
            isWeekEnd = YES;
        }
    }
    return isWeekEnd;
}

+ (NSString *)getShortWeekdaySymbolsFromDate:(NSDate *)date
{
    NSCalendar *calendar         = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags          = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSUInteger weekday           = [components weekday];
    NSArray *weekdayNames        = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    return [weekdayNames objectAtIndex:weekday - 1];
}

+ (NSString *)getStandaloneWeekdaySymbolsFromDate:(NSDate *)date
{
    NSCalendar *calendar         = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags          = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSUInteger weekday           = [components weekday];
    NSArray *fullWeekdayNames    = [[[NSDateFormatter alloc] init] standaloneWeekdaySymbols];
    return [fullWeekdayNames objectAtIndex:weekday - 1];
}

+ (NSInteger)getWeekOfYearNumberFromDate:(NSDate *)date
{
    //  先定义一个遵循某个历法的日历对象
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSCalendarUnitYear, NSCalendarUnitMonth, NSCalendarUnitDay等）
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    return [dateComponents weekOfYear];
}

+ (NSInteger)getWeekOfMonthNumberFromDate:(NSDate *)date
{
    //  先定义一个遵循某个历法的日历对象
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSCalendarUnitYear, NSCalendarUnitMonth, NSCalendarUnitDay等）
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    return [dateComponents weekOfMonth];
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+ (NSString *)compareCurrentTime:(NSDate *)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return result;
}

//XY ADD: (2014-12-23 11:33) start
+ (NSString *)lastUpdateTimeWithRefreshKey:(NSString *)refreshKey
{
    NSString *lastUpdateTimeString = nil;
    NSUserDefaults *userDefaults   = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdateDate         = [userDefaults objectForKey:refreshKey];

    if (lastUpdateDate) {
        
        NSDate *nsToday                          = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDate *nsYesterday                      = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*1];
        NSDate *nsDayBeforeYesterday             = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*2];

        NSCalendar *calendar                     = [NSCalendar currentCalendar];
        unsigned unitFlags                       = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

        NSDateComponents *compLastUpdateDate     = [calendar components:unitFlags fromDate:lastUpdateDate];
        NSDateComponents *compToday              = [calendar components:unitFlags fromDate:nsToday];
        NSDateComponents *compYesterday          = [calendar components:unitFlags fromDate:nsYesterday];
        NSDateComponents *compDayBeforeYesterday = [calendar components:unitFlags fromDate:nsDayBeforeYesterday];
        
        if (compLastUpdateDate.year == compToday.year &&
            compLastUpdateDate.month == compToday.month &&
            compLastUpdateDate.day == compToday.day) {
            
            lastUpdateTimeString = [NSString stringWithFormat:@"最后更新：今天 %@", [XYDateUtils stringFromDate:lastUpdateDate withFormat:@"HH:mm"]];
        }
        else if (compLastUpdateDate.year == compYesterday.year &&
                 compLastUpdateDate.month == compYesterday.month &&
                 compLastUpdateDate.day == compYesterday.day) {
            
            lastUpdateTimeString = [NSString stringWithFormat:@"最后更新：昨天 %@", [XYDateUtils stringFromDate:lastUpdateDate withFormat:@"HH:mm"]];
        }
        else if (compLastUpdateDate.year == compDayBeforeYesterday.year &&
                 compLastUpdateDate.month == compDayBeforeYesterday.month &&
                 compLastUpdateDate.day == compDayBeforeYesterday.day) {
        
            lastUpdateTimeString = [NSString stringWithFormat:@"最后更新：前天 %@", [XYDateUtils stringFromDate:lastUpdateDate withFormat:@"HH:mm"]];
        }
        else {
        
            lastUpdateTimeString = [NSString stringWithFormat:@"最后更新：%@", [XYDateUtils stringFromDate:lastUpdateDate withFormat:@"yyyy年M月d日 HH:mm"]];
        }
    }
    else {
        lastUpdateTimeString = @"从未";
    }
    
    [userDefaults setObject:[NSDate date] forKey:refreshKey];
    [userDefaults synchronize];
    
    return lastUpdateTimeString;
}
//XY ADD: (2014-12-23 11:33) end

//XY ADD: (2015-01-13 18:30) start
+ (NSDate *)nextDayForDate:(NSDate *)date
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
    
}
//XY ADD: (2015-01-13 18:30) end

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"
+ (NSString *)wechat_changeTheDateString:(NSString *)Str
{
    NSDate *lastDate = [NSDate wechat_dateFromString:Str withFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *period;   //时间段
    NSString *hour;     //时
    NSString *result;
    
    if ([lastDate wechat_hour]>=5 && [lastDate wechat_hour]<12) {
        period = @"上午";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate wechat_hour]];
    }else if ([lastDate wechat_hour]>=12 && [lastDate wechat_hour]<=18){
        period = @"下午";
        int tmpHour = (int)[lastDate wechat_hour]-12;
        hour = [NSString stringWithFormat:@"%02d",(tmpHour<=0?12:tmpHour)];
    }else if ([lastDate wechat_hour]>18 && [lastDate wechat_hour]<=23){
        period = @"晚上";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate wechat_hour]-12];
    }else{
        period = @"清晨";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate wechat_hour]];
    }
    
    if ([lastDate wechat_year]==[[NSDate date] wechat_year]) {
        NSInteger days = [NSDate wechat_daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days == 0) {
            if ([lastDate wechat_daysBetweenCurrentDateAndDate] == -1){
                result = @"昨天";
            }
            else{
                result = [NSString stringWithFormat:@"%@ %@:%02d",period,hour,(int)[lastDate wechat_minute]];
            }
        }else{
            result = [lastDate wechat_stringYearMonthDayCompareToday];
        }
    }else{
        result = [lastDate wechat_stringYearMonthDay];
    }
    
    return result;
}

@end
