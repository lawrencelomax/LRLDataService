//
//  LRLDataProvider.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 31/01/2014.
//
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol LRLDataProvider <NSObject>

- (RACSignal *) dataForResourceURL:(NSURL *)resourceURL;

@end
