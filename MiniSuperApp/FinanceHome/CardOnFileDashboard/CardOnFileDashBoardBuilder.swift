//
//  CardOnFileBuilder.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/02.
//

import ModernRIBs

protocol CardOnFileDashBoardDependency: Dependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
    
}

final class CardOnFileDashBoardComponent: Component<CardOnFileDashBoardDependency>, CardOnFileDashBoardInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
}

// MARK: - Builder

protocol CardOnFileDashBoardBuildable: Buildable {
    func build(withListener listener: CardOnFileDashBoardListener) -> CardOnFileDashBoardRouting
}

final class CardOnFileDashboardBuilder: Builder<CardOnFileDashBoardDependency>, CardOnFileDashBoardBuildable {

    override init(dependency: CardOnFileDashBoardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CardOnFileDashBoardListener) -> CardOnFileDashBoardRouting {
        let component = CardOnFileDashBoardComponent(dependency: dependency)
        let viewController = CardOnFileDashBoardViewController()
        let interactor = CardOnFileDashBoardInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return CardOnFileDashboardRouter(interactor: interactor, viewController: viewController)
    }
}
