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
        KeyboardView {
            GeometryReader { geometry in
                ZStack {
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
                                        email: $viewModel.email,
                                        passwordAlertIsShown: $viewModel.passwordAlertIsShown
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
                    }
                    .padding(.horizontal)
                    LoadingView()
                        .frame(width: 155, height: 175)
                        .isHidden(!viewModel.loadViewShown)
                    
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
                .textFieldAlert(
                    title: "Change Password",
                    textFields: [
                        .init(
                            text: $viewModel.newPassword,
                            placeholder: "Write a new password"
                        )
                    ],
                    actions: [
                        .init(
                            title: "Cancel",
                            closure: { _ in
                                viewModel.newPassword = ""
                                viewModel.passwordAlertIsShown = false
                            }
                        ),
                        .init(
                            title: "Save",
                            closure: { _ in
                                viewModel.onChangePassword.send()
                            }
                        )
                    ],
                    isPresented: $viewModel.passwordAlertIsShown
                )
            }
        } toolBar: {
            ZStack {
                EmptyView()
                if viewModel.settingView == .account && !viewModel.passwordAlertIsShown {
                    HStack {
                        Button {
                            viewModel.onSaveUserInfo.send()
                        } label: {
                            Text("Save")
                        }
                        Spacer()
                        Button {
                            viewModel.onCancelUserInfoChanges.send()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
        }
    }
}
