import ModernRIBs

protocol FinanceHomeDependency: Dependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency,
                                  CardOnFileDashBoardDependency, AddPaymentMethodDependency, TopupDependency {
    var topBaseViewController: ViewControllable
    
    var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    
    init(dependency: FinanceHomeDependency,
         topupBaseViewController: ViewControllable) {
        self.topBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
    let viewController = FinanceHomeViewController()

    let component = FinanceHomeComponent(dependency: dependency,
                                         topupBaseViewController: viewController)
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
    let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
    let topupBuilder = TopupBuilder(dependency: component)
    
    return FinanceHomeRouter(
        interactor: interactor,
        viewController: viewController,
        superPayDashboardBuildable: superPayDashboardBuilder,
        cardOnFile: cardOnFileDashboardBuilder,
        addPaymentMethodBuildable: addPaymentMethodBuilder,
        topupBuildable: topupBuilder
    )
  }
}
