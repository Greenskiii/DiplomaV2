//
//  DeviceDetailsView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 07.02.2023.
//

import SwiftUI
import Combine

struct DeviceDetailsView: View {
    @ObservedObject var viewModel: DeviceDetailsViewModel
    
    @State var isChaned: Bool = false
    var body: some View {
        ZStack {
            Color("TropicalBlue")
            VStack {
                createEditButtons()
                    .padding(.horizontal)
                    .isHidden(!viewModel.editViewIsShow)
                
                createDeviceInfoView()
                createDeviceLocationView()
                
                Button {
                    withAnimation {
                        viewModel.onDeleteDevice.send()
                    }
                } label: {
                    Text(NSLocalizedString("DELETE", comment: "Action"))
                        .foregroundColor(.red)
                        .padding(.bottom)
                }
                .isHidden(viewModel.editViewIsShow)
            }
        }
    }
    
    private func createEditButtons() -> some View {
        HStack {
            Button {
                withAnimation {
                    viewModel.onSaveChanges.send()
                }
            } label: {
                Text(NSLocalizedString("SAVE", comment: "Action"))
            }
            .isHidden(viewModel.selectedRoomId.isEmpty)
            Spacer()
            Button {
                withAnimation {
                    viewModel.onCancelChanges.send()
                }
            } label: {
                Text(NSLocalizedString("CANCEL", comment: "Action"))
                    .foregroundColor(.red)
            }
        }
    }
    
    private func createDeviceInfoView() -> some View {
        VStack {
            UrlImageView(urlString: viewModel.device.image)
                .frame(width: 150, height: 150)
            Text(viewModel.device.name)
                .font(.title)
            Text("id:\(viewModel.device.id)")
                .font(.caption)
            HStack {
                ForEach(viewModel.device.values, id: \.self) { value in
                    VStack {
                        Image(systemName: value.imageSystemName)
                            .frame(width: 12, height: 12)
                        Text(value.value)
                    }
                    .padding()
                }
            }
        }
    }
    
    private func createDeviceLocationView() -> some View {
        VStack {
            Menu {
                ForEach(viewModel.housePreview, id: \.self) { house in
                    Button {
                        viewModel.onChangeHouse.send(house.id)
                    } label: {
                        HStack {
                            Text(house.name)
                            Spacer()
                            if viewModel.selectedHouseId == house.id {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10))
                            }
                        }
                    }
                }
            } label: {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    if let house = viewModel.housePreview.first(where: { $0.id == viewModel.selectedHouseId }) {
                        Text(house.name)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.top)
            }
            
            Menu {
                ForEach(viewModel.rooms, id: \.self) { room in
                    Button {
                        viewModel.onChangeRoom.send(room.id)
                    } label: {
                        HStack {
                            Text(room.name)
                            Spacer()
                            if viewModel.selectedRoomId == room.id {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10))
                            }
                        }
                    }
                }
            } label: {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    if let room = viewModel.rooms.first(where: { $0.id == viewModel.selectedRoomId }) {
                        Text(room.name)
                            .foregroundColor(viewModel.selectedRoomId.isEmpty ? .gray : .black)
                            .padding()
                    } else {
                        Text(NSLocalizedString("SELECT_ROOM", comment: "Device View"))
                            .foregroundColor(viewModel.selectedRoomId.isEmpty ? .gray : .black)
                            .padding()
                    }
                }
                .frame(height: 50)
                .padding()
            }
        }
    }
}


