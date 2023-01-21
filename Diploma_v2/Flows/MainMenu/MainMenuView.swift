//
//  MainMenuView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI

struct MainMenuView: View {
    
    let authManager = AuthManager()
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                Color("TropicalBlue")
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .frame(width: 40)
                                .foregroundColor(Color("Royalblue"))
                            
                            VStack {
                                Rectangle()
                                    .frame(width: 20, height: 3)
                                    .foregroundColor(.white)
                                    .offset(y: 3)
                                Rectangle()
                                    .frame(width: 20, height: 3)
                                    .foregroundColor(.white)
                                Rectangle()
                                    .frame(width: 20, height: 3)
                                    .foregroundColor(.white)
                                    .offset(y: -3)
                            }
                        }
                        .padding(.trailing, 10)
                        .offset(y: -5)
                    }
                    Spacer()
                    
//                    Rectangle()
//                        .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
//                        
                    
                    RoundedRectangle(cornerRadius: 16)
                        .ignoresSafeArea()
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.9)
                        .offset(y: 10)
                }
                VStack {
                    Text("MainMenuView")
                    
                    Button {
                        authManager.logOut()
                    } label: {
                        Text("logOut")
                    }
                }
            }
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
