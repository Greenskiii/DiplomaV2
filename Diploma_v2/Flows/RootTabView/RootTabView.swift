//
//  RootTabView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.03.2023.
//

import SwiftUI

struct RootTabView: View {
    @ObservedObject var viewModel: RootTabViewModel

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            main.tag(TabType.main)
            settings.tag(TabType.settings)
        }
    }

    private var main: some View {
        MainMenuView(viewModel: viewModel.mainMenuViewModel)
            .tabItem {
                Label("Menu", systemImage: "house")
            }
    }

    private var settings: some View {
        SettingsView(viewModel: viewModel.settingsViewModel)
            .tabItem {
                Label("Settings", systemImage: "person")
            }
    }
}

enum TabType: Int {
    case main
    case settings
}
