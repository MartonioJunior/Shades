//
//  Colorable.swift
//  Shades
//
//  Created by Martônio Júnior on 30/10/23.
//

import Foundation

public protocol Colorable {
    static func create(from color: AnyColor) -> Self
    func eraseToAnyColor() -> AnyColor
}

// MARK: Default Implementation
public extension Colorable {
    func dynamicConversion<C: Colorable>(to colorableType: C.Type = C.self) -> C {
        colorableType.create(from: eraseToAnyColor())
    }

    func mapAnyColor<T>(_ transform: @escaping (AnyColor) -> T) -> T {
        transform(eraseToAnyColor())
    }

    func mapChannels(_ transform: @escaping (Double) -> Double, includeAlpha: Bool = false) -> Self {
        mapAnyColor {
            AnyColor(
                r: transform($0.red),
                g: transform($0.green),
                b: transform($0.blue),
                a: includeAlpha ? transform($0.alpha) : $0.alpha
            )
        }.dynamicConversion()
    }

    func mapColor<T>(_ transform: @escaping (Self) -> T) -> T {
        transform(self)
    }
}

// MARK: CGColor
public import CoreGraphics
@available(iOS 13.0, *)
extension CGColor: Colorable {
    public static func create(from color: AnyColor) -> Self {
        Self(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }

    public func eraseToAnyColor() -> AnyColor {
        guard let components else { return .init(r: 0, g: 0, b: 0, a: alpha) }

        return .init(r: components[0], g: components[1], b: components[2], a: alpha)
    }
}

// MARK: NSColor
#if canImport(AppKit)
public import AppKit

extension NSColor: Colorable {
    public static func create(from color: AnyColor) -> Self {
        Self(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }

    public func eraseToAnyColor() -> AnyColor {
        .init(r: redComponent, g: greenComponent, b: blueComponent, a: alphaComponent)
    }
}
#endif

// MARK: SwiftUI
import SwiftUI

@available(macOS 12.0, iOS 15, *)
extension Color: Colorable {
    public static func create(from color: AnyColor) -> Self {
        .init(red: color.red, green: color.green, blue: color.blue, opacity: color.alpha)
    }

    public func eraseToAnyColor() -> AnyColor {
        guard let cgColor else { return .white}

        return cgColor.eraseToAnyColor()
    }
}

// MARK: UIColor
#if canImport(UIKit)
public import UIKit

extension UIColor: Colorable {
    public static func create(from color: AnyColor) -> Self {
        Self(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }

    public func eraseToAnyColor() -> AnyColor {
        let color = rgba
        return .init(r: color.red, g: color.green, b: color.blue, a: color.alpha)
    }

    var rgba: AnyColor { eraseToAnyColor() }
}
#endif
