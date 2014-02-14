//
//  LRLServiceConfiguration.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import "LRLBaseModel.h"

@interface LRLConfiguration : LRLBaseModel

@property (nonatomic, strong) NSURL *imdbEndpoint;
@property (nonatomic, strong) NSURL *configEndpoint;
@property (nonatomic, strong) NSURL *trailerAddictEndpoint;
@property (nonatomic, strong) NSURL *rottenTomatoesEndpoint;

@property (nonatomic, strong) NSString *tvdbAPIKey;
@property (nonatomic, strong) NSString *rottenTomatoesAPIKey;

@end
