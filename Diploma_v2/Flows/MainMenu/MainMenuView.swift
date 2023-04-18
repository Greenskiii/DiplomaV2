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
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("LightGray"), Color("TropicalBlue")]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
                
                VStack {
                    makeTopView()
                        .padding(.horizontal)
                        .padding(.top)
                    if let house = viewModel.house {
                        makeRoomPreviewView(for: house)
                        if let room = house.rooms.first(where: { $0.id == viewModel.choosenRoomId }) {
                        ScrollView(.vertical) {
                            DevicesView(
                                devices: room.devices,
                                onPressAddDevice: viewModel.onPressAddDevice,
                                onTapDevice: viewModel.onTapDevice
                            )
                            .frame(height: geometry.size.height * 0.2)
                            .padding(.horizontal)
                            .padding(.top, 4)
                            
                                ValuesGridView(values: room.values.chunked(into: 3))
                                        .padding()
                            }
                        }
                    }
                }
                HStack {
                    if let choosenHouse = viewModel.house?.id {
                        HouseMenu(
                            isMenuShown: $viewModel.isMenuShown,
                            choosenHouse: choosenHouse,
                            houses: viewModel.housePreview,
                            onChangeHouse: viewModel.onChangeHouse
                        )
                            .padding()
                    }
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.top)
            }
            .edgesIgnoringSafeArea(.bottom)
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
                    RoomPreviewCard(
                        room: room,
                        isSelected: room.id == viewModel.choosenRoomId
                    )
                        .frame(minWidth: 150)
                        .padding(.vertical, 4)
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
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
