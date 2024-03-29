//
//  EditingView.m
//  documentary-video-ios-native
//
//  Created by Bibo on 4/7/15.
//  Copyright (c) 2015 Bibo. All rights reserved.
//

#import "EditingView.h"
#import "CameraView.h"

@interface EditingView ()
@end

@implementation EditingView

@synthesize videoImage;
@synthesize photoImageOne;
@synthesize photoImageTwo;
@synthesize photoImageThree;
@synthesize photoImageFour;
@synthesize publishBtn;
@synthesize cancelBtn;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-20)];
        backgroundScrollView.delegate = self;
        backgroundScrollView.bounces = NO;
        [self addSubview:backgroundScrollView];
        self.isPublic = YES;
        y = 0;
        [self addTitle];
        [self addVideoImage];
        [self addFourPhotoImages];
        [self addAboutBox];
        //        [self addLocationBox];
        //        [self addEventOccuredTimeBox];
        //        [self addEventPostingTimeBox];
        //        [self addPrivacyToggle];
        [self addShareToBtns];
        [self addPublishBtn];
    }
    return self;
}

-(void)addTitle {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y, self.frame.size.width-40, 44)];
    titleLabel.text = @"编辑内容";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundScrollView addSubview:titleLabel];
    
    y = y + 44;
}

-(void)addVideoImage {
    self.videoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, y, self.frame.size.width, self.frame.size.width*9/16)];
    self.videoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImage.clipsToBounds = YES;
    UIImage *rotatedImage = [[UIImage alloc]initWithCGImage:[CameraView shared].camRollThumbNail.CGImage scale:1.0 orientation:UIImageOrientationLeft];
    self.videoImage.image = rotatedImage;
    [backgroundScrollView addSubview:self.videoImage];
    
    
    self.titleTextfield = [[UITextField alloc]initWithFrame:CGRectMake((self.videoImage.bounds.size.width-320)/2, self.videoImage.bounds.size.height/2-40/2+60, 320, 40)];
    self.titleTextfield.text = @"加标题";
    self.titleTextfield.textAlignment = NSTextAlignmentCenter;
    self.titleTextfield.textColor = [UIColor whiteColor];
    self.titleTextfield.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.titleTextfield.delegate = self;
    
    [backgroundScrollView addSubview:self.titleTextfield];
    
    y = y + self.frame.size.width*9/16 + 5;//10 is spacing
}

-(void)addFourPhotoImages {
    
    CGFloat width = (self.frame.size.width-25)/4;
    
    photoImageOne = [[UIImageView alloc]initWithFrame:CGRectMake(5, y, width, width)];
    photoImageOne.contentMode = UIViewContentModeScaleAspectFill;
    photoImageOne.clipsToBounds = YES;
    photoImageOne.image = [UIImage imageNamed:@"photo_ph01"];
    //    photoImageOne.backgroundColor = [UIColor redColor];
    [backgroundScrollView addSubview:photoImageOne];
    
    photoImageOne.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnImageOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedOnImageOne:)];
    [photoImageOne addGestureRecognizer:tapOnImageOne];
    
    photoImageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(10+width, y, width, width)];
    photoImageTwo.contentMode = UIViewContentModeScaleAspectFill;
    photoImageTwo.clipsToBounds = YES;
    photoImageTwo.image = [UIImage imageNamed:@"photo_ph02"];
    photoImageTwo.backgroundColor = [UIColor blueColor];
    [backgroundScrollView addSubview:photoImageTwo];
    
    photoImageTwo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnImageTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedOnImageTwo:)];
    [photoImageTwo addGestureRecognizer:tapOnImageTwo];
    
    photoImageThree = [[UIImageView alloc]initWithFrame:CGRectMake(15+width*2, y, width, width)];
    photoImageThree.contentMode = UIViewContentModeScaleAspectFill;
    photoImageThree.clipsToBounds = YES;
    photoImageThree.image = [UIImage imageNamed:@"photo_ph03"];
    photoImageThree.backgroundColor = [UIColor purpleColor];
    [backgroundScrollView addSubview:photoImageThree];
    
    photoImageThree.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnImageThree = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedOnImageThree:)];
    [photoImageThree addGestureRecognizer:tapOnImageThree];
    
    photoImageFour = [[UIImageView alloc]initWithFrame:CGRectMake(20+width*3, y, width, width)];
    photoImageFour.contentMode = UIViewContentModeScaleAspectFill;
    photoImageFour.clipsToBounds = YES;
    photoImageFour.image = [UIImage imageNamed:@"photo_ph04"];
    photoImageFour.backgroundColor = [UIColor greenColor];
    [backgroundScrollView addSubview:photoImageFour];
    
    photoImageFour.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnImageFour = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedOnImageFour:)];
    [photoImageFour addGestureRecognizer:tapOnImageFour];
    
    y = y + self.frame.size.width/4;
}

