//
//  SettingsView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State var editMode = false
    @State var settingView = SettingViews.main
    @State var showingLogoutAlert = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color("TropicalBlue")
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Text(NSLocalizedString("SETTINGS", comment: "Settings"))
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(Color("Navy"))
                        Spacer()
                    }
                    .padding()

                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundColor(.white)
                                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                                ScrollView {
                                    switch settingView {
                                    case .account:
                                        AccountSettingView(settingView: $settingView, userName: $viewModel.name, email: $viewModel.email)
                                            .transition(.move(edge: settingView == .account ? .trailing : .leading))
                                    case .main:
                                        MainSettingView(settingView: $settingView, showingLogoutAlert: $showingLogoutAlert)
                                    case .houses:
                                        EmptyView()
                                    }
                            }
                        }
                            .frame(minHeight: geometry.size.height * 0.75)
                            .padding(.horizontal)
                            .padding(.bottom)
                }
            }
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text(NSLocalizedString("LOGOUT", comment: "Settings")),
                    message: Text(NSLocalizedString("LOGOUT_QUESTION", comment: "Settings")),
                    primaryButton: .destructive(Text(NSLocalizedString("CANCEL", comment: "Action"))) {
                        self.showingLogoutAlert = false
                    },
                    secondaryButton: .cancel(Text(NSLocalizedString("YES", comment: "Action"))) {
                        self.viewModel.logout.send()
                    }
                )
            }
        }
    }
}

enum SettingViews {
    case main
    case account
    case houses
}

protocol SettingProtocol {
    var title: String { get }
    var hasNextPage: Bool { get }
    var imageName: String? { get }
}

enum AccountSettings: CaseIterable, SettingProtocol {
    case name
    case email
    case changePassword
    
    var title: String {
        switch self {
        case .name:
            return ""
        case .email:
            return ""
        case .changePassword:
            return NSLocalizedString("CHANGE_PASSWORD", comment: "Account Settings")
        }
    }
    
    var imageName: String? {
        switch self {
        case .name:
            return "person"
        case .email:
            return "envelope"
        case .changePassword:
            return "lock"
        }
    }
    
    var hasNextPage: Bool {
        return false
    }
}

enum Settings: CaseIterable, SettingProtocol {
    case account
    case houses
    case notifications
    case logout
    
    var title: String {
        switch self {
        case .account:
            return NSLocalizedString("ACCOUNT", comment: "Settings")
        case .notifications:
            return NSLocalizedString("NOTIFICATIONS", comment: "Settings")
        case .houses:
            return NSLocalizedString("HOUSES", comment: "Settings")
        case .logout:
            return NSLocalizedString("LOGOUT", comment: "Settings")
        }
    }

    var hasNextPage: Bool {
        switch self {
        case .account, .houses:
            return true
        case .notifications, .logout:
            return false
        }
    }
    
    var imageName: String? {
        nil
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
