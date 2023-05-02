//
//  SettingsViewController.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 19.04.2023.
//

import UIKit
import SwiftUI

final class SettingsViewController: UIViewController {
    var viewModel: SettingsViewModel!

    private lazy var embedController: UIHostingController<SettingsView> = {
        let controller = UIHostingController(rootView: SettingsView(viewModel: viewModel))
        controller.navigationController?.setNavigationBarHidden(true, animated: true)
        return controller
    }()

    init(viewModel: SettingsViewModel) {
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

    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        addChild(embedController)
        view.addSubview(embedController.view)
        embedController.view?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                embedController.view.topAnchor.constraint(equalTo: view.topAnchor),
                embedController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                embedController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                embedController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
    }
}