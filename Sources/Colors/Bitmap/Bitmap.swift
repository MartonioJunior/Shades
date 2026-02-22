//
//  Bitmap.swift
//  Shades
//
//  Created by Martônio Júnior on 24/04/2025.
//

import MatheSIMD

@available(macOS 26.0.0, *)
public typealias Bitmap<let Width: Int, let Height: Int, C> = Matrix<Width, Height, C> where C: Colorable

// MARK: DotSyntax
@available(macOS 26.0.0, *)
public extension Bitmap {
    static func fill(_ color: Element = .create(from: .white)) -> Self? {
        .init { _ in color }
    }

    static func checkered(
        _ color1: Element = .create(from: .white),
        _ color2: Element = .create(from: .black),
        size: Size
    ) -> Self? {
        .init { ($0.row + $0.column).isMultiple(of: 2) ? color1 : color2 }
    }
}

// MARK: Filters
public extension Colorable {
    var greyedOut: Self {
        mapAnyColor {
            let grey = 0.3 * $0.red + 0.59 * $0.green + 0.11 * $0.blue
            return AnyColor(r: grey, g: grey, b: grey, a: $0.alpha)
        }.dynamicConversion()
    }

    func addingNoise(delta: Double = 0.196) -> Self {
        mapChannels {
            $0 + .random(in: -delta...delta)
        }
    }
}

@available(macOS 26, *)
public extension Bitmap {
    /// Filter that gives the Bitmap the effect of an old photo
    var aged: Self {
        .init {
            self[$0].addingNoise().greyedOut.mapAnyColor {
                AnyColor(r: $0.red + 0.196, g: $0.green, b: $0.blue - 0.196, a: $0.alpha)
            }.dynamicConversion()
        }
    }

    func crossFade(
        to target: Self,
        t: (Position) -> Double
    ) -> Self where Element: Mixable, Element.Mix == Element {
        .init {
            self[$0].mix(with: target[$0], by: t($0)).dynamicConversion()
        }
    }

    /// Can be used for fading in and out of an image
    func lerp(
        to target: Self,
        t: @escaping (Position) -> Double
    ) -> Self {
        .init { position in
            self[position].eraseToAnyColor().mapChannels { $0 * t(position) }.dynamicConversion()
        }
    }
}
