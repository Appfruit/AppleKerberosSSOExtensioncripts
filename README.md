# AppleKerberosSSOExtensioncripts
This script is based on the Apple example published in their Apple Kerberos SSO Extension guide.

The script *DistributedNotificationListener.swift* must be called with the following arguments.

| Name | Value |
| --- | --- |
| **-notification** | Name of the distributed notification |
| **-action** | Path to the script to execute if the notification is detected. |

**Example**

```DistributedNotificationListener.swift -notification com.apple.KerberosPlugin.ConnectionCompleted /tmp/myExampleScript.sh```

#### Distributed Notifications
Defines the Distributed Notification the script should listen. Under macOS all applications can send distributed notifications, however it is mostly unclear how they are named. here a list of known notifications.

| Notification | Application | Description |
| --- | --- | --- |
| com.apple.KerberosPlugin.ConnectionCompleted | Apple Kerberos Extension | The Kerberos SSO extension has run its connection process. |
| com.apple.KerberosPlugin.ADPasswordChanged | Apple Kerberos Extension | The user has changed the Active Directory password with the extension. |
| com.apple.KerberosPlugin.LocalPasswordSynced | Apple Kerberos Extension | The user has brought the Active Directory and local passwords in sync. |
| com.apple.KerberosPlugin.InternalNetworkAvailable | Apple Kerberos Extension | The user has connected to a network where the configured Active Directory domain is available. |
| com.apple.KerberosPlugin.InternalNetworkNotAvailable | Apple Kerberos Extension | The user has connected to a network where the configured Active Directory domain is not available. |
| com.apple.KerberosExtension.gotNewCredential | Apple Kerberos Extension | The user has acquired a new Kerberos TGT. |
| com.apple.KerberosExtension.passwordChangedWithPasswordSync | Apple Kerberos Extension | The user has changed the Active Directory password, and the local password has been updated to match the new Active Directory password. |

### LaunchAgent or LaunchDaemon
TO run this script as as a logged-in-user (LaunchAgent) or as root (LaunchDaemon) we can deploy the following plist file.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <true/>
    <key>Label</key>
    <string>ch.appfruit.DistributedNotificationListener.example</string>
    <key>RunAtLoad</key>
    <true/>
    <key>ProgramArguments</key>
    <array>
      <string>/Library/Application Support/Appfruit/DistributedNotificationListener/DistributedNotificationListener.swift</string>
        <string>-notification</string>
        <string><!-- Enter Distributed Notification name --></string>
        <string>-action</string>
        <string><!-- Enter path to script --></string>
      </array>
  </dict>
</plist>
```

### Installer
The installer only deploys the script, you need to modify it according to your needs to deploy LaunchAgents, LaunchDaemons and your scripts.