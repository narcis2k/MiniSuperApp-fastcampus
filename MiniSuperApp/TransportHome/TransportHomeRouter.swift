import ModernRIBs

protocol TransportHomeInteractable: Interactable, TopupListener {
  var router: TransportHomeRouting? { get set }
  var listener: TransportHomeListener? { get set }
}

protocol TransportHomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TransportHomeRouter: ViewableRouter<TransportHomeInteractable, TransportHomeViewControllable>, TransportHomeRouting {
  
    private let topupBuilable: TopupBuildable
    private var topupRouting: Routing?
    
  init(
    interactor: TransportHomeInteractable,
    viewController: TransportHomeViewControllable,
    topupBuildable: TopupBuildable
  ) {
    self.topupBuilable = topupBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
    func attachTopup() {
        if topupRouting != nil {
            return
        }
        
        let router = topupBuilable.build(withListener: interactor)
        self.topupRouting = router
        attachChild(router)
    }
    
    func detachTopup() {
        guard let router = topupRouting else { return }
        detachChild(router)
        
        self.topupRouting = nil
    }
    
}
