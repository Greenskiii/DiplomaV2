//
//  HousesSettingsView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 22.03.2023.
//

import SwiftUI
import Combine

struct HousesSettingsView: View {
    private enum Constants {
        enum AddHouseButton {
            static let cornerRadius: CGFloat = 8
            static let height: CGFloat = 70
        }
    }
    
    @State var editMode = false
    @Binding var settingView: SettingViews
    @Binding var deleteHouse: Bool
    @Binding var choosenHouseId: String
    @Binding var addHouse: Bool
    var onGoToRoomsSettings: PassthroughSubject<String, Never>
    var houses: [HousePreview]
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        self.settingView = .main
                    }
                } label: {
                    Image(systemName: "chevron.backward.circle")
                        .foregroundColor(Color("Navy"))
                        .font(.title2)
                }
                Text("Houses")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color("Navy"))
                Spacer()
                
                Button(editMode ? "Done" : "Edit") {
                    withAnimation {
                        self.editMode.toggle()
                    }
                }
            }
            
            VStack {
                ForEach(houses, id: \.self) { house in
                    Button {
                        withAnimation {
                            if editMode {
                                choosenHouseId = house.id
                                deleteHouse.toggle()
                            } else {
                                onGoToRoomsSettings.send(house.id)
                            }
                        }
                    } label: {
                        HStack {
                            Text(house.name)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(Color("Navy"))
                            Spacer()
                            Image(systemName: editMode ? "minus.circle.fill" : "greaterthan.circle")
                                .font(.title3)
                                .foregroundColor(editMode ? Color.red : Color("Navy"))
                        }
                        .padding(.vertical)
                    }
                    if house != houses.last {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
            
            Spacer()
            if editMode {
                Button {
                    withAnimation {
                        addHouse.toggle()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.AddHouseButton.cornerRadius)
                            .foregroundColor(Color("Navy"))
                        
                        Text("Add house")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(height: Constants.AddHouseButton.height)
                }
            }
        }
        .padding()
    }
}
