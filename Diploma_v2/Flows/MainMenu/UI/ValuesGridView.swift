//
//  ValuesGridView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 14.04.2023.
//

import SwiftUI

struct ValuesGridView: View {
    private enum Constants {
        static let spacing: CGFloat = 25
        static let imageFont: Font = .system(size: 22)
        static let imagePadding: CGFloat = 12
        static let cornerRadius: CGFloat = 16
        static let circleWidth: CGFloat = 5
    }
    
    let values: [[Value]]
    
    var body: some View {
        VStack {
            ForEach(values, id: \.self) { values1 in
                HStack(spacing: Constants.spacing) {
                    ForEach(values1, id: \.self) { value in
                        if values1.count == 3 && value != values1.last {
                            makeValueCard(value: value)
                        } else if values1.count < 3 {
                            makeValueCard(value: value)
                        }
                    }
                }
                .padding(.bottom)
                if values1.count == 3,
                   let value = values1.last {
                    makeThirdValueCard(value: value)
                }
            }
        }
    }
    
    func makeThirdValueCard(value: Value) -> some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                Image(systemName: value.imageSystemName)
                    .font(Constants.imageFont)
                    .foregroundColor(Color("Royalblue"))
                    .padding(Constants.imagePadding)
                    .background(
                        Circle()
                            .foregroundColor(Color("LightGray"))
                    )
                Text(value.name)
                    .font(.headline)
                    .padding(.leading)
                Text(value.value)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            
            Circle()
                .foregroundColor(value.valueState.color)
                .frame(width: Constants.circleWidth)
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .foregroundColor(Color.white)
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
        )
        .foregroundColor(Color("Royalblue"))
        .padding(.bottom)
    }
    
    func makeValueCard(value: Value) -> some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                VStack(alignment: .leading) {
                    Image(systemName: value.imageSystemName)
                        .font(Constants.imageFont)
                        .foregroundColor(Color("Royalblue"))
                        .padding(Constants.imagePadding)
                        .background(
                            Circle()
                                .foregroundColor(Color("LightGray"))
                        )
                    
                    Text(value.name)
                        .font(.headline)
                    
                    Text(value.value)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding([.vertical, .leading])
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundColor(Color.white)
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
            )
            
            Circle()
                .foregroundColor(value.valueState.color)
                .frame(width: Constants.circleWidth)
                .padding()
        }
        .foregroundColor(Color("Royalblue"))
    }
}
