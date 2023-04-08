//
//  SettingsView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
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
                            switch viewModel.settingView {
                            case .account:
                                AccountSettingView(
                                    settingView: $viewModel.settingView,
                                    userName: $viewModel.name,
                                    email: $viewModel.email
                                )
                                    .transition(.opacity)
                            case .main:
                                MainSettingView(
                                    settingView: $viewModel.settingView,
                                    showingLogoutAlert: $viewModel.showingLogoutAlert
                                )
                                    .transition(.opacity)
                            case .houses:
                                HousesSettingsView(
                                    settingView: $viewModel.settingView,
                                    deleteHouse: $viewModel.deleteHouse,
                                    choosenHouseId: $viewModel.choosenHouseId,
                                    addHouse: $viewModel.addHouse,
                                    onGoToRoomsSettings: viewModel.onGoToRoomsSettings,
                                    houses: viewModel.housePreview
                                )
                                    .transition(.opacity)
                                
                            case .rooms:
                                if let house = viewModel.house {
                                    RoomsSettingView(
                                        settingView: $viewModel.settingView,
                                        deleteRoom: $viewModel.deleteRoom,
                                        addRoom: $viewModel.addRoom,
                                        choosenHouseId: $viewModel.choosenHouseId,
                                        rooms: house.rooms
                                    )
                                        .transition(.opacity)
                                }
                            }
                        }
                    }
                    .frame(minHeight: geometry.size.height * 0.75)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .alert(isPresented: $viewModel.showingLogoutAlert) {
                Alert(
                    title: Text(NSLocalizedString("LOGOUT", comment: "Settings")),
                    message: Text(NSLocalizedString("LOGOUT_QUESTION", comment: "Settings")),
                    primaryButton: .destructive(Text(NSLocalizedString("CANCEL", comment: "Action"))) {
                        viewModel.showingLogoutAlert = false
                    },
                    secondaryButton: .cancel(Text(NSLocalizedString("YES", comment: "Action"))) {
                        self.viewModel.logout.send()
                    }
                )
            }
            .textFieldAlert(
                title: "Delete",
                message: "Are you sure you want to delete?",
                textFields: [],
                actions: [
                    .init(
                        title: "Cancel",
                        closure: { _ in
                            viewModel.deleteHouse = false
                            viewModel.choosenHouseId = ""
                        }
                    ),
                    .init(
                        title: "Yes",
                        closure: { _ in
                            viewModel.onDeleteRoom.send(viewModel.choosenHouseId)
                            viewModel.choosenHouseId = ""
                        }
                    )
                ],
                isPresented: $viewModel.deleteRoom
            )
            .textFieldAlert(
                title: "Delete",
                message: "Are you sure you want to delete?",
                textFields: [],
                actions: [
                    .init(
                        title: "Cancel",
                        closure: { _ in
                            viewModel.choosenHouseId = ""
                        }
                    ),
                    .init(
                        title: "Add",
                        closure: { _ in
                            if !viewModel.choosenHouseId.isEmpty {
                                viewModel.onAddHouse.send(viewModel.choosenHouseId)
                                viewModel.choosenHouseId = ""
                            }
                        }
                    )
                ],
                isPresented: $viewModel.addHouse
            )
            .textFieldAlert(
                title: "Add House",
                textFields: [
                    .init(
                        text: $viewModel.choosenHouseId,
                        placeholder: "Write the name of the house"
                    )
                ],
                actions: [
                    .init(
                        title: "Cancel",
                        closure: { _ in
                            viewModel.choosenHouseId = ""
                        }
                    ),
                    .init(
                        title: "Add",
                        closure: { _ in
                            if !viewModel.choosenHouseId.isEmpty {
                                viewModel.onAddHouse.send(viewModel.choosenHouseId)
                                viewModel.choosenHouseId = ""
                            }
                        }
                    )
                ],
                isPresented: $viewModel.addHouse
            )
            .textFieldAlert(
                title: "Add Room",
                textFields: [
                    .init(
                        text: $viewModel.choosenHouseId,
                        placeholder: "Write the name of the room"
                    )
                ],
                actions: [
                    .init(
                        title: "Cancel",
                        closure: { _ in
                            viewModel.choosenHouseId = ""
                        }
                    ),
                    .init(
                        title: "Add",
                        closure: { _ in
                            if !viewModel.choosenHouseId.isEmpty {
                                viewModel.onAddRoom.send(viewModel.choosenHouseId)
                                viewModel.choosenHouseId = ""
                            }
                        }
                    )
                ],
                isPresented: $viewModel.addRoom
            )
        }
    }
}

enum SettingViews {
    case main
    case account
    case houses
    case rooms
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
