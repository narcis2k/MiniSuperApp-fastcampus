import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashBoardListener, AddPaymentMethodListener, TopupListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  
    private let superPayDashboardBuildable: SuperPayDashboardBuildable
    private var superPayRouting: Routing?

    private let cardOnFileBuildable: CardOnFileDashBoardBuildable
    private var cardOnFileRouting: Routing?

    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let topupBuildable: TopupBuildable
    private var topupRouting: Routing?

    init(interactor: FinanceHomeInteractable,
         viewController: FinanceHomeViewControllable,
         superPayDashboardBuildable: SuperPayDashboardBuildable,
         cardOnFile: CardOnFileDashBoardBuildable,
         addPaymentMethodBuildable: AddPaymentMethodBuildable,
         topupBuildable: TopupBuildable) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        self.cardOnFileBuildable = cardOnFile
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.topupBuildable = topupBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSuperPayDashboard() {
        guard superPayRouting == nil else { return }
        
        let router = superPayDashboardBuildable.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        superPayRouting = router
        attachChild(router)
    }
    
    func attachCardOnFile() {
        if cardOnFileRouting != nil {
            return
        }
        
        let router = cardOnFileBuildable.build(withListener: interactor)
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        cardOnFileRouting = router
        attachChild(router)
    }
    
    func attachAddPaymentMethod() {
        if addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: .close)
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewControllable.present(navigation, animated: true, completion: nil)
        
        addPaymentMethodRouting = router
        attachChild(router)
    }
    
    func detachPaymentMethod() {
        guard let router = addPaymentMethodRouting else { return }
        
        viewControllable.dismiss(completion: nil)
        
        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    func attachTopup() {
        if topupRouting != nil {
            return
        }
        
        let router = topupBuildable.build(withListener: interactor)
        topupRouting = router
        attachChild(router)
        
    }
    
    func detachTopup() {
        guard let router = topupRouting else { return }
        
        detachChild(router)
        topupRouting = nil
    }
}
