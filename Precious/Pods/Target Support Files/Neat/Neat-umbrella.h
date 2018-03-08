#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Neat.h"
#import "NELineHeightFixer.h"
#import "NELineHeightFixerInner.h"
#import "NSLayoutManager+LineHeightFixer.h"
#import "NSLayoutManagerDelegateFixerWrapper.h"
#import "UIFont+Patch.h"

FOUNDATION_EXPORT double NeatVersionNumber;
FOUNDATION_EXPORT const unsigned char NeatVersionString[];

