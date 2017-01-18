//
//  AFHttp.h
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GCDAsyncSocket.h"
@interface AFHttp : NSObject<GCDAsyncSocketDelegate>
@property (nonatomic,readonly) AFHTTPRequestOperationManager * manager;
@property (nonatomic, strong) GCDAsyncSocket *socket;
+ (AFHttp *)shareInstanced;

- (void)connectToHost;



- (void)get:(NSString *)url parameters:(NSDictionary *)parameters  completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;
- (void)post:(NSString *)url withParams:(NSDictionary *)params completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

- (void)reNameWithIP:(NSString *)ip name:(NSString *)name completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

- (void)reStroeWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

- (void)joinGroupWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

- (void)exitGroupWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

- (void)joinToMasterWithIP:(NSString *)ip masterSSID:(NSString *)ssid channel:(NSString *)ch auth:(NSString *)auth encry:(NSString *)encry pwd:(NSString *)pwd completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

- (void)updateStartCheckWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

- (void)updateStartWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

- (void)updateStatusWithIP:(NSString *)ip completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;
@end
