// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "WeekOversight 2025",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "WeekOversight 2025",
            targets: ["WeekOversight 2025"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/CoreXLSX.git", from: "0.14.1")
    ],
    targets: [
        .target(
            name: "WeekOversight 2025",
            dependencies: ["CoreXLSX"])
    ]
) 