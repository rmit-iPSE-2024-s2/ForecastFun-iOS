//
//  ScheduleOptionList.swift
//  A1
//
//  Created by Francis Z on 31/8/2024.
//

import SwiftUI

struct ScheduleOptionList: View {
    @Binding var selectedOption: UpcomingForecast
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false ){
            
            HStack( spacing:30){
                ForEach(UpcomingForecast.allCases, id: \.self){item in
                    
                    HStack{
                        Text(item.title)
                            .padding(1.5)
                            .frame(width: 60)
                            .foregroundColor(item == selectedOption ? .white : Color(red: 55/255, green:31/255 , blue: 92/255, opacity: 1.0))
                            .background(item == selectedOption ? Color(red: 248/255, green:168/255 , blue: 112/255, opacity: 1.0) : .clear)
                            .cornerRadius(3)
                    }
                    .onTapGesture{
                        withAnimation {
                            self.selectedOption = item
                        }
                    }
                    
                }
                
            }

        }

        
        
        
    }
}

#Preview {
    ScheduleOptionList(selectedOption: .constant(.Monday))
}
