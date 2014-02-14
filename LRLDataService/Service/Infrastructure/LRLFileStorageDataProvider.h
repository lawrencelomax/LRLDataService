//
//  LRLFileStorageDataProvider.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 31/01/2014.
//
//

#import <Foundation/Foundation.h>

#import "LRLDataProvider.h"

extern NSString *const LRLFileStorageDataProviderErrorDomain;

@interface LRLFileStorageDataProvider : NSObject <LRLDataProvider>

+ (instancetype) dataProviderWithFileManager:(NSFileManager *)fileManager;
+ (instancetype) dataProvider;

@property (nonatomic, readonly) NSFileManager *fileManager;

- (RACSignal *) saveData:(id<NSCoding>)data withResourceURL:(NSURL *)resourceURL;

@end
