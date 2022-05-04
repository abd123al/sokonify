#include "include/server/server_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>
#include <winbase.h>
#include <iostream>

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

typedef int(__stdcall* f_StartServer)();

void ServerPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("startServer") == 0) {
      //Loading dll
      HINSTANCE  hModule = LoadLibrary(TEXT("E:\\_Projects\\mahesabu\\client\\packages\\server\\windows\\include\\lib\\lib.dll"));

      if (!hModule) {
          std::cout << "could not load the dynamic library" << std::endl;
      }

      // resolve function address here
      f_StartServer fn = (f_StartServer)GetProcAddress(hModule, "StartServer");

      if (!fn) {
          std::cout << "could not locate the function" << std::endl;
      }

    std::cout << "StartServer() port: " << fn() << std::endl;
    std::string port = "8080";
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
