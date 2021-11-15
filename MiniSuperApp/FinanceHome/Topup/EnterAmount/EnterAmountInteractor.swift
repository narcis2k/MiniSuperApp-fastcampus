//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/08.
//

import Foundation
import ModernRIBs
import Combine

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
    func startLoading()
    func stopLoading()
}

protocol EnterAmountListener: AnyObject {
    func enterAmoundDidTapClose()
    func enterAmountDidTapPaymentMethod()
    func enterAmountDidFinishTopup()
}
protocol EnterAmountInteractorDependency {
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
    var superPayRepository: SuperPayRepository { get }
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
        presenter.startLoading()
        dependency.superPayRepository.topup(
            amount: amount,
            paymentMethodID: dependency.selectedPaymentMethod.value.id
        ).receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] _ in
                self?.presenter.stopLoading()
            },
            receiveValue: { [weak self] in
                self?.listener?.enterAmountDidFinishTopup()
            }
        ).store(in: &cancellable)
    }
}
