//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <simple_secure_storage_windows/simple_secure_storage_windows_plugin_c_api.h>
#include <webcrypto/webcrypto_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  SimpleSecureStorageWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SimpleSecureStorageWindowsPluginCApi"));
  WebcryptoPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WebcryptoPlugin"));
}
