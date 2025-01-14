// swift-tools-version:5.9

//
// This source file is part of the Stanford Spezi open source project
// 
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "SpeziLLM",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "SpeziLLM", targets: ["SpeziLLM"]),
        .library(name: "SpeziLLMLocal", targets: ["SpeziLLMLocal"]),
        .library(name: "SpeziLLMLocalDownload", targets: ["SpeziLLMLocalDownload"]),
        .library(name: "SpeziLLMOpenAI", targets: ["SpeziLLMOpenAI"])
    ],
    dependencies: [
        .package(url: "https://github.com/MacPaw/OpenAI", .upToNextMinor(from: "0.2.6")),
        .package(url: "https://github.com/StanfordBDHG/llama.cpp", .upToNextMinor(from: "0.1.8")),
        .package(url: "https://github.com/StanfordSpezi/Spezi", from: "1.1.0"),
        .package(url: "https://github.com/StanfordSpezi/SpeziStorage", from: "1.0.0"),
        .package(url: "https://github.com/StanfordSpezi/SpeziOnboarding", from: "1.0.0"),
        .package(url: "https://github.com/StanfordSpezi/SpeziSpeech", from: "1.0.0"),
        .package(url: "https://github.com/StanfordSpezi/SpeziChat", .upToNextMinor(from: "0.1.8")),
        .package(url: "https://github.com/StanfordSpezi/SpeziViews", from: "1.0.0"),
        .package(url: "https://github.com/groue/Semaphore.git", exact: "0.0.8")
    ],
    targets: [
        .target(
            name: "SpeziLLM",
            dependencies: [
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "SpeziChat", package: "SpeziChat"),
                .product(name: "SpeziViews", package: "SpeziViews")
            ]
        ),
        .target(
            name: "SpeziLLMLocal",
            dependencies: [
                .target(name: "SpeziLLM"),
                .product(name: "llama", package: "llama.cpp"),
                .product(name: "Semaphore", package: "Semaphore"),
                .product(name: "Spezi", package: "Spezi")
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ]
        ),
        .target(
            name: "SpeziLLMLocalDownload",
            dependencies: [
                .product(name: "SpeziOnboarding", package: "SpeziOnboarding"),
                .product(name: "SpeziViews", package: "SpeziViews")
            ]
        ),
        .target(
            name: "SpeziLLMOpenAI",
            dependencies: [
                .target(name: "SpeziLLM"),
                .product(name: "OpenAI", package: "OpenAI"),
                .product(name: "Semaphore", package: "Semaphore"),
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "SpeziChat", package: "SpeziChat"),
                .product(name: "SpeziSecureStorage", package: "SpeziStorage"),
                .product(name: "SpeziSpeechRecognizer", package: "SpeziSpeech"),
                .product(name: "SpeziOnboarding", package: "SpeziOnboarding")
            ]
        ),
        .testTarget(
            name: "SpeziLLMTests",
            dependencies: [
                .target(name: "SpeziLLMOpenAI")
            ]
        )
    ]
)
