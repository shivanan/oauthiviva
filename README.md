# oauthiviva

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

cd C:\Users\ACER\AppData\Local\Android\Sdk\emulator
emulator -writable-system -netdelay none -netspeed full -avd Nexus61

adb root
adb shell avbctl disable-verification  <--- this will not freeze the emulator
adb reboot
adb remount
adb pull /system/etc/hosts

10.0.2.2 example.com

adb push ./hosts /etc/hosts
adb push ./hosts /etc/system/hosts
adb push ./hosts /system/etc/hosts