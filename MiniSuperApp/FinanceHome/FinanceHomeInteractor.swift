import ModernRIBs

protocol FinanceHomeRouting: ViewableRouting {
  func attachSuperPayDashboard()
    func attachCardOnFile()
    func attachAddPaymentMethod()
    func detachPaymentMethod()
}

protocol FinanceHomePresentable: Presentable {
  var listener: FinanceHomePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener, AdaptivePresentationControllerDelegate {
  
  weak var router: FinanceHomeRouting?
  weak var listener: FinanceHomeListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: FinanceHomePresentable) {
    presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init(presenter: presenter)
    presenter.listener = self
    presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    router?.attachSuperPayDashboard()
    router?.attachCardOnFile()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
    
    func cardOnFileDidTapAddPaymentMethod() {
        router?.attachAddPaymentMethod()
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachPaymentMethod()
    }
    
    func presentationControllerDismiss() {
        router?.detachPaymentMethod()
    }
    
    func addPaymentMethodDidAddCard(method: PaymentMethod) {
        router?.detachPaymentMethod()
    }
}
