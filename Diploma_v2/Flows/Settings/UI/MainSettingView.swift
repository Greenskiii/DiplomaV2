//
//  MainSettingView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 22.03.2023.
//

import SwiftUI

struct MainSettingView: View {
    @Binding var settingView: SettingViews
    @Binding var showingLogoutAlert: Bool

    var body: some View {
        VStack {
            ForEach(Settings.allCases, id: \.self) { setting in
                SettingsText(setting: setting)
                    .padding()

                    .onTapGesture {
                        withAnimation {
                            switch setting {
                            case .account:
                                self.settingView = .account
                            case .notifications:
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            case .houses:
                                self.settingView = .houses
                            case .logout:
                                self.showingLogoutAlert = true
                            }
                        }
                    }
                
                if setting != Settings.allCases.last {
                    Divider()
                        .padding(.horizontal)
                }
            }
            Spacer()
        }
    }
}
