//
//  LRLTheTVDBService.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLConfiguredDataService.h"

@interface LRLTheTVDBService : LRLConfiguredDataService

- (RACSignal *) infoForIMDBID:(NSString *)imdbID;

@end
