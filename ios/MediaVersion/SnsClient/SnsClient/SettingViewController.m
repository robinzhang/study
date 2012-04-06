//
//  SettingViewController.m
//  SnsClient
//
//  Created by zhan xiaoping on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"

@implementation SettingViewController
@synthesize setting=_setting;
@synthesize rangelist=rangelist;
//@synthesize vStartTime=vStartTime;
//@synthesize vEndTime=vEndTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_setting.png"] tag:0] autorelease];
        self.tableViewStyle = UITableViewStyleGrouped;
        self.variableHeightRows = YES;
        
        self.title = NSLocalizedString(@"Notifications", @"提醒设置");
        
        switchForMe=[[UISwitch alloc] init];
        [switchForMe addTarget:self action:@selector(save) forControlEvents:UIControlEventAllTouchEvents];
        switchFollower=[[UISwitch alloc] init];
        [switchFollower addTarget:self action:@selector(save) forControlEvents:UIControlEventAllTouchEvents];
        switchAll=[[UISwitch alloc] init];
        [switchAll addTarget:self action:@selector(save) forControlEvents:UIControlEventAllTouchEvents];
        //switchFriends=[[UISwitch alloc] init];
        //[switchFriends addTarget:self action:@selector(save) forControlEvents:UIControlEventAllTouchEvents];
        switchPM=[[UISwitch alloc] init];
        [switchPM addTarget:self action:@selector(save) forControlEvents:UIControlEventAllTouchEvents];
        
        switchGpsOn=[[UISwitch alloc] init];
        [switchGpsOn addTarget:self action:@selector(save) forControlEvents:UIControlEventAllTouchEvents];
        
        notifyTime=[[UIButton alloc] init];
        [notifyTime setTitle:@"9:00-21:00" forState:UIControlStateNormal];
        notifyTime.frame=CGRectMake(105, 0, 150, 30);
        [notifyTime setTitleColor:RGBCOLOR(42, 178, 255) forState:UIControlStateNormal];
        [notifyTime addTarget:self action:@selector(togglePicker) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *arr =  [[NSArray alloc] initWithObjects:@"0:00",@"1:00",@"2:00",@"3:00",@"4:00",@"5:00",@"6:00",@"7:00",@"8:00",@"9:00",
                         @"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00", @"24:00",nil];
        self.rangelist =arr;
        [arr release];
        
        _me = [UserHelper GetUserID];
        self.setting = [UserHelper GetAppSetting:_me];
        
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)showTimePicker{
    
    startTime  = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40,320, 240)];
    startTime.delegate =self; 
    startTime.tag=0;
    
    [pickerContainer addSubview:startTime];
    startTime.showsSelectionIndicator = YES;
    startTime.delegate=self;
    
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    [flexSpace release];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(togglePicker)];
    [barItems addObject:doneBtn];
    [doneBtn release];
    [pickerDateToolbar setItems:barItems animated:YES];
    [barItems release];
    [pickerContainer addSubview:pickerDateToolbar];
    [pickerDateToolbar release];
    
}

