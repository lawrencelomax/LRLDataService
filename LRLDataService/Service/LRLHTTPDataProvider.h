//
//  LRLHTTPDataProvider.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 31/01/2014.
//
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>
#import "LRLDataProvider.h"

@interface LRLHTTPDataProvider : NSObject <LRLDataProvider>

+ (instancetype) dataProvider;
+ (instancetype) dataProviderWithManager:(AFHTTPRequestOperationManager *)manager;

@property (nonatomic, readonly) AFHTTPRequestOperationManager *manager;

@end
