//
//  GCDiscreetNotificationView.m
//  Mtl mobile
//
//  Created by Guillaume Campagna on 09-12-27.
//  Copyright 2009 LittleKiwi. All rights reserved.
//

#import "GCDiscreetNotificationView.h"
#import "AppDelegate.h"

#define STAND_TIME 3
#define SHAREAPP ((AppDelegate *)[[UIApplication sharedApplication] delegate])

const CGFloat GCDiscreetNotificationViewBorderSize = 25;
const CGFloat GCDiscreetNotificationViewPadding = 15;
const CGFloat GCDiscreetNotificationViewHeight = 30;

NSString* const GCShowAnimation = @"show";
NSString* const GCHideAnimation = @"hide";
NSString* const GCChangeProprety = @"changeProprety";

NSString* const GCDiscreetNotificationViewTextKey = @"text";
NSString* const GCDiscreetNotificationViewActivityKey = @"activity";

@interface GCDiscreetNotificationView ()

@property (nonatomic, readonly) CGPoint showingCenter;
@property (nonatomic, readonly) CGPoint hidingCenter;

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, retain) NSDictionary* animationDict;

- (void) show:(BOOL)animated name:(NSString *)name;
- (void) hide:(BOOL)animated name:(NSString *)name;
- (void) showOrHide:(BOOL) hide animated:(BOOL) animated name:(NSString*) name;
- (void) animationDidStop:(NSString *)animationID finished:(BOOL) finished context:(void *) context;

- (void) placeOnGrid;
- (void) changePropretyAnimatedWithKeys:(NSArray*) keys values:(NSArray*) values;

@end

@implementation GCDiscreetNotificationView

@synthesize activityIndicator, presentationMode, label;
@synthesize animating, animationDict;


static GCDiscreetNotificationView *discreetNotificationView = nil;

#pragma mark -
#pragma mark Init and dealloc

- (id) initWithText:(NSString *)text inView:(UIView *)aView {
    return [self initWithText:text showActivity:NO inView:aView];
}

- (id)initWithText:(NSString*) text showActivity:(BOOL) activity inView:(UIView*) aView {
    return [self initWithText:text showActivity:activity inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:aView];
}

+(GCDiscreetNotificationView *) initDiscreetNotificationView:(NSString *)_text
{
    //之前取的是非
    if (discreetNotificationView) {
        [discreetNotificationView removeFromSuperview];
        
        NSLog(@"移除试图");
    }
    discreetNotificationView = [[self alloc] initWithText:_text
                                             showActivity:NO
                                       inPresentationMode: GCDiscreetNotificationViewPresentationModeTop
                                                   inView:SHAREAPP.window];
    
    return discreetNotificationView;
    
}

- (id) initWithText:(NSString *)text showActivity:(BOOL)activity
 inPresentationMode:(GCDiscreetNotificationViewPresentationMode)aPresentationMode inView:(UIView *)aView {
//    aView = SHAREAPP.window;
    if ((self = [super initWithFrame:CGRectZero])) {
        self.view = aView;
        self.textLabel = text;
        self.showActivity = activity;
        self.presentationMode = aPresentationMode;
        
        self.center = self.hidingCenter;
        [self setNeedsLayout];
        
        self.userInteractionEnabled = NO;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.animating = NO;
        
        [self show:YES];
        [self hideAnimatedAfter:STAND_TIME];
    }
    return self;
}

#pragma mark -
#pragma mark Drawing and layout

