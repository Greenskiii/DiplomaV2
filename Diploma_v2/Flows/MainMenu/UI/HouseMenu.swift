//
//  HouseMenu.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 21.03.2023.
//

import SwiftUI
import Combine

struct HouseMenu: View {
    @Binding var isMenuShown: Bool
    var choosenHouse: String
    var houses: [HousePreview]
    var onChangeHouse: PassthroughSubject<String, Never>
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Spacer()
                    .frame(height: 15)
                ForEach(houses, id: \.self) { house in
                    VStack {
                        HStack {
                            Text(house.name)
                                .frame(width: 100)
                                .padding(.horizontal)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            if house.id == choosenHouse {
                                Image(systemName: "checkmark")
                                    .padding(.horizontal)
                            }
                        }
                        .foregroundColor(Color("Navy"))
                        .onTapGesture {
                            withAnimation {
                                onChangeHouse.send(house.id)
                                isMenuShown = false
                            }
                        }
                        if house != houses.last {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.gray)
                                .frame(height: 1)
                                .padding(.horizontal)
                        }
                    }
                }
                Spacer()
                    .frame(height: 15)
            }
            .padding(2)
            .frame(width: 200)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color("LightGray")).shadow(color: .gray, radius: 3, x: 2, y: 2))
            .transition(.scale(scale: 0, anchor: .topLeading))
            .isHidden(!isMenuShown)
            
            button
        }
        .padding(.horizontal, 4)
        
    }
    
    var button: some View {
        Image(systemName: isMenuShown ? "xmark.circle.fill" : "house.circle.fill")
            .foregroundColor(Color("Navy"))
            .font(.system(size: 30))
            .foregroundColor(.white)
            .rotationEffect(Angle.degrees(isMenuShown ? 360 : 0))
            .padding(.horizontal, 7)
            .offset(x: -20, y: -20)
        
            .onTapGesture {
                withAnimation {
                    isMenuShown.toggle()
                }
            }
    }
}

