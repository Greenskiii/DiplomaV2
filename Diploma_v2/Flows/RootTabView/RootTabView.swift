//
//  RootTabView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.03.2023.
//

import SwiftUI

struct RootTabView: View {
    private enum Constants {
        enum TapBar {
            static let height: CGFloat = 90
            static let horizontalPadding: CGFloat = 30
            static let bottomPadding: CGFloat = 15
        }
        
        enum AddDeviceView {
            static let height: CGFloat = 150
        }
        
        enum ErrorView {
            static let height: CGFloat = 225
            static let width: CGFloat = 225
        }
        enum BottomSheetView {
            static let height: CGFloat = 550
        }
    }
    
    @ObservedObject var viewModel: RootTabViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            TabView(selection: $viewModel.selectedTab) {
                if let viewModel = viewModel.mainMenuViewModel {
                    setMainView(viewModel: viewModel).tag(TabType.main)
                }
                
                if let viewModel = viewModel.settingsViewModel {
                    setSettingsView(viewModel: viewModel).tag(TabType.settings)
                }
            }
            
            ZStack {
                Capsule()
                    .fill(.white)
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    .padding()
                
                CustomTabView(selectedTab: $viewModel.selectedTab)
            }
            .frame(height: Constants.TapBar.height, alignment: .center)
            .padding(.horizontal, Constants.TapBar.horizontalPadding)
            .padding(.bottom, Constants.TapBar.bottomPadding)
            
            ZStack(alignment: .center) {
                VisualEffectView(effect: UIBlurEffect(style: .light))
                    .onTapGesture {
                        withAnimation {
                            viewModel.onPressAddDevice.send()
                        }
                    }
                    .ignoresSafeArea()
                
                AddDeviceView(
                    deviceId: $viewModel.newDeviceId,
                    onGoToScannerScreen: viewModel.onGoToScannerScreen,
                    onSaveNewDeviceId: viewModel.onSaveNewDeviceId
                )
                .frame(height: Constants.AddDeviceView.height)
                .padding()
            }
            .zIndex(.infinity)
            .transition(.opacity)
            .isHidden(!viewModel.addDeviceViewIsOpen)
            
            BottomSheetView(maxHeight: Constants.BottomSheetView.height,
                            isOpen: $viewModel.deviceDetailIsOpen) {
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
            
            VStack(alignment: .center) {
                Spacer()
                ErrorView(errorText: viewModel.errorText)
                    .frame(width: Constants.ErrorView.width,
                           height: Constants.ErrorView.height)
                    .foregroundColor(.black)
                Spacer()
            }
            .transition(.opacity)
            .isHidden(!viewModel.showErrorView)
            
            VStack(alignment: .center) {
                Spacer()
                LoadingView()
                    .foregroundColor(.black)
                Spacer()
            }
            .transition(.opacity)
            .isHidden(!viewModel.loadViewShown)
        }
        .ignoresSafeArea()
    }
    
    func setMainView(viewModel: MainMenuViewModel) -> some View {
        return MainMenuView(viewModel: viewModel)
    }
    
    func setSettingsView(viewModel: SettingsViewModel) -> some View {
        SettingsView(viewModel: viewModel)
    }
}
