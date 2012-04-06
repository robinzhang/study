
#import "KaixinRequest.h"
#import <extThree20JSON/extThree20JSON.h>
#import "extThree20JSON/JSON.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static NSString* kStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f";
static const int kGeneralErrorCode = 10000;

static const NSTimeInterval kTimeoutInterval = 180.0;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation KaixinRequest

@synthesize delegate = _delegate,
            url = _url,
            httpMethod = _httpMethod,
            params = _params,
            connection = _connection,
            responseText = _responseText;

//////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (KaixinRequest *)getRequestWithParams:(NSMutableDictionary *) params
                         httpMethod:(NSString *) httpMethod
                           delegate:(id<KaixinRequestDelegate>) delegate
                         requestURL:(NSString *) url {

  KaixinRequest* request = [[[KaixinRequest alloc] init] autorelease];
  request.delegate = delegate;
  request.url = url;
  request.httpMethod = httpMethod;
  request.params = params;
  request.connection = nil;
  request.responseText = nil;

  return request;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

+ (NSString *)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params {
  return [self serializeURL:baseUrl params:params httpMethod:@"GET"];
}

/**
 * Generate get URL
 */
+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod {

  NSURL* parsedURL = [NSURL URLWithString:baseUrl];
  NSString* queryPrefix = parsedURL.query ? @"&" : @"?";

  NSMutableArray* pairs = [NSMutableArray array];
  for (NSString* key in [params keyEnumerator]) {
    if (([[params valueForKey:key] isKindOfClass:[UIImage class]])
        ||([[params valueForKey:key] isKindOfClass:[NSData class]])) {
      if ([httpMethod isEqualToString:@"GET"]) {
        NSLog(@"can not use GET to upload a file");
      }
      continue;
    }

    NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                NULL, /* allocator */
                                (CFStringRef)[params objectForKey:key],
                                NULL, /* charactersToLeaveUnescaped */
                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                kCFStringEncodingUTF8);

    [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, /*[params objectForKey:key]*/escaped_value]];
    [escaped_value release];
  }
  NSString* query = [pairs componentsJoinedByString:@"&"];

  return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

/**
 * Body append for POST method
 */
