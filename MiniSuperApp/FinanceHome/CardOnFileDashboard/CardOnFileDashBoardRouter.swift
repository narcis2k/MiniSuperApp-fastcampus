//
//  CardOnFileRouter.swift
//  MiniSuperApp
//
//  Created by nathan on 2021/11/02.
//

import ModernRIBs

protocol CardOnFileDashBoardInteractable: Interactable {
    var router: CardOnFileDashBoardRouting? { get set }
    var listener: CardOnFileDashBoardListener? { get set }
}

protocol CardOnFileDashBoardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CardOnFileDashboardRouter: ViewableRouter<CardOnFileDashBoardInteractable, CardOnFileDashBoardViewControllable>, CardOnFileDashBoardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CardOnFileDashBoardInteractable, viewController: CardOnFileDashBoardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
