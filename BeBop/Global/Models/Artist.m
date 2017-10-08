//
//  Artist.m
//  BeBop
//
//  Created by Guilherme Mogames on 10/7/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

#import "Artist.h"

@implementation Artist

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"imageUrl": @"image_url",
                                                                  @"thumbUrl": @"thumb_url",
                                                                  @"facebookPageUrl": @"facebook_page_url",
                                                                  @"trackerCount": @"tracker_count",
                                                                  @"upcomingEventCount": @"upcoming_event_count"
                                                                  }];
}
@end
