# Quick Reference Guide - Monorepo Structure

## Directory Structure

```
multiloader-mods-mc/
├── common/
│   ├── build.gradle           # Applies shared-common.gradle to all subprojects
│   ├── examplemod/
│   │   ├── gradle.properties  # mod_id, mod_name, version, description
│   │   └── src/main/
│   └── yourmod/
│       ├── gradle.properties
│       └── src/main/
├── fabric/
│   ├── build.gradle           # Applies shared-fabric.gradle to all subprojects
│   ├── examplemod/
│   │   ├── gradle.properties  # mod_id, mod_name, version
│   │   └── src/main/
│   └── yourmod/
│       ├── gradle.properties
│       └── src/main/
├── forge/                     # Same structure as fabric
├── neoforge/                  # Same structure as fabric
└── buildSrc/
    └── src/main/groovy/
        ├── shared-common.gradle
        ├── shared-fabric.gradle
        ├── shared-forge.gradle
        └── shared-neoforge.gradle
```

## Adding a New Mod - Quick Steps

### Option 1: Use the Script
```bash
# Linux/Mac
./create-mod.sh mynewmod

# Windows
create-mod.bat mynewmod
```

### Option 2: Manual

1. **Create directories:**
   ```bash
   for loader in common fabric forge neoforge; do
       mkdir -p $loader/mynewmod/src/main/{java,resources}
   done
   ```

2. **Create `common/mynewmod/gradle.properties`:**
   ```properties
   mod_id=mynewmod
   mod_name=My New Mod
   mod_author=YourName
   version=1.0.0
   description=My awesome new mod
   ```

3. **Create minimal `gradle.properties` for each loader:**
   (fabric, forge, neoforge)
   ```properties
   mod_id=mynewmod
   mod_name=My New Mod
   version=1.0.0
   ```

4. **Refresh Gradle** - Done!

## Project Paths

- Common: `:common:modname`
- Fabric: `:fabric:modname`
- Forge: `:forge:modname`
- NeoForge: `:neoforge:modname`

## Building

```bash
# Build all mods, all loaders
./gradlew build

# Build specific mod, all loaders
./gradlew :common:mynewmod:build :fabric:mynewmod:build

# Build specific mod, one loader
./gradlew :fabric:mynewmod:build
```

## Running

Run configurations are automatically generated:
- Fabric Client - modname
- Fabric Server - modname
- Forge Client - modname
- NeoForge Client - modname

Run directories: `runs/modname/client`, `runs/modname/server`

## Properties

### Global (root `gradle.properties`)
- `minecraft_version`
- `fabric_version`, `forge_version`, `neoforge_version`
- `java_version`
- Mapping versions

### Per-Mod (`loader/modname/gradle.properties`)
- `mod_id` - Required, unique identifier
- `mod_name` - Required, display name
- `mod_author` - Optional
- `version` - Required
- `description` - Optional (only in common)

## Key Files

| File | Purpose |
|------|---------|
| `settings.gradle` | Auto-discovers all mods |
| `build.gradle` (root) | Plugin version declarations |
| `common/build.gradle` | Applies shared-common.gradle |
| `fabric/build.gradle` | Applies shared-fabric.gradle |
| `buildSrc/src/main/groovy/shared-*.gradle` | Actual build logic |

## Tips

- Keep common code vanilla-only (no loader APIs)
- Use Service Provider pattern for platform-specific code
- Each mod's `gradle.properties` overrides root properties
- Source code structure is up to you (no enforced package names)
- Delete a mod = delete the folder, refresh Gradle

## Troubleshooting

**Mod not appearing?**
- Check directory structure matches: `loader/modname/src/main/...`
- Refresh Gradle

**Build failing?**
- Check `gradle.properties` has required fields (mod_id, mod_name, version)
- Ensure common module exists for each loader module

**Wrong version showing?**
- Check both root and mod-specific `gradle.properties`
- Mod-specific overrides root properties

---

For detailed information, see [MONOREPO_GUIDE.md](MONOREPO_GUIDE.md) and [README.md](README.md)

