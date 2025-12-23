#!/bin/bash

# Script to create a new mod in the monorepo
# Usage: ./create-mod.sh <modname>

if [ -z "$1" ]; then
    echo "Usage: ./create-mod.sh <modname>"
    echo "Example: ./create-mod.sh awesomemod"
    exit 1
fi

MOD_NAME=$1
MOD_NAME_LOWER=$(echo "$MOD_NAME" | tr '[:upper:]' '[:lower:]')

echo "Creating new mod: $MOD_NAME"
echo "Mod ID will be: $MOD_NAME_LOWER"

# Create directory structure
echo "Creating directory structure..."

mkdir -p "common/$MOD_NAME_LOWER/src/main/java"
mkdir -p "common/$MOD_NAME_LOWER/src/main/resources"

mkdir -p "fabric/$MOD_NAME_LOWER/src/main/java"
mkdir -p "fabric/$MOD_NAME_LOWER/src/main/resources"

mkdir -p "forge/$MOD_NAME_LOWER/src/main/java"
mkdir -p "forge/$MOD_NAME_LOWER/src/main/resources"

mkdir -p "neoforge/$MOD_NAME_LOWER/src/main/java"
mkdir -p "neoforge/$MOD_NAME_LOWER/src/main/resources"

# Create common gradle.properties
echo "Creating gradle.properties files..."

cat > "common/$MOD_NAME_LOWER/gradle.properties" << EOF
# Mod-specific properties for $MOD_NAME
# These override the global properties from the root gradle.properties

mod_id=$MOD_NAME_LOWER
mod_name=$MOD_NAME
version=0.1.0
description=An awesome Minecraft mod!
EOF

# Create loader-specific gradle.properties
for loader in fabric forge neoforge; do
    cat > "$loader/$MOD_NAME_LOWER/gradle.properties" << EOF
# Mod-specific properties for $MOD_NAME ($loader)
# Inherits from common/$MOD_NAME_LOWER/gradle.properties

mod_id=$MOD_NAME_LOWER
mod_name=$MOD_NAME
version=0.1.0
EOF
done

echo ""
echo "✅ Mod structure created successfully!"
echo ""
echo "Next steps:"
echo "1. Edit common/$MOD_NAME_LOWER/gradle.properties with your mod details"
echo "2. Add your source code to the src/main/java directories"
echo "3. Refresh Gradle in your IDE"
echo "4. Run configurations will appear automatically!"
echo ""
echo "Directory structure:"
echo "├── common/$MOD_NAME_LOWER/    (shared code)"
echo "├── fabric/$MOD_NAME_LOWER/    (fabric-specific)"
echo "├── forge/$MOD_NAME_LOWER/     (forge-specific)"
echo "└── neoforge/$MOD_NAME_LOWER/  (neoforge-specific)"

