//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImageView;
@property (nonatomic, retain) UIButton *avatarBtn;
@property (nonatomic, retain) UIImageView *bubbleNewImageView;

- (void) setupInternalData;

@end

@implementation UIBubbleTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImageView = _bubbleImageView;
@synthesize showAvatar = _showAvatar;
@synthesize avatarBtn = _avatarBtn;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

#if !__has_feature(objc_arc)
- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.bubbleImageView = nil;
    self.avatarBtn = nil;
    [super dealloc];
}
#endif

- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.bubbleImageView)
    {
#if !__has_feature(objc_arc)
        self.bubbleImageView = [[[UIImageView alloc] init] autorelease];
#else
        self.bubbleImageView = [[UIImageView alloc] init];
#endif
        [self addSubview:self.bubbleImageView];
    }
    
    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;

    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarBtn removeFromSuperview];
        self.avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.avatarBtn addTarget:self action:@selector(avatarBtnDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.avatarBtn setBackgroundImage:(self.data.avatar ? self.data.avatar : self.data.missingAvatar) forState:UIControlStateNormal];
#if !__has_feature(objc_arc)
        self.bubbleNewImageView = [[[UIImageView alloc] initWithImage:self.data.bubbleNewImage] autorelease];
#else
        self.bubbleNewImageView = [[UIImageView alloc] initWithImage:self.data.bubbleNewImage];
#endif
        self.avatarBtn.layer.cornerRadius = 9.0;
        self.avatarBtn.layer.masksToBounds = YES;
        self.avatarBtn.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        self.avatarBtn.layer.borderWidth = 1.0;
        
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 10 : self.frame.size.width - self.data.avatarSize.width - 10;
        CGFloat avatarY = self.frame.size.height - self.data.avatarSize.height;
        
        self.avatarBtn.frame = CGRectMake(avatarX, avatarY, self.data.avatarSize.width, self.data.avatarSize.height);
        [self addSubview:self.avatarBtn];
        
        self.bubbleNewImageView.frame = CGRectMake(avatarX, avatarY - NSBubbleNewMarginY - CGRectGetHeight(self.bubbleNewImageView.frame), CGRectGetWidth(self.bubbleNewImageView.frame), CGRectGetHeight(self.bubbleNewImageView.frame));
        [self addSubview:self.bubbleNewImageView];
        
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta;
        
        if (type == BubbleTypeSomeoneElse) x += self.data.avatarSize.width + 13;
        if (type == BubbleTypeMine) x -= self.data.avatarSize.width + 10;
    }

    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];

    self.bubbleImageView.image = self.data.bubbleImage;
    self.bubbleImageView.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
}

#pragma mark -
#pragma mark - Action

- (void)avatarBtnDidPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(bubbleTableViewCellDidSelectedAvatar:)]) {
        [_delegate bubbleTableViewCellDidSelectedAvatar:self];
    }
}

@end
