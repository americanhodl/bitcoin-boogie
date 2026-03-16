# Bitcoin Boogie - Android App

Stack sats or die trying.

## Prerequisites

- **Android Studio** (latest stable) — download from https://developer.android.com/studio
- **Java 17+** — usually bundled with Android Studio

## Build the APK

### Option 1: Android Studio (easiest)

1. Open Android Studio
2. File → Open → select the `bitcoin-boogie-android` folder
3. Wait for Gradle sync to finish (may take a few minutes first time)
4. Build → Build Bundle(s) / APK(s) → Build APK(s)
5. APK will be at: `app/build/outputs/apk/debug/app-debug.apk`

For a signed release APK:
1. Build → Generate Signed Bundle / APK
2. Select APK
3. Create a new keystore — **save this keystore file!** You need it for every future
   update AND for Zapstore certificate linking
4. Build
5. Release APK at: `app/build/outputs/apk/release/app-release.apk`

### Option 2: Command line

```bash
# Debug build
./gradlew assembleDebug

# Release build
./gradlew assembleRelease
```

## Test on your phone

```bash
# Connect phone via USB with developer mode enabled
adb install app/build/outputs/apk/debug/app-debug.apk
```

Or transfer the .apk file to your phone and tap to install.

---

## Publish to Zapstore

### Step 1: Get a Nostr keypair

If you don't have one, create one with any Nostr client (Damus, Primal, Amethyst, etc.).
You'll need your nsec (private key) for signing releases.

### Step 2: Push this project to GitHub

Create a repo (e.g. `github.com/yourusername/bitcoin-boogie`) and push this project.
Zapstore verifies developers by checking your repo, so this is important.

### Step 3: Install zsp

```bash
# Option A: Go install
go install github.com/zapstore/zsp@latest

# Option B: Download binary from
# https://github.com/zapstore/zsp/releases
```

### Step 4: Run the wizard

```bash
zsp publish --wizard
```

The wizard walks you through:
- **Source selection** — point it to your GitHub repo
- **Metadata** — app name, description, icon, screenshots
- **Signing** — signs the release with your Nostr key
- **Certificate linking** — links your APK signing keystore to your Nostr identity
  (one-time step, have your .jks keystore file ready). This creates a cryptographic
  proof (NIP-C1) that you control the key that signs your app.
- **Publish** — pushes to Zapstore relays

The wizard creates a `zapstore.yaml` in your repo root. **Commit this file.**

### Step 5: Get whitelisted

The first time you publish:

1. The wizard writes `zapstore.yaml` with your repo URL and npub to your repo root
2. **Commit and push** `zapstore.yaml` to your GitHub repo
3. Publish — the Zapstore relay fetches `zapstore.yaml` from your repo, verifies the
   pubkey matches, and whitelists you
4. All future publishes pass immediately

If your Nostr identity already has social reputation (followers, activity), you may be
whitelisted automatically via the Vertex reputation system.

### Step 6: Set up Lightning payments

Add a Lightning address to your Nostr profile. Users can zap you directly in Zapstore.
You receive 100% of payments — no middleman, no 30% cut.

### Quick publish (after first time)

Once whitelisted, future updates are one command:

```bash
zsp publish -r github.com/yourusername/bitcoin-boogie
```

---

## Project Structure

```
bitcoin-boogie-android/
├── app/
│   ├── src/main/
│   │   ├── assets/
│   │   │   └── index.html              ← The game
│   │   ├── java/.../MainActivity.java   ← WebView wrapper
│   │   ├── AndroidManifest.xml
│   │   └── res/                         ← Icons, themes, strings
│   └── build.gradle                     ← App build config
├── build.gradle                         ← Project build config
├── settings.gradle
├── zapstore.yaml                        ← Created by zsp wizard (commit this!)
└── gradle/                              ← Gradle wrapper
```

## Customizing

- **Update the game**: Edit `app/src/main/assets/index.html`
- **Change app icon**: Replace the vector drawable in `res/drawable/ic_launcher_foreground.xml`
  or use Android Studio's Image Asset tool (right-click res → New → Image Asset)
- **Change app name**: Edit `res/values/strings.xml`
- **Change package ID**: Update `applicationId` in `app/build.gradle` and the package
  in `AndroidManifest.xml` and `MainActivity.java`

## Releasing Updates

1. Update `app/src/main/assets/index.html` with your changes
2. Bump `versionCode` (must increase) and `versionName` in `app/build.gradle`
3. Build signed release APK
4. `zsp publish -r github.com/yourusername/bitcoin-boogie`

That's it. Your users get the update in Zapstore.
