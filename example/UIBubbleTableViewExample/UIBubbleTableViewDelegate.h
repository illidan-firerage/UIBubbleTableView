//
//  UIBubbleTableViewDelegate.h
//  UIBubbleTableViewExample
//
//  Created by Aidian.Tang on 14-6-6.
//
//

@class UIBubbleTableView;
@protocol UIBubbleTableViewDelegate <NSObject>

@optional

- (void)bubbleTableViewWillBeginDragging:(UIBubbleTableView *)bubbleTableView;
- (void)bubbleTableView:(UIBubbleTableView *)bubbleTableView didSelectedAvatar:(NSBubbleData *)bubbleData;

@end
