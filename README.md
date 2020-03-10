# Primitive Realm Platform showcase app

Swift 5.1 | Xcode 11.3.1 | Carthage 0.34.0

### Bootstrap

To check the app you need to do a setup:

#### 1) Install dependencies:
```
carthage bootstrap --platform iOS --no-use-binaries
```

#### 2) Create a realm server instance
Go to https://realm.io/products/realm-platform, log in / sign up and create new realm instance. You will get a realm instance URL that you need to specify in code. To do that, add a new file called `RealmInstanceAddress.swift` to `RealmPlatformTryout/Environment/` and define your real instance domain name, like following:
```
let realmInstanceAddress = "for-example.us1.cloud.realm.io"
```

On https://cloud.realm.io/instances open your realm instance in Realm Studio. On tab "Users" create two users:
1. Username: `admin` Password: `admin`. Set Role to Administrator.
2. Username: `guest` Password: `guest`
On tab "Realms" create new realm called "public".

Next, open file `RealmPlatformTryout/Realm/LoginAPI.swift` and uncomment lines:
```
//        configurePublicRealm()
//        return .never()
```
Now run the app and wait until text "public realm configured" appears in the console. Stop the app.

Finally, comment "configurePublicRealm()" and "return .never()" back and run the app.
