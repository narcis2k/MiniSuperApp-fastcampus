//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/02.
//

import ModernRIBs
import Combine

protocol CardOnFileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
    var listener: CardOnFilePresentableListener? { get set }
    
    func update(with models: [PaymentMethodViewModel])
}

protocol CardOnFileListener: AnyObject {
    func cardOnFileDidTapAddPaymentMethod()
}

protocol CardOnfileInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {

    weak var router: CardOnFileRouting?
    weak var listener: CardOnFileListener?
    
    private let dependency: CardOnfileInteractorDependency
    
    private var cancellables: Set<AnyCancellable>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CardOnFilePresentable,
        dependency: CardOnfileInteractorDependency
    ) {
        self.dependency = dependency
        cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.cardsOnFileRepository.cardOnFile.sink { [self] methods in
            let viewModels = methods.prefix(5).map(PaymentMethodViewModel.init)
            self.presenter.update(with: viewModels)
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didTappAddPaymentMethod() {
        listener?.cardOnFileDidTapAddPaymentMethod()
    }
}
