//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <nb_utils/nb_utils_plugin.h>
#include <url_launcher_windows/url_launcher_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  nb_utils_pluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("nb_utils_plugin"));
  UrlLauncherPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherPlugin"));
}
