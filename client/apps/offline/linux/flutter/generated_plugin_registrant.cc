//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <server/server_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) server_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ServerPlugin");
  server_plugin_register_with_registrar(server_registrar);
}
