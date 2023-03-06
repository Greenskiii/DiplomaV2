//
//  MainMenuView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI
import Combine

struct MainMenuView: View {
    @ObservedObject var viewModel: MainMenuViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color("TropicalBlue")
                    .ignoresSafeArea()

                VStack {
                    makeTopView()
                        .padding(.horizontal)
                    if let house = viewModel.house {
                        makeRoomPreviewView(for: house)
                        if let room = viewModel.shownRoom {
                            makeDevicesGrid(for: room)
                                
                                .frame(minHeight: geometry.size.height * 0.75)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                    }
                }
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
    }

    func makeTopView() -> some View {
        ZStack(alignment: .bottom) {
            Image("MainTitle")
                .resizable()
                .frame(width: 125, height: 35)
            HStack(alignment: .bottom) {
                if !viewModel.housesId.isEmpty {
                    Menu {
                        ForEach(viewModel.housesId, id: \.self) { id in
                            Button {
                                viewModel.onChangeHouse.send(id)
                            } label: {
                                HStack {
                                    Text(id)
                                    Spacer()
                                    if viewModel.house?.name == id {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 10))
                                    }
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            HStack {
                                Text(viewModel.house?.name ?? "")
                                    .bold()
                                    .frame(maxWidth: 85, maxHeight: 20)
                                Image(systemName: "arrowtriangle.down.fill")
                                    .font(.system(size: 10))
                            }
                            .foregroundColor(Color("Navy"))
                        }
                    }
                }
                Spacer()
                HStack {
                    if let user = viewModel.user {
                        Text(user.name)
                            .foregroundColor(Color("Navy"))
                        
                        if !user.imageUrl.isEmpty {
                            ImageView(withURL: user.imageUrl)
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

    func makeRoomPreviewView(for house: House) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(house.rooms, id: \.self) { room in
                    RoomPreviewCard(room: room, isSelected: room.name == viewModel.choosenRoom)
                        .frame(width: 150)
                        .onTapGesture {
                            withAnimation {
                                viewModel.onChooseRoom.send(room.id)
                            }
                        }
                        .padding(.vertical)
                }
            }
            .padding(.horizontal)
        }
    }

    func makeDevicesGrid(for room: House.Room) -> some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 3, x: 2, y: 2)

                if room.devices.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "externaldrive.badge.wifi")
                            .foregroundColor(.gray)
                            .font(.system(size: 100))
                            .padding()

                        Text(room.id == "Favorite" ? "There are no devices yet" : "There are no devices yet\nСlick the button below to add")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    DevicesGridView(devices: room.devices, onTapDevice: viewModel.onTapDevice, onTapFavorite: viewModel.onTapFavorite)
                        .padding(.bottom)
                }
            
            if room.id != "Favorite" {
                Button {
                    viewModel.onPressAdddevice.send()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("Navy"))
                        
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(height: 70)
                }
            }
        }
    }
}
