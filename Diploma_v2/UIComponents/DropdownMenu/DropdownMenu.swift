//
//  DropdownMenu.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 27.01.2023.
//

import SwiftUI

struct DropdownMenu: View {
    @State private var isOptionsPresented: Bool = false
    
    @Binding var selectedOption: String
    
    let placeholder: String
    
    let options: [RoomType]
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.isOptionsPresented.toggle()
            }
        }) {
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, lineWidth: 2)

                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                }
                .frame(height: !isOptionsPresented ? CGFloat(32) :
                        CGFloat(self.options.count * 34)
                )

                            VStack {
                                if self.isOptionsPresented {
                                    Spacer(minLength: 60)
                                    DropdownMenuList(options: self.options) { option in
                                        self.isOptionsPresented = false
                                        self.selectedOption = option
                                    }
                                    .offset(y: -10)
                                }
                            }
                            .foregroundColor(.white)

                HStack {
                    Text(selectedOption.isEmpty ? placeholder : selectedOption)
                        .fontWeight(.medium)
                        .foregroundColor(selectedOption.isEmpty ? .gray : .black)
                    
                    Spacer()
                    
                    Image(systemName: self.isOptionsPresented ? "chevron.up" : "chevron.down")
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                .padding(
                    .bottom, self.isOptionsPresented
                    ? CGFloat(self.options.count * 32) > 300
                        ? 300
                        : CGFloat(self.options.count * 32) + 30
                    : 0
                )
            }
        }
        .padding()
        .padding(.horizontal)
                .padding(
                    .bottom, self.isOptionsPresented
                    ? CGFloat(self.options.count * 32) > 300
                        ? 300 + 30
                        : CGFloat(self.options.count * 32) + 30
                    : 0
                )
    }
}

//struct DropdownMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        DropdownMenu(
//            selectedOption: .constant(nil),
//            placeholder: "Select your birth month",
//            options: DropdownMenuOption.testAllMonths
//        )
//    }
//}
