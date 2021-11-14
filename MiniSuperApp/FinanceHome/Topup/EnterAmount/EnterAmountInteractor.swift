//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/08.
//

import ModernRIBs
import Combine

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
}

protocol EnterAmountListener: AnyObject {
    func enterAmoundDidTapClose()
    func enterAmountDidTapPaymentMethod()
}
protocol EnterAmountInteractorDependency {
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
}
final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {

    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?
    
    private let dependency: EnterAmountInteractorDependency
    
    var cancellable: Set<AnyCancellable>

    init(presenter: EnterAmountPresentable,
         dependency: EnterAmountInteractorDependency) {
        self.dependency = dependency
        self.cancellable = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.selectedPaymentMethod.sink { [weak self] paymentMethod in
            self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel(paymentMethod))
        }.store(in: &cancellable)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.enterAmoundDidTapClose()
    }
    
    func didTapPaymentMethod() {
        listener?.enterAmountDidTapPaymentMethod()
    }
    
    func didTapTopup(with amount: Double) {
        
    }
}
