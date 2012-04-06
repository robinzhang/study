//
//  SettingViewController.h
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHelper.h"
#define kPickerHeight 255

@interface SettingViewController : SnSecTableViewController<UIPickerViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    UISwitch *switchForMe;
    UISwitch *switchFollower;
    UISwitch *switchAll;
    UISwitch *switchPM;
    //UISwitch *switchFriends;
    UIButton *notifyTime;
    UILabel  *notifyTimeLable;
    UIPickerView *startTime;
    UIPickerView *endTime;
    UIView *pickerContainer;
    UISwitch *switchGpsOn;
    
    NSArray *rangelist;
    
    //int val;
    //NSInteger vStartTime;
    //NSInteger vEndTime;
    
    NSString *_me;
    SnAppSetting *_setting;
}
//@property (nonatomic,assign) int val;
//@property (nonatomic,assign) NSInteger vStartTime;
@property (nonatomic,retain) SnAppSetting* setting;
@property (nonatomic,retain) NSArray *rangelist;
@end
