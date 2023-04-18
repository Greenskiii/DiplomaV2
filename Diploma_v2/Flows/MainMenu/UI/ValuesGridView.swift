//
//  ValuesGridView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 14.04.2023.
//

import SwiftUI

struct ValuesGridView: View {
    let values: [[Value]]
    
    var body: some View {
        VStack {
            ForEach(values, id: \.self) { values1 in
                HStack(spacing: 25) {
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
                    ZStack {
                        Image(systemName: value.imageSystemName)
                            .font(.system(size: 22))
                            .foregroundColor(Color("Royalblue"))
                            .padding(12)
                            .background(Circle().foregroundColor(Color("LightGray")))
                    }
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
                .frame(width: 5)
                .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color.white)
            .shadow(color: .gray, radius: 3, x: 2, y: 2)
        )
        .foregroundColor(Color("Royalblue"))
        .padding(.bottom)
    }
    
    func makeValueCard(value: Value) -> some View {
        ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(Color.white)
                            .shadow(color: .gray, radius: 3, x: 2, y: 2)
            HStack {
                VStack(alignment: .leading) {
                    Image(systemName: value.imageSystemName)
                        .font(.system(size: 22))
                        .foregroundColor(Color("Royalblue"))
                        .padding(12)
                        .background(Circle().foregroundColor(Color("LightGray")))
                    
                    Text(value.name)
                        .font(.headline)
                    
                    Text(value.value)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.vertical)
                .padding(.leading)
                Spacer()
            }

            Circle()
                .foregroundColor(value.valueState.color)
                .frame(width: 5)
                .padding()
        }
        .foregroundColor(Color("Royalblue"))
    }
}
