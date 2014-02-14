//
//  LRLTrailer.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 16/02/2014.
//
//

#import "LRLBaseModel.h"

@interface LRLTrailer : LRLBaseModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSString *pubDateString;

@property (nonatomic, strong) NSString *trailerId;
@property (nonatomic, strong) NSString *imdbId;
@property (nonatomic, strong) NSString *embed;

@end
