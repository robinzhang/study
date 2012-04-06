
//#define KApi_Domain               @"http://sandbox.open.kanguo.com"
//#define KApi_Domain               @"http://open.kanguo.com"
#define KApi_Domain                 @"http://beta.open.kanguo.com"
#define URLSinaUserLoginIn          @"%@/users/SinaLogin?accountId=%@&accountName=%@&userToken=%@&userTokenSecret=%@&Open_Account_TypeValue=1&userFaceUrl=%@"
#define URLSnMessageUserList        @"%@/TMessages/GetNewsFromPeople?userid=%@&accountId=%@&newsType=2&pageIndex=%d&pageSize=%d&longitude=%f&latitude=%f&Mode=%d"   // 0 时间  1距离

#define URLMediaUsersList           @"%@/Users/GetMediaUsersList/%d/%d"

#define URLMessageGetFavourite      @"%@/TMessages/GetFavourite/%@/%d/%d"
//#define URLSnMyMessageList        @"%@/TMessages/Pull?userid=%@&longtitude=&latitude=&range=&pageIndex=%d&pageSize=%d&Mode=0&sendType=128&MessageType=&MessageLevel="
#define URLSnMessageShareList       @"%@/TMessages/PullNewsAround?userid=%@&longtitude=%@&latitude=%@&range=%d&pageIndex=%d&pageSize=%d&Mode=%d&sendType=128"

#define URLUserLogon                @"%@/users/seclogon/%@/%@"  /// username  password
#define URLUserRegister             @"%@/users/registe/%@/%@/%@/%@/%@/%d"  /// username  password  nickname latitude longitude sex
#define URLUserProfile              @"%@/users/%@"  /// userid
#define URLSnMessageDetail          @"%@/TMessages/GetMessageComment/%@/%@/1/1" /// userid  messageid
#define URLGetAroundUsers           @"%@/Users/GetAroundUsers/%f/%f/%@/%d/%d"   ///{Longitude}/{Latitude}/{range}/{pageIndex}/{pageSize}
#define URLGetUserList              @"%@/TMessages/GetUserRelation/%d/%d/%@/%d"  ///{pageindex}/{pagesize}/{userid}/{type}  0=fans 1=follow 2=friend
#define URLFollow                   @"%@/TMessages/Follow/%@/%@"
#define URLUnFollow                 @"%@/TMessages/UnFollow/%@/%@"
#define URLGetUserRelation          @"%@/TMessages/GetUserRelationDetails/%@/%@"
#define URLGetNotify                @"%@/TMessages/GetNotifys?userid=%@&longitude=%f&latitude=%f&range=2000&count=2&sendType=%d"
#define URLUpdateUserFace           @"%@/Users/UpdateUserFace/%@"   // userid
#define URLUpdateUserInfo           @"%@/Users/UpdateUserInfo?userid=%@&name=%@&introduction=%@&cityid=&regionid=&sex=%d"   // userid  username intro 

#define URLPostNews                 @"%@/TMessages/PostNews?userid=%@&maintitle=%@&subtitle=%@&occurtime=%@&longitude=%@&latitude=%@&address=%@&content=%@&cancomment=%@&newsType=%@&source=%@&notifySoundName=%@&idlists=%@"  //
#define URLAddFavourite             @"%@/TMessages/AddFavourite/%@/%@/%@/%d"  //{userid}  {orgionaluserid} {tmessageId}  {Mode} 0+ 1-
#define URLNewsDetails              @"%@/TMessages/GetNewsDetails/%@/%@" //messageId  userId
#define URLNewsComment              @"%@/TMessages/GetMessageComment/%@/%@/%d/%d" //userid messageid
#define URLCommentNews              @"%@/TMessages/Comment?userid=%@&tmessageid=%@&originalUserId=%@&text=%@&transfer=0"
#define URLCheckFavorite            @"%@/TMessages/IsNewsInCollection/%@/%@/%@"   //{userid}/{OrgionalMessageUserID}/{MessageID}
#define URLPrivateNews              @"%@/TMessages/GetPrivateNews/%@/%f/%f/%d/%d/%d"
#define URLPostUserCorrection       @"%@/TMessages/PostUserCorrection?userid=%@&orgionalMessageuserid=%@&tmessageid=%@&content=%@"   //{userid}/{OrgionalMessageUserID}/{MessageID}/{content}
#define URLDelMessages              @"%@/TMessages/Del/%@/%@" // Userid  MessageID
#define URLGuestLogin               @"%@/users/GuestLogin/%@" // 
#define URLPublishImage             @"%@/TMessages/PublishImage/%@"  //Userid 
#define URLPostNewsContent          @"%@/TMessages/PostNewsContent?userid=%@&maintitle=%@&subtitle=&occurtime=&longitude=%@&latitude=%@&address=%@&cancomment=1&newsType=2&source=iphone&notifySoundName=&idlists=%@&imageUrl=%@" 
    //?userid={userid}&maintitle={maintitle}&subtitle={subtitle}&occurtime={occurtime}&longitude={longitude}&latitude={latitude}&address={address}&cancomment={cancomment}&newsType={newsType}&source={source}&notifySoundName={notifySoundName}&idlists={idlists}&imageUrl={imageUrl}

