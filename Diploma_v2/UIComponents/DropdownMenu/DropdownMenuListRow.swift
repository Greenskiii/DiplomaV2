//
//  DropdownMenuListRow.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 27.01.2023.
//

import SwiftUI

struct DropdownMenuListRow: View {
    let option: String
    
    let onSelectedAction: (_ option: String) -> Void
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.onSelectedAction(option)
            }
        }) {
            Text(option)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(.black)
        .padding(.vertical, 5)
        .padding(.horizontal)
    }
}

//struct DropdownMenuListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        DropdownMenuListRow(option: DropdownMenuOption.testSingleMonth, onSelectedAction: { _ in })
//    }
//}

