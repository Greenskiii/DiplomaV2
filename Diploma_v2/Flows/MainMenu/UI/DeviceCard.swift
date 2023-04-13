//
//  DeviceCard.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.02.2023.
//

import SwiftUI

struct DeviceCard: View {
    let device: Device
    let isFavoriteRoom: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("BlueShark"))
                .opacity(0.5)
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    UrlImageView(urlString: device.image)
                        .frame(width: 50, height: 50)
                    
                    VStack {
                        Text(device.name)
                            .font(.system(size: 16))
                        if isFavoriteRoom {
                            Text(device.room)
                                .font(.system(size: 12))
                        }
                    }
                }
                
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(device.values, id: \.self) { value in
                        makeValueView(value: value)
                            .frame(width: 60, height: 60)
                    }
                }
            }
            .padding()
            
        }
        .animation(.easeInOut(duration: 2))
    }
    
    private func makeValueView(value: Value) -> some View {
        ZStack {
            Circle()
                .trim(from: 0.5, to: 1)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .fill(
                    AngularGradient(gradient: Gradient(colors: [Color("Navy"), Color("LightGray"), Color("LightGray"), Color("LightGray"), Color("Royalblue"), Color("Navy")]), center: .center)
                )
            Circle()
                .trim(
                    from: getPosition(minValue: value.minValue, maxValue: value.maxValue, currentValue: value.value) - 0.00125,
                    to: getPosition(minValue: value.minValue, maxValue: value.maxValue, currentValue: value.value) + 0.00125
                )
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .fill(
                    AngularGradient(gradient: Gradient(colors: [Color("LightGray"), Color("Navy"), Color("Navy"), Color("Navy"), Color("Royalblue"), Color("LightGray")]), center: .center)
                )
            
            VStack {
                Text(value.value)
                    .font(.system(size: 14))
                    .padding(.bottom, 2)
                
                Image(systemName: value.imageSystemName)
            }
        }
    }
    
    private func getPosition(minValue: String, maxValue: String, currentValue: String) -> CGFloat {
        let newStr = currentValue.compactMap { char in
            if Float(String(char)) != nil {
                return char
            } else if char == "." {
                return char
            }
            return nil
        }
        guard let max = Float(maxValue),
              let min = Float(minValue),
              let value = Float(String(newStr)) else {
            return 0
        }
        
        let x = 0.5 + ((0.5 / (max - min)) * (value - min))
        return CGFloat(x)
    }
}
