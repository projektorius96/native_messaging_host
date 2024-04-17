# Project name: native_messaging_host (NMH)

> **NOTE**: The codebase is Windows-users oriented !

### Prerequisites

- Set up the native messaging host on your local machine referring to [specification](https://developer.chrome.com/docs/extensions/develop/concepts/native-messaging#native-messaging-host) that describes how to do that;
- Load the extension on Chromium-based browser of choice, the extension can be found at `./nmh-extension--unpacked/`;

### Build your executable

> Before running the command it assumes your current working directory is `native_messaging_host` on your active terminal (_I use Git Bash for Windows_), then simply <br>
`dart compile exe ./bin/main.dart -o ./bin/main.exe`

### Test the NMH

1. Click on your extension icon pinned to your toolbar
2. Open the extension service worker console and expect the following output as shown in Figure 1 below: 
![Figure 1](./nmh-extension--unpacked/output.png)
3. Build something incredible with Dart and JavaScript (Chrome Extensions), respecting the stdio limitations as described per the [specification](https://developer.chrome.com/docs/extensions/develop/concepts/native-messaging#native-messaging-host)
---

Made with ♥ by [projektorius96](https://github.com/projektorius96)
