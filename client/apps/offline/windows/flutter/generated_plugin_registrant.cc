//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <connectivity_plus_windows/connectivity_plus_windows_plugin.h>
#include <graph/graph_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <server/server_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  GraphPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GraphPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  ServerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ServerPlugin"));
}
