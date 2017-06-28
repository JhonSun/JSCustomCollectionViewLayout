//
//  CWPictureWallCollectionViewLayout.h
//  TheCloudWisdom
//
//  Created by drision on 2017/2/15.
//  Copyright © 2017年 drision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWPictureWallCollectionViewLayout : UICollectionViewLayout
//cell宽度数组
@property(nonatomic,copy) NSArray *ViewsWidthArray;

@property (nonatomic, assign) CGFloat cellHeight;//高度

@property (nonatomic, assign) CGFloat extraWidth;//字体左右两边加起来的宽度

@property (nonatomic, assign) UIEdgeInsets newDefaultInsets;//上下左右间距，cell行间距，cell列间距

//最大行数
@property(nonatomic,assign) NSInteger MaxLinesCount;

@property (nonatomic, assign) NSInteger linesNum;
@end
