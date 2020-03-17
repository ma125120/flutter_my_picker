#import "FlutterMyPickerPlugin.h"
#if __has_include(<flutter_my_picker/flutter_my_picker-Swift.h>)
#import <flutter_my_picker/flutter_my_picker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_my_picker-Swift.h"
#endif

@implementation FlutterMyPickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMyPickerPlugin registerWithRegistrar:registrar];
}
@end
