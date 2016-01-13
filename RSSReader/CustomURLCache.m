//
//  CustomURLCache.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 12/01/16.
//  Copyright © 2016 Mac-Mini-2. All rights reserved.
//

#import "CustomURLCache.h"


@implementation CustomURLCache

static NSString * const CustomURLCacheExpirationKey = @"3600";
static NSTimeInterval const CustomURLCacheExpirationInterval = 600;


+ (instancetype)standardURLCache
{
    static CustomURLCache *_standardURLCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardURLCache = [[CustomURLCache alloc]
                             initWithMemoryCapacity:(2 * 1024 * 1024)
                             diskCapacity:(100 * 1024 * 1024)
                             diskPath:nil];
    });
    return _standardURLCache;
}

#pragma mark - NSURLCache

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    if (cachedResponse)
    {
        NSDate* cacheDate = cachedResponse.userInfo[CustomURLCacheExpirationKey];
        NSDate* cacheExpirationDate = [cacheDate dateByAddingTimeInterval:CustomURLCacheExpirationInterval];
        if ([cacheExpirationDate compare:[NSDate date]] == NSOrderedAscending)
        {
            [self removeCachedResponseForRequest:request];
            return nil;
        }
    }
    return cachedResponse;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse
                 forRequest:(NSURLRequest *)request
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:cachedResponse.userInfo];
    userInfo[CustomURLCacheExpirationKey] = [NSDate date];
    
    NSCachedURLResponse *modifiedCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:userInfo storagePolicy:cachedResponse.storagePolicy];
    //NSLog(@"data is cached %@",modifiedCachedResponse);
    [super storeCachedResponse:modifiedCachedResponse forRequest:request];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    NSMutableDictionary *mutableUserInfo = [[cachedResponse userInfo] mutableCopy];
    NSMutableData *mutableData = [[cachedResponse data] mutableCopy];
    NSURLCacheStoragePolicy storagePolicy = NSURLCacheStorageAllowedInMemoryOnly;
    
    // ...
    
    return [[NSCachedURLResponse alloc] initWithResponse:[cachedResponse response]
                                                    data:mutableData
                                                userInfo:mutableUserInfo
                                           storagePolicy:storagePolicy];
}


@end




