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
                        } else {
                            VStack {
                                Spacer()
                                Image(systemName: "house")
                                    .font(.system(size: 150))
                                    .padding(.bottom)
                                Text("Select a room to view more information")
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
            Image("MainTitle")
                .resizable()
                .frame(width: 125, height: 35)
            HStack(alignment: .bottom) {
                if !viewModel.housePreview.isEmpty {
                    Menu {
                        ForEach(viewModel.housePreview, id: \.self) { house in
                            Button {
                                viewModel.onChangeHouse.send(house.id)
                            } label: {
                                HStack {
                                    Text(house.name)
                                    Spacer()
                                    if viewModel.house?.id == house.id {
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
                    RoomPreviewCard(room: room, isSelected: room.id == viewModel.choosenRoom)
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
