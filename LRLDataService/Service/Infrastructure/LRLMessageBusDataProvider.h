//
//  LRLMessageBusDataProvider.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 9/02/2014.
//
//

#import <Foundation/Foundation.h>

#import "LRLDataProvider.h"
#import "LRLKeyValueInterchange.h"

@interface LRLMessageBusDataProvider : NSObject <LRLDataProvider>

+ (instancetype) dataProvider;
+ (instancetype) dataProviderWithInterchange:(LRLKeyValueInterchange *)interchange;

@end
