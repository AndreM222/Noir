//
//  WindowAccessor.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/10/26.
//

import AppKit
import SwiftUI

struct WindowAccessor: NSViewRepresentable {
    var callback: (NSWindow) -> Void

    func makeNSView(context _: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                callback(window)
            }
        }
        return view
    }

    func updateNSView(_: NSView, context _: Context) {}
}
