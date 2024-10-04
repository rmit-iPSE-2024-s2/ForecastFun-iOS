//
//  RecActivityView.swift
//  A1
//
//  Created by Francis Z on 31/8/2024.
//

import SwiftUI

struct RecActivityView: View {
    @State private var addedActivity: Bool = false
    @State private var toggleConfirm: Bool = false
    var body: some View {
        ZStack{
            Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0)
                .ignoresSafeArea(.all)
  
            
            
            ZStack {
               
                
                
                VStack{
                    ActivityCardTitle(title:"Walking", bgColor: Color(red: 130/255, green:218/255 , blue: 171/255, opacity: 1.0))
                        .padding()
                    
                    Grid{
                        GridRow{
                            valueCard(label:"Temperature C", value: "22")
                            valueCard(label:"Precipitation mm", value: "0")
                        }
                        GridRow{
                            valueCard(label:"Humidity %", value: "60")
                            valueCard(label:"Wind km/h", value: "15")
                        }
                    }
                    
                    ZStack{
                        Capsule()
                            .frame(height:10)
                            .foregroundColor(Color(red: 244/255, green:147/255 , blue: 152/255, opacity: 1.0))
                        Capsule()
                            .offset(x:80)
                            .frame(width:180,height:10)
                            .foregroundColor(Color(red: 230/255, green:199/255 , blue: 94/255, opacity: 1.0))
                            
                        Capsule()
                            .frame(width:120,height:10)
                            .foregroundColor(Color(red: 130/255, green:218/255 , blue: 171/255, opacity: 1.0))
                        
                        VStack{
                            Text("NOW")
                            ZStack
                            {
                                Capsule()
                                    .frame(width:32,height:13)
                                    .foregroundColor(.white)
                                
                                Capsule()
                                    .frame(width:30,height:10)
                                    .foregroundColor(Color(red: 130/255, green:218/255 , blue: 171/255, opacity: 1.0))
                            }
                        }
                        .offset(y:-40)
                        
                    }
                    .padding([.top,.trailing,.leading],50)
                    
                    Text("Current conditions are perfect for this activity")

                    Text("Would you like to schedule this activity now?")
                        .padding()
                    
                    Button(action: {
                        addedActivity = true
                        withAnimation {
                            toggleConfirm.toggle()
                        }
                    }) {
                        Text(!addedActivity ? "Add Activity" : "Added")
                            .font(.title2)
                            .padding()
                            .background(!addedActivity ? Color(red:251, green:144/255, blue:98/255, opacity:0.7) : Color(red:251, green:144/255, blue:98/255, opacity:0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(addedActivity)
                }
                
                if(toggleConfirm){
                    ZStack{
                        Text("\"Walking\" has been added to your Monday Schedule")
                            .frame(width:300, height: 100)
                            .foregroundColor(.white)
                            .zIndex(1)
                            .background(Color(red:251, green:144/255, blue:98/255, opacity:0.9))
                            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            .padding(4)
                        
                        Button(action:{
                            withAnimation {
                                toggleConfirm.toggle()
                            }
                        }
                        ){
                            Image(systemName:"xmark")
                                .font(.system(size:20))
                                
                        }
                        .foregroundColor(.white)
                        .zIndex(1)
                        .offset(x:130, y: -30)
                        
                        
                        
                    }

                    
                }

            }
            .offset(y:-30)
            .padding(5)
            .foregroundColor(Color(red: 55/255, green:31/255 , blue: 92/255, opacity: 1.0))
        }
    }
}

#Preview {
    RecActivityView()
}

struct ActivityCardTitle: View{
    var title: String
    var bgColor: Color
    
    var body: some View{
        HStack {

            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(.title))
                .foregroundColor(.white)

        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20)
        .padding(20)
        .background(bgColor)
        .cornerRadius(20)
    }
    
}

struct valueCard: View {
    var label: String
    var value: String
    
    var body: some View{
        
        VStack{
            Text("\(label)")
                .padding()
            Text("\(value)")
                .font(.system(size:30))
                .padding()
                .frame(width:100, height: 80)
                .background(Color(red: 130/255, green:218/255 , blue: 171/255, opacity: 1.0))
                .foregroundColor(.white)
                .cornerRadius(10)

            
        }
        
        
    }
}
