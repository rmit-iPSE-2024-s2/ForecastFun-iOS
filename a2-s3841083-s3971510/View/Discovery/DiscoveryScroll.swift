//
//  DiscoveryScroll.swift
//  A1
//
//  Created by Anthony Forti on 30/8/2024.
//

import SwiftUI

struct DiscoveryScroll: View {
    let images = ["Basketball", "Running", "Soccer", "Swimming", "Cycling", "Tennis"]
    let titles = ["Basketball", "Running", "Soccer", "Swimming", "Cycling", "Tennis"]
    let subtitles = ["2km Away", "3km Away", "1.5km Away", "2.5km Away", "4km Away", "2km Away"]
    
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    let textColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    let highlightColor = Color.blue

    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Trending Activities")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(0..<images.count, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 8) {
                                    ZStack {
                                        // Keep the frame static, and center the image within the frame
                                        Color.clear.frame(height: 100)
                                        Image(images[index])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 66, height: 66)  // 50% larger image
                                            .padding()  // Optional padding to ensure centering
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Center the image
                                    }
                                    
                                    Text(titles[index])
                                        .font(.headline)
                                        .foregroundColor(textColor)
                                    Text(subtitles[index])
                                        .font(.subheadline)
                                        .foregroundColor(textColor.opacity(0.7))
                                }
                                .padding(.horizontal, 8)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    selectedTab = 2
                }) {
                    Text("Choose an Activity")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(highlightColor)
                        .foregroundColor(backgroundColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
    }
}

struct DiscoveryScroll_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryScroll(selectedTab: .constant(1))
    }
}