-(void)addAboutBox {
    //    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y, self.frame.size.width-40, 30)];
    //    titleLabel.text = @"内容";
    //    titleLabel.textColor = [UIColor grayColor];
    //    [backgroundScrollView addSubview:titleLabel];
    y = y + 5;
    
    double height = self.frame.size.height - 60 - self.videoImage.bounds.size.height - 5 - self.photoImageOne.bounds.size.height - 5 - 5 - 5 - 30 - 60;
    
    
    UIView *boxView = [[UIView alloc]initWithFrame:CGRectMake(5, y, self.frame.size.width-10, height)];
    //    boxView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    boxView.layer.borderWidth = 1;
    //    boxView.layer.cornerRadius = 5;
    [backgroundScrollView addSubview:boxView];
    
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutBtn.frame = CGRectMake(15, 5, 20, 20);
    [aboutBtn setImage:[UIImage imageNamed:@"write_24"] forState:UIControlStateNormal];
    [boxView addSubview:aboutBtn];
    
    self.aboutBox = [[UITextView alloc]initWithFrame:CGRectMake(6, y+30, self.frame.size.width-12, 90)];
    self.aboutBox.delegate = self;
    self.aboutBox.font = [UIFont systemFontOfSize:16];
    [backgroundScrollView addSubview:self.aboutBox];
    
    y = y + height;
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(15, height - 20, 20, 20);
    [locationBtn setImage:[UIImage imageNamed:@"location_24"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(tappedOnLocation:) forControlEvents:UIControlEventTouchUpInside];
    [boxView addSubview:locationBtn];
    
    UIButton *EventOccuredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    EventOccuredBtn.frame = CGRectMake(50, height - 20, 20, 20);
    [EventOccuredBtn setImage:[UIImage imageNamed:@"eventTime_24"] forState:UIControlStateNormal];
    [EventOccuredBtn addTarget:self action:@selector(tappedOnOccurTime:) forControlEvents:UIControlEventTouchUpInside];
    [boxView addSubview:EventOccuredBtn];
    
    UIButton *EventPostingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    EventPostingBtn.frame = CGRectMake(90, height - 20, 20, 20);
    [EventPostingBtn setImage:[UIImage imageNamed:@"publish_24"] forState:UIControlStateNormal];
    [EventPostingBtn addTarget:self action:@selector(tappedOnPublishTime:) forControlEvents:UIControlEventTouchUpInside];
    [boxView addSubview:EventPostingBtn];
    
    self.privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.privacyBtn.frame = CGRectMake(boxView.frame.size.width-35, height - 20, 20, 20);
    [self.privacyBtn setImage:[UIImage imageNamed:@"privacy_24"] forState:UIControlStateNormal];
    [self.privacyBtn setImage:[UIImage imageNamed:@"privacy_24_act"] forState:UIControlStateSelected];
    [self.privacyBtn addTarget: self action:@selector(privacyButtonSelected:) forControlEvents: UIControlEventTouchUpInside];

    [boxView addSubview:self.privacyBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, height - 20 + 40 , self.frame.size.width-10, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [boxView addSubview:lineView];
    
    y = y + 40;
}

-(void)privacyButtonSelected:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [self.privacyBtn setImage:[UIImage imageNamed:@"privacy_24"] forState:UIControlStateNormal];
    } else {
        [self.privacyBtn setImage:[UIImage imageNamed:@"privacy_24_act"] forState:UIControlStateNormal];
    }
}

-(void)addLocationBox {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y+5, self.frame.size.width-40, 30)];
    titleLabel.text = @"地点";
    titleLabel.textColor = [UIColor grayColor];
    [backgroundScrollView addSubview:titleLabel];
    y = y + 35;
    
    UIView *locationBox = [[UIView alloc]initWithFrame:CGRectMake(20, y, self.frame.size.width-40, 30)];
    locationBox.layer.borderWidth = 1;
    locationBox.layer.borderColor = [UIColor grayColor].CGColor;
    locationBox.layer.cornerRadius = 5;
    [backgroundScrollView addSubview:locationBox];
    y = y + 30;
}

-(void)addEventOccuredTimeBox {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y+5, self.frame.size.width-40, 30)];
    titleLabel.text = @"事情发生时间";
    titleLabel.textColor = [UIColor grayColor];
    [backgroundScrollView addSubview:titleLabel];
    y = y + 35;
    
    UITextField *eventTimeTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, y, self.frame.size.width-40, 30)];
    eventTimeTextField.text = @" 今天";
    eventTimeTextField.backgroundColor = [UIColor whiteColor];
    eventTimeTextField.borderStyle = UITextBorderStyleRoundedRect;
    eventTimeTextField.layer.borderWidth = 1;
    eventTimeTextField.layer.borderColor = [UIColor grayColor].CGColor;
    eventTimeTextField.layer.cornerRadius = 5;
    eventTimeTextField.delegate = self;
    [backgroundScrollView addSubview:eventTimeTextField];
    y = y + 30;
}

