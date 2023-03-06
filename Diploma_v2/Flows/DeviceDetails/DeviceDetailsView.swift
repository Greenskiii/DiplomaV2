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
                    Text("Delete")
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
                Text("Save")
            }
            Spacer()
            Button {
                withAnimation {
                    viewModel.onCancelChanges.send()
                }
            } label: {
                Text("Cancel")
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
                ForEach(viewModel.housesId, id: \.self) { house in
                    Button {
                        viewModel.onChangeHouse.send(house)
                    } label: {
                        HStack {
                            Text(house)
                            Spacer()
                            if viewModel.selectedHouseId == house {
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
                    Text(viewModel.selectedHouseId)
                        .foregroundColor(.black)
                        .padding()
                }
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.top)
            }

            Menu {
                ForEach(viewModel.rooms, id: \.self) { room in
                    Button {
                        viewModel.onChangeRoom.send(room)
                    } label: {
                        HStack {
                            Text(room)
                            Spacer()
                            if viewModel.selectedRoomId == room {
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
                    
                    Text(viewModel.selectedRoomId.isEmpty ? "Select the room" : viewModel.selectedRoomId)
                        .foregroundColor(viewModel.selectedRoomId.isEmpty ? .gray : .black)
                        .padding()
                }
                .frame(height: 50)
                .padding()
            }
        }
    }
}


