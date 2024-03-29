//
//  AskWhoViewController.m
//  TimeImprint
//
//  Created by Yi Gu on 5/11/15.
//  Copyright (c) 2015 Timeimprint. All rights reserved.
//

#import "AskWhoViewController.h"
#import "UtilityViewController.h"
#import "GraphAPIManager.h"

@interface AskWhoViewController ()

@property (nonatomic, strong) NSString *strUserID;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *names;
@property (nonatomic, strong) NSMutableArray *friendsImages;
@property (nonatomic, strong) NSMutableArray *selectedFriendsImages;
@property (nonatomic) NSInteger segmentCounts;

@end

@implementation AskWhoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initProps];
    // hide left bar title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view.
    
    
    [self setupSegmentedControl];
    
    self.names = [[NSMutableArray alloc] initWithObjects:@"Joy", @"Jason", @"Hockey", nil];
    UIImage *image0 = [UIImage imageNamed:@"joy.png"];
    UIImage *image1 = [UIImage imageNamed:@"Jason.png"];
    UIImage *image2 = [UIImage imageNamed:@"hockey.png"];
    self.friendsImages = [[NSMutableArray alloc] initWithObjects:image0, image1, image2, nil];
    
    self.selectedFriendsImages = [[NSMutableArray alloc] init];
    
    self.tableFriends.delegate = self;
    self.tableFriends.dataSource = self;
}

- (void)initProps {
    self.segmentCounts = 1;
    self.strUserID = @"019d34ec15524c99babc2b560dbd1d72";
    self.friends = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.labelTopic.text = self.strTopic;
    
    GraphAPIManager *apiGraph = [GraphAPIManager sharedInstance];
    [self getFriendsWithAPI:apiGraph];
}

- (void)getFriendsWithAPI:(GraphAPIManager *)apiGraph {
    [apiGraph getFollowers:self.strUserID start:@0 limit:@10 filter_followed:false filter_unfollowed:true success:^(id successResponse) {
        if([successResponse isKindOfClass:[NSArray class]]){
            [self.friends removeAllObjects];
            [self.friends addObjectsFromArray:successResponse];
            
            [self.tableFriends reloadData];
        }
    } failure:^(id failureResponse, NSError *error) {
        NSLog(@"Error: can't get followers");
    }];
}

// segmented view
- (void) setupSegmentedControl {
    // set font
    UIFont *font = [UIFont fontWithName:@"NotoSansCJKsc-Light" size:18.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
    
    [self.segmentedSocial setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    // remove the separate line of segmented control
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, self.segmentedSocial.frame.size.height), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
    [self.segmentedSocial setDividerImage:blank forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // set border
    self.segmentedSocial.layer.borderWidth = 0.5;
    [self.segmentedSocial.layer setBorderColor:[UIColor grayColor].CGColor];
    
    // initial selected value
    UIColor *tintcolor=[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
    [[self.segmentedSocial.subviews objectAtIndex:self.segmentCounts] setTintColor:tintcolor];
}


- (IBAction)segmentedSocialChange:(UISegmentedControl *)sender {
    // change tint color
    for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i] isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
            
        }
        else
        {
            [[sender.subviews objectAtIndex:i] setTintColor:nil];
        }
    }
}

// table view
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellFriendTopic";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *dictFriend = [self.friends objectAtIndex:indexPath.row];
    
    [self setCell:cell withDict:dictFriend];
    
    return cell;
}

- (void)setCell:(UITableViewCell *)cell
       withDict:(NSDictionary *)dictFriend {
    UIImage *image = [UtilityViewController getImageFromStringURL:[dictFriend objectForKey:@"avatar"]];
    NSString *name = [dictFriend objectForKey:@"name"];
    
    // set profile image
    UIImageView *imageProfile = (UIImageView *)[cell viewWithTag:2010];
    imageProfile.image = image;
    
    // set name
    UILabel *labelName = (UILabel *)[cell viewWithTag:2011];
    labelName.text = name;
    
    // set checkbox
    UIImageView *imageCheck = (UIImageView *)[cell viewWithTag:2012];
    
    if([self.selectedFriendsImages containsObject:imageProfile.image]){
        imageCheck.image = [UIImage imageNamed:@"user_selected"];
    }else{
        imageCheck.image = [UIImage imageNamed:@"user_unselected"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCheck:)];
    [cell addGestureRecognizer:tap];

}

- (void)handleCheck: (UITapGestureRecognizer *)tapRecognizer {
    CGPoint tapLocation = [tapRecognizer locationInView:self.tableFriends];
    NSIndexPath *tappedIndexPath = [self.tableFriends indexPathForRowAtPoint:tapLocation];
    
    if([self.selectedFriendsImages containsObject:[self.friendsImages objectAtIndex:tappedIndexPath.row]]){
        [self.selectedFriendsImages removeObject:[self.friendsImages objectAtIndex:tappedIndexPath.row]];
    }else{
        [self.selectedFriendsImages addObject:[self.friendsImages objectAtIndex:tappedIndexPath.row]];
    }
    
    [self.tableFriends reloadRowsAtIndexPaths:[NSArray arrayWithObject:tappedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self reloadFriends];
}

- (void)reloadFriends {
    for(UIImageView *v in self.viewSelectedFriends.subviews){
        if([v isKindOfClass:[UIImageView class]] && [self.friendsImages containsObject:v.image]){
            [v removeFromSuperview];
        }
    }
    
    for(int i = 0; i < [self.selectedFriendsImages count]; i++){
        [self addImage:[self.selectedFriendsImages objectAtIndex:i] ToViewWithLocation:55 + i * (46) : 13 :36 :36];
    }
}

- (void)addImage:(UIImage *)image ToViewWithLocation:(CGFloat)x :(CGFloat)y :(CGFloat)width :(CGFloat)
height {
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    imageHolder.image = image;
    
    [self.viewSelectedFriends addSubview:imageHolder];
}


@end
