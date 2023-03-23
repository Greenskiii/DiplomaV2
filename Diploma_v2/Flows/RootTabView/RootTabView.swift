//
//  RootTabView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.03.2023.
//

import SwiftUI

struct RootTabView: View {
    @ObservedObject var viewModel: RootTabViewModel
    @State var isMenuShown = false

    var body: some View {
        ZStack(alignment: .top) {
            Color("TropicalBlue")
                .ignoresSafeArea()
            VStack {
                makeTopView()
                    .padding(.horizontal)
                    .padding(.top)

                TabView(selection: $viewModel.selectedTab) {
                    if let viewModel = viewModel.mainMenuViewModel {
                        setMainView(viewModel: viewModel).tag(TabType.main)

                    }
                    
                    if let viewModel = viewModel.settingsViewModel {
                        setSettingsView(viewModel: viewModel).tag(TabType.settings)
                    }
                }
            }
            HStack {
                if let choosenHouse = viewModel.house?.id {
                    HouseMenu(isMenuShown: $isMenuShown, choosenHouse: choosenHouse, houses: viewModel.housePreview, onChangeHouse: viewModel.onChangeHouse)
                        .padding()
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top)

            if viewModel.addDeviceViewIsOpen {
                ZStack(alignment: .center) {
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .onTapGesture {
                            viewModel.onPressAdddevice.send()
                        }
                        .ignoresSafeArea()
                    
                    AddDeviceView(
                        deviceId: $viewModel.newDeviceId,
                        onGoToScannerScreen: viewModel.onGoToScannerScreen,
                        onSaveNewDeviceId: viewModel.onSaveNewDeviceId
                    )
                    .frame(height: 150)
                    .padding()
                }
            }
            if viewModel.showErrorView {
                ErrorView(errorText: viewModel.errorText)
                    .frame(width: 225, height: 255)
                    .foregroundColor(.black)
                    .animation(.easeInOut(duration: 1), value: viewModel.showErrorView)
            }

            BottomSheetView(maxHeight: 600, isOpen: $viewModel.deviceDetailIsOpen) {
                if viewModel.deviceDetailIsOpen,
                   let deviceDetailsViewModel = viewModel.deviceDetailsViewModel {
                    DeviceDetailsView(viewModel: deviceDetailsViewModel)
                        .transition(.move(edge: .bottom))
                }
            }
            .ignoresSafeArea()
            .shadow(color: .gray, radius: 3, x: 2, y: 0)
            .onDisappear {
                viewModel.onTapDevice.send(nil)
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
                                .frame(width: 40, height: 40)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 25))
                                .foregroundColor(Color("Navy"))
                        }
                    }
                }
            }
        }
    }

    func setMainView(viewModel: MainMenuViewModel) -> some View {
        return MainMenuView(viewModel: viewModel)
            .tabItem {
                Label(NSLocalizedString("HOUSE", comment: "TapBar"), systemImage: "house")
            }
    }
    
    func setSettingsView(viewModel: SettingsViewModel) -> some View {
        SettingsView(viewModel: viewModel)
            .tabItem {
                Label(NSLocalizedString("SETTINGS", comment: "TapBar"), systemImage: "person")
            }
    }
}

enum TabType: Int {
    case main
    case settings
}

