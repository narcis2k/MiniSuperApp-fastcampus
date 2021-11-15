//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/07.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    func attachAddPaymentMethod(closeButtonType: DismissButtonType)
    func detachAddPaymentMethod()
    func attachEnterAmount()
    func detachEnterAmount()
    func attachCardOnFile(paymentMethods: [PaymentMethod])
    func detachCardOnFile()
    func popToRoot()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}

protocol TopupInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private var isEnterAmountReset: Bool = false
    
    var paymentMethods: [PaymentMethod] {
        dependency.cardsOnFileRepository.cardOnFile.value
    }
      
    private let dependency: TopupInteractorDependency
    init(dependency: TopupInteractorDependency) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if let card = dependency.cardsOnFileRepository.cardOnFile.value.first {
            isEnterAmountReset = true
            dependency.paymentMethodStream.send(card)
            // 금액 입력 화면
            router?.attachEnterAmount()
        } else {
            isEnterAmountReset = false
            // 카드 추가 화면
            router?.attachAddPaymentMethod(closeButtonType: .close)
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func presentationControllerDismiss() {
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        if isEnterAmountReset == false {
            listener?.topupDidClose()
        }
    }
    
    func addPaymentMethodDidAddCard(method: PaymentMethod) {
        dependency.paymentMethodStream.send(method)
        if isEnterAmountReset {
            router?.popToRoot()
        } else {
            isEnterAmountReset = true
            router?.attachEnterAmount()
        }
    }
    
    func enterAmoundDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(paymentMethods: paymentMethods)
    }
    
    func cardOnFileDidClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAdd() {
        router?.attachAddPaymentMethod(closeButtonType: .back)
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethods[safe: index] {
            dependency.paymentMethodStream.send(selected)
        }
        
        router?.detachCardOnFile()
    }
    
    func enterAmountDidFinishTopup() {
        listener?.topupDidFinish()
    }
}
