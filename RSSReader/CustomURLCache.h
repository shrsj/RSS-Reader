//
//  CustomURLCache.h
//  RSSReader
//
//  Created by Mac-Mini-2 on 12/01/16.
//  Copyright © 2016 Mac-Mini-2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomURLCache : NSURLCache

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request;

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse
                 forRequest:(NSURLRequest *)request;

@end
