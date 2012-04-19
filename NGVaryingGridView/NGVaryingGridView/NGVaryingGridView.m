//
//  NGVaryingGridView.m
//  NGVaryingGridView
//
//  Created by Philip Messlehner on 19.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGVaryingGridView.h"

@interface NGVaryingGridView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *gridCells;
@property (nonatomic, strong) NSArray *gridRects;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)loadCellsInRect:(CGRect)rect;
- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation NGVaryingGridView

@synthesize scrollView = _scrollView;
@synthesize scrollViewDelegate = _scrollViewDelegate;
@synthesize gridViewDelegate = _gridViewDelegate;
@synthesize cellWidth = _cellWidth;
@synthesize gridCells = _gridCells;
@synthesize maximumContentWidth = _maximumContentWidth;
@synthesize gridRects = _gridRects;

////////////////////////////////////////////////////////////////////////
#pragma mark - Life Cycle
////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _gridCells = [NSMutableDictionary dictionary];
        
        [super addSubview:_scrollView];
        _scrollView.delegate = self;
    }
    return self;
}

- (void)dealloc {
    _scrollView.delegate = nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview != nil) {
        [self reloadData];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self loadCellsInRect:self.visibleRect];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - PVTVGridView
////////////////////////////////////////////////////////////////////////

- (void)setGridViewDelegate:(id<NGVaryingGridViewDelegate>)gridViewDelegate {
    if (gridViewDelegate != _gridViewDelegate) {
        _gridViewDelegate = gridViewDelegate;
        [self reloadData];
    }
}

- (void)reloadData {
    if (_gridViewDelegate && self.superview != nil) {
        CGFloat maxX = 0.f;
        CGFloat maxY = 0.f;
        
        self.gridRects = [self.gridViewDelegate rectsForCellsInGridView:self];
        [self.gridCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.gridCells removeAllObjects];
        
        for (NSValue *rectValue in self.gridRects) {
            CGRect rect = [rectValue CGRectValue];
            maxX = MAX(maxX, rect.origin.x + rect.size.width);
            maxY = MAX(maxY, rect.origin.y + rect.size.width);
        }
        maxX = MIN(maxX, _maximumContentWidth);
        self.scrollView.contentSize = CGSizeMake(maxX, maxY);
        
        [self loadCellsInRect:self.visibleRect];
        
        // ScrollIndicator will hide underneath view when you are adding Subviews while Scrolling
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.gridViewDelegate respondsToSelector:@selector(gridView:didSelectCell:index:)]) {
        [self.gridViewDelegate gridView:self didSelectCell:gestureRecognizer.view index:[self.gridRects indexOfObject:[NSValue valueWithCGRect:gestureRecognizer.view.frame]]];
    }
}

- (void)loadCellsInRect:(CGRect)rect {
    NSUInteger index = 0;
    for (NSValue *rectValue in self.gridRects) {
        CGRect rectOfValue = [rectValue CGRectValue];
        if (!CGRectIsEmpty(CGRectIntersection(rect, rectOfValue))) {
            UIView *gridViewCell = [self.gridCells objectForKey:rectValue];
            if (gridViewCell == nil) {
                gridViewCell = [self.gridViewDelegate gridView:self viewForCellWithRect:rectOfValue index:index];
                if (gridViewCell.frame.size.width != self.cellWidth) {
                    gridViewCell.frame = CGRectMake(gridViewCell.frame.origin.x, gridViewCell.frame.origin.y, self.cellWidth, gridViewCell.frame.size.height);
                }
                [gridViewCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
                [self.gridCells setObject:gridViewCell forKey:rectValue];
            }
            
            [self.scrollView addSubview:gridViewCell];
        }
        index ++;
    }
}

- (UIView *)gridCellWithCGPoint:(CGPoint)point {
    for (UIView *view in self.gridCells.allValues) {
        if (CGRectContainsPoint(view.frame, point)) {
            return view;
        }
    }
    
    return nil;
}

- (void)scrollToGridCell:(UIView *)cell animated:(BOOL)animated {
    [self.scrollView scrollRectToVisible:cell.frame animated:animated];
}

- (CGRect)visibleRect {
    CGRect visibleRect;
    visibleRect.origin = self.scrollView.contentOffset;
    visibleRect.size = self.scrollView.bounds.size;
    
    float scale = 1.0 / self.scrollView.zoomScale;
    visibleRect.origin.x *= scale;
    visibleRect.origin.y *= scale;
    visibleRect.size.width *= scale;
    visibleRect.size.height *= scale;
    
    return visibleRect;
}

- (void)addOverlayView:(UIView *)overlayView {
    [super addSubview:overlayView];
}

- (void)addSubview:(UIView *)view {
    [self.scrollView addSubview:view];
}

- (BOOL)isDirectionalLockEnabled {
    return self.scrollView.isDirectionalLockEnabled;
}

- (void)setDirectionalLockEnabled:(BOOL)directionalLockEnabled {
    self.scrollView.directionalLockEnabled = directionalLockEnabled;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate
////////////////////////////////////////////////////////////////////////

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
    
    [self loadCellsInRect:self.visibleRect];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.scrollViewDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset  {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.scrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.scrollViewDelegate viewForZoomingInScrollView:scrollView];        
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.scrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.scrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale]; 
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.scrollViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.scrollViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}

@end
