// swift-tools-version:5.6

import PackageDescription

let applePlatforms: [Platform] = [
  .iOS,
  .macOS,
  .tvOS,
  .watchOS,
  .macCatalyst,
  .custom("visionos")
]

let package = Package(
  name: "CryptoSwift",
  // Altered for Fernlet (https://github.com/bowman-mw/fernlet): iOS is 26.0 here, not upstream 1.10.0's
  // .v11, so swiftc signs class_ro_t for arm64e. No other line of this package differs from upstream.
  platforms: [
    .macOS(.v10_13), .macCatalyst(.v13), .iOS("26.0"), .tvOS(.v11), .watchOS(.v4), .custom("visionos", versionString: "1.0")
  ],
  products: [
    .library(
      name: "CryptoSwift",
      targets: ["CryptoSwift"]
    )
  ],
  targets: [
    // Keep the privacy manifest out of non-Apple builds so SwiftPM doesn't pull in
    // Foundation just to synthesize a resource bundle accessor.
    .target(name: "CryptoSwiftResources", resources: [.copy("PrivacyInfo.xcprivacy")]),
    .target(
      name: "CryptoSwift",
      dependencies: [
        .target(name: "CryptoSwiftResources", condition: .when(platforms: applePlatforms))
      ]
    ),
    .testTarget(name: "CryptoSwiftTests", dependencies: ["CryptoSwift"])
  ],
  swiftLanguageVersions: [.v5]
)
