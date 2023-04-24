//
//  ContentView.swift
//  Diplom_v2
//
//  Created by Алексей Даневич on 11.01.2023.
//

import SwiftUI

struct SegmentedPicker: View {
    private enum Constants {
        static let activeSegmentColor: Color = Color(.tertiarySystemBackground)
        static let backgroundColor: Color = Color(.secondarySystemBackground)
        static let shadowColor: Color = Color.gray
        static let textColor: Color = Color.black
        static let selectedTextColor: Color = Color.white
        static let textFont: Font = .system(size: 12)
        
        static let segmentCornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 4
        static let segmentXPadding: CGFloat = 16
        static let segmentYPadding: CGFloat = 8
        static let pickerPadding: CGFloat = 4
        static let animationDuration: Double = 0.3
    }
    
    @State private var segmentSize: CGSize = .zero
    @Binding private var selection: Int
    
    private let items: [String]
    
    private var activeSegmentView: AnyView {
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { return EmptyView().eraseToAnyView() }
        return RoundedRectangle(cornerRadius: Constants.segmentCornerRadius)
            .foregroundColor(Color("BlueShark"))
            .shadow(color: Constants.shadowColor, radius: Constants.shadowRadius)
            .frame(width: self.segmentSize.width, height: self.segmentSize.height)
            .offset(x: self.computeActiveSegmentHorizontalOffset(), y: 0)
            .animation(Animation.linear(duration: Constants.animationDuration))
            .eraseToAnyView()
    }
    
    init(items: [String], selection: Binding<Int>) {
        self._selection = selection
        self.items = items
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            self.activeSegmentView
            HStack {
                ForEach(0..<self.items.count, id: \.self) { index in
                    self.getSegmentView(for: index)
                }
            }
        }
        .padding(Constants.pickerPadding)
        .background(Constants.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: Constants.segmentCornerRadius))
    }
    
    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        CGFloat(self.selection) * (self.segmentSize.width + Constants.segmentXPadding / 2)
    }
    
    private func getSegmentView(for index: Int) -> some View {
        guard index < self.items.count else {
            return EmptyView().eraseToAnyView()
        }
        let isSelected = self.selection == index
        return Text(self.items[index])
            .foregroundColor(isSelected ? Constants.selectedTextColor: Constants.textColor)
            .lineLimit(1)
            .padding(.vertical, Constants.segmentYPadding)
            .padding(.horizontal, Constants.segmentXPadding)
            .frame(minWidth: 0, maxWidth: .infinity)
            .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
            .onTapGesture { self.onItemTap(index: index) }
            .eraseToAnyView()
    }
    
    private func onItemTap(index: Int) {
        guard index < self.items.count else {
            return
        }
        withAnimation {
            self.selection = index
        }
    }
}
