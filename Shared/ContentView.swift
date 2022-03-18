//
//  ContentView.swift
//  Shared
//
//  Created by Dan Hart on 3/18/22.
//

import SwiftUI
import Splash

struct ContentView: View {
    var font: Splash.Font {
        .init(size: 18)
    }
    
    var theme: Splash.Theme {
        .presentation(withFont: font)
    }
    
    var highlighter: Splash.SyntaxHighlighter<AttributedStringOutputFormat> {
        SyntaxHighlighter(format: AttributedStringOutputFormat(theme: theme))
    }
    
    var body: some View {
        NSASLabel { label in
            label.attributedText = highlighter.highlight("func helloWorld() -> String")
        }
        .padding()
    }
}

struct NSASLabel: UIViewRepresentable {
    typealias TheUIView = UILabel
    fileprivate var configuration = { (view: TheUIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> TheUIView { TheUIView() }
    func updateUIView(_ uiView: TheUIView, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
