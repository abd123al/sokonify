//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_secure_storage_linux/flutter_secure_storage_linux_plugin.h>
#include <graph/graph_plugin.h>
#include <server/server_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_secure_storage_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterSecureStorageLinuxPlugin");
  flutter_secure_storage_linux_plugin_register_with_registrar(flutter_secure_storage_linux_registrar);
  g_autoptr(FlPluginRegistrar) graph_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "GraphPlugin");
  graph_plugin_register_with_registrar(graph_registrar);
  g_autoptr(FlPluginRegistrar) server_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ServerPlugin");
  server_plugin_register_with_registrar(server_registrar);
}
