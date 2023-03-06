//
//  RootTabViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.03.2023.
//

import SwiftUI

class RootTabViewModel: ObservableObject {
    @Published var selectedTab: TabType = .main

    let mainMenuViewModel: MainMenuViewModel

    init(mainMenuViewModel: MainMenuViewModel) {
        self.mainMenuViewModel = mainMenuViewModel
    }
}
