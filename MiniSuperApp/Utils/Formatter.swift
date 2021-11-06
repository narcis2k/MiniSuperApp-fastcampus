//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/01.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