#define URLVersionChecker          @"%@/Users/Version/%@/iphone"  // {AppKey}  
#define URLGetNewsComment          @"%@/TMessages/GetNewsComment/%@/%d/%d" //{userid} {pageindex} {pageSize}

#define URLGetUserNotifications          @"%@/users/GetUserNotifications?userid=%@"
#define URLUpdateUserNotifications       @"%@/users/UpdateUserNotifications?userid=%@&dataKey=%d"
#define URLGetMessageVisitors            @"%@/TMessages/GetMessageVister/%@/%@/%d/%d"

#define KUserID                     @"UserID"
#define KUserSecToken               @"UserSecToken"
#define KGUserID                    @"GUserID"
#define KGUserSecToken              @"GUserSecToken"
#define KNotifyInterval             1800
#define KDefaultLatitude            39.908687
#define KDefaultLongitude           116.461968
#define NowVesion                   1.2
#define KUserAgent                  @"kgIosMedia"
#define SinaWeiBoAPPKey             @"1067181552"
#define SinaWeiBoAPPSecret          @"41e97458dc695cb292cccd77c9775898"
#define KWeiboUID                   @"WeiboUID"
#define KDeviceUniqueId             @"KDeviceUniqueId"
#define KPageTitleHeight            27
#define KLocationReqireAlerted      @"KLocationReqireAlerted"
#define KMessageRange               2000
#define GAID                        @"UA-23031932-3"
#define kGANDispatchPeriodSec       10
#define DebugModel                  NO
#define KAppKey                     @"AppKey"
#define KAppKValue                  @"2"
#define KPMSessionTimerInterval     30  /// 心跳

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SnMessage.h"
#import "SnAppSetting.h"
#import "UserProfile.h"
#import "SnUserAppInfo.h"
#import "SnTableMessageItem.h"
#import "LogonViewController.h"
#import "SnViewController.h"
#import "SnTableViewController.h"
#import "SnSecTableViewController.h"
#import "SnModelViewController.h"
#import "GANTracker.h"

@interface UserHelper : NSObject
+(SnTableMessageItem*)buildMessageItem:(SnMessage*)post nowLocation:(CLLocation*)nowLocation;

///////////////////////////////////////////////////////////////////////////////////////////////////
+(NSString*)GetUserID;
+(NSString*)GetSecToken;
+(bool)isLogon;
+(bool)isGuestLogon;
+(void)SetUserLogon:(NSString*)userid usertoken:(NSString*)usertoken;
+(void)SetGuestLogon:(NSString*)userid usertoken:(NSString*)usertoken;
+(void)SetUserLogout;

///////////////////////////////////////////////////////////////////////////////////////////////////
+(CLLocation*)GetUserLocation;
+(void)SetUserLocation:(CLLocation*)location;

///////////////////////////////////////////////////////////////////////////////////////////////////
+(UserProfile*)GetUserProfile:(NSString*)userid;
+(void)SetUserProfile:(UserProfile*)profile;

///////////////////////////////////////////////////////////////////////////////////////////////////
+(SnUserAppInfo*)GetUserAppInfo;
+(void)SetUserAppInfo:(SnUserAppInfo*)info;

+ (NSDate*) formatDateByString:(NSString*)input;
+(NSString*)formartDateTimeFull:(NSDate*)date;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)getDistance:(CLLocation*)location another:(CLLocation*)another;

///////////////////////////////////////////////////////////////////////////////////////////////////
+(void)doAlert:(id)sender  title:(NSString*)title message:(NSString*)message;

///////////////////////////////////////////////////////////////////////////////////////////////////
+(NSMutableArray*)GetMessageList:(NSString*)key;
+(void)SetMessageList:(NSArray *)objectArray key:(NSString*)key;

///////////////////////////////////////////////////////////////////////////////////////////////////
+(SnAppSetting*)GetAppSetting:(NSString*)userid;
+(void)SetAppSetting:(SnAppSetting*)setting;

///////////////////////////////////////////////////////////////////////////////////////////////////
+(void)DegBugWidthLog:(NSString*)log title:(NSString*)title;

/////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)locationPath;
+ (void) log:(NSString*)msg;
+ (NSArray*) getLogArray;
+ (void) clearLog;

+ (NSString*) registeHWMac;
@end
