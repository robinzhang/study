//
//  UserHelper.m
//  SnsClient
//
//  Created by  on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserHelper.h"
#import "DeviceMac.h"

@implementation UserHelper
////////////////////////////////////// buildMessageItem ///////////////////////
+(SnTableMessageItem*)buildMessageItem:(SnMessage*)post nowLocation:(CLLocation*)nowLocation
{
    //        NSString *url = [NSString stringWithFormat:@"tt://message/?messageid=%@&userid=%@"
    //                                 ,post.MessageID
    //                                 ,post.UserID];
    
    CLLocation* another = [[CLLocation alloc] initWithLatitude:post.Latitude longitude:post.Longitude];
    NSString *distanceStr = [UserHelper getDistance:nowLocation another:another];
    NSString *timeStr = [post.PublicDate formatRelativeTime];
    // NSString *text = [NSString stringWithFormat:@"%@ 距离:%@ \r点击:%d 评论:%d",timeStr,distanceStr,post.ViewCount,post.CommentCount];
    NSString *text = [NSString stringWithFormat:@"%@ 距离:%@",timeStr,distanceStr];
    NSString *caption = [NSString stringWithFormat:@"看过:%d 评论:%d",post.ViewCount,post.CommentCount];
    
    NSString *url = [NSString stringWithFormat:@"tt://message/?messageid=%@&userid=%@&username=%@&userface=%@"
                     ,post.MessageID
                     ,post.UserID
                     ,[post.UserName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
                     ,post.UserFace];
    
    SnTableMessageItem *item = 
    [SnTableMessageItem  
     itemWithTitle:post.MessageBody
     caption:caption 
     text:text 
     timestamp:nil 
     URL:url
     ];
    
    [item setUserType:post.UserType];
    [item setImageURL:[NSString stringWithFormat:@"%@_80_80.jpg",post.UserFace]];
    item.userInfo = post;
    item.PicFlag = 0;
    //item.viewcount = [NSString stringWithFormat:@"%d",post.ViewCount];
    //item.commentCount = [NSString stringWithFormat:@"%d",post.CommentCount];
    if(TTIsStringWithAnyText(post.PicPath))
         item.PicFlag = 1;
    //[item setCommentCount:post.commentCount];
    //[item setMessageType:post.messageType];
   
    return item;
}

////////////////////////////////////// User Logon ///////////////////////
+(NSString*)GetUserID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:KUserID] && [userDefaults objectForKey:KUserSecToken])
        return [userDefaults objectForKey:KUserID];
    else if([userDefaults objectForKey:KGUserID] && [userDefaults objectForKey:KGUserSecToken])
        return [userDefaults objectForKey:KGUserID];
    else
       return @""; 
}

////////////////////////////////////// User GuestLogon ///////////////////////
+(NSString*)GetSecToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:KUserID] && [userDefaults objectForKey:KUserSecToken])
        return [userDefaults objectForKey:KUserSecToken];
    else if([userDefaults objectForKey:KGUserID] && [userDefaults objectForKey:KGUserSecToken])
        return [userDefaults objectForKey:KGUserSecToken];
    else
        return @"";
}

+(bool)isLogon
{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     if([userDefaults objectForKey:KUserSecToken] && [userDefaults objectForKey:KUserID])
        return YES;
     else
        return NO;
}

+(bool)isGuestLogon
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:KGUserSecToken] && [userDefaults objectForKey:KGUserID])
        return YES;
    else
        return NO;
}


+(void)SetUserLogon:(NSString*)userid usertoken:(NSString*)usertoken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userid forKey:KUserID];
    [userDefaults setObject:usertoken forKey:KUserSecToken];
    [userDefaults synchronize];
}

+(void)SetGuestLogon:(NSString*)userid usertoken:(NSString*)usertoken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userid forKey:KGUserID];
    [userDefaults setObject:usertoken forKey:KGUserSecToken];
    [userDefaults synchronize];
}

+(void)SetUserLogout
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:KUserID];
    [userDefaults removeObjectForKey:KUserSecToken];
    [userDefaults synchronize];
}

+(UserProfile*)GetUserProfile:(NSString*)userid
{
    NSString *key = [NSString stringWithFormat:@"KProfle_%@",userid];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [userDefaults objectForKey: key];
    UserProfile* obj = nil;
    if([userDefaults objectForKey: key])
        obj = (UserProfile*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}

+(void)SetUserProfile:(UserProfile*)profile
{
    NSString *key = [NSString stringWithFormat:@"KProfle_%@",profile.UserID];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:profile];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:myEncodedObject  forKey:key];
    [userDefaults synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+(SnUserAppInfo*)GetUserAppInfo
{
    NSString *userid = [UserHelper GetUserID];
    NSString *key = [NSString stringWithFormat:@"KUserAppInfo_%@",userid];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [userDefaults objectForKey: key];
    SnUserAppInfo* obj;
    if([userDefaults objectForKey: key])
    {
       obj = (SnUserAppInfo*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    }
    else
    {
        obj = [[SnUserAppInfo alloc] init];
        obj.UserID = userid;
    }
   
    obj.LocationDidChange = [userDefaults  boolForKey:@"APP_LocationDidChange"];
    obj.LastVesion = [userDefaults floatForKey:@"APP_LastVesion"];
    if([userDefaults objectForKey:@"APP_WeiBoUserID"])
        obj.WeiBoUserID = [userDefaults objectForKey:@"APP_WeiBoUserID"];
   return obj;
}

+(void)SetUserAppInfo:(SnUserAppInfo*)info
{
    NSString *userid = [UserHelper GetUserID];
    NSString *key = [NSString stringWithFormat:@"KUserAppInfo_%@",userid];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:info];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:myEncodedObject  forKey:key];
    [userDefaults setFloat:info.LastVesion forKey:@"APP_LastVesion"];
    [userDefaults setObject:info.WeiBoUserID forKey:@"APP_WeiBoUserID"];
    [userDefaults setBool:info.LocationDidChange forKey:@"APP_LocationDidChange"];
    [userDefaults synchronize];
}

