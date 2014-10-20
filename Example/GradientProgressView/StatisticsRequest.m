#import "StatisticsRequest.h"
@interface StatisticsRequest()
@property(nonatomic,retain) NSURLConnection *urlConnection;
@end

@implementation StatisticsRequest

-(void)dealloc
{
    [_mutableData release];
    [_requestUrlString release];
    [_requestBody release];
    [super dealloc];

}
- (id)initWithDelegate:(id<StatisticsRequestDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (BOOL)isOK
{
    return self.code==200;
}

- (BOOL)isServerReturnedErrror
{
    return self.code>200 && self.code<700;
}

- (BOOL)isNetworkFailure
{
    return self.code>=700 && self.code<800;
}

- (BOOL)isUserCancelled
{
    return self.code==800;
}


- (void)postRequestWithURL:(NSString *)url postBody:(NSString *)s
{
    self.requestUrlString=url;
    self.requestBody=s;
    NSLog(@"Post request: request address:%@\n request body:%@", url, s);
    NSData* postBody= [self.requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)postBody.length];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postBody];
    [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSString *authStr = @"su:gw";
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    self.mutableData = [NSMutableData data];
    self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.urlConnection start];
}

- (void)requestWithURL:(NSString *)url
{
    _requestUrlString = url;
    _requestBody = nil;
    
    NSLog(@"PND request:%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    _mutableData = [NSMutableData data];
    _urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [_urlConnection start];
}

- (void)restart
{
    if (_requestBody==nil)
        [self requestWithURL:_requestUrlString];
    else
        [self postRequestWithURL:_requestUrlString postBody:_requestBody];
}

- (void)cancelRequest
{
    [self.urlConnection cancel];
    self.urlConnection = nil;
}

- (BOOL)canRelogin
{
    return YES;
}

- (void)processResponse:(NSData *)data
{
    NSError* error=nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error != nil)
    {
        NSLog(@"convert into JSON error: %@", [error localizedDescription]);
        return;
    }
    
    
    
    
quit:
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(statisticsRequestResponds:)])
        [_delegate statisticsRequestResponds:self];

}

#pragma NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    self.code=httpResponse.statusCode;
    NSLog(@"the response is %ld",self.code);
    [self.mutableData setLength:0];
    if (self.code!=200) {
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(statisticsRequestResponds:)])
            [self.delegate statisticsRequestResponds:self];
    }
    
    
    //_totalBytes += [[[httpResponse allHeaderFields] objectForKey:@"Content-Length"] integerValue];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSString *content = [[NSString alloc] initWithData:_mutableData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", content);
    
    [self processResponse:self.mutableData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.code = 701;
    [self.urlConnection release];
    [self.mutableData release];
    NSLog(@"Connection failed! Error - %@",[error localizedDescription]);
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(statisticsRequestResponds:)])
        [self.delegate statisticsRequestResponds:self];
}
@end