-(void)addEventPostingTimeBox {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y+5, self.frame.size.width-40, 30)];
    titleLabel.text = @"发布时间";
    titleLabel.textColor = [UIColor grayColor];
    [backgroundScrollView addSubview:titleLabel];
    y = y + 35;
    
    UITextField *postingTimeTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, y, self.frame.size.width-40, 30)];
    postingTimeTextField.text = @" 今天";
    postingTimeTextField.borderStyle = UITextBorderStyleRoundedRect;
    postingTimeTextField.layer.borderWidth = 1;
    postingTimeTextField.layer.borderColor = [UIColor grayColor].CGColor;
    postingTimeTextField.layer.cornerRadius = 5;
    postingTimeTextField.backgroundColor = [UIColor whiteColor];
    postingTimeTextField.delegate = self;
    [backgroundScrollView addSubview:postingTimeTextField];
    y = y + 30;
}

-(void)addPrivacyToggle {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y+5, 100, 30)];
    titleLabel.text = @"时光记隐私";
    titleLabel.textColor = [UIColor grayColor];
    [backgroundScrollView addSubview:titleLabel];
    
    UILabel *publicLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, y+5, 40, 30)];
    publicLabel.text = @"公开";
    publicLabel.textColor = [UIColor grayColor];
    [backgroundScrollView addSubview:publicLabel];
    
    self.pricacyToggle = [[UISwitch alloc]initWithFrame:CGRectMake(160, y+5, 70, 30)];
    //    pricacyToggle.tintColor = [UIColor redColor];
    self.pricacyToggle.onTintColor = [UIColor redColor];
    [backgroundScrollView addSubview:self.pricacyToggle];
    
    UILabel *privateLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, y+5, 40, 30)];
    privateLabel.text = @"私密";
    privateLabel.textColor = [UIColor grayColor];
    [backgroundScrollView addSubview:privateLabel];
    
    y = y + 55;
}

-(void)addShareToBtns {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, y, 60, 30)];
    titleLabel.text = @"分享到";
    titleLabel.textColor = [UIColor grayColor];
    [backgroundScrollView addSubview:titleLabel];
    double x = self.frame.size.width -  60 - 10 - 5*50;
    
    x += 5 + 60;
    UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatBtn.frame = CGRectMake(x, y+5, 32, 24);
    [wechatBtn setImage:[UIImage imageNamed:@"wechat_friend"] forState:UIControlStateNormal];
    [backgroundScrollView addSubview:wechatBtn];
    
    [wechatBtn addTarget:self action:@selector(wechatFriendTap:) forControlEvents:UIControlEventTouchUpInside];

    
    x += 50;
    UIButton *wechatMomentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatMomentBtn.frame = CGRectMake(x, y+5, 32, 24);
    [wechatMomentBtn setImage:[UIImage imageNamed:@"moment"] forState:UIControlStateNormal];
    [backgroundScrollView addSubview:wechatMomentBtn];
    
    [wechatMomentBtn addTarget:self action:@selector(wechatMomentTap:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)addPublishBtn {
    
    publishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    publishBtn.frame = CGRectMake(self.frame.size.width-70, 0, 76, 44);
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    publishBtn.backgroundColor = [UIColor clearColor];
    publishBtn.tintColor = [UIColor darkTextColor];
    [publishBtn addTarget:self action:@selector(tappedOnPublish:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:publishBtn];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(0, 0, 70, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.tintColor = [UIColor darkTextColor];
    [cancelBtn addTarget:self action:@selector(tappedOnCancel:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:cancelBtn];

    [backgroundScrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height-19)];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
    [backgroundScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-100) animated:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [backgroundScrollView setContentOffset:CGPointMake(0, textView.frame.origin.y-100) animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing:YES];
}

-(void)tappedOnImageOne:(UITapGestureRecognizer *)sender {
    NSLog(@"1");
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"whichPhotoFrame"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openCameraRollForPhoto" object:nil];
}

-(void)tappedOnImageTwo:(UITapGestureRecognizer *)sender {
    NSLog(@"2");
    [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"whichPhotoFrame"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openCameraRollForPhoto" object:nil];
}

-(void)tappedOnImageThree:(UITapGestureRecognizer *)sender {
    NSLog(@"3");
    [[NSUserDefaults standardUserDefaults]setInteger:3 forKey:@"whichPhotoFrame"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openCameraRollForPhoto" object:nil];
}

-(void)tappedOnImageFour:(UITapGestureRecognizer *)sender {
    NSLog(@"4");
    [[NSUserDefaults standardUserDefaults]setInteger:4 forKey:@"whichPhotoFrame"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openCameraRollForPhoto" object:nil];
}

-(void)tappedOnLocation:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tappedOnLocation" object:nil];
}
-(void)tappedOnOccurTime:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tappedOnOccurTime" object:nil];
}
-(void)tappedOnPublishTime:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tappedOnPublishTime" object:nil];
}
-(void)tappedOnPublish:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tappedOnPublish" object:nil];
}

-(void)tappedOnCancel:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tappedOnCancel" object:nil];
}

- (void)wechatFriendTap:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tappedOnWeChatFriend" object:nil];
    
}

- (void)wechatMomentTap:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tappedOnWeChatMoment" object:nil];
    
}

@end
