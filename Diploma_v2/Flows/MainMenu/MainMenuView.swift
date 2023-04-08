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
                    if let house = viewModel.house {
                        makeRoomPreviewView(for: house)
                        if let room = viewModel.shownRoom {
                            makeDevicesGrid(for: room)
                                .frame(minHeight: geometry.size.height * 0.75)
                                .padding(.horizontal)
                                .padding(.bottom)
                        } else {
                            VStack {
                                Spacer()
                                Image(systemName: "house")
                                    .font(.system(size: 150))
                                    .padding(.bottom)
                                Text(NSLocalizedString("SELECT_ROOM", comment: "Main Menu"))
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .foregroundColor(.gray)
                        }
                    }
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
                    RoomPreviewCard(room: room, isSelected: room.id == viewModel.choosenRoomId)
                        .frame(width: 150)
                        .padding(.bottom)
                        .onTapGesture {
                            withAnimation {
                                viewModel.onChooseRoom.send(room.id)
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }

    func makeDevicesGrid(for room: Room) -> some View {
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

                        Text(NSLocalizedString(room.name == "Favorite" ? "NO_DEVICES_FAVORITE" : "NO_DEVICES", comment: "Main Menu") )
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    DevicesGridView(
                        devices: room.devices,
                        onTapDevice: viewModel.onTapDevice,
                        onTapFavorite: viewModel.onTapFavorite
                    )
                        .padding(.bottom)
                        .animation(.easeInOut(duration: 1))
                }
            
            if room.name != "Favorite" {
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
