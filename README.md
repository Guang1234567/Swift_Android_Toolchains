# Swift-Android-Toolchains

Only for >= MacOS 10.14.x,

Not working on Windows Host!!! 

## English

The newest ( >= swift 5.1) cross-toolchain for using `apple swift lang` to dev `android ndk app`.


## Chinese

使用 `swift` 去开发 `android ndk app` 需要一个交叉编译链.
此项目提供比较新的交叉编译链 ( >= swift 5.1).

## Dependency

-  ndk r20b   (must !!!)
-  android studio 3.5  (must !!!)

## Sample

[swift-android-architecture](https://github.com/Guang1234567/swift-android-architecture)

set 

```bash
swift-android.dir=/Users/XXX/dev_kit/sdk/swift_source/swift-android-5.1-dev
```
in `local.properies` file.


## Comand Line

cd your swift project, then type :

```ruby
~/dev_kit/sdk/swift_source/swift-android-5.1-dev/build-tools/1.9.6-swift5/swift-build --configuration debug -Xswiftc -DDEBUG -Xswiftc -g -v
```
