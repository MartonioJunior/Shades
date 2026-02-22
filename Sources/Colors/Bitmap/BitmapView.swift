//
//  BitmapView.swift
//  Shades
//
//  Created by Martônio Júnior on 24/04/2025.
//

import SwiftUI

@available(macOS 26, iOS 26, *)
public struct BitmapView<let Width: Int, let Height: Int, C: Colorable> {
    public typealias BitmapImage = Bitmap<Width, Height, C>

    // MARK: Variables
    var bitmap: BitmapImage
    var pixelPerfect: Bool
    /// Ratio of cell size
    var lineWidthRatio: CGFloat?
    var lineColor: Color?

    // MARK: Initializers
    public init(
        bitmap: BitmapImage,
        pixelPerfect: Bool = false,
        lineWidthRatio: CGFloat? = 0.05,
        lineColor: Color? = .white
    ) {
        self.bitmap = bitmap
        self.pixelPerfect = pixelPerfect
        self.lineWidthRatio = lineWidthRatio
        self.lineColor = lineColor
    }

    // MARK: Methods
    func renderBitmap(cellSize: CGSize, fill: (Path, GraphicsContext.Shading) -> Void) {
        for row in 0..<Height {
            for column in 0..<Width {
                let path = Path(
                    CGRect(
                        x: CGFloat(column) * cellSize.width,
                        y: CGFloat(row) * cellSize.height,
                        width: cellSize.width,
                        height: cellSize.height
                    )
                )
                let color = bitmap[r: row, c: column]
                fill(path, .color(color.dynamicConversion()))
            }
        }
    }

    func renderLines(
        _ lineWidthRatio: CGFloat,
        _ cellSize: CGSize,
        _ size: CGSize,
        _ ctx: GraphicsContext,
        _ lineColor: Color
    ) {
        let thickness = (horizontal: lineWidthRatio * cellSize.height, vertical: lineWidthRatio * cellSize.width)
        let minimumRequired = 2

        if Height > minimumRequired {
            for row in 1 ... Height - 1 {
                let linePath = Path { p in
                    p.move(to: CGPoint(x: 0, y: CGFloat(row) * cellSize.height))
                    p.addLine(to: CGPoint(x: size.width, y: CGFloat(row) * cellSize.height))
                }
                ctx.stroke(linePath, with: .color(lineColor), lineWidth: thickness.horizontal)
            }
        }

        if Width > minimumRequired {
            for column in 1 ... Width - 1 {
                let linePath = Path { p in
                    p.move(to: CGPoint(x: CGFloat(column) * cellSize.width, y: 0))
                    p.addLine(to: CGPoint(x: CGFloat(column) * cellSize.width, y: size.height))
                }
                ctx.stroke(linePath, with: .color(lineColor), lineWidth: thickness.vertical)
            }
        }
    }

    @ViewBuilder
    func pixelPerfectView() -> some View {
        Image(
            size: .init(width: Width, height: Height),
            label: nil,
            opaque: true,
            colorMode: .nonLinear
        ) { ctx in
            renderBitmap(cellSize: .init(width: 1, height: 1)) { path, shading in
                ctx.fill(path, with: shading)
            }
        }
        .interpolation(.none)
        .resizable()
        .scaledToFit()
    }

    @ViewBuilder
    func defaultView() -> some View {
        Canvas(
            opaque: true,
            colorMode: .nonLinear,
            rendersAsynchronously: false
        ) { ctx, size in
            let cellWidth = (size.width / CGFloat(Width))
            let cellHeight = (size.height / CGFloat(Height))

            renderBitmap(cellSize: .init(width: cellWidth, height: cellHeight)) { path, shading in
                ctx.fill(
                    path,
                    with: shading,
                    style: .init(eoFill: false, antialiased: false)
                )
            }

            if let lineWidthRatio, let lineColor {
                renderLines(lineWidthRatio, CGSize(width: cellWidth, height: cellHeight), size, ctx, lineColor)
            }
        }
        .aspectRatio(CGFloat(Height / Width), contentMode: .fit)
    }
}

// MARK: Self: View
@available(macOS 26, iOS 26, *)
extension BitmapView: View {
    public var body: some View {
        if pixelPerfect {
            pixelPerfectView()
        } else {
            defaultView()
        }
    }
}
