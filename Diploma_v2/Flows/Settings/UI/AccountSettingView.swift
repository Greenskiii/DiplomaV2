//
//  AccountSettingView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 22.03.2023.
//

import SwiftUI

struct AccountSettingView: View {
    @Binding var settingView: SettingViews
    @Binding var userName: String
    @Binding var email: String

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

                Text(NSLocalizedString("ACCOUNT", comment: "Settings"))
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color("Navy"))
                Spacer()
            }


            ForEach(AccountSettings.allCases, id: \.self) { setting in
                HStack {
                    SettingsText(setting: setting)
                        .padding(.vertical)
                    switch setting {
                    case .name:
                        HStack {
                            TextField(NSLocalizedString("NAME", comment: "User"), text: $userName)
                            Spacer()
                        }
                    case .email:
                        HStack {
                            TextField(NSLocalizedString("EMAIL", comment: "User"), text: $email)
                            Spacer()
                        }
                    case .changePassword:
                        HStack {
                            Spacer()
                            Image(systemName: "greaterthan.circle")
                                .font(.title3)
                                .foregroundColor(Color("Navy"))
                        }
                        .padding(.horizontal)
                    }
                }
                
                if setting != AccountSettings.allCases.last {
                    Divider()
                }
            }
            Spacer()
        }
        .padding()
    }
}

