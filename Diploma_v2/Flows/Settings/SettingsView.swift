//
//  SettingsView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State var editMode = false
    
//    init(viewModel: SettingsViewModel) {
//        self.viewModel = viewModel
//            UITableView.appearance().backgroundColor =  UIColor( Color("TropicalBlue"))
//        }
    
    var body: some View {

            Form {
                Section(header: Text("PROFILE")) {
                    Text("Username")
//                    Toggle(isOn: $isPrivate) {
//                        Text("Private Account")
//                    }
                }
            }
            .onAppear { // ADD THESE AFTER YOUR FORM VIEW
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear { // CHANGE BACK TO SYSTEM's DEFAULT
                UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
            .background(Color.yellow)

    }
    
    func makeTopView() -> some View {
        ZStack(alignment: .bottom) {
            Image("MainTitle")
                .resizable()
                .frame(width: 125, height: 35)
            HStack {
                
                if editMode {
                    Button {
                        withAnimation {
                            self.editMode = false
                        }
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }
                } else {
                    Menu {
                        ForEach(viewModel.housePreview, id: \.self) { house in
                            Button {
                                viewModel.onChangeHouse.send(house.id)
                            } label: {
                                HStack {
                                    Text(house.name)
                                    Spacer()
                                    if viewModel.house?.name == house.id {
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
                if editMode {
                    Button {
                        withAnimation {
                            self.editMode = false
                        }
                    } label: {
                        Text("Save")
                    }
                } else {
                    Button {
                        withAnimation {
                            self.editMode = true
                        }
                    } label: {
                        Text("Edit")
                    }
                }
            }
        }
    }
}


extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
