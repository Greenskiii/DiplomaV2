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
                    .shadow(color: .gray.opacity(0.4), radius: 20, x: 0, y: 20)
                    .padding()
                
                CustomTabView(selectedTab: $viewModel.selectedTab)
            }
            .frame(height: 90, alignment: .center)
            .padding(.horizontal, 30)
            .padding(.bottom, 15)
            
            if viewModel.addDeviceViewIsOpen {
                ZStack(alignment: .center) {
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .onTapGesture {
                            viewModel.onPressAddDevice.send()
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
            
            BottomSheetView(maxHeight: 550, isOpen: $viewModel.deviceDetailIsOpen) {
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
        .ignoresSafeArea()
    }
    
    func setMainView(viewModel: MainMenuViewModel) -> some View {
        return MainMenuView(viewModel: viewModel)
    }
    
    func setSettingsView(viewModel: SettingsViewModel) -> some View {
        SettingsView(viewModel: viewModel)
    }
}
