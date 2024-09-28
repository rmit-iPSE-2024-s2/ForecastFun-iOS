//
//  ContentView.swift
//  A1
//
//  Created by Anthony Forti on 28/8/2024.
//

import SwiftUI

struct HomeView: View {
    var weather: ResponseBody
    
    var body: some View {
        HomeScreen(weather: weather)
    }
}

struct PinView: View {
    var body: some View {
        DiscoveryScroll()
    }
}

struct WalkView: View {
    var body: some View {
        ActivitiesMenu()
    }
}

struct ClockView: View {
    var body: some View {
        ScheduleView()
    }
}

enum TabbedItems: Int, CaseIterable{
    case home = 0
    case pin
    case walk
    case clock
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .pin:
            return "Discover"
        case .walk:
            return "Activities"
        case.clock:
            return "Schedule"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .pin:
            return "map"
        case .walk:
            return "target"
        case .clock:
            return "calendar"
            
        }
    }
}

struct MainTabbedView: View {
    var weather: ResponseBody
    @State var selectedTab = 0
    
    var body: some View {
        
        ZStack (alignment: .bottom){
            TabView(selection: $selectedTab) {
                HomeScreen(weather:weather)
                    .tag(0)
                PinView()
                    .tag(1)
                WalkView()
                    .tag(2)
                ClockView()
                    .tag(3)
                
                
            }
            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                        }
                        }
                }
                .padding(6)

            }
            .frame(width:360,height: 65)
            .background(Color(red: 43/255, green:58/255 , blue: 84/255, opacity: 1.0))
            .cornerRadius(20)

        }
    }
}



extension MainTabbedView {
    func CustomTabItem(imageName: String, isActive: Bool) -> some View {
        HStack{
            Spacer()
            Image(systemName:imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width:30, height:30)
                .foregroundColor(isActive ? Color(red:226/255, green:237/255, blue: 255/255, opacity: 1) : Color(red:226/255, green:237/255, blue: 255/255, opacity: 0.4))
            Spacer()
        }
        .cornerRadius(30)
    }
}


#Preview {
    MainTabbedView(weather: previewWeather)
}
