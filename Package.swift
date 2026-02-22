// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

// MARK: - Utilities
public enum UpcomingFeatures: String, CaseIterable {
    case existentialAny
    case fullTypedThrows
    case internalImportsByDefault
    case memberImportVisibility
    case nonescapableTypes
    case nonisolatedNonsendingByDefault
    case inferIsolatedConformances
    case valueGenerics

    var asSetting: SwiftSetting { .enableUpcomingFeature(rawValue.capitalized) }
}

public extension Array where Element == SwiftSetting {
    static var upcomingFeatures: Self { UpcomingFeatures.allCases.map(\.asSetting) }
}

func dep(local: String) -> Package.Dependency {
    .package(path: local)
}

func dep(url: String, _ version: Range<Version>, local: String = "") -> Package.Dependency {
    if local.isEmpty {
        .package(url: url, version)
    } else {
        dep(local: local)
    }
}

func lib(_ name: String, targets: String...) -> Product {
    .library(name: name, targets: targets)
}

func platformDeps(_ platforms: SupportedPlatform...) -> [SupportedPlatform] {
    platforms
}

func targetDep(name: String, package: String) -> Target.Dependency {
    .product(name: name, package: package)
}

// MARK: - Dependencies
let mathe = targetDep(name: "Mathe", package: "Mathe")

let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/MartonioJunior/Mathe", branch: "main")
]

// MARK: - Targets
let targets: [Target] = [
    .target(
        name: "Colors",
        dependencies: [mathe],
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Shades",
        dependencies: ["Colors"],
        swiftSettings: .upcomingFeatures
    )
]

let testTargets: [Target] = targets.map {
    .testTarget(name: "\($0.name)Tests", dependencies: [Target.Dependency(stringLiteral: $0.name)] + $0.dependencies)
}

// MARK: - Products
let products: [Product] = targets.map {
    .library(name: $0.name, targets: [$0.name])
}

// MARK: - Supported Platforms
let supportedPlatforms: [SupportedPlatform] = [
    .macOS(.v13)
]

// MARK: - PackageDescription
let package = Package(
    name: "Shades",
    platforms: supportedPlatforms,
    products: products,
    dependencies: dependencies,
    targets: targets + testTargets,
    swiftLanguageModes: [.v6]
)
