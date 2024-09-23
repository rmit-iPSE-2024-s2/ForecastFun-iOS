//
//  SplashScreenView.swift
//  A1
//
//  Created by Francis Z on 31/8/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    var body: some View {
        // change t
        if isActive{
           MainTabbedView()
        }
        else{
            ZStack{
                Color(red: 249/255, green:246/255 , blue: 240/255, opacity: 1.0)
                    .ignoresSafeArea(.all)
            VStack{
                VStack{
                    Image(systemName: "cloud")
                        .font(.system(size: 60))
                    Text("Forecast Fun")
                        .font(.system(size:20))
                        .padding()
                        
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration:1.2)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }}
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }
                    
                }
            }
        }
        }
        
}

#Preview {
    SplashScreenView()
}
