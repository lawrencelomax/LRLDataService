//
//  LRLServiceConfiguration.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 10/02/2014.
//
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>

@interface LRLServiceConfiguration : MTLModel

@property (nonatomic, strong) NSURL *imdbEndpoint;

@end
