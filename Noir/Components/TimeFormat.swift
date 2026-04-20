//
//  TimeFormat.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/29/26.
//

func formatTime(_ seconds: Int) -> String {
    let h = seconds / 3600
    let m = (seconds % 3600) / 60
    return "\(h)h \(m)m"
}
