//
//  AddHouseView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 23.01.2023.
//

import SwiftUI

struct AddHouseView: View {
@State var name = ""
    @State var type = ""
    var body: some View {
        VStack {
            Spacer()
            TextField("Room name", text: $name)
//            DropdownMenu(selectedOption: $type, placeholder: "choose room type", options: RoomType.allCases)
            Spacer()

        }
    }
}

struct AddHouseView_Previews: PreviewProvider {
    static var previews: some View {
        AddHouseView()
    }
}
