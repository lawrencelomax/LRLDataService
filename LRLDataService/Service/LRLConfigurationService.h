//
//  LRLConfigurationService.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLDataService.h"

@interface LRLConfigurationService : LRLDataService

- (RACSignal *) configuration;

@end
