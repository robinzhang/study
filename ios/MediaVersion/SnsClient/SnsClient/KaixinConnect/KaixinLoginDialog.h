

#import "KaixinDialog.h"

@protocol KaixinLoginDialogDelegate;

@interface KaixinLoginDialog : KaixinDialog {
  id<KaixinLoginDialogDelegate> _loginDelegate;
}

-(id) initWithURL:(NSString *) loginURL
      loginParams:(NSMutableDictionary *) params
      delegate:(id <KaixinLoginDialogDelegate>) delegate;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@protocol KaixinLoginDialogDelegate <NSObject>

- (void)KaixinDialogLogin:(NSString *)token 
             refreshToken:(NSString *)refreshToken 
           expirationDate:(NSDate *)expirationDate;

- (void)KaixinDialogNotLogin:(BOOL)cancelled;

@end


