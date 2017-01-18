//
//  AFHttp.m
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "AFHttp.h"
typedef struct {
    short int length;
    uint8_t checksum;
    short int comand;

}SendData;

#define UART_HEADER_FLAGS  0x20189618
typedef struct UART_SOCKET_BUFFER
{
    unsigned int header; //必须为UART_HEADER_FLAGS
    unsigned int len; //command的length
    unsigned char command[100];
}UART_SOCKET_BUFFER;



@implementation AFHttp
#pragma mark - Life Cycle
- (id)init
{
    if((self = [super init]))
    {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                             delegateQueue:dispatch_queue_create("GCDAsyncSocketQueue", NULL)];
    }
    return self;
    
}

- (void)dealloc
{
    _manager = nil;
    
}

- (void)connectToHost{
    
    NSError *error;
    [_socket connectToHost:@"192.168.1.118" onPort:8899 withTimeout:3 error:&error];
    [_socket readDataWithTimeout:-1 tag:1];
}

#pragma mark GCDAsyncSocketDelegate


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    NSLog(@"socketdidConnectToHost%@",host);
    
    NSString *cmdstr = @"AXX+PAS+0x00050x0D0x0008&";
    NSData *data = [cmdstr dataUsingEncoding:NSUTF8StringEncoding];
    UART_SOCKET_BUFFER buffer;
    buffer.header =UART_HEADER_FLAGS;
    buffer.len =(unsigned int)[data length];
    memcpy(buffer.command,[data bytes],[data length]);
//   [sock writeData:[NSData dataWithBytes:&buffer length:[data length]] withTimeout:3 tag:1];
    
//    SendData data;
//    data.length = sizeof(data);
//    data.checksum = 6;
//    data.comand = 0x001a;
//    NSData *msgData = [[NSData alloc]initWithBytes:&data length:sizeof(data)];
//    NSString *str = [msgData base64EncodedStringWithOptions:0];
//    NSLog(@"%@", str);
//    NSMutableData *data = [NSMutableData data];
//    uint8_t i = 2;// 8位
//    [data appendData:[YMSocketUtils byteFromUInt8:i]];
//    
//    
//    
//    NSString *cmd = [NSString stringWithFormat:@"AXX+PAS+%@&",str];
//    NSData *temp = [cmd dataUsingEncoding:NSUTF8StringEncoding];
//    [sock writeData:temp withTimeout:3 tag:1];
    
//
//    [sock writeData:[NSData dataWithBytes:puart_socket_buffer length:[data length]+TCP_SOCKET_BUFFER_HEADER_SIZE] withTimeout:3 tag:1];
    
}



- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
   
    NSLog(@"socketdidWriteDataWithTag%ld",tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSLog(@"socketdiddidReadData%@",data);
//    UART_SOCKET_BUFFER buffer;
//    [data getBytes:&buffer length:sizeof(buffer)];
//    NSLog(@"dd");
}


#pragma mark  Class Methods
+ (AFHttp *)shareInstanced
{
    static AFHttp * this = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[self alloc] init];
    });
    
    return this;
}



#pragma mark Instance Methods
- (NSString *)urlEncode:(NSString *)url
{
    NSAssert(url != nil, @"The url is nil.");
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (void)get:(NSString *)url parameters:(NSDictionary *)parameters completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [_manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSLog(@"%@,%@,%@",responseObject,operation.request.URL,parameters);
        if(success)
        {
            if(responseObject)
            {
                success(responseObject);
            }
            else
            {
                success(nil);
            }
        }
        
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@,%@,%@,%@",error,operation.responseString,operation.request.allHTTPHeaderFields,operation.request.URL);
        if(failure)
            failure(error,operation.responseString);
    }];
}

- (void)post:(NSString *)url withParams:(NSDictionary *)params completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [_manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        NSDictionary *res  = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSLog(@"%@,%@,%@",res,operation.request.URL,params);
        if(success)
            success(res);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@,%@,%@,%@,%@",error,operation.responseString,operation.request.allHTTPHeaderFields,params,url);
        
        if(failure)
            failure(error,operation.responseString);
    }];
}
#pragma mark VIFA

- (NSString *)makeURLwithIP:(NSString *)ip command:(NSString *)command
{
    return [[NSString stringWithFormat:@"http://%@/httpapi.asp?command=%@",ip,command]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)reNameWithIP:(NSString *)ip name:(NSString *)name completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    NSString *command = [NSString stringWithFormat:@"setDeviceName:%@",name];
    NSString *url = [self makeURLwithIP:ip command:command];
    
    [self get:url parameters:nil completionBlock:^(id obj) {
        
        if (success) success(obj);
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        if (failure) failure(error,responseString);
    }];
}

