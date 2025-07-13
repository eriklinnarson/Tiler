//
//  ActionKeybindingListView.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-13.
//

import SwiftUI

struct ActionKeybindingListView<RowModel: Identifiable, RowView: View>: View {
    let models: [RowModel]
    let rowViewBuilder: (RowModel) -> RowView
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(models) { rowModel in
                rowViewBuilder(rowModel)
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .font(.title2)
    }
}
