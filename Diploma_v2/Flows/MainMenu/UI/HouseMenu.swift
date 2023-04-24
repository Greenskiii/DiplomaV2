//
//  HouseMenu.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 21.03.2023.
//

import SwiftUI
import Combine

struct HouseMenu: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 8
        static let textWidth: CGFloat = 100
        static let verticalPadding: CGFloat = 15
        static let width: CGFloat = 200
        static let horizontalPadding: CGFloat = 4
        
        enum Image {
            static let font: Font = .system(size: 30)
            static let horizontalPadding: CGFloat = 7
            static let offset: CGFloat = -20
        }
    }
    
    @Binding var isMenuShown: Bool
    var choosenHouse: String
    var houses: [HousePreview]
    var onChangeHouse: PassthroughSubject<String, Never>
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                ForEach(houses, id: \.self) { house in
                    VStack {
                        HStack {
                            Text(house.name)
                                .frame(width: Constants.textWidth)
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
                            Divider()
                                .padding(.horizontal)
                        }
                    }
 
                }
            }
            .padding(.vertical, Constants.verticalPadding)
            .frame(width: Constants.width)
            .background(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill(Color("LightGray"))
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
            )
            .transition(.scale(scale: 0, anchor: .topLeading))
            .isHidden(!isMenuShown)
            
            Image(systemName: isMenuShown ? "xmark.circle.fill" : "house.circle.fill")
                .foregroundColor(Color("Navy"))
                .font(Constants.Image.font)
                .foregroundColor(.white)
                .rotationEffect(Angle.degrees(isMenuShown ? 360 : 0))
                .padding(.horizontal, Constants.Image.horizontalPadding)
                .offset(x: Constants.Image.offset, y: Constants.Image.offset)
                .onTapGesture {
                    withAnimation {
                        isMenuShown.toggle()
                    }
                }
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