- (void)reStroeWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    NSString *command = @"restoreToDefault";
    NSString *url = [self makeURLwithIP:ip command:command];
    [self get:url parameters:nil completionBlock:^(id obj) {
        
        if (success) success(obj);
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        if (failure) failure(error,responseString);
    }];
}

/*
 支持一键组网功能的，并且在相同局域网内的音箱会进组。
 支持一键组网功能的音箱会退组，即使此命令发给子音箱，子音箱也会发给主音箱实现全部退组。
*/
- (void)joinGroupWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    NSString *command = @"multiroom:JoinGroup";
    NSString *url = [self makeURLwithIP:ip command:command];
    [self get:url parameters:nil completionBlock:^(id obj) {
        
        if (success) success(obj);
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        if (failure) failure(error,responseString);
    }];
}

/*
 所有连接到此主音箱的子音箱都会退出。如果此命令发给子音箱，则仅此子音箱退组。
*/
- (void)exitGroupWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    NSString *command = @"multiroom:Ungroup";
    NSString *url = [self makeURLwithIP:ip command:command];
    [self get:url parameters:nil completionBlock:^(id obj) {
        
        if (success) success(obj);
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        if (failure) failure(error,responseString);
    }];
}

/*
 发送指令给的音箱，此音箱会连接上主音箱，组成多房间。
 ssid 待连接主音箱的ssid名称，要以16进制编码传输
 ch 待连接主音箱的wifi信道（从主音箱的getStatus 返回值，解析出来WifiChannel，来获取主音箱的channel）
 auth 主音箱的加密方式（从主音箱的getStatus返回值，解析出securemode；
      securemode 等于 0,auth 填成OPEN, encry 填成 NONE 
      securemode 等于 1,auth 填成getStatus 返回值的auth，encry填成getStatus 返回值的encry，pwd 填成getStatus返回值的psk
 encry 加密类型 ,参考auth
 pwd OPEN类型密码为空；有密码时，要以16进制编码传输
 chext 填0即可
 
*/
- (void)joinToMasterWithIP:(NSString *)ip masterSSID:(NSString *)ssid channel:(NSString *)ch auth:(NSString *)auth encry:(NSString *)encry pwd:(NSString *)pwd completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    NSString *command = [NSString stringWithFormat:@"ConnectMasterAp:ssid=%@:ch=%@:auth=%@:encry=%@:pwd=%@:chext=0",ssid,ch,auth,encry,pwd];
    NSString *url = [self makeURLwithIP:ip command:command];
    [self get:url parameters:nil completionBlock:^(id obj) {
        
        if (success) success(obj);
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        if (failure) failure(error,responseString);
    }];
}



/*
 该接口用于通知设备去服务器查询是否有更新可用。
 40
 有升级包
 10
 正在检查中
 others
 没有升级包
 */
- (void)updateStartCheckWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    NSString *command = @"getMvRemoteUpdateStartCheck";
    NSString *url = [self makeURLwithIP:ip command:command];
    [self get:url parameters:nil completionBlock:^(id obj) {
        
        if (success) success(obj);
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        if (failure) failure(error,responseString);
    }];
}

/*
 调用该接口后，如果有升级包，则设备会开始下载升级包
 下载完成后会自动开始烧录；
 升级过程请勿断电
 */
- (void)updateStartWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    NSString *command = @"getMvRemoteUpdateStart";
    NSString *url = [self makeURLwithIP:ip command:command];
    [self get:url parameters:nil completionBlock:^(id obj) {
        
        if (success) success(obj);
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        if (failure) failure(error,responseString);
    }];
}

/*
 查询升级包下载状态
 10 正在检查中
 21 检查升级包失败
 22 下载升级包失败
 23 检查升级包失败
 25 开始在下载升级包
 27 用户分区升级包下载完成
 30 下载升级包完成
 */
- (void)updateStatusWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    NSString *command = @"getMvRemoteUpdateStatus";
    NSString *url = [self makeURLwithIP:ip command:command];

    [self get:url parameters:nil completionBlock:^(id obj) {
        
        if (success) success(obj);
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        if (failure) failure(error,responseString);
    }];
}


@end
