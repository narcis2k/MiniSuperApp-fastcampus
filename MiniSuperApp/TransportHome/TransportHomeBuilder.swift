import ModernRIBs

protocol TransportHomeDependency: Dependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency, TopupDependency, TransportHomeDependency {
    let topBaseViewController: ViewControllable
    var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    
    init(dependency: TransportHomeDependency, topBaseViewController: ViewControllable) {
        self.topBaseViewController = topBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol TransportHomeBuildable: Buildable {
  func build(withListener listener: TransportHomeListener) -> TransportHomeRouting
}

final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
  
  override init(dependency: TransportHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: TransportHomeListener) -> TransportHomeRouting {
    let viewController = TransportHomeViewController()
    let component = TransportHomeComponent(dependency: dependency, topBaseViewController: viewController)
    
    let interactor = TransportHomeInteractor(presenter: viewController, dependency: component)
    interactor.listener = listener
    
    let topupBuilder = TopupBuilder(dependency: component)
    
    return TransportHomeRouter(
      interactor: interactor,
      viewController: viewController,
        topupBuildable: topupBuilder
    )
  }
}
