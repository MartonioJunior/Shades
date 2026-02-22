//
//  Colorable+Tests.swift
//  Shades
//
//  Created by Martônio Júnior on 19/02/25.
//

@testable import Colors
import Testing

struct ColorableTests {}

// MARK: CGColor
#if canImport(CGGraphics)
extension ColorableTests {
    @Test("Creates a CGColor from an AnyColor instance", arguments: [
        (AnyColor(r: 0.5, g: 0.4, b: 0.8, a: 1), CGColor(red: 0.5, green: 0.4, blue: 0.8, alpha: 1))
    ])
    func create(color: AnyColor, expected: CGColor) async throws {
        let created = CGColor.create(from: color)

        assert(created == expected)
    }

    @Test("Erases a CGColor to an AnyColor instance", arguments: [
        (CGColor(red: 0.5, green: 0.4, blue: 0.8, alpha: 1), AnyColor(r: 0.5, g: 0.4, b: 0.8, a: 1))
    ])
    func erase(color: CGColor, expected: AnyColor) async throws {
        let erased = color.eraseToAnyColor()

        assert(erased == expected)
    }
}
#endif

// MARK: NSColor
#if canImport(AppKit)
import AppKit

extension ColorableTests {
    @Test("Creates a NSColor from an AnyColor instance", arguments: [
        (AnyColor(r: 0.5, g: 0.4, b: 0.8, a: 1), NSColor(red: 0.5, green: 0.4, blue: 0.8, alpha: 1))
    ])
    func create(color: AnyColor, expected: NSColor) async throws {
        let created = NSColor.create(from: color)

        assert(created == expected)
    }

    @Test("Erases a NSColor to an AnyColor instance", arguments: [
        (NSColor(red: 0.5, green: 0.4, blue: 0.8, alpha: 1), AnyColor(r: 0.5, g: 0.4, b: 0.8, a: 1))
    ])
    func erase(color: NSColor, expected: AnyColor) async throws {
        let erased = color.eraseToAnyColor()

        assert(erased == expected)
    }
}
#endif

// MARK: UIColor
#if canImport(UIKit)
import UIKit

extension ColorableTests {
    @Test("Creates a UIColor from an AnyColor instance", arguments: [
        (AnyColor(r: 0.5, g: 0.4, b: 0.8, a: 1), UIColor(red: 0.5, green: 0.4, blue: 0.8, alpha: 1))
    ])
    func create(color: AnyColor, expected: UIColor) async throws {
        let created = UIColor.create(from: color)

        assert(created == expected)
    }

    @Test("Erases a UIColor to an AnyColor instance", arguments: [
        (UIColor(red: 0.5, green: 0.4, blue: 0.8, alpha: 1), AnyColor(r: 0.5, g: 0.4, b: 0.8, a: 1))
    ])
    func erase(color: UIColor, expected: AnyColor) async throws {
        let erased = color.eraseToAnyColor()

        assert(erased == expected)
    }

    @Test("Also erases UIColor to an AnyColor instance", arguments: [
        (UIColor(red: 0.5, green: 0.4, blue: 0.8, alpha: 1), AnyColor(r: 0.5, g: 0.4, b: 0.8, a: 1))
    ])
    func rgba(color: UIColor, expected: AnyColor) async throws {
        let rgba = color.rgba

        assert(rgba == expected)
    }
}
#endif