- (void) layoutSubviews {
    BOOL withActivity = self.activityIndicator != nil;
    CGFloat baseWidth = (2 * GCDiscreetNotificationViewBorderSize) + (withActivity * GCDiscreetNotificationViewPadding);
    
    CGFloat maxLabelWidth = self.view.frame.size.width - self.activityIndicator.frame.size.width * withActivity - baseWidth;
    CGSize maxLabelSize = CGSizeMake(maxLabelWidth, GCDiscreetNotificationViewHeight);
    CGFloat textSizeWidth = (self.textLabel != nil) ? [self.textLabel sizeWithFont:self.label.font constrainedToSize:maxLabelSize lineBreakMode:NSLineBreakByTruncatingTail].width : 0;
    
    CGFloat activityIndicatorWidth = (self.activityIndicator != nil) ? self.activityIndicator.frame.size.width : 0;
    CGRect bounds = CGRectMake(0, 0, baseWidth + textSizeWidth + activityIndicatorWidth, GCDiscreetNotificationViewHeight);
    if (!CGRectEqualToRect(self.bounds, bounds)) { //The bounds have changed...
        self.bounds = bounds;
//        self.frame =CGRectMake(0, 60, baseWidth + textSizeWidth + activityIndicatorWidth, GCDiscreetNotificationViewHeight);
        [self setNeedsDisplay];
    }
    CGFloat soc_height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat t_height = soc_height/2-GCDiscreetNotificationViewHeight;
    if (soc_height > 1136/2) {
        t_height = 1136/4 - GCDiscreetNotificationViewHeight;
    }
    NSLog(@"soc_height = %f  t_height = %f",soc_height,t_height);
    if (self.activityIndicator == nil)
    {
        self.label.frame = CGRectMake(GCDiscreetNotificationViewBorderSize, t_height, textSizeWidth, GCDiscreetNotificationViewHeight);
        if (textSizeWidth>250.f) {
            self.label.numberOfLines = 0;
            self.label.font = [UIFont systemFontOfSize:12];
        }
    }
    else {
        self.activityIndicator.frame = CGRectMake(GCDiscreetNotificationViewBorderSize, GCDiscreetNotificationViewPadding, self.activityIndicator.frame.size.width, self.activityIndicator.frame.size.height);
        self.label.frame = CGRectMake(GCDiscreetNotificationViewBorderSize + GCDiscreetNotificationViewPadding + self.activityIndicator.frame.size.width, t_height, textSizeWidth, GCDiscreetNotificationViewHeight);
        if (textSizeWidth>250.f) {
            self.label.numberOfLines = 0;
            self.label.font = [UIFont systemFontOfSize:12];
        }
    }
    
    [self placeOnGrid];
}

#pragma mark -
#pragma mark Show/Hide

- (void)showAnimated {
    [self show:YES];
}

- (void)hideAnimated {
    [self hide:YES];
}

- (void) hideAnimatedAfter:(NSTimeInterval) timeInterval {
    [self performSelector:@selector(hideAnimated) withObject:nil afterDelay:timeInterval];
}

- (void)showAndDismissAutomaticallyAnimated {
    [self showAndDismissAfter:1.0];
}

- (void)showAndDismissAfter:(NSTimeInterval)timeInterval {
    [self showAnimated];
    [self hideAnimatedAfter:timeInterval];
}

- (void) show:(BOOL)animated {
    [self show:animated name:GCShowAnimation];
}

- (void) hide:(BOOL)animated {
    [self hide:animated name:GCHideAnimation];
}

- (void) show:(BOOL)animated name:(NSString*) name {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAnimated) object:nil];
    
    [self showOrHide:NO animated:animated name:name];
}

- (void) hide:(BOOL)animated name:(NSString*) name {
    [self showOrHide:YES animated:animated name:name];
}

- (void) showOrHide:(BOOL)hide animated:(BOOL)animated name:(NSString *)name {
    if ((hide && self.isShowing) || (!hide && !self.isShowing)) {
        if (animated) {
            self.animating = YES;
            [UIView beginAnimations:name context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        }
        
        if (hide) self.center = self.hidingCenter;
        else {
            [self.activityIndicator startAnimating];
            self.center = self.showingCenter;
        }
        
        [self placeOnGrid];
        
        if (animated) [UIView commitAnimations];
        
        self.label.hidden = hide;
    }
}

#pragma mark -
#pragma mark Animations

- (void) animationDidStop:(NSString *)animationID finished:(BOOL) finished context:(void *) context {
    if (animationID == GCHideAnimation) [self.activityIndicator stopAnimating];
    else if (animationID == GCChangeProprety) {
        NSString* showName = GCShowAnimation;
        
        for (NSString* key in [self.animationDict allKeys]) {
            if (key == GCDiscreetNotificationViewActivityKey) {
                self.showActivity = [[self.animationDict objectForKey:key] boolValue];
            }
            else if (key == GCDiscreetNotificationViewTextKey) {
                self.textLabel = [self.animationDict objectForKey:key];
            }
        }
        
        self.animationDict = nil;
        
        [self show:YES name:showName];
    }
    else if (animationID == GCShowAnimation) {
        if (self.animationDict != nil) [self hide:YES name:GCChangeProprety];
    }
    
    self.animating = NO;
}


#pragma mark -
#pragma mark Getter and setters

- (NSString *) textLabel {
    return self.label.text;
}

- (void) setTextLabel:(NSString *) aText {
    self.label.text = [NSString stringWithFormat:@"  %@  ",aText];
    [self setNeedsLayout];
}

- (UILabel *)label {
    if (label == nil) {
        label = [[UILabel alloc] init];
        
        label.font = [UIFont boldSystemFontOfSize:15.0];
        label.textColor = [UIColor whiteColor];
        label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//        label.backgroundColor = TEXT_HOLDER_COLOR;
        label.backgroundColor = [UIColor colorWithRed:90/255.0 green:88/255.0 blue:89/255.0 alpha:1];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 5;
        [self addSubview:label];
    }
    return label;
}

- (BOOL) showActivity {
    return (self.activityIndicator != nil);
}

- (void) setShowActivity:(BOOL) activity {
    if (activity != self.showActivity) {
        if (activity) {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self addSubview:activityIndicator];
        }
        else {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }
        
        [self setNeedsLayout];
    }
}

