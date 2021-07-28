#import "ExampleAppDelegate.h"
#import "Demo1WebViewController.h"
#import "Demo2WebViewController.h"
#import "Demo3WebViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ExampleAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1. Create the UIWebView example
//    ExampleUIWebViewController* UIWebViewExampleController = [[ExampleUIWebViewController alloc] init];
//    UIWebViewExampleController.tabBarItem.title             = @"UIWebView";

    // 2. Create the tab footer and add the UIWebView example
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    [tabBarController addChildViewController:UIWebViewExampleController];
    tabBarController.tabBar.barTintColor = UIColorFromRGB(0xeeeeee);
    
    // Demo1-Native2Web
    Demo1WKWebViewController* Demo1WKWebVC = [[Demo1WKWebViewController alloc] init];
    Demo1WKWebVC.tabBarItem.title             = @"Demo1";
    [tabBarController addChildViewController:Demo1WKWebVC];
    
    // Demo2-Web2Native
    Demo2WKWebViewController* Demo2WKWebVC = [[Demo2WKWebViewController alloc] init];
    Demo2WKWebVC.tabBarItem.title = @"Demo2";
    [tabBarController addChildViewController:Demo2WKWebVC];
    
    // Demo3-CompleteJSB
    Demo3WebViewController* Demo3WKWebVC = [[Demo3WebViewController alloc] init];
    Demo3WKWebVC.tabBarItem.title             = @"Demo3";
    [tabBarController addChildViewController:Demo3WKWebVC];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
