# Android-OpenJDK-Build

Cross compiled OpenJDK for Android, built with the Android NDK. This fork builds complete JDKs
(not just the JRE) and publishes them all to a single GitHub release.

## Downloading

Every build is uploaded to one rolling release:

https://github.com/lovelisy/Android-OpenJDK-Build/releases/tag/android-jdk

The tag `android-jdk` is reused on every run, so the link never changes and the assets are
overwritten with the newest build.

Each archive is a `.tar.xz` containing a complete JDK:

```
bin/javac  bin/java  jmods/  include/  lib/modules  release
```

Extract it with an xz aware tool. On Android the file is not a zip, and file managers that
assume zip will fail with `invalid stored block lengths`:

```bash
pkg install xz-utils tar
tar xJf jdk21-arm64-*.tar.xz
```

Note the capital `J`, which means xz.

## Supported versions

| JDK | Branch | aarch64 | aarch32 | x86 | x86_64 |
|---|---|---|---|---|---|
| 8 | `Build_JRE_8` | yes | yes | yes | yes |
| 11 | `Build_JRE_11` | yes | yes | yes | yes |
| 17 | `Build_JRE_17` | yes | yes | yes | yes |
| 21 | `Build_JRE_21.0.12.1` | yes | yes | yes | yes |
| 25 | `Build_JRE_25` | yes | yes | no | yes |

`Build_JRE_21` is an older 21 branch kept for history; use `Build_JRE_21.0.12.1`.

## Building everything at once

The workflow on `main` builds every version and architecture and publishes the result.

Run it from the Actions tab, or from the API:

```bash
curl -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/lovelisy/Android-OpenJDK-Build/actions/workflows/build.yml/dispatches \
  -d '{"ref":"main","inputs":{"versions":"8 11 17 21 25","archs":"aarch64 aarch32 x86_64 x86","publish":"true"}}'
```

| Input | Default | Meaning |
|---|---|---|
| `versions` | `8 11 17 21 25` | Space separated list of JDK versions |
| `archs` | `aarch64 aarch32 x86_64 x86` | Space separated list of architectures |
| `publish` | `true` | Create or update the release |

The run fans out into one job per version and architecture, so the full set is about 19 jobs.
Narrow `versions` or `archs` to cut build time and storage.

## Building one version

Each `Build_JRE_*` branch has its own workflow and its own scripts. Check out that branch and
see its README.

## Limits

These are headless builds. `--enable-headless-only=yes` is passed to `configure`, so there is
no AWT/Swing or X11 backend:

- console programs, `javac`, `jar`, `jlink`: work
- Swing/AWT windows, JCEF, anything needing a display: do not work

The archives are built for Android (bionic) and only run there, not on desktop Linux.

## References

- http://openjdk.java.net/projects/mobile/android.html
- https://github.com/PojavLauncherTeam/android-openjdk-build-multiarch
