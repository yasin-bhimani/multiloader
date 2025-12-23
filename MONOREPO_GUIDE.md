# MultiLoader Monorepo for Minecraft Mods

This is a monorepo for managing multiple Minecraft mods that compile for multiple modloaders (Fabric, Forge, and NeoForge) using shared build configurations.

## 🏗️ Project Structure

```
multiloader-mods-mc/
├── common/                    # Common code (vanilla Minecraft only)
│   ├── examplemod/           # Example mod common code
│   │   ├── src/
│   │   └── gradle.properties # Mod-specific properties
│   ├── anothermod/           # Another mod
│   │   ├── src/
│   │   └── gradle.properties
│   └── build.gradle          # Shared config for all common subprojects
├── fabric/                   # Fabric loader implementations
│   ├── examplemod/
│   │   ├── src/
│   │   └── gradle.properties
│   ├── anothermod/
│   │   ├── src/
│   │   └── gradle.properties
│   └── build.gradle          # Shared config for all fabric subprojects
├── forge/                    # Forge loader implementations
│   ├── examplemod/
│   │   ├── src/
│   │   └── gradle.properties
│   └── build.gradle          # Shared config for all forge subprojects
├── neoforge/                 # NeoForge loader implementations
│   ├── examplemod/
│   │   ├── src/
│   │   └── gradle.properties
│   └── build.gradle          # Shared config for all neoforge subprojects
├── buildSrc/                 # Shared Gradle plugins
├── gradle.properties         # Global properties (MC version, loader versions, etc)
└── settings.gradle           # Automatic subproject discovery
```

## ✨ Key Features

1. **Loader-First Organization**: Each loader (common, fabric, forge, neoforge) contains multiple mod subprojects
2. **Shared Build Logic**: Each loader has a single `build.gradle` that all its mods inherit from
3. **Automatic Discovery**: New mods are automatically detected - just create the folders!
4. **Minimal Configuration**: Each mod only needs a simple `gradle.properties` file
5. **Independent Run Configs**: Each mod gets its own run directories and IDE configurations

## 🚀 Getting Started

### Prerequisites

- Java 21 JDK
- IntelliJ IDEA (recommended) or another IDE

### Setup

1. Clone this repository
2. Open the root folder in IntelliJ IDEA
3. Set Project SDK and Gradle JVM to Java 21
4. Refresh Gradle (the projects will be auto-discovered)
5. Run configurations will appear automatically for each mod

## 📦 Adding a New Mod

### Step 1: Create Directory Structure

Create directories for your new mod under each loader:

```bash
mkdir -p common/mymod/src/main/java
mkdir -p common/mymod/src/main/resources
mkdir -p fabric/mymod/src/main/java
mkdir -p fabric/mymod/src/main/resources
mkdir -p forge/mymod/src/main/java
mkdir -p forge/mymod/src/main/resources
mkdir -p neoforge/mymod/src/main/java
mkdir -p neoforge/mymod/src/main/resources
```

### Step 2: Create Mod Properties

Create `common/mymod/gradle.properties`:

```properties
# Mod-specific properties
mod_id=mymod
mod_name=My Awesome Mod
version=0.1.0
description=An awesome mod that does amazing things!
```

Create similar `gradle.properties` files in `fabric/mymod/`, `forge/mymod/`, and `neoforge/mymod/` with just:

```properties
mod_id=mymod
mod_name=My Awesome Mod
version=0.1.0
```

**Note:** `mod_author` is set globally in the root `gradle.properties` as "Strange Quark" and doesn't need to be specified per-mod unless you want to override it.

### Step 3: Add Source Code

Follow the MultiLoader pattern:

**Common** (`common/mymod/src/main/java/com/yourname/mymod/`):

- Put shared code here
- Only use vanilla Minecraft APIs
- Use the Service Provider pattern for loader-specific functionality

**Loader-Specific** (`fabric/mymod/`, `forge/mymod/`, `neoforge/mymod/`):

- Entry point classes (implements loader-specific initialization)
- Platform-specific implementations
- Loader-specific mixins

