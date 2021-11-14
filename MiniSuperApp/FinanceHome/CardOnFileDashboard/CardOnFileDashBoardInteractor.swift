//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/02.
//

import ModernRIBs
import Combine

protocol CardOnFileDashBoardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashBoardPresentable: Presentable {
    var listener: CardOnFileDashBoardPresentableListener? { get set }
    
    func update(with models: [PaymentMethodViewModel])
}

protocol CardOnFileDashBoardListener: AnyObject {
    func cardOnFileDidTapAddPaymentMethod()
}

protocol CardOnFileDashBoardInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashBoardInteractor: PresentableInteractor<CardOnFileDashBoardPresentable>, CardOnFileDashBoardInteractable, CardOnFileDashBoardPresentableListener {

    weak var router: CardOnFileDashBoardRouting?
    weak var listener: CardOnFileDashBoardListener?
    
    private let dependency: CardOnFileDashBoardInteractorDependency
    
    private var cancellables: Set<AnyCancellable>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CardOnFileDashBoardPresentable,
        dependency: CardOnFileDashBoardInteractorDependency
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
