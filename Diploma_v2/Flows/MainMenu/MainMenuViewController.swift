//
//  MainMenuViewController.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.01.2023.
//

import UIKit
import SwiftUI

final class MainMenuViewController: UIViewController {
    
//    var viewModel: AuthorizationViewModel!
    
    private lazy var embedController: UIHostingController<MainMenuView> = {
        let controller = UIHostingController(rootView: MainMenuView())
        return controller
    }()
    
//    init(viewModel: AuthorizationViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    private func configureUI() {
         add(childViewController: embedController, to: view)
    }
}
