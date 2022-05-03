#include "include/server/server_plugin.h"
#include "include/lib/lib.h"

// This must be included before many other Windows headers.
#include <windows.h>


#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

namespace {

class ServerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ServerPlugin();

  virtual ~ServerPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void ServerPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "server",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<ServerPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

ServerPlugin::ServerPlugin() {}

ServerPlugin::~ServerPlugin() {}

void ServerPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("startServer") == 0) {
    string port = StartServer("8080");
    cout << "port " << port << " running.";
    result->Success(flutter::EncodableValue(port));
  } else {
    result->NotImplemented();
  }
}

}  // namespace

void ServerPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ServerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
