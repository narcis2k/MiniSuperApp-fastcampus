//
//  PaymentModel.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/02.
//

import Foundation

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