- (void)utfAppendBody:(NSMutableData *)body data:(NSString *)data {
  [body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

//对value进行URL编码
- (NSString*)encodeString:(NSString*)actionString URLencode:(NSStringEncoding)enc {
	NSMutableString *escaped = [NSMutableString string];
	[escaped setString:[actionString stringByAddingPercentEscapesUsingEncoding:enc]];
	
	[escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	return escaped;
}

-(BOOL)isKindOfUIImage{
	NSString *iskind=nil;	
	for (NSString *key in [_params keyEnumerator]) {
		if ([key isEqualToString:@"upload"]) {
			iskind=key;
			break;
		}
	}
	return iskind!=nil;	
} 	 


/**
 * Generate body for POST method
 */


- (NSMutableData *)generatePostBody {
	NSMutableData *body = [NSMutableData data];
    NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    [self utfAppendBody:body data:[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]];
    
    for (id key in [_params keyEnumerator]) {
        
        if (([[_params valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[_params valueForKey:key] isKindOfClass:[NSData class]])) {
            
            [dataDictionary setObject:[_params valueForKey:key] forKey:key];
            continue;
            
        }
        
        [self utfAppendBody:body
                       data:[NSString
                             stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                             key]];
        [self utfAppendBody:body data:[_params valueForKey:key]];
        
        [self utfAppendBody:body data:endLine];
    }
    
    if ([dataDictionary count] > 0) {
        for (id key in dataDictionary) {
            NSObject *dataParam = [dataDictionary valueForKey:key];
            if ([dataParam isKindOfClass:[UIImage class]]) {
                NSData* imageData = UIImagePNGRepresentation((UIImage*)dataParam);
			    [self utfAppendBody:body
                               data:[NSString stringWithFormat:
                                     @"Content-Disposition: form-data; name=\"upload_photo\";filename=\"%@\"\r\n", key]];
                [self utfAppendBody:body
                               data:[NSString stringWithString:@"Content-Type: image/png\r\n\r\n"]];
				
                [body appendData:imageData];
            } else {
                NSAssert([dataParam isKindOfClass:[NSData class]],
                         @"dataParam must be a UIImage or NSData");
                [self utfAppendBody:body
                               data:[NSString stringWithFormat:
                                     @"Content-Disposition: form-data; name=\"upload_photo\";filename=\"%@\"\r\n", key]];
                [self utfAppendBody:body
                               data:[NSString stringWithString:@"Content-Type: content/unknown\r\n\r\n"]];
                [body appendData:(NSData*)dataParam];
            }
            [self utfAppendBody:body data:endLine];
            
        }
    }
	
    return body;
}




/**
 * Formulate the NSError
 */
- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData {
   return [NSError errorWithDomain:@"KaixinErrDomain" code:code userInfo:errorData];

}

/**
 * parse the response data
 */
- (id)parseJsonResponse:(NSData *)data error:(NSError **)error {

  NSString* responseString = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding]
                              autorelease];
  SBJsonParser *jsonParser = [[SBJsonParser new] autorelease];
  if ([responseString isEqualToString:@"true"]) {
    return [NSDictionary dictionaryWithObject:@"true" forKey:@"result"];
  } else if ([responseString isEqualToString:@"false"]) {
    if (error != nil) {
      *error = [self formError:kGeneralErrorCode
                      userInfo:[NSDictionary
                                dictionaryWithObject:@"This operation can not be completed"
                                forKey:@"error_msg"]];
    }
    return nil;
  }


  id result = [jsonParser objectWithString:responseString];

  if (![result isKindOfClass:[NSArray class]]) {
    if ([result objectForKey:@"error"] != nil) {
      if (error != nil) {
        *error = [self formError:kGeneralErrorCode
                        userInfo:result];
      }
      return nil;
    }

    if ([result objectForKey:@"error_code"] != nil) {
      if (error != nil) {
        *error = [self formError:[[result objectForKey:@"error_code"] intValue] userInfo:result];
      }
      return nil;
    }

    if ([result objectForKey:@"error_msg"] != nil) {
      if (error != nil) {
        *error = [self formError:kGeneralErrorCode userInfo:result];
      }
    }

    if ([result objectForKey:@"error_reason"] != nil) {
      if (error != nil) {
        *error = [self formError:kGeneralErrorCode userInfo:result];
      }
    }
  }

  return result;

}

/*
 * private helper function: call the delegate function when the request
 *                          fails with error
 */
- (void)failWithError:(NSError *)error {
  if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
    [_delegate request:self didFailWithError:error];
  }
}

/*
 * private helper function: handle the response data
 */
- (void)handleResponseData:(NSData *)data {
  if ([_delegate respondsToSelector:
      @selector(request:didLoadRawResponse:)]) {
    [_delegate request:self didLoadRawResponse:data];
  }

  if ([_delegate respondsToSelector:@selector(request:didLoad:)] ||
      [_delegate respondsToSelector:
          @selector(request:didFailWithError:)]) {
    NSError* error = nil;
    id result = [self parseJsonResponse:data error:&error];

    if (error) {
      [self failWithError:error];
    } else if ([_delegate respondsToSelector:
        @selector(request:didLoad:)]) {
      [_delegate request:self didLoad:(result == nil ? data : result)];
    }

  }

}



//////////////////////////////////////////////////////////////////////////////////////////////////
// public

/**
 * @return boolean - whether this request is processing
 */
- (BOOL)loading {
  return !!_connection;
}

- (void)connect {
    if ([_delegate respondsToSelector:@selector(requestLoading:)]) {
        [_delegate requestLoading:self];
    }
    
    NSString* url = [[self class] serializeURL:_url params:_params httpMethod:_httpMethod];
		
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:kTimeoutInterval];
    
    
    [request setHTTPMethod:self.httpMethod];
    if ([self.httpMethod isEqualToString: @"POST"]) {
        NSString* contentType = [NSString
                                 stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:[self generatePostBody]];
    }
    [request setHTTPShouldHandleCookies:false];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

/**
 * Free internal structure
 */
- (void)dealloc {
  [_connection cancel];
  [_connection release];
  [_responseText release];
  [_url release];
  [_httpMethod release];
  [_params release];
  [super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// NSURLConnectionDelegate


/*
 * add for the https:
 * Whether to need to the ssl
 */
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace 
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

/*
 * add for the https:
 * Processing the https: ignore the certificate
 */
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
{
    NSSet *trustedHosts = [NSSet setWithObjects: @"https://api.kaixin001.com", 
                                                 @"http://api.kaixin001.com", 
                                                 @"http://www.kaixin001.com", nil];
      
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if ([trustedHosts containsObject:challenge.protectionSpace.host])
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  _responseText = [[NSMutableData alloc] init];

  NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
  if ([_delegate respondsToSelector:
      @selector(request:didReceiveResponse:)]) {
    [_delegate request:self didReceiveResponse:httpResponse];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [_responseText appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
    willCacheResponse:(NSCachedURLResponse*)cachedResponse {
  return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  [self handleResponseData:_responseText];

  [_responseText release];
  _responseText = nil;
  [_connection release];
  _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  [self failWithError:error];

  [_responseText release];
  _responseText = nil;
  [_connection release];
  _connection = nil;
}

@end
