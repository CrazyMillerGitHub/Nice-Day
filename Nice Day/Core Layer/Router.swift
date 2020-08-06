//
//  Router.swift
//  Nice Day
//
//  Created by Михаил Борисов on 19.07.2020.
//  Copyright © 2020 Mikhail Borisov. All rights reserved.
//
//
//import UIKit
//import Foundation
//
//protocol Transition: class {
//
//    func open(_ viewController: UIViewController)
//    func close(_ viewController: UIViewController)
//}
//
//class ModalTransition: NSObject {
//
//    var modalTransitionStyle: UIModalTransitionStyle
//    var modalPresentationStyle: UIModalPresentationStyle
//
//    var completionHandler: (() -> Void)?
//
//    var isAnimated: Bool = true
//    var animator: Animator?
//
//    weak var viewController: UIViewController?
//
//    init(_ animator: Animator? = nil,
//         isAnimated: Bool = true,
//         modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
//         modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
//        self.animator = animator
//        self.isAnimated = isAnimated
//        self.modalTransitionStyle = modalTransitionStyle
//        self.modalPresentationStyle = modalPresentationStyle
//    }
//
//}
//
//extension ModalTransition: UIViewControllerTransitioningDelegate {}
//
//extension ModalTransition: Transition {
//
//    func open(_ viewController: UIViewController) {
//        viewController.transitioningDelegate = self
//        viewController.modalTransitionStyle = modalTransitionStyle
//        viewController.modalPresentationStyle = modalPresentationStyle
//        self.viewController?.present(viewController, animated: isAnimated, completion: completionHandler)
//    }
//
//    func close(_ viewController: UIViewController) {
//        viewController.dismiss(animated: isAnimated, completion: completionHandler)
//    }
//
//}
//
//protocol Animator: UIViewControllerAnimatedTransitioning {
//    var isPresenting: Bool { get set }
//}
//
//protocol Closable: class {
//    func close()
//}
//
//protocol RouterProtocol: class {
//
//    associatedtype V: UIViewController
//
////    weak var viewController: V? { get }
//    func open(_ viewController: UIViewController, transtion: Transition)
//}
//
//class Router<U>: RouterProtocol, Closable where U: UIViewController {
//
//    typealias V = U
//
//    weak var viewController: V?
//    var openTranstion: Transition?
//
//    func open(_ viewController: UIViewController, transtion: Transition) {
//        transtion.open(viewController)
//    }
//
//    func close() {
//        guard let openTransition = openTranstion else {
//            assertionFailure("You should specify an open transition in order to close a module.")
//            return
//        }
//        guard let viewController = viewController else {
//            assertionFailure("Nothing to close.")
//            return
//        }
//        openTransition.close(viewController)
//    }
//
//}
//

//protocol ProfileRoute {
//
//    var profileTranstion: Transition? { get }
//
//    func openProfile()
//}
//
//final class ProfileRouter: Router<ProfileViewController> {
//
//    typealias Routes = Closable
//}
//
//extension ProfileRoute where Self: RouterProtocol {
//
//    var profileTransition: Transition {
//        return ModalTransition()
//    }
//
//    func openProfile() {
//        let router = ProfileRouter()
//        let viewController = ProfileViewController(router: router)
//        let transition = profileTransition
//        router.openTranstion = profileTransition
//        open(viewController, transtion: transition)
//    }
//}
//
//final class FriendRouter: Router<ProfileView>, FriendRouter.Routes {
//
//    var profileTranstion: Transition?
//
//    typealias Routes = ProfileRoute
//}
//
//class ProfileViewController: UIViewController {
//
//    let router: ProfileRouter
//
//    init (router: ProfileRouter) {
//        self.router = router
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