- (void) setView:(UIView *) aView {
    if (self.view != aView) {
        [self removeFromSuperview];
        
        [aView addSubview:self];
        [self setNeedsLayout];
    }
}

- (UIView *)view {
    return self.superview;
}

- (void) setPresentationMode:(GCDiscreetNotificationViewPresentationMode) newPresentationMode {
    if (presentationMode != newPresentationMode) {
        BOOL showing = self.isShowing;
        
        presentationMode = newPresentationMode;
        if (presentationMode == GCDiscreetNotificationViewPresentationModeTop) {
            self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        }
        else if (presentationMode == GCDiscreetNotificationViewPresentationModeBottom) {
            self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        }
        
        self.center = showing ? self.showingCenter : self.hidingCenter;
        
        [self setNeedsDisplay];
        [self placeOnGrid];
    }
}

- (BOOL) isShowing {
    return (self.center.y == self.showingCenter.y);
}

- (CGPoint) showingCenter {
    CGFloat y = 0;
    if (self.presentationMode == GCDiscreetNotificationViewPresentationModeTop) y = 15;
    else if (self.presentationMode == GCDiscreetNotificationViewPresentationModeBottom) y = self.view.frame.size.height - 15;
    return CGPointMake(self.view.frame.size.width / 2, y);
}

- (CGPoint) hidingCenter {
    CGFloat y = 0;
    if (self.presentationMode == GCDiscreetNotificationViewPresentationModeTop) y = - 15;
    else if (self.presentationMode == GCDiscreetNotificationViewPresentationModeBottom) y = 15 + self.view.frame.size.height;
    return CGPointMake(self.view.frame.size.width / 2, y);
}

#pragma mark -
#pragma mark Animated Setters

- (void) setTextLabel:(NSString *)aText animated:(BOOL)animated {
    if (animated && (self.showing || self.animating)) {
        [self changePropretyAnimatedWithKeys:[NSArray arrayWithObject:GCDiscreetNotificationViewTextKey]
                                      values:[NSArray arrayWithObject:aText]];
    }
    else self.textLabel = aText;
}

- (void) setShowActivity:(BOOL)activity animated:(BOOL)animated {
    if (animated && (self.showing || self.animating)) {
        [self changePropretyAnimatedWithKeys:[NSArray arrayWithObject:GCDiscreetNotificationViewActivityKey]
                                      values:[NSArray arrayWithObject:[NSNumber numberWithBool:activity]]];
    }
    else self.showActivity = activity;
}

- (void) setTextLabel:(NSString *)aText andSetShowActivity:(BOOL)activity animated:(BOOL)animated {
    if (animated && (self.showing || self.animating)) {
        [self changePropretyAnimatedWithKeys:[NSArray arrayWithObjects:GCDiscreetNotificationViewTextKey, GCDiscreetNotificationViewActivityKey, nil]
                                      values:[NSArray arrayWithObjects:aText, [NSNumber numberWithBool:activity], nil]];
    }
    else {
        self.textLabel = aText;
        self.showActivity = activity;
    }
}

#pragma mark -
#pragma mark Helper Methods

- (void) placeOnGrid {
    CGRect frame = self.frame;
    
    frame.origin.x = roundf(frame.origin.x);
    frame.origin.y = roundf(frame.origin.y);
    
    self.frame = frame;
}

- (void) changePropretyAnimatedWithKeys:(NSArray*) keys values:(NSArray*) values {
    NSDictionary* newDict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    if (self.animationDict == nil) {
        self.animationDict = newDict;
    }
    else {
        NSMutableDictionary* mutableAnimationDict = [self.animationDict mutableCopy];
        [mutableAnimationDict addEntriesFromDictionary:newDict];
        self.animationDict = mutableAnimationDict;
    }
    
    if (!self.animating) [self hide:YES name:GCChangeProprety];
}

#pragma mark - UIView subclass

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) self.animationDict = nil;
}

@end
