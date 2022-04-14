//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <graph/graph_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) graph_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "GraphPlugin");
  graph_plugin_register_with_registrar(graph_registrar);
}
