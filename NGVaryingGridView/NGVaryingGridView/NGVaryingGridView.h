//
//  NGVaryingGridView.h
//  NGVaryingGridView
//
//  Created by Philip Messlehner on 19.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NGVaryingGridView;
@class NGVaryingGridViewDelegate;

////////////////////////////////////////////////////////////////////////
#pragma mark - NGVaryingGridViewDelegate
////////////////////////////////////////////////////////////////////////

@protocol NGVaryingGridViewDelegate <NSObject>

@required
- (NSArray *)rectsForCellsInGridView:(NGVaryingGridView *)gridView;
- (UIView *)gridView:(NGVaryingGridView *)gridView viewForCellWithRect:(CGRect)rect index:(NSUInteger)index;

@optional
- (void)gridView:(NGVaryingGridView *)gridView didSelectCell:(UIView *)cell index:(NSUInteger)index;

@end 

////////////////////////////////////////////////////////////////////////
#pragma mark - NGVaryingGridView
////////////////////////////////////////////////////////////////////////

@interface NGVaryingGridView : UIView

@property (nonatomic, unsafe_unretained) id <NGVaryingGridViewDelegate> gridViewDelegate;
@property (nonatomic, unsafe_unretained) id <UIScrollViewDelegate> scrollViewDelegate;
@property (nonatomic) CGFloat cellWidth;
@property (nonatomic) CGFloat maximumContentWidth;
@property (nonatomic, readonly) CGRect visibleRect;
@property(nonatomic, getter=isDirectionalLockEnabled) BOOL directionalLockEnabled;

/**
 Reloads the rows and sections of the receiver.
 */
- (void)reloadData;

/**
 Returns the GridCell with a point inside its frame
 @param point the point locating the GridCell inside the GridView
 @return the GridCell at the given point or `nil` if there is no GridCell at this point or is not loaded.
 */
- (UIView *)gridCellWithCGPoint:(CGPoint)point;

/**
 Scroll the GridView to a specifc GridCell 
 @param cell the GridCell where the GridView should scroll to
 @param animated `YES` if you want to animate the change in position, `NO` if it should be immediate.
 */
- (void)scrollToGridCell:(UIView *)cell animated:(BOOL)animated;


/**
 Adds an Overlay to the GridView. The `UIView` will not be inside the scrollable Area, but above it
 @param overlayView the OverlayView
 */
- (void)addOverlayView:(UIView *)overlayView;

@end
