# Nearby Messages

Allow your users to find nearby devices and share messages in a way that’s as
frictionless as a conversation. This enables rich interactions such as as
collaborative editing, forming a group, voting, or broadcasting a resource.

The Nearby Messages API is available for Android and iOS, allowing for
seamless cross-platform experiences.

## Usage

### Creating a Message Manager

This code creates a message manager object, which lets you publish and
subscribe.  Message exchange is unauthenticated, so you will need to supply a
public API key for iOS.  You can create one using the [developer console]
(https://console.developers.google.com/) entry for your project.

```objective-c
GNSMessageManager *messageManager =
    [[GNSMessageManager alloc] initWithAPIKey:@"<insert API key here>"];
```

### Publishing a Message

This code publishes a message containing your name.  The publication is
active as long as the publication object exists; release it to stop publishing.

```objective-c
id<GNSPublication> publication =
    [messageManager publicationWithMessage:[GNSMessage messageWithContent:[myName dataUsingEncoding:NSUTF8StringEncoding]]];
```

### Subscribing for Messages

This code subscribes to names shared by the above publication.
The subscription is active as long as the subscription objects exists; release
it to stop subscribing.

The message found handler is called when nearby devices that are publishing
names are discovered nearby.  The message lost handler is called when a
published name is no longer observed (because the device has gone out of
range or is no longer publishing the name).

```objective-c
id<GNSSubscription> subscription =
    [messageManager subscriptionWithMessageFoundHandler:^(GNSMessage *message) {
      // Add the name to a list for display
    }
    messageLostHandler:^(GNSMessage *message) {
      // Remove the name from the list
    }];
```

### Tracking the Nearby permission state

The user must give permission before device discovery will work.  This is called
the permission state.

On the first call to create a publication or subscription, a permission consent
dialog will be automatically displayed, and the user can approve or deny.  If
the user approves, all is well.  If the user denies, device discovery will not
work.  In this case, your app should show a message in the UI to remind the user
why it’s not working.  The permission state is stored in NSUserDefaults.

Your app can subscribe to the permission state in order to keep its UI in sync.
Here’s how:

```objective-c
_nearbyPermission = [[GNSPermission alloc] initWithChangedHandler:^(BOOL granted) {
  // Update the UI here
}];
```

You may want to provide a way for the user to change the permission state; for
example, using a toggle switch on a settings page.  Here’s an example of how it
can get and set the permission state.

Note: The app should set the permission state only in response to the user
action of toggling it on or off in the UI.

```objective-c
BOOL permissionState = [GNSPermission isGranted];
[GNSPermission setGranted:!permissionState];  // toggle the state
```

### Tracking user settings that affect Nearby

If the user has denied microphone permission or has turned Bluetooth off, Nearby
will not work as well, or may not work at all.  Your app should show a message
in these cases, alerting the user that Nearby’s operations are being hindered.
You can track the status of these user settings by passing in handlers when you
create the message manager.  Here’s how:

```objective-c
GNSMessageManager *messageManager = [[GNSMessageManager alloc]
    initWithAPIKey:kMyAPIKey
       paramsBlock:^(GNSMessageManagerParams *params) {
         params.microphonePermissionErrorHandler = ^(BOOL hasError) {
           // Update the UI here
         };
         params.bluetoothPowerErrorHandler = ^(BOOL hasError) {
           // Update the UI here
         };
}];
```

### Scanning for Beacons

Nearby Messages supports scanning for both Eddystone and iBeacons. But because
iBeacon scanning causes iOS to ask for permission to track the user's location,
it is disabled by default.  You can subscribe for beacons by enabling
beacon scanning and passing a namespace and type into the subscription
parameters. Here’s an example:

```objective-c
_beaconSubscription = [_messageManager
    subscriptionWithMessageFoundHandler:myMessageFoundHandler
                     messageLostHandler:myMessageLostHandler
                            paramsBlock:^(GNSSubscriptionParams *params) {
                              params.deviceTypesToDiscover = kGNSDeviceBLEBeacon;
                              params.messageNamespace = @"com.mycompany.mybeaconservice";
                              params.type = @"mybeacontype";
                            }];
```

Your app's Info.plist should include the NSLocationAlwaysUsageDescription key
with short explanation of why location is being used.  See [Apple's
documentation]
(https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW18)
for details.

### Controlling the Mediums used for Discovery

By default, all mediums (audio and Bluetooth) are used for discovery of nearby
devices.  In some cases, your app may need to use only one of the mediums, and
it may not need to do both broadcasting and scanning on that medium.

For instance, an app that is designed to connect to a set-top box that’s
broadcasting on audio only needs to scan on audio to discover it.  Here’s how
the app can publish a message to that set-top box using only audio scanning for
discovery:

```objective-c
_publication = [_messageManager publicationWithMessage:message
    paramsBlock:^(GNSPublicationParams *params) {
      params.strategy = [GNSStrategy strategyWithParamsBlock:^(GNSStrategyParams *params) {
        params.discoveryMediums = kGNSDiscoveryMediumsAudio;
        params.discoveryMode = kGNSDiscoveryModeScan;
      }];
    }];
```

### Enabling Debug Logging

Debug logging can be useful for tracking down problems that you may encounter
when integrating Nearby Messages into your app.  It logs significant internal
events that can help us debug most problems.  To enable debug logging:

```objective-c
[GNSMessageManager setDebugLoggingEnabled:YES];
```

## Installation

[CocoaPods](http://cocoapods.org/) is the recommended installation method.  Add
the following line to your project's Podfile:

```ruby
pod 'NearbyMessages'
```

## License

See the [Nearby](https://developers.google.com/nearby) developer site for license details.
