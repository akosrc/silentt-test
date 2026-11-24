#import <UIKit/UIKit.h>
#include "PUBG/core/MenuLoad/Includes.h"
#import <AVFoundation/AVFoundation.h>
#include "PUBG/core/ue4/xor.h"

#define TOKEN ENCRYPT("wZ3Q/xYPjTIWo5gRdA5jLfamO6POk7SjBPQALRXHafuNi0nwolEDstMEOrlEsxHyiUUj4M/7hRwYD6VApIf9c3kkgQYy6dWE/B69+eT5F0g=")

extern bool menu_open;

static UIWindow *FindActiveKeyWindow(void) {
    UIApplication *app = [UIApplication sharedApplication];
    for (UIWindow *win in app.windows) {
        if (win.isKeyWindow && win.rootViewController.view) {
            return win;
        }
    }
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in app.connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *win in windowScene.windows) {
                    if (win.isKeyWindow && win.rootViewController.view) {
                        return win;
                    }
                }
                if (windowScene.windows.lastObject.rootViewController.view) {
                    return windowScene.windows.lastObject;
                }
            }
        }
    }
    return app.keyWindow ?: app.windows.lastObject;
}

void initAPI(){
    [[ImGuiLoad share] show];
}

@interface ImGuiLoad()
@property (nonatomic, strong) ImGuiDrawView *vna;
@property (nonatomic, assign) BOOL gestureInstalled;
- (void)initMenu;
- (void)initTapGes;
- (void)toggleMenu;
- (void)handleTap:(UITapGestureRecognizer *)gesture;
@end

@implementation ImGuiLoad

+ (void)load { 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ 
        initAPI();
        [[ImGuiLoad share] initTapGes]; 
    }); 
}

+ (instancetype)share { 
    static ImGuiLoad *tool; 
    static dispatch_once_t onceToken; 
    dispatch_once(&onceToken, ^{ 
        tool = [[ImGuiLoad alloc] init]; 
    }); 
    return tool; 
}

- (void)show { 
    [self initMenu]; 
    if (!_vna.view) return;
    _vna.view.hidden = NO; 
    menu_open = true; 
    if (_vna.view.superview) {
        [_vna.view.superview bringSubviewToFront:_vna.view];
    }
}

- (void)initMenu { 
    UIWindow *keyWindow = FindActiveKeyWindow();
    UIView *parentView = keyWindow.rootViewController.view ?: keyWindow;
    if (!parentView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initMenu];
        });
        return;
    }

    if (!_vna) { 
        _vna = [[ImGuiDrawView alloc] init]; 
        _vna.view.frame = [UIScreen mainScreen].bounds; 
        _vna.view.userInteractionEnabled = YES; 
        _vna.view.backgroundColor = [UIColor clearColor]; 
        [parentView addSubview:_vna.view]; 
        _vna.view.hidden = NO; 
        menu_open = true; 
    } else if (_vna.view.superview != parentView) {
        [_vna.view removeFromSuperview];
        [parentView addSubview:_vna.view];
    }
}

- (void)toggleMenu { 
    [self initMenu];
    if (!_vna.view) return;
    _vna.view.hidden = !_vna.view.hidden; 
    menu_open = !_vna.view.hidden; 
    if (menu_open && _vna.view.superview) {
        [_vna.view.superview bringSubviewToFront:_vna.view];
    }
}

- (void)initTapGes { 
    if (self.gestureInstalled) return;
    UIWindow *keyWindow = FindActiveKeyWindow();
    UIView *targetView = keyWindow ?: keyWindow.rootViewController.view;
    if (!targetView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initTapGes];
        });
        return;
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]; 
    tap.numberOfTapsRequired = 2; 
    tap.numberOfTouchesRequired = 2; 
    tap.cancelsTouchesInView = NO;
    [targetView addGestureRecognizer:tap]; 
    self.gestureInstalled = YES;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture { 
    if (gesture.state == UIGestureRecognizerStateEnded) { 
        [self toggleMenu]; 
    } 
}

@end
