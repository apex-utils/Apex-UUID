# Apex-Utils - UUID

This repository contains a free, open source implementation of the UUIDv4 spec written for Salesforce Apex. This app is provided as-is with no warranty under the (MIT License)[https://opensource.org/licenses/MIT]. See the license file for details.

# Installation

This package can be installed in an unlocked (fully editable) form using the following SF CLI command:

```
sfdx force:package:install -p [package id - see releases page]
```

There is no installation key.

# Contributing

Please feel free to submit a pull request with any changes you recommend.

# Utilization

## Creating a UUIDv4

To create an instance of the UUIDv4 class, use the following code (assumes the unlocked package is installed. If the source is installed directly, omit the namespace)

```apex
uuid.UUIDv4 uuidObj = new uuid.UUIDv4();
```

To access the generated UUID, use the ```toString()``` method

```apex
String uuidStr = uuidObj.toString();
```

To create a UUID instance from a UUID string, use the static ```valueOf(String UUIDString)``` method like so:

```apex
uuid.UUIDv4 newUUID = uuid.UUIDv4.valueOf(uuidStr);
```

## Using UUIDs in sets and maps

UUIDv4 provides impelementations for both hashCode and equals methods, meaning you can safely use UUIDv4 in both sets and maps.
