//
//  Artist.h
//  BeBop
//
//  Created by Guilherme Mogames on 10/7/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface Artist : JSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *thumbUrl;
@property (strong, nonatomic) NSString *facebookPageUrl;
@property (strong, nonatomic) NSString *mbid;
@property (assign, nonatomic) int trackerCount;
@property (assign, nonatomic) int upcomingEventCount;

@end
