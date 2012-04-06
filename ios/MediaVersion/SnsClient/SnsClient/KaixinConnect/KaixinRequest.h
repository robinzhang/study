
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KaixinRequestDelegate;


@interface KaixinRequest : NSObject {
  id<KaixinRequestDelegate> _delegate;
  NSString*             _url;
  NSString*             _httpMethod;
  NSMutableDictionary*  _params;
  NSURLConnection*      _connection;
  NSMutableData*        _responseText;
}


@property(nonatomic,assign) id<KaixinRequestDelegate> delegate;

/**
 * The URL which will be contacted to execute the request.
 */
@property(nonatomic,copy) NSString* url;

/**
 * The API method which will be called.
 */
@property(nonatomic,copy) NSString* httpMethod;

/**
 * The dictionary of parameters to pass to the method.
 *
 * These values in the dictionary will be converted to strings using the
 * standard Objective-C object-to-string conversion facilities.
 */
@property(nonatomic,retain) NSMutableDictionary* params;
@property(nonatomic,assign) NSURLConnection*  connection;
@property(nonatomic,assign) NSMutableData* responseText;


+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params;

+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod;

+ (KaixinRequest*)getRequestWithParams:(NSMutableDictionary *) params
                        httpMethod:(NSString *) httpMethod
                          delegate:(id<KaixinRequestDelegate>)delegate
                        requestURL:(NSString *) url;
- (BOOL) loading;

- (void) connect;

@end

////////////////////////////////////////////////////////////////////////////////

/*
 *Your application should implement this delegate
 */
@protocol KaixinRequestDelegate <NSObject>

@optional

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(KaixinRequest *)request;

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(KaixinRequest *)request didReceiveResponse:(NSURLResponse *)response;

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(KaixinRequest *)request didFailWithError:(NSError *)error;

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(KaixinRequest *)request didLoad:(id)result;

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(KaixinRequest *)request didLoadRawResponse:(NSData *)data;

@end

