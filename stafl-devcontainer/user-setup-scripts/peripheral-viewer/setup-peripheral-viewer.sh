#!/bin/bash

wget "https://open-vsx.org/api/eclipse-cdt/peripheral-inspector/1.9.0/file/eclipse-cdt.peripheral-inspector-1.9.0.vsix"

code --install-extension /user-setup-scripts/peripheral-viewer/eclipse-cdt.peripheral-inspector-1.9.0.vsix
