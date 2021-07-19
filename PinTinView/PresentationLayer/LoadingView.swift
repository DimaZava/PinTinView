//
//  LoadingView.swift
//  PinTinView
//
//  Created by Dmitry Zawadsky on 19.07.2021.
//

import SwiftUI

struct LoadingView: View {

    @State private var isCircleRotating = true

    var body: some View {

        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .fill(Color(.lightGray))
                .frame(width: 150, height: 150)

            Circle()
                .trim(from: 0, to: 1 / 4)
                .stroke(lineWidth: 10)
                .frame(width: 150, height: 150)
                .foregroundColor(Color.blue)
                .rotationEffect(.degrees(360))
                .animation(Animation.default.speed(Double.random(in: 0.2...0.5))
                            .repeatCount(.max, autoreverses: false))
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    var color: Color?
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(style: style)
        if let color = color {
            indicatorView.color = UIColor(color)
        }
        return indicatorView
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

//struct LoadingView: View {
//    @Binding var isAnimating: Bool
//    let count: UInt
//    let width: CGFloat
//    let spacing: CGFloat
//
//    var body: some View {
//        GeometryReader { geometry in
//            ForEach(0..<Int(count)) { index in
//                item(forIndex: index, in: geometry.size)
//                    .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
//                    .animation(
//                        Animation.default
//                            .speed(Double.random(in: 0.2...0.5))
//                            .repeatCount(isAnimating ? .max : 1, autoreverses: false)
//                    )
//            }
//        }
//        .aspectRatio(contentMode: .fit)
//    }
//
//    private func item(forIndex index: Int, in geometrySize: CGSize) -> some View {
//        Group { () -> Path in
//            var p = Path()
//            p.addArc(center: CGPoint(x: geometrySize.width/2, y: geometrySize.height/2),
//                     radius: geometrySize.width/2 - width/2 - CGFloat(index) * (width + spacing),
//                     startAngle: .degrees(0),
//                     endAngle: .degrees(Double(Int.random(in: 120...300))),
//                     clockwise: true)
//            return p.strokedPath(.init(lineWidth: width))
//        }
//        .frame(width: geometrySize.width, height: geometrySize.height)
//    }
//}
