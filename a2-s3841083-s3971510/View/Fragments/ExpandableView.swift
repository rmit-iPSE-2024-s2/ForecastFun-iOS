//
//  ExpandableView.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 11/10/2024.
//

import SwiftUI

/// The `ExpandableView` allows users to interact with a thumbnail view, which can be expanded
/// to reveal more detailed information. This view supports gestures like long press and swipe
/// to facilitate the transition between the thumbnail and the expanded view.
struct ExpandableView: View {
    @Namespace private var namespace
    @State private var show = false
    @State private var isLongPressed = false
    @State private var isSwiped = false
    
    var thumbnail: ThumbnailView
    var expanded: ExpandedView
    let backgroundColor = Color(red:36/255, green:50/255, blue: 71/255, opacity: 1)
    let hiddenColor = Color(red:36/255, green:50/255, blue: 71/255, opacity: 0)
    let highlightColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    
    var body: some View {
        ZStack{
            if !show{
                thumbnailView()
            }
            else{
                expandedView()
            }
            
        }
        .gesture(
            SimultaneousGesture(
                LongPressGesture(minimumDuration: 0.2) // short long press
                    .onEnded { _ in
                        withAnimation {
                            isLongPressed.toggle() // Indicate long press
                        }
                    },
                
                DragGesture() // Detect swipe
                    .onEnded { value in
                        if isLongPressed && (abs(value.translation.width) > 50 || abs(value.translation.height) > 50) {
                            // Only turn green after both long press and swipe
                            withAnimation {
                                isSwiped.toggle() // Indicate swipe
                                show.toggle()
                            }
                        }
                    }
            )
        )

    }
    
//    Color(isSwiped ? backgroundColor : (isLongPressed ? highlightColor : backgroundColor))
    @ViewBuilder
    private func thumbnailView() -> some View{
        ZStack{
            thumbnail
                .matchedGeometryEffect(id: "view", in: namespace)
        }
        .background(
            Color(backgroundColor)
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .mask{
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .matchedGeometryEffect(id: "mask", in: namespace)
            
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(isSwiped ? hiddenColor : (isLongPressed ? highlightColor : hiddenColor)), lineWidth:0.7)
            // if the card is long pressed, highlight the card to indicate its selected, otherwise have no border (opacity of 0)
        )
    }
    
    @ViewBuilder
    private func expandedView() -> some View{
        ZStack{
            expanded
                .matchedGeometryEffect(id: "view", in: namespace)
                .background(
                    Color(backgroundColor)
                        .matchedGeometryEffect(id: "background", in: namespace)
                )
                .mask{
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .matchedGeometryEffect(id: "mask", in: namespace)
                }
            
            
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction:0.8)){
                        isLongPressed.toggle()
                        isSwiped.toggle()
                        show.toggle()
                    }
                }, label:{
                    Image(systemName: "xmark")
                        .foregroundColor(Color(red: 226 / 255, green: 237 / 255, blue: 255 / 255))
                })
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .matchedGeometryEffect(id: "mask", in: namespace)
        }
    }
    
}

