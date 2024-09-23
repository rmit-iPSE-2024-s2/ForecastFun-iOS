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
                            .foregroundColor(item == selectedOption ? .white : Color(red: 36/255, green:34/255 , blue: 49/255, opacity: 1.0))
                            .background(item == selectedOption ? Color(red: 40/255, green:40/255 , blue: 40/255, opacity: 1.0) : .clear)
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
