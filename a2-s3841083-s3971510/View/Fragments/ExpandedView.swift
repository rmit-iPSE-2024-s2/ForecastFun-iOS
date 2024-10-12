//
//  ExpandedView.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 11/10/2024.
//

import SwiftUI

/// A view that wraps and displays the expandable content view in a ZStack.
struct ExpandedView: View {
    var id = UUID()
    @ViewBuilder var content: any View
    var body: some View {
        ZStack{
            AnyView(content)
        }
    }
}
