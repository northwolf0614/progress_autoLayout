
#import <Foundation/Foundation.h>


@class StatisticsRequest;//StatisticsRequest

@protocol StatisticsRequestDelegate <NSObject>

- (void)statisticsRequestResponds:(StatisticsRequest *)request;

@end

@interface StatisticsRequest : NSObject <NSURLConnectionDelegate>
@property (nonatomic) NSInteger code;
@property (nonatomic, retain) NSMutableData *mutableData;
@property (nonatomic, retain) NSString *requestUrlString;
@property (nonatomic, retain) NSString *requestBody;
@property (nonatomic, assign) id<StatisticsRequestDelegate> delegate;

- (id)initWithDelegate:(id<StatisticsRequestDelegate>)delegate;
/**
 * post request
 */
- (void)postRequestWithURL:(NSString *)url postBody:(NSString *)s;
/**
 * get requesrt，used for Login, Synchronize, VehiclePosition
 */
- (void)requestWithURL:(NSString *)url;

/**
 * cancel the request for a example: there are some requests but the last one is valid
 */
- (void)cancelRequest;

/**
 * 这个函数用于请求返回未登录时。我们重新登录后，重新请求一遍。
 * 默认的实现是使用保存的url和body，重新请求一遍。如果派生类需要修改这个行为，请重载该方法。
 */
- (void)restart;

/**
 * 接收完毕服务端请求后的方法。服务端返回的数据放在data中。默认行为是将data视为xml，并解析。
 * 需要不同的处理的，需重载该方法。例如Synchronize, VehiclePosition
 */
- (void)processResponse:(NSData *)data;
/**
 * xml已解析完毕，子类需要处理xml的，重载该方法。
 */
//- (void)doWithXML:(GDataXMLElement *)xml;

- (BOOL)isOK;
/**
 * used to indentify the server error
 */
- (BOOL)isServerReturnedErrror;
/**
 * used to indentify  network failure
 */
- (BOOL)isNetworkFailure;
/**
 * used to identify user cancellation
 */
- (BOOL)isUserCancelled;

/**
 * 派生类根据需要重载。默认返回YES，即可以请求返回未登录时，可以重新登录。
 * 实际上，并不是所有的请求都需要重新登录，比如Login Request
 */
- (BOOL)canRelogin;
@end
