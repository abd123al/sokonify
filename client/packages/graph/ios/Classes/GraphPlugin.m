#import "GraphPlugin.h"
#if __has_include(<graph/graph-Swift.h>)
#import <graph/graph-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "graph-Swift.h"
#endif

@implementation GraphPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGraphPlugin registerWithRegistrar:registrar];
}
@end
