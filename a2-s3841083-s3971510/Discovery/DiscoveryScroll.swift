//
//  DiscoveryScroll.swift
//  A1
//
//  Created by Anthony Forti on 30/8/2024.
//

import SwiftUI

struct DiscoveryScroll: View {
    let images = ["queenspark",
                  "scottsdale",
                  "botanicgardens",
                  "carltongardens",
                  "princesspark",
                  "yarrabend"]
    
    var body: some View {
        ZStack {Color(red: 218/255, green:210/255 , blue: 240/255, opacity: 1.0)
                .ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Discover")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding()
                ScrollView (.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(images, id: \.self) { image in
                            VStack {
                                Image(image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 140)
                                    .clipped()
                                
                                HStack {
                                    VStack (alignment: .leading){
                                        Text("Queens Park - 2km Away")
                                            .font(.system(size:14))
                                            .fontWeight(.semibold)
                                        Text("Moonee Ponds")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("4.4")
                                        .font(.caption2)
                                        .padding(6)
                                        .background(Color(.systemGray5))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    
    struct DiscoveryScroll_Previews: PreviewProvider {
        static var previews: some View {
            DiscoveryScroll()
        }
    }
}
