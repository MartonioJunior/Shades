//
//  AnyColor+Tests.swift
//  Shades
//
//  Created by Martônio Júnior on 01/03/2025.
//

@testable import Colors
import CoreGraphics
import Testing

struct AnyColorTests {
    @Test("Creates a generic RGBA color abstraction", arguments: [
        (0.7, 0.4, 0.3, 0.6, AnyColor(r: 0.7, g: 0.4, b: 0.3, a: 0.6)),
        (-1, 0.4, 0.5, 2, AnyColor(r: 0, g: 0.4, b: 0.5, a: 1)),
        (7, 0.7, -0.3, 0.4, AnyColor(r: 1, g: 0.7, b: 0, a: 0.4)),
        (0.6, 0.5, 0.4, nil, AnyColor(r: 0.6, g: 0.5, b: 0.4, a: 1))
    ])
    func initializer(r: Double, g: Double, b: Double, a: Double?, expected: AnyColor) async throws {
        let color = a == nil ? AnyColor(r: r, g: g, b: b) : AnyColor(r: r, g: g, b: b, a: a!)
        #expect(color == expected)
    }

    @Test("Composes a color abstraction into a specific type", arguments: [
        (AnyColor(r: 0.7, g: 0.4, b: 0.3, a: 0.6), CGColor(red: 0.7, green: 0.4, blue: 0.3, alpha: 0.6))
    ])
    func compose(color: AnyColor, expected: CGColor) async throws {
        let composed = color.compose(as: CGColor.self)
        #expect(composed == expected)
    }

    @Test("Paints a color abstraction into a specific type", arguments: [
        (AnyColor(r: 0.7, g: 0.4, b: 0.3, a: 0.6), CGColor(red: 0.7, green: 0.4, blue: 0.3, alpha: 0.6))
    ])
    func paint(color: AnyColor, expected: CGColor) async throws {
        var painted: CGColor = .clear
        color.paint(&painted)
        #expect(painted == expected)
    }

    @Test("Creates a color based on it's rgba values", arguments: [
        (255, 151, 112, 255, AnyColor(r: 1, g: 0.592156862745098, b: 0.4392156862745098, a: 1))
    ])
    func rgba(red: Int, green: Int, blue: Int, alpha: Int, expected: AnyColor) async throws {
        let color = AnyColor.rgba(red, green, blue, alpha)
        #expect(color == expected)
    }

    @Test("Validates constants for AnyColor type", arguments: [
        (AnyColor.apricot, AnyColor(r: 1, g: 0.592156862745098, b: 0.4392156862745098, a: 1)),
        (AnyColor.beige, AnyColor(r: 1, g: 0.906, b: 0.82, a: 1)),
        (AnyColor.black, AnyColor(r: 0, g: 0, b: 0, a: 1)),
        (AnyColor.blue, AnyColor(r: 0, g: 0, b: 1, a: 1)),
        (AnyColor.green, AnyColor(r: 0, g: 1, b: 0, a: 1)),
        (AnyColor.lightOrange, AnyColor(r: 1, g: 0.592, b: 0.439, a: 1)),
        (AnyColor.lightPeach, AnyColor(r: 1, g: 0.9098039215686274, b: 0.8196078431372549, a: 1)),
        (AnyColor.poolBlue, AnyColor(r: 0.4627450980392157, g: 0.8980392156862745, b: 0.9882352941176471, a: 1)),
        (AnyColor.red, AnyColor(r: 1, g: 0, b: 0, a: 1)),
        (AnyColor.skyBlue, AnyColor(r: 0.39215686274509803, g: 0.6862745098039216, b: 1, a: 1)),
        (AnyColor.yellow, AnyColor(r: 1, g: 1, b: 0, a: 1))
    ])
    func constants(constant: AnyColor, expected: AnyColor) async throws {
        #expect(constant == expected)
    }
}

// MARK: OS-specific code
#if os(iOS)
import UIKit

extension AnyColorTests {
    @Test("Composes a color abstraction into a specific type", arguments: [
        (AnyColor(r: 0.7, g: 0.4, b: 0.3, a: 0.6), UIColor(red: 0.7, green: 0.4, blue: 0.3, alpha: 0.6))
    ])
    func compose(color: AnyColor, expected: UIColor) async throws {
        let composed = color.compose(as: UIColor.self)
        #expect(composed == expected)
    }
}
#elseif os(macOS)
import AppKit

extension AnyColorTests {
    @Test("Composes a color abstraction into a specific type", arguments: [
        (AnyColor(r: 0.7, g: 0.4, b: 0.3, a: 0.6), NSColor(red: 0.7, green: 0.4, blue: 0.3, alpha: 0.6))
    ])
    func compose(color: AnyColor, expected: NSColor) async throws {
        let composed = color.compose(as: NSColor.self)
        #expect(composed == expected)
    }
}
#endif
