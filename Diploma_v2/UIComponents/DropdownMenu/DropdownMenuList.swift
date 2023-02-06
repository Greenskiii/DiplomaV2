//
//  DropdownMenuList.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 27.01.2023.
//

import SwiftUI

struct DropdownMenuList: View {
    let options: [RoomType]
    
    let onSelectedAction: (_ option: String) -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 2)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 2) {
                    ForEach(options, id: \.self) { option in
                        DropdownMenuListRow(option: option.image, onSelectedAction: self.onSelectedAction)
                    }
                }
            }
            .padding(.vertical, 5)
        }
        .frame(height: CGFloat(self.options.count * 32) > 300
               ? 300
               : CGFloat(self.options.count * 32)
        )
    }
}

//struct DropdownMenuList_Previews: PreviewProvider {
//    static var previews: some View {
//        DropdownMenuList(options: DropdownMenuOption.testAllMonths, onSelectedAction: { _ in })
//    }
//}
