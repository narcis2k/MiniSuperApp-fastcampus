//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/14.
//

import Foundation

protocol SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    
}

final class SuperPayRepositoryImp: SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
    
    private let balanceSubject = CurrentValuePublisher<Double>(0)
    
}
