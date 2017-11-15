#!/usr/bin/env bash

# do that aslong we are not sure this is really set in the base image
GOCD_PLUGIN_EXTERNAL_HOME=${$GOCD_PLUGIN_EXTERNAL_HOME-/godata/plugins/external}

if [ ! -d "${GOCD_PLUGIN_EXTERNAL_HOME}" ]; then
    mkdir -p "${GOCD_PLUGIN_EXTERNAL_HOME}"
fi

while IFS='=' read -r name value ; do
  if [[ $name == *"GOCD_PLUGIN_INSTALL_"* ]]; then
    plugin_name=${name//GOCD_PLUGIN_INSTALL_/} # delete longest match from back (everything after first _)
    plugin_url=${value}
    # only the last bit of the path since we assume, for now, i github download like .... https://github.com/gocd-contrib/.../v0.8.0/<myplugin>
    plugin_filename=${plugin_url##*/}
    plugin_dest=${GOCD_PLUGIN_EXTERNAL_HOME}/${plugin_filename}
    if [ ! -f plugin_dest ]; then
        echo "installing plugin $plugin_name from $plugin_url to $plugin_dest"
        # TODO: should we use silent?
        curl --silent --location --retry 3 ${plugin_url} -o ${plugin_dest}
    else
        echo "installing plugin ${plugin_name} already installed"
    fi
  fi
done < <(env)