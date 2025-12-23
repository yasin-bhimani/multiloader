@echo off
REM Script to create a new mod in the monorepo
REM Usage: create-mod.bat <modname>

if "%1"=="" (
    echo Usage: create-mod.bat ^<modname^>
    echo Example: create-mod.bat awesomemod
    exit /b 1
)

set MOD_NAME=%1
set MOD_NAME_LOWER=%MOD_NAME%
REM Convert to lowercase (simple method for Windows)
for %%i in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do call set MOD_NAME_LOWER=%%MOD_NAME_LOWER:%%i=%%i%%

echo Creating new mod: %MOD_NAME%
echo Mod ID will be: %MOD_NAME_LOWER%

REM Create directory structure
echo Creating directory structure...

mkdir "common\%MOD_NAME_LOWER%\src\main\java" 2>nul
mkdir "common\%MOD_NAME_LOWER%\src\main\resources" 2>nul

mkdir "fabric\%MOD_NAME_LOWER%\src\main\java" 2>nul
mkdir "fabric\%MOD_NAME_LOWER%\src\main\resources" 2>nul

mkdir "forge\%MOD_NAME_LOWER%\src\main\java" 2>nul
mkdir "forge\%MOD_NAME_LOWER%\src\main\resources" 2>nul

mkdir "neoforge\%MOD_NAME_LOWER%\src\main\java" 2>nul
mkdir "neoforge\%MOD_NAME_LOWER%\src\main\resources" 2>nul

REM Create common gradle.properties
echo Creating gradle.properties files...

(
echo # Mod-specific properties for %MOD_NAME%
echo # These override the global properties from the root gradle.properties
echo.
echo mod_id=%MOD_NAME_LOWER%
echo mod_name=%MOD_NAME%
echo version=0.1.0
echo description=An awesome Minecraft mod!
) > "common\%MOD_NAME_LOWER%\gradle.properties"

REM Create loader-specific gradle.properties
for %%L in (fabric forge neoforge) do (
    (
    echo # Mod-specific properties for %MOD_NAME% ^(%%L^)
    echo # Inherits from common/%MOD_NAME_LOWER%/gradle.properties
    echo.
    echo mod_id=%MOD_NAME_LOWER%
    echo mod_name=%MOD_NAME%
    echo version=0.1.0
    ) > "%%L\%MOD_NAME_LOWER%\gradle.properties"
)

echo.
echo ✅ Mod structure created successfully!
echo.
echo Next steps:
echo 1. Edit common\%MOD_NAME_LOWER%\gradle.properties with your mod details
echo 2. Add your source code to the src\main\java directories
echo 3. Refresh Gradle in your IDE
echo 4. Run configurations will appear automatically!
echo.
echo Directory structure:
echo ├── common\%MOD_NAME_LOWER%\    (shared code)
echo ├── fabric\%MOD_NAME_LOWER%\    (fabric-specific)
echo ├── forge\%MOD_NAME_LOWER%\     (forge-specific)
echo └── neoforge\%MOD_NAME_LOWER%\  (neoforge-specific)

