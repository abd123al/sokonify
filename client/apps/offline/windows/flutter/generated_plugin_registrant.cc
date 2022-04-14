//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <graph/graph_plugin.h>
#include <server/server_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  GraphPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GraphPlugin"));
  ServerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ServerPlugin"));
}
