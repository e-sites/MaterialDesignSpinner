// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "MaterialDesignSpinner",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(name: "MaterialDesignSpinner", targets: ["MaterialDesignSpinner"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MaterialDesignSpinner",
            dependencies: [
            ],
            path: "Sources"
        )
    ],
    swiftLanguageVersions: [ .v5 ]
)