### Step 4: Refresh Gradle

In IntelliJ IDEA, click the Gradle refresh button. Your new mod will be automatically discovered and configured!

## 🎮 Running Mods

Each mod has its own run configurations:

- **Fabric**: `Fabric Client - mymod`, `Fabric Server - mymod`
- **Forge**: `Client - mymod`, `Server - mymod`, `Data - mymod`
- **NeoForge**: `NeoForge Client - mymod`, `NeoForge Server - mymod`, `NeoForge Data - mymod`

Run directories are separated per mod: `runs/mymod/client`, `runs/mymod/server`, etc.

## 🔧 Building Mods

Build all mods:

```bash
./gradlew build
```

Build a specific mod for all loaders:

```bash
./gradlew :common:mymod:build :fabric:mymod:build :forge:mymod:build :neoforge:mymod:build
```

Build a specific mod for one loader:

```bash
./gradlew :fabric:mymod:build
```

## 📝 Configuration Guide

### Global Configuration (`gradle.properties`)

These properties apply to ALL mods:

- Minecraft version
- Loader versions (Fabric, Forge, NeoForge)
- Java version
- Parchment mappings

### Mod-Specific Configuration

Each mod's `gradle.properties` can override:

- `mod_id` - Unique mod identifier
- `mod_name` - Display name
- `mod_author` - Your name
- `version` - Mod version
- `description` - Mod description

### Shared Build Configuration

Each loader's `build.gradle` (`common/build.gradle`, `fabric/build.gradle`, etc.) contains:

- Plugin configuration
- Dependency setup
- Run configuration templates
- Task configurations

**You rarely need to modify these!** They work for all mods automatically.

## 🎯 Project Layout Guidelines

### Common Module (`common/`)

✅ **DO**:

- Shared game logic
- Vanilla Minecraft APIs
- Service provider interfaces
- Common mixins

❌ **DON'T**:

- Loader-specific APIs
- Loader-specific events
- Direct references to Fabric/Forge/NeoForge

### Loader Modules (`fabric/`, `forge/`, `neoforge/`)

✅ **DO**:

- Mod entry points
- Service provider implementations
- Loader-specific event handlers
- Loader-specific mixins

## 🔗 Dependencies Between Mods

Each loader-specific module automatically depends on its corresponding common module:

- `:fabric:mymod` depends on `:common:mymod`
- `:forge:mymod` depends on `:common:mymod`
- `:neoforge:mymod` depends on `:common:mymod`

To add inter-mod dependencies, edit the specific loader's shared `build.gradle`.

## 🛠️ Advanced: Removing a Loader

To stop supporting a loader (e.g., Forge) for all mods:

1. Delete the loader directory (e.g., `forge/`)
2. Remove it from `settings.gradle` in the `loaders` list
3. Refresh Gradle

## 📚 Example: Service Provider Pattern

This pattern lets common code call loader-specific code.

**Common** (`common/mymod/src/.../IPlatformHelper.java`):

```java
public interface IPlatformHelper {
    String getPlatformName();
}
```

**Fabric** (`fabric/mymod/src/.../FabricPlatformHelper.java`):

```java
public class FabricPlatformHelper implements IPlatformHelper {
    @Override
    public String getPlatformName() {
        return "Fabric";
    }
}
```

**Fabric** (`fabric/mymod/src/main/resources/META-INF/services/com.yourname.mymod.IPlatformHelper`):

```
com.yourname.mymod.platform.FabricPlatformHelper
```

Repeat for Forge and NeoForge!

## 📖 Additional Resources

- [Fabric Wiki](https://fabricmc.net/wiki/)
- [Forge Documentation](https://docs.minecraftforge.net/)
- [NeoForge Documentation](https://docs.neoforged.net/)

## 🤝 Contributing

When adding new mods to this monorepo:

1. Follow the naming conventions
2. Keep common code truly common (vanilla only)
3. Document any special dependencies
4. Test on all supported loaders

---

**Happy Modding! 🎮✨**
