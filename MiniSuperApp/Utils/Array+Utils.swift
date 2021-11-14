//
//  Array+Utils.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/08.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
