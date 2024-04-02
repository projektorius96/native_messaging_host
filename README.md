# Project name: native_messaging_host (Windows users)

[specification](<(https://developer.chrome.com/docs/extensions/develop/concepts/native-messaging#native-messaging-host)>)

### Prerequisites

1.  The following environment variable appened to system-wide PATH as follows:

```
    %LOCALAPPDATA%\Pub\Cache\bin
```

1.  pubspec.yaml must contain:

```
executables:
  native_messaging_host: main
```

1.  The following considers that your current working directory (cwd) on active terminal dialog is the `native_messaging_host`, then run the following command:

```
dart pub global activate --source path . # dot (literal period) stands for cwd whereas the "cwd", as in our specific case, is the package name of "native_messaging_host"
```

1.  Sadly, official Dart docs for Windows does not clearly state that we have to suffix our `native_messaging_host` with `.bat` format i.e. `native_messaging_host.bat` when calling from command line anywhere in the system. Quite frankly, this was a coincidental discovery. _As far as I do understand, without following step 1 above, we could still run the_ `_native_messaging_host.bat_`_, but when we should run it with the following command as follows_:

```
dart pub global run native_messaging_host.bat # effectively step 1 above aliases the command "dart pub global run" for specific case of running native_messaging_host as native application, even yet the application has not even been compiled (ahead of time) in real life;
```

---

Made with ♥ by [projektorius96](https://github.com/projektorius96)
