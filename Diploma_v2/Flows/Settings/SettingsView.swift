//
//  SettingsView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import SwiftUI

struct SettingsView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let loadingViewHeight: CGFloat = 175
        static let loadingViewWidth: CGFloat = 155
        static let horizontalPadding: CGFloat = 10
        
        enum TopView {
            static let imageHeight: CGFloat = 40
            static let imageWidth: CGFloat = 40
            static let font: Font = .system(size: 25)
        }
    }
    
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        KeyboardView {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color("LightGray"), Color("TropicalBlue")]),
                                           startPoint: .top,
                                           endPoint: .bottom)
                        )
                        .ignoresSafeArea()
                    VStack {
                        makeTopView()
                            .padding(.top)
                        HStack {
                            Text(NSLocalizedString("SETTINGS", comment: "Settings"))
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(Color("Navy"))
                            Spacer()
                        }
                        .padding()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: Constants.cornerRadius)
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
                        .frame(minHeight: geometry.size.height * 0.7)
                        .padding(.bottom)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        if let choosenHouse = viewModel.house?.id {
                            HouseMenu(isMenuShown: $viewModel.isMenuShown, choosenHouse: choosenHouse, houses: viewModel.housePreview, onChangeHouse: viewModel.onChangeHouse)
                                .padding()
                        }
                        Spacer()
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .padding(.top)
                    
                    LoadingView()
                        .frame(width: Constants.loadingViewWidth,
                               height: Constants.loadingViewHeight)
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
                            Text(NSLocalizedString("SAVE", comment: "Action"))
                        }
                        Spacer()
                        Button {
                            viewModel.onCancelUserInfoChanges.send()
                        } label: {
                            Text(NSLocalizedString("CANCEL", comment: "Action"))
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
        }
    }
    
    func makeTopView() -> some View {
        ZStack(alignment: .bottom) {
            if let choosenHouse = viewModel.house?.name {
                Text(choosenHouse)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color("Navy"))
                
            }
            HStack(alignment: .bottom) {
                Spacer()
                HStack {
                    if let user = viewModel.user {
                        Text(user.name)
                            .foregroundColor(Color("Navy"))
                        
                        if !user.imageUrl.isEmpty {
                            UrlImageView(urlString: user.imageUrl)
                                .clipShape(Circle())
                                .frame(width: Constants.TopView.imageWidth,
                                       height: Constants.TopView.imageHeight)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(Constants.TopView.font)
                                .foregroundColor(Color("Navy"))
                        }
                    }
                }
            }
        }
    }
}
