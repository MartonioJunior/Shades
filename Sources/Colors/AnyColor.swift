//
//  AnyColor.swift
//  Shades
//
//  Created by Martônio Júnior on 29/10/23.
//

import Foundation

// TODO: Separate all color representations into their own types
public struct AnyColor {
    // MARK: Variables
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double

    // MARK: Initializers
    init(r red: Double, g green: Double, b blue: Double, a alpha: Double = 1) {
        let acceptedRange: ClosedRange<Double> = 0...1
        self.red = acceptedRange.clamp(red)
        self.green = acceptedRange.clamp(green)
        self.blue = acceptedRange.clamp(blue)
        self.alpha = acceptedRange.clamp(alpha)
    }

    // MARK: Methods
    public func compose<T: Colorable>(as type: T.Type = T.self) -> T {
        .create(from: self)
    }

    public func paint<T: Colorable>(_ element: inout T) {
        element = compose()
    }
}

// MARK: DotSyntax
public extension AnyColor {
    static func rgba(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Int = 255) -> AnyColor {
        .init(r: Double(red) / 255.0, g: Double(green) / 255.0, b: Double(blue) / 255.0, a: Double(alpha) / 255.0)
    }
}

// MARK: Constants
public extension AnyColor {
    static var apricot: Self { .rgba(255, 151, 112) }
    static var beige: Self { .init(r: 1, g: 0.906, b: 0.82) }
    static var black: Self { .init(r: 0, g: 0, b: 0) }
    static var blue: Self { .init(r: 0, g: 0, b: 1) }
    static var green: Self { .init(r: 0, g: 1, b: 0) }
    static var lightOrange: Self { .init(r: 1, g: 0.592, b: 0.439) }
    static var lightPeach: Self { .rgba(255, 232, 209) }
    static var poolBlue: Self { .rgba(118, 229, 252) }
    static var red: Self { .init(r: 1, g: 0, b: 0) }
    static var skyBlue: Self { .rgba(100, 175, 255) }
    static var white: Self { .init(r: 1, g: 1, b: 1) }
    static var yellow: Self { .init(r: 1, g: 1, b: 0) }
}

// MARK: Self: Colorable
extension AnyColor: Colorable {
    public static func create(from color: AnyColor) -> AnyColor { color }
    public func eraseToAnyColor() -> AnyColor { self }
}

// MARK: Self: Codable
extension AnyColor: Codable {}

// MARK: Self: Equatable
extension AnyColor: Equatable {}

// MARK: Self: Hashable
extension AnyColor: Hashable {}

// MARK: Self: Sendable
extension AnyColor: Sendable {}

// MARK: ClosedRange (EX)
extension ClosedRange {
    func clamp(_ value: Bound) -> Bound {
        Swift.min(Swift.max(value, lowerBound), upperBound)
    }
}

// MARK: ColorResource (EX)
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@available(macOS 14.0, *)
@available(iOS 17.0, *)
extension AnyColor {
    init(resource: ColorResource) {
        #if os(macOS)
        let color = NSColor(resource: resource)
        self.init(r: color.redComponent, g: color.greenComponent, b: color.blueComponent, a: color.alphaComponent)
        #else
        let color = UIColor(resource: resource).rgba
        self.init(r: color.red, g: color.green, b: color.blue, a: color.alpha)
        #endif
    }
}
