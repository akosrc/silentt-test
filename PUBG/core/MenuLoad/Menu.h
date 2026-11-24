#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImGuiLoad : NSObject
+ (instancetype)share;
- (void)show;
- (void)initMenu;
- (void)toggleMenu;
- (void)initTapGes;
- (void)bringOverlayToTop;
@end

NS_ASSUME_NONNULL_END
