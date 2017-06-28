//
//  CWPictureWallCollectionViewLayout.m
//  TheCloudWisdom
//
//  Created by drision on 2017/2/15.
//  Copyright © 2017年 drision. All rights reserved.
//

#pragma mark ---横排纵滑layout


#import "CWPictureWallCollectionViewLayout.h"

#define NewDefaultCollectionViewWidth  self.collectionView.frame.size.width

@interface CWPictureWallCollectionViewLayout ()

//创建数组存放每行空余区域宽度
@property(nonatomic,strong) NSMutableArray *surplusWidthArray;

//cell布局数组
@property(nonatomic,strong) NSMutableArray *cellArr;

@end

@implementation CWPictureWallCollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellHeight = 30;
        self.extraWidth = 20;
        self.newDefaultInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return self;
}

- (NSMutableArray *)surplusWidthArray{
    if (!_surplusWidthArray) {
        _surplusWidthArray=[NSMutableArray array];
    }
    return _surplusWidthArray;
}

- (NSMutableArray *)cellArr{
    if (!_cellArr) {
        _cellArr =[NSMutableArray array];
    }
    
    return _cellArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //布局属性刷新更改
    CGFloat cellheight=self.cellHeight;
    CGFloat labelWidth = [self.ViewsWidthArray[indexPath.row] doubleValue];
    CGFloat extraWidth = self.extraWidth;
    CGFloat cellwidth = labelWidth + extraWidth;
    UIEdgeInsets NewDefaultInsets = self.newDefaultInsets;
    if (indexPath.row == 0) {
        attr.frame = CGRectMake(NewDefaultInsets.left, NewDefaultInsets.top, cellwidth, cellheight);
        CGFloat fristsurplusWidth= [[self.surplusWidthArray firstObject] floatValue] - cellwidth - NewDefaultInsets.left - NewDefaultInsets.right;
        self.surplusWidthArray[self.linesNum]=[NSString stringWithFormat:@"%lf",fristsurplusWidth];
    }else{
        for (NSInteger i=0; i<self.MaxLinesCount; i++) {
            if (cellwidth <= [self.surplusWidthArray[i] floatValue] - NewDefaultInsets.right) {
                attr.frame=CGRectMake(NewDefaultCollectionViewWidth - [self.surplusWidthArray[i] floatValue], NewDefaultInsets.top * (i + 1) + NewDefaultInsets.bottom * i + i * cellheight, cellwidth, cellheight);
                CGFloat fristsurplusWidth = [self.surplusWidthArray[i] floatValue] - cellwidth - NewDefaultInsets.left - NewDefaultInsets.right;
                self.surplusWidthArray[i] = [NSString stringWithFormat:@"%lf",fristsurplusWidth];
                self.linesNum = i+1;
                break;
            }
        }
    }
//    NSLog(@"row=%ld   origin x=%lf  y=%lf  size x=%lf  y=%lf",indexPath.row,attr.frame.origin.x,attr.frame.origin.y,attr.frame.size.width,attr.frame.size.height);
    
    
    
    return attr;
}
- (void)prepareLayout{
    [super prepareLayout];
    //设置cell的布局属性  这里的self.layoutAttributesForItemAtIndexPath 是本类的一个属性 通过对应的indexPath我们可以拿到对应的item的布局属性 然后存储起来
    [self.surplusWidthArray removeAllObjects];
    [self.cellArr removeAllObjects];
    UIEdgeInsets NewDefaultInsets = self.newDefaultInsets;
    for (NSInteger i=0; i<self.MaxLinesCount; i++) {
        [self.surplusWidthArray addObject:[NSString stringWithFormat:@"%lf",NewDefaultCollectionViewWidth - NewDefaultInsets.left]];
    }
    NSInteger count=[self.collectionView numberOfItemsInSection:0];
    
    self.linesNum=0;
    for (int i=0; i<count; i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs=[self layoutAttributesForItemAtIndexPath:indexPath];
        [self.cellArr addObject:attrs];
    }
}

#pragma mark -- 设置collectionView的范围 contentSize
- (CGSize)collectionViewContentSize{
    //这里返回的横坐标是什么都可以
//    for (NSInteger i=0; i<self.surplusWidthArray.count; i++) {
//        if ([self.surplusWidthArray[i] floatValue]==NewDefaultCollectionViewWidth-NewDefaultInsets.left-NewDefaultInsets.right) {
//            self.linesNum=i;
//            break;
//        }
//    }
//    NSLog(@"lines=====%ld",self.linesNum);
    UIEdgeInsets NewDefaultInsets = self.newDefaultInsets;
    CGFloat height = self.linesNum*(self.cellHeight+NewDefaultInsets.top+NewDefaultInsets.bottom);
    return CGSizeMake(0,height);
}
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //在里我们将我们存储起来的item布局属性交付给cell
    return self.cellArr;
}

@end
