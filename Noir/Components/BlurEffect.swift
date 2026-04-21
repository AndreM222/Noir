//
//  BlurEffect.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/13/26.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct VariableBlurView: NSViewRepresentable {
    var maxBlurRadius: CGFloat = 20

    func makeNSView(context _: Context) -> NSView {
        VariableBlurNSView(maxBlurRadius: maxBlurRadius)
    }

    func updateNSView(_: NSView, context _: Context) {}
}

class VariableBlurNSView: NSView {
    let maxBlurRadius: CGFloat

    init(maxBlurRadius: CGFloat) {
        self.maxBlurRadius = maxBlurRadius
        super.init(frame: .zero)
        wantsLayer = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    override func makeBackingLayer() -> CALayer {
        let layer = CALayer()
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.radius = Float(maxBlurRadius)

        if let filter = CIFilter(name: "CIGaussianBlur") {
            layer.filters = [filter]
            layer.setValue(maxBlurRadius, forKeyPath: "filters.CIGaussianBlur.inputRadius")
        }

        return layer
    }
}

struct ProgressiveBlurView: View {
    var maxBlur: CGFloat = 16
    var steps: Int = 8

    var body: some View {
        ZStack {
            ForEach(0 ..< steps, id: \.self) { i in
                let fraction = CGFloat(i + 1) / CGFloat(steps)
                let blurAmount = fraction * fraction * maxBlur

                Rectangle()
                    .fill(.clear)
                    .background(.regularMaterial)
                    .blur(radius: blurAmount)
                    .mask(
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: max(0, fraction - 0.25)),
                                .init(color: .black, location: min(1, fraction + 0.1))
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(0.18)
            }
        }
        .allowsHitTesting(false)
    }
}
