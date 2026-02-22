//
//  Mixable.swift
//  Shades
//
//  Created by Martônio Júnior on 21/01/25.
//

public protocol Mixable {
    associatedtype Mix

    func mix(with other: Mix, by amount: Double) -> Self
}

// MARK: Mixable types
extension AnyColor: Mixable {
    public func mix(with other: Self, by amount: Double) -> Self {
        .init(
            r: (red...other.red).crossFade(by: amount),
            g: (green...other.green).crossFade(by: amount),
            b: (blue...other.blue).crossFade(by: amount),
            a: (alpha...other.alpha).crossFade(by: amount)
        )
    }
}

// MARK: Mix == Self
public extension Mixable where Mix == Self {}

// MARK: ClosedRange (EX)
extension ClosedRange where Bound: Numeric {
    func crossFade(by t: Bound) -> Bound {
        t * upperBound + (1 - t) * lowerBound
    }
}
