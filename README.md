# libmpv-macos-autobuild

在 macOS 自动构建 libmpv 动态链接库并导出所有的依赖.

使用脚本 [mpv/ci/build-macos.sh], 但是禁用 vapoursynth, 因为它需要 python.

构建完成后使用 [extract.sh] 导出所有依赖库.