//
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)loadView{
    [super loadView];
    
    CGRect frame=self.view.bounds;
    pickerContainer=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, 320, kPickerHeight)];
    pickerContainer.alpha=0.9;
    
    [self showTimePicker];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)save{
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int val=256;
    
//    if (switchForMe.on) {
//        if(val > 0)
//            val=8 |val;
//        else
//            val=8; 
//    }
    
    if(switchFollower.on){
             val=512 | val;
    }
    
    if(switchAll.on){
             val= 128 | val;
    }

//    if(switchFriends.on){
//         if(val> 0)
//             val= 1|val;
//         else
//             val=1; 
//    }
    
    self.setting.KBatterySaveMode = switchGpsOn.on;
    self.setting.NotifySettings = val;
    //[userDefaults setBool:switchGpsOn.on forKey:KBatterySaveMode];
    //[userDefaults setInteger:val forKey:NotifySettings];
    if (switchPM.on) {
        //[userDefaults setInteger:1 forKey:KPMNotifySetting];
        self.setting.KPMNotifySetting = 1;
    }
    else
    {
        self.setting.KPMNotifySetting = 0;
        //[userDefaults setInteger:0 forKey:KPMNotifySetting];
    }
    
//    int vStartTime = self.setting.KNotifyStartTime;
//    int vEndTime = self.setting.KNotifyEndTime;
    //_setting.KNotifyStartTime = self.vStartTime;
    //_setting.KNotifyEndTime = self.vEndTime;
    
    //[userDefaults setInteger:self.vStartTime forKey:KNotifyStartTime];
    //[userDefaults setInteger:self.vEndTime forKey:KNotifyEndTime];
    
    
//    BOOL inSpan=NO;
//    NSDate *now=[NSDate date];
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
//    [dateFormatter setDateFormat:@"HH"];
//    NSInteger cu=[[dateFormatter stringFromDate:now] integerValue];
//    [dateFormatter release];
//    if (vStartTime<vEndTime) {
//        inSpan=(vStartTime<=cu) && (vEndTime>=cu);
//    }else{
//        inSpan=(vEndTime<=cu) && (vStartTime>=cu);
//    }
    //[userDefaults synchronize];
    [UserHelper SetAppSetting:self.setting];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)togglePicker{
    CGRect frame=self.view.bounds;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    //NSLog(@"togglePicker");
    if(![pickerContainer superview]){
        [pickerContainer setFrame:CGRectMake(0, frame.size.height - kPickerHeight, 320, kPickerHeight)];
        [self.view insertSubview:pickerContainer aboveSubview:self.tableView];
        [pickerContainer setAlpha:1.0f];
    }else{
        
        [pickerContainer removeFromSuperview];
        [pickerContainer setAlpha:0];
        [pickerContainer setFrame:CGRectMake(0, frame.size.height, 320, kPickerHeight)];
        
        NSString *notifyTimeStr=[NSString stringWithFormat:@"%d:00-%d:00",self.setting.KNotifyStartTime,self.setting.KNotifyEndTime];
        [notifyTime setTitle:notifyTimeStr forState:UIControlStateNormal];
        [self save];
        
    }
    
	[UIView commitAnimations];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadData{

    
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //val=[userDefaults integerForKey:NotifySettings];
    //NSInteger pm=[userDefaults integerForKey:KPMNotifySetting];
    
    int val = self.setting.NotifySettings;
    //int pm = self.setting.KPMNotifySetting;
    
    switchForMe.on=((val|256)==val);
    switchFollower.on=((val|512)==val);
    switchAll.on=((val|128)==val);
    //switchFriends.on=((val|512)==val);
    //switchPM.on=(pm==1);
    
    
    //self.vStartTime=[userDefaults integerForKey:KNotifyStartTime];
    //self.vEndTime=[userDefaults integerForKey:KNotifyEndTime];
    
//    if (![userDefaults objectForKey:KNotifyStartTime]) {
//        self.vStartTime=6;
//    }else{
//        self.vStartTime=[userDefaults integerForKey:KNotifyStartTime];
//    }
//    if (![userDefaults objectForKey:KNotifyEndTime]) {
//        self.vEndTime=24;
//    }else{
//        self.vEndTime=[userDefaults integerForKey:KNotifyEndTime];
//    }
    
    [startTime selectRow:self.setting.KNotifyStartTime  inComponent:0  animated:YES];
    [startTime selectRow:self.setting.KNotifyEndTime  inComponent:1  animated:YES];
//    [startTime selectRow:self.vStartTime  inComponent:0  animated:YES];
//    [startTime selectRow:self.vEndTime  inComponent:1  animated:YES];
    
    NSString *notifyTimeStr=[NSString stringWithFormat:@"%d:00-%d:00",self.setting.KNotifyStartTime,self.setting.KNotifyEndTime];
    [notifyTime setTitle:notifyTimeStr forState:UIControlStateNormal] ;
    
    switchGpsOn.on=self.setting.KBatterySaveMode;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
//    if (![[GANTracker sharedTracker] trackPageview:@"/Setting"  withError:nil]) {
//        // Handle error here
//    }
    //self.navigationItem.hidesBackButton = YES;
    
    if (![[GANTracker sharedTracker] trackPageview:[[self class] description]  withError:nil]) {
        // Handle error here
    }
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    
//    TTTableControlItem* switchForMeItem = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Leave For Myself", @"留给我自己的") control:switchForMe];
    TTTableControlItem* switchFollowerItem = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Following", @"我关注的人的") control:switchFollower];
    TTTableControlItem* switchAllItem = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Public Notes", @"陌生人的") control:switchAll];
//    TTTableControlItem* switchFriendsItem = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Friends", @"朋友的") control:switchFriends];
    TTTableControlItem* switchGPSItem = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Battery Save Mode", @"省电模式") control:switchGpsOn];
    TTTableControlItem* notifyTimeItem = [TTTableControlItem itemWithCaption:NSLocalizedString(@"Notification Time", @"接收通知时段") control:notifyTime];
    
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       NSLocalizedString(@"Notifications", @"Notifications"),
                       //switchForMeItem, 
                       //switchFriendsItem,
                       switchFollowerItem, 
                       switchAllItem, 
                       
                       NSLocalizedString(@"Notification Time", @"接收通知时段"),
                       notifyTimeItem,
                       
                       NSLocalizedString(@"Battery Save Mode", @"省电模式"),
                       switchGPSItem,
                       nil];
    
}


#pragma mark - View UIPickerViewDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.rangelist count];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.rangelist objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component==0) {
        self.setting.KNotifyStartTime = row;
       NSLog(@"start time:%d",row);
    }
    
    if (component==1) {
        self.setting.KNotifyEndTime=row;
       NSLog(@"end time:%d",row);
    }
    

    //NSLog(@"start time:%d",self.setting.KNotifyStartTime);
    //NSLog(@"end time:%d",self.setting.KNotifyEndTime);
    

    
}

#pragma mark - View lifecycle
-(void)setView:(UIView *)view
{
    if(view == nil)
        return;
    
    [super setView:view];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewDidUnload
{
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [super dealloc];
    [notifyTime release];
    [switchForMe release];
    [switchFollower release];
    //[switchFriends release];
    [switchAll release];
    [switchPM release];
    [startTime release];
    [endTime release];
    [pickerContainer release];
    [rangelist release];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
