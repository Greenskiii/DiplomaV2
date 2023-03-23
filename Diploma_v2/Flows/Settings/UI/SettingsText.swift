//
//  SettingsText.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 22.03.2023.
//

import SwiftUI

struct SettingsText: View {
    let setting: SettingProtocol
    
    var body: some View {
        HStack {
            if let imageName = setting.imageName {
                Image(systemName: imageName)
                    .font(.title3)
                    .foregroundColor(Color("Navy"))
            }
            if !setting.title.isEmpty {
                Text(setting.title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(Color("Navy"))
                Spacer()
            }

            if setting.hasNextPage {
                Image(systemName: "greaterthan.circle")
                    .font(.title3)
                    .foregroundColor(Color("Navy"))
            }
        }
    }
}
