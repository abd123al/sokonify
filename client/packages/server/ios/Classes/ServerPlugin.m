#import "ServerPlugin.h"
#if __has_include(<server/server-Swift.h>)
#import <server/server-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "server-Swift.h"
#endif

@implementation ServerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftServerPlugin registerWithRegistrar:registrar];
}
@end
