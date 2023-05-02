//
//  DeviceDetailsView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 07.02.2023.
//

import SwiftUI
import Combine

struct DeviceDetailsView: View {
    private enum Constants {
        static let backgroundColor: String = "TropicalBlue"
        static let height: CGFloat = 50
        
        enum DeviceInfoView {
            static let imageHeight: CGFloat = 150
            static let imageWidth: CGFloat = 150
            static let valueImageHeight: CGFloat = 12
            static let valueImageWidth: CGFloat = 12
        }
        
        enum DeviceLocationView {
            static let cornerRadius: CGFloat = 16
            static let checkmarkFont: Font = .system(size: 10)
        }
    }
    
    @ObservedObject var viewModel: DeviceDetailsViewModel
    @State var isChaned: Bool = false
    
    var body: some View {
        ZStack {
            Color(Constants.backgroundColor)
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
                .frame(width: Constants.DeviceInfoView.imageWidth,
                       height: Constants.DeviceInfoView.imageHeight)
            Text(viewModel.device.name)
                .font(.title)
            Text("id:\(viewModel.device.id)")
                .font(.caption)
            HStack {
                ForEach(viewModel.device.values, id: \.self) { value in
                    VStack {
                        Image(systemName: value.imageSystemName)
                            .frame(width: Constants.DeviceInfoView.valueImageWidth,
                                   height: Constants.DeviceInfoView.valueImageHeight)
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
                                    .font(Constants.DeviceLocationView.checkmarkFont)
                            }
                        }
                    }
                }
            } label: {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Constants.DeviceLocationView.cornerRadius)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    if let house = viewModel.housePreview.first(where: { $0.id == viewModel.selectedHouseId }) {
                        Text(house.name)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                .frame(height: Constants.height)
                .padding([.horizontal, .top])
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
                                    .font(Constants.DeviceLocationView.checkmarkFont)
                            }
                        }
                    }
                }
            } label: {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Constants.DeviceLocationView.cornerRadius)
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
                .frame(height: Constants.height)
                .padding()
            }
        }
    }
}
