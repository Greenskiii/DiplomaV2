//
//  RoomsSettingView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 07.04.2023.
//

import SwiftUI
import Combine

struct RoomsSettingView: View {
    @State var editMode = false
    @Binding var settingView: SettingViews
    @Binding var deleteRoom: Bool
    @Binding var addRoom: Bool
    @Binding var choosenHouseId: String
    
    var rooms: [Room]
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        self.settingView = .houses
                    }
                } label: {
                    Image(systemName: "chevron.backward.circle")
                        .foregroundColor(Color("Navy"))
                        .font(.title2)
                }
                Text("Rooms")
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
                ForEach(rooms, id: \.self) { room in
                    if room.name != "Favorite" {
                        Button {
                            if editMode {
                                choosenHouseId = room.id
                                deleteRoom.toggle()
                            } else {
                                print("go to devices")
                            }
                        } label: {
                            HStack {
                                Text(room.name)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("Navy"))
                                Spacer()
                            }
                            .padding(.vertical)
                        }
                        if room != rooms.last {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
            
            Spacer()
            if editMode {
                Button {
                    withAnimation {
                        addRoom.toggle()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("Navy"))
                        
                        Text("Add Room")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(height: 70)
                }
            }
        }
        .padding()
    }
}
