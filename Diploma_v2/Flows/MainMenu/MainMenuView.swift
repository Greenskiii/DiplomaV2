//
//  MainMenuView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var viewModel: MainMenuViewModel
    @State var selection = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("TropicalBlue")
                    .ignoresSafeArea()
                VStack {
                    makeTopView()
                        .padding()
                    if let house = viewModel.house {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(house.rooms, id: \.self) { room in
                                    RoomPreviewCard(room: room, isSelected: room.name == viewModel.choosenRoom)
                                        .frame(width: 150)
                                        .onTapGesture {
                                            withAnimation {
                                                viewModel.onChooseRoom.send(room.name)
                                            }
                                        }
                                }
                            }
                            .padding(.bottom)
                            .padding(.horizontal)
                        }
                        if let room = viewModel.shownRoom {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundColor(.white)
                                ZStack(alignment: .bottom) {
                                    DevicesGridView(devices: room.devices)
                                    Button {
                                        
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundColor(Color("Navy"))
//                                                .opacity(0.8)

                                            Image(systemName: "plus")
                                                .font(.system(size: 30))
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                        .frame(height: 75)
                                    }
                                }
                            }
                            .frame(height: geometry.size.height * 0.7)
                            .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
    }

    func makeTopView() -> some View {
        
        ZStack(alignment: .bottom) {
            Image("MainTitle")
                .resizable()
                .frame(width: 125, height: 35)
            HStack(alignment: .bottom) {
                if !viewModel.houses.isEmpty {
                    Menu {
                        ForEach(viewModel.houses, id: \.self) { house in
                            Button {
                                viewModel.choosenHouse = house
                                viewModel.onChangeHouse.send(house)
                            } label: {
                                HStack {
                                    Text(house)
                                    Spacer()
                                    if viewModel.choosenHouse == house {
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
                                Image(systemName: "arrowtriangle.down.fill")
                                    .font(.system(size: 10))
                            }
                            .foregroundColor(Color("Navy"))
                        }
                    }
                }
                Spacer()
                if let user = viewModel.user,
                   !user.imageUrl.isEmpty {
                    ImageView(withURL: user.imageUrl)
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
