# MultiLoader Minecraft Mods Monorepo

A monorepo template for developing multiple Minecraft mods that compile for **Fabric**, **Forge**, and **NeoForge** using shared build configurations and a common codebase.

## 🌟 What Makes This Special?

This isn't just a MultiLoader template - it's a **monorepo** that lets you manage multiple mods efficiently:

- **Loader-First Organization**: Each loader (common, fabric, forge, neoforge) contains multiple mod subprojects
- **Shared Build Logic**: Write build configuration once, use it for all your mods
- **Zero Configuration Overhead**: Adding a new mod requires just creating folders and a simple properties file
- **Automatic Discovery**: New mods are automatically detected by Gradle
- **Independent Execution**: Each mod gets its own run directories and IDE configurations

## 📁 Project Structure

```
multiloader-mods-mc/
├── common/              # Shared code for all mods (vanilla Minecraft only)
│   ├── examplemod/
│   ├── anothermod/
│   └── build.gradle     # Shared config for all common subprojects
├── fabric/              # Fabric-specific implementations
│   ├── examplemod/
│   ├── anothermod/
│   └── build.gradle     # Shared config for all fabric subprojects
├── forge/               # Forge-specific implementations
│   ├── examplemod/
│   └── build.gradle
├── neoforge/            # NeoForge-specific implementations
│   ├── examplemod/
│   └── build.gradle
├── buildSrc/            # Custom Gradle plugins
├── gradle.properties    # Global settings (MC version, loader versions)
└── settings.gradle      # Automatic subproject discovery
```

## 🚀 Quick Start

### Prerequisites

- **Java 21** JDK
- **IntelliJ IDEA** (recommended) or another IDE with Gradle support

### Setup

1. **Clone this repository**

   ```bash
   git clone <your-repo-url>
   cd multiloader-mods-mc
   ```

2. **Open in IntelliJ IDEA**

   - File → Open → Select the root folder
   - If asked about trust, trust the project

3. **Configure Java**

   - Go to File → Project Structure → Project SDK → Select Java 21
   - Go to File → Settings → Build, Execution, Deployment → Build Tools → Gradle
   - Set "Gradle JVM" to Java 21

4. **Refresh Gradle**

   - Click the Gradle refresh button in the Gradle panel
   - All mods will be automatically discovered

5. **Run a mod**
   - Run configurations will appear automatically
   - Select "Fabric Client - examplemod" or any other configuration
   - Click Run!

## ✨ Creating a New Mod

### Option 1: Using the Script (Recommended)

**Linux/Mac:**

```bash
./create-mod.sh coolmod
```

**Windows:**

```batch
create-mod.bat coolmod
```

This automatically creates the complete structure!

### Option 2: Manual Creation

1. **Create directories:**

   ```bash
   mkdir -p common/coolmod/src/main/{java,resources}
   mkdir -p fabric/coolmod/src/main/{java,resources}
   mkdir -p forge/coolmod/src/main/{java,resources}
   mkdir -p neoforge/coolmod/src/main/{java,resources}
   ```

2. **Create `common/coolmod/gradle.properties`:**

   ```properties
   mod_id=coolmod
   mod_name=Cool Mod
   mod_author=YourName
   version=1.0.0
   description=A cool Minecraft mod
   ```

3. **Create `gradle.properties` in fabric/forge/neoforge:**

   ```properties
   mod_id=coolmod
   mod_name=Cool Mod
   version=1.0.0
   ```

4. **Refresh Gradle** - Your mod is ready!

## 🎮 Working with Mods

### Running Mods

Each mod has separate run configurations:

- **Fabric**: `Fabric Client - modname`, `Fabric Server - modname`
- **Forge**: `Client - modname`, `Server - modname`, `Data - modname`
- **NeoForge**: `NeoForge Client - modname`, `NeoForge Server - modname`

### Building Mods

```bash
# Build everything
./gradlew build

# Build specific mod for all loaders
./gradlew :common:mymod:build :fabric:mymod:build :forge:mymod:build :neoforge:mymod:build

# Build specific mod for one loader
./gradlew :fabric:mymod:build
```

### Testing Mods

Run configurations are isolated per mod with separate run directories:

```
runs/
├── examplemod/
│   ├── client/
│   └── server/
└── coolmod/
    ├── client/
    └── server/
```

## 🛠️ Configuration

### Global Configuration (`gradle.properties` in root)

Applies to **ALL** mods:

- `minecraft_version` - Minecraft version
- `fabric_version`, `forge_version`, `neoforge_version` - Loader versions
- `java_version` - Java version
- `parchment_minecraft`, `parchment_version` - Mapping versions

### Per-Mod Configuration

Each mod's `gradle.properties` (in `common/modname/`, `fabric/modname/`, etc.):

- `mod_id` - Unique identifier (required)
- `mod_name` - Display name (required)
- `mod_author` - Your name
- `version` - Mod version
- `description` - Mod description

## 📚 Development Guidelines

### Common Module (`common/modname/`)

✅ **Use for:**

- Shared game logic across all loaders
- Vanilla Minecraft APIs only
- Service provider interfaces for platform abstraction
- Common mixins

❌ **Avoid:**

- Loader-specific APIs (Fabric API, Forge events, etc.)
- Direct references to mod loaders

### Loader Modules (`fabric/modname/`, `forge/modname/`, `neoforge/modname/`)

✅ **Use for:**

- Mod entry points and initialization
- Service provider implementations
- Loader-specific event handlers
- Loader-specific mixins

### Service Provider Pattern

For calling loader-specific code from common code:

1. **Define interface in common** (`common/mymod/src/.../IPlatformHelper.java`)
2. **Implement in each loader** (`fabric/mymod/src/.../FabricPlatformHelper.java`)
3. **Register service** (`META-INF/services/com.example.IPlatformHelper`)

See existing `examplemod` for a complete example!

## 📖 Documentation

- **[MONOREPO_GUIDE.md](MONOREPO_GUIDE.md)** - Detailed guide on using this monorepo
- **[Fabric Wiki](https://fabricmc.net/wiki/)**
- **[Forge Docs](https://docs.minecraftforge.net/)**
- **[NeoForge Docs](https://docs.neoforged.net/)**

## 🎯 Current Versions

- **Minecraft**: 1.21.11
- **Java**: 21
- **Fabric Loader**: 0.18.2
- **Fabric API**: 0.139.5+1.21.11
- **Forge**: 61.0.1
- **NeoForge**: 21.11.3-beta

## 🔧 Troubleshooting

**"Cannot find project ':common:mymod'"**

- Make sure the directory structure exists
- Refresh Gradle

**"Java version mismatch"**

- Ensure Project SDK and Gradle JVM are both set to Java 21

**"Run configuration not appearing"**

- Refresh Gradle
- Check that `src/` directories exist in the mod folders

## 🤝 Contributing to This Monorepo

When adding new mods:

1. Follow the naming conventions (lowercase for mod IDs)
2. Keep common code truly common (vanilla APIs only)
3. Test on all three loaders before committing
4. Update your mod's version in `gradle.properties`

## 📄 License

This template is released under [CC0-1.0](LICENSE). Your mods can use any license you choose.

## 🙏 Credits

Based on the [MultiLoader Template](https://github.com/jaredlll08/MultiLoader-Template) by Jared.

---

**Happy Modding! 🎮✨**

_Need help? Check out [MONOREPO_GUIDE.md](MONOREPO_GUIDE.md) for detailed documentation._
