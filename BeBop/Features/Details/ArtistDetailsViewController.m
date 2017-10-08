//
//  ArtistDetailsViewController.m
//  BeBop
//
//  Created by Guilherme Mogames on 10/5/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistDetailsViewController.h"
#import <YapImageManager/YapImageManager-Swift.h>

@interface ArtistDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgArtistBackground;
@property (weak, nonatomic) IBOutlet UIView *vwImageArtist;
@property (weak, nonatomic) IBOutlet UIImageView *imgArtist;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistName;
@property (weak, nonatomic) IBOutlet UILabel *lblTrackers;
@property (weak, nonatomic) IBOutlet UILabel *lblEventCount;
@property (weak, nonatomic) IBOutlet UITableView *tblEvents;
@end

@implementation ArtistDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Artist Details";
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    
    // Blur Background Image
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    visualEffectView.frame = _imgArtistBackground.bounds;
    visualEffectView.alpha = 0.9;
    [_imgArtistBackground addSubview:visualEffectView];
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(visualEffectView);
    
    [_imgArtistBackground addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[visualEffectView]|"
      options:(NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing)
      metrics:nil
      views:views]];
    
    [_imgArtistBackground addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|[visualEffectView]|"
      options:(NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom)
      metrics:nil
      views:views]];
    
    // Setup Thumb Image
    _vwImageArtist.layer.cornerRadius = _vwImageArtist.frame.size.width/2;
    _vwImageArtist.clipsToBounds = YES;
    
    // Setup events table
    [_tblEvents setRowHeight:UITableViewAutomaticDimension];
    [_tblEvents setEstimatedRowHeight:80];
    [_tblEvents setTableFooterView:[UIView new]];
}

- (void)setupData {
    
    NSURL *bigUrl = [[NSURL alloc]initWithString:_artist.imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:bigUrl];
    _imgArtistBackground.image = [UIImage imageWithData:data];
    
    NSURL *thumbUrl = [[NSURL alloc]initWithString:_artist.thumbUrl];
    NSData *thumbData = [NSData dataWithContentsOfURL:thumbUrl];
    _imgArtist.image = [UIImage imageWithData:thumbData];
    
    _lblArtistName.text = _artist.name;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    _lblTrackers.text = [NSString stringWithFormat:@"Trackers: %@", [formatter stringFromNumber:[NSNumber numberWithInt:_artist.trackerCount]]];
    
    if (_artist.upcomingEventCount == 0) {
        _lblEventCount.text = @"No upcoming events scheduled";
    } else {
        _lblEventCount.text = [NSString stringWithFormat:@"%i Upcoming Events scheduled", _artist.upcomingEventCount];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [UITableViewCell new];
}
@end
