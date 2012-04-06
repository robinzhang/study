//
//  ShareViewController.h
//  SnsClient
//
//  Created by  on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "MessageDetailController.h"
#import "UserHelper.h"
#import "ShareViewOfflineSource.h"
#import "GoogleLocalConnection.h"
#import "SnUserAppInfo.h"
#import "NotifyMessageHelper.h"
#import "SnInfoView.h"
#import "LocaltionHelper.h"

@interface ShareViewController : SnModelViewController<MKMapViewDelegate,UISearchBarDelegate,GoogleLocalConnectionDelegate,UITableViewDelegate,UITableViewDataSource,SnAppLocationDelegate>
{
    MKMapView *_mapview;
    CLLocation *_reLocation;
    int _reRange;
    //SnUserAppInfo *_uAppInfo;
    bool _fristload;
    
    CalloutMapAnnotation *_calloutAnnotation;
    MKAnnotationView *_selectedAnnotationView;
    int magicNumber;
    
    NSMutableArray*  _posts;
    NSString *_me;
    TTActivityLabel *loading;
    
    UISearchBar *_searcheBar;
    UIButton *_cancelButton;
    UITableView *tableView;
    NSMutableArray *searchArray;
    GoogleLocalConnection *googleLocalConnection;
    
    UIView *_nodataView;
    SnInfoView *errorinfoview;
}

@property (nonatomic, retain)  NSMutableArray *posts;
@property (nonatomic, retain)  MKMapView *mapview;
@property (nonatomic, assign)  bool fristload;
//@property (nonatomic, retain)  SnUserAppInfo* uAppInfo;
@property (nonatomic, assign)  int reRange;
@property (nonatomic, assign)  CLLocation* reLocation;
-(void)doRefreshLocation;
-(void)setListType;
-(void)initEmptyView;
@end
