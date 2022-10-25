//
//  SwiftUIView.swift
//  Loggie_Example
//
//  Created by Damjan Dimovski on 13.10.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Loggie
import WebKit

@available(iOS 13.0.0, *)
struct SwiftUIView: View {

    @State private var showingLogs = false

    var body: some View {
        VStack {
            SwiftUIWebView()
            Button("Show logs") {
                showingLogs = true
            }
        }
        .sheet(isPresented: $showingLogs) {
            LogListTableView()
        }
    }
}

@available(iOS 13.0.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

@available(iOS 13.0.0, *)
struct SwiftUIWebView: UIViewRepresentable {
    typealias UIViewType = UIWebView

    let webView: UIWebView

    init() {
        URLProtocol.registerClass(LoggieURLProtocol.self)
        webView = UIWebView(frame: .zero)
        webView.loadRequest(URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users/1")!))
    }

    func makeUIView(context: Context) -> UIWebView {
        webView
    }
    func updateUIView(_ uiView: UIWebView, context: Context) {
    }
}
