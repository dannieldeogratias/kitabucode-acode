# KitabuCode (Acode-based)

Android programming editor based on Acode, with the owner's blue book-and-K logo. Application ID: `com.kitabucode.editor`.

## Included offline

HTML/CSS preview and JavaScript/TypeScript editor services are included. The APK build prepares Python 3, pip, Python language-server completion/diagnostics, Node.js, npm, Git, C/C++ tools and OpenJDK 21 for x86-64 and ARM64 (64-bit devices). First terminal use extracts the bundled environment; it does not download packages. Extra third-party project dependencies and optional language servers may still require separate installation.

The runtime package list, licence metadata and Alpine source link are included under `/usr/share/kitabucode` inside the terminal environment.

## Build and testing

Use **KitabuCode APK** in GitHub Actions on `codex/acode-migration`. Download the `KitabuCode-debug` artifact. This is a development APK, not a store release. The workflow prepares runtime assets before the Cordova build; a bare local build does not run that preparation.

The 16 KB x86-64 Android 17 emulator currently crashes in the upstream PRoot runtime. Compatibility on that image is not verified. Use a standard 4 KB image for validation while this is investigated.

## Attribution

Based on https://github.com/Acode-Foundation/Acode. The original MIT copyright and licence are retained in license.txt. Native runtime components, plugins and downloaded packages retain their own licences. KitabuCode branding was supplied and authorised by the project owner.
