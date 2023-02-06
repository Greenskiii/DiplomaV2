//
//  AuthorizationRouter.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import UIKit
import SwiftUI

final class AuthorizationViewController: UIViewController {
    
    var viewModel: AuthorizationViewModel!
    
    private lazy var embedController: UIHostingController<AuthorizationView> = {
        let controller = UIHostingController(rootView: AuthorizationView(viewModel: viewModel))
        return controller
    }()
    
    init(viewModel: AuthorizationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        addChild(embedController)
        view.addSubview(embedController.view)
        embedController.view?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            embedController.view.topAnchor.constraint(equalTo: view.topAnchor),
            embedController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            embedController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            embedController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

public extension UIViewController {
    func add(
        childViewController viewController: UIViewController,
        to contentView: UIView,
        shouldIgnoreSafeArea: Bool = true
    ) {
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewController.view.topAnchor.constraint(
                equalTo: shouldIgnoreSafeArea ? contentView.topAnchor : contentView.safeAreaLayoutGuide.topAnchor
            ),
            viewController.view.bottomAnchor.constraint(
                equalTo: shouldIgnoreSafeArea ? contentView.bottomAnchor : contentView.safeAreaLayoutGuide.bottomAnchor
            )
        ])
        viewController.didMove(toParent: self)
    }
}
