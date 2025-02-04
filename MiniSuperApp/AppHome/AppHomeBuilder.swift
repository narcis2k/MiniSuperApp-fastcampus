import ModernRIBs

protocol AppHomeDependency: Dependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
}

final class AppHomeComponent: Component<AppHomeDependency>, TransportHomeDependency {
    var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
}

// MARK: - Builder

public protocol AppHomeBuildable: Buildable {
  func build(withListener listener: AppHomeListener) -> ViewableRouting
}

final class AppHomeBuilder: Builder<AppHomeDependency>, AppHomeBuildable {
  
  override init(dependency: AppHomeDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: AppHomeListener) -> ViewableRouting {
    let component = AppHomeComponent(dependency: dependency)
    let viewController = AppHomeViewController()
    let interactor = AppHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let transportHomeBuilder = TransportHomeBuilder(dependency: component)
    
    return AppHomeRouter(
      interactor: interactor,
      viewController: viewController,
      transportHomeBuildable: transportHomeBuilder
    )
  }
}
