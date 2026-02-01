/*
 * This file is part of the SDNetworkActivityIndicator package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
#import <UIKit/UIKit.h>
#import "SDNetworkActivityIndicator.h"

@interface SDNetworkActivityIndicator ()
{
    @private NSUInteger counter;
}
@end

@implementation SDNetworkActivityIndicator

#pragma mark - Private helper

+ (void)_setVisible:(BOOL)visible
{
#if !TARGET_OS_VISION
    if (@available(iOS 13.0, *)) {
        // Network activity indicator removed in iOS 13+
        // Intentionally no-op
    } else {
        [[UIApplication sharedApplication]
            setNetworkActivityIndicatorVisible:visible];
    }
#endif
}

#pragma mark - Public API

+ (void)setNetworkActivityIndicatorVisible:(BOOL)visible
{
    [self _setVisible:visible];
}

+ (instancetype)sharedActivityIndicator
{
    static SDNetworkActivityIndicator *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (id)init
{
    if ((self = [super init])) {
        counter = 0;
    }
    return self;
}

- (void)startActivity
{
    @synchronized (self) {
        counter++;
        [[self class] _setVisible:YES];
    }
}

- (void)stopActivity
{
    @synchronized (self) {
        if (counter > 0 && --counter == 0) {
            [[self class] _setVisible:NO];
        }
    }
}

- (void)stopAllActivity
{
    @synchronized (self) {
        counter = 0;
        [[self class] _setVisible:NO];
    }
}

@end

