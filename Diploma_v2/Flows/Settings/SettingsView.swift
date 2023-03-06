//
//  SettingsView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            Color("TropicalBlue")
                .ignoresSafeArea()
            Text("Settings")
        }
    }
}