////////////////////////////////////// UserLocation ///////////////////////
+(CLLocation*)GetUserLocation
{
    NSString *keyLa = @"UserLocation_La";
    NSString *keyLo = @"UserLocation_Lo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float la = KDefaultLatitude;
    float lo = KDefaultLongitude;
    if([userDefaults objectForKey: keyLa] && [userDefaults objectForKey: keyLo])
    {
        la = [[userDefaults objectForKey: keyLa] floatValue];
        lo = [[userDefaults objectForKey: keyLo] floatValue];
        //-180 180,  90 -90
         return [[CLLocation alloc]initWithLatitude:la longitude:lo];
    }
    
    //if(la > 0 && lo>0) 
    //else
    
    return [[CLLocation alloc]initWithLatitude:KDefaultLatitude longitude:KDefaultLongitude];
}

+(void)SetUserLocation:(CLLocation*)location
{
    NSString *keyLa = @"UserLocation_La";
    NSString *keyLo = @"UserLocation_Lo";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%f", location.coordinate.latitude]  forKey:keyLa];
    [userDefaults setObject:[NSString stringWithFormat:@"%f", location.coordinate.longitude]  forKey:keyLo];
    [userDefaults synchronize];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate*) formatDateByString:(NSString*)input
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:input];
    [dateFormatter release];
    return date;
}

+(NSString*)formartDateTimeFull:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString* str = [formatter stringFromDate:date];
    [formatter release];
    return str;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)getDistance:(CLLocation*)location another:(CLLocation*)another{
    return [NSString stringWithFormat:@"%0.2f km",[location distanceFromLocation:another]/1000];
}

+(void)doAlert:(id)sender  title:(NSString*)title message:(NSString*)message
{
	UIAlertView *alertDialog;
    
    alertDialog = [[UIAlertView alloc] 
                   initWithTitle: title 
                   message:message
                   delegate: nil 
                   cancelButtonTitle: NSLocalizedString(@"Done", @"确定")
                   otherButtonTitles: nil];
    
    [alertDialog show];
	[alertDialog release];
}

+(NSMutableArray*)GetMessageList:(NSString*)key
{
    //NSString *key = [NSString stringWithFormat:@"KHomeMessageArry_%@",userid];
    NSMutableArray  *objectArray = [[NSMutableArray alloc] init];
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:key];
    if ([currentDefaults objectForKey:key])
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
            objectArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        else
            objectArray = [[NSMutableArray alloc] init];
        //[dataRepresentingSavedArray release];
    }
    return objectArray;
}

+(void)SetMessageList:(NSArray *)objectArray key:(NSString*)key
{
    //NSString *key = [NSString stringWithFormat:@"KHomeMessageArry_%@",userid];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:objectArray] forKey:key];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+(SnAppSetting*)GetAppSetting:(NSString*)userid
{
    NSString *key = [NSString stringWithFormat:@"KAppSetting_%@",userid];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [userDefaults objectForKey: key];
    SnAppSetting* obj;
    if([userDefaults objectForKey: key])
    {
       obj = (SnAppSetting*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
       //[myEncodedObject release];
    }
    else
    {
        obj = [[ SnAppSetting alloc] init];
        obj.UserID = userid;
    }
    return obj;
}

+(void)SetAppSetting:(SnAppSetting*)setting
{
    NSString *key = [NSString stringWithFormat:@"KAppSetting_%@",setting.UserID];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:setting];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:myEncodedObject  forKey:key];
    [userDefaults synchronize];
}

+(void)DegBugWidthLog:(NSString*)log title:(NSString*)title
{
    if(DebugModel == YES) // + _ +
      NSLog(@"-- %@ >> %@",title,log);
}



///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)locationPath
{
	NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	return [path stringByAppendingPathComponent:@"debug.log"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void) log:(NSString*)msg
{	
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];
	NSString * logMessage = [NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:[NSDate date]], msg];
    
	NSString * fileName = [UserHelper locationPath];
	FILE * f = fopen([fileName cStringUsingEncoding:NSUTF8StringEncoding], "at");
	fprintf(f, "%s\n", [logMessage cStringUsingEncoding:NSUTF8StringEncoding]);
	fclose (f);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSArray*) getLogArray
{
	NSString * fileName = [UserHelper locationPath];
	NSString *content = [NSString stringWithContentsOfFile:fileName
                                              usedEncoding:nil error:nil];
	NSMutableArray * array = (NSMutableArray *)[content componentsSeparatedByString:@"\n"];
	NSMutableArray * newArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < [array count]; i++)
	{
		NSString * item = [array objectAtIndex:i];
		if ([item length])
			[newArray addObject:item];
	}
	return (NSArray*)newArray;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void) clearLog
{
	NSString * content = @"";
	NSString * fileName = [UserHelper locationPath];
	[content writeToFile:fileName 
              atomically:NO 
                encoding:NSStringEncodingConversionAllowLossy 
                   error:nil];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*) registeHWMac
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:KDeviceUniqueId]) {
        //return [userDefaults stringForKey:KDeviceUniqueId];
    }
    
    //NSString *hwType=[NSString stringWithFormat:@"%@,%@,%@",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    NSString *did = [NSString stringWithFormat:@"%s",hw_addrs[1]];
    
    [userDefaults setValue:did forKey:KDeviceUniqueId];
    [userDefaults synchronize];
    return did;
}
@end
