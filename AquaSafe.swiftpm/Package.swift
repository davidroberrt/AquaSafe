// swift-tools-version: 6.0

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "AquaSafe",
    platforms: [
        .iOS("18.0")
    ],
    products: [
        .iOSApplication(
            name: "AquaSafe",
            targets: ["AppModule"],
            bundleIdentifier: "davidrobert.AquaSafe",
            teamIdentifier: "8FVAA57BW9",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .locationAlwaysAndWhenInUse(purposeString: "We need your location to show the weather and maps."),
                .locationWhenInUse(purposeString: "We need your location to show the weather and location maps."),
                .fileAccess(.pictureFolder, mode: .readWrite),
                .photoLibrary(purposeString: "This application needs to access your photo library so that you can select images.")
            ],
            appCategory: .weather
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ],
    swiftLanguageVersions: [.version("6")]
)