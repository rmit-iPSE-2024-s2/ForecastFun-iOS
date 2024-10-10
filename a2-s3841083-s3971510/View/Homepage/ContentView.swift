import SwiftUI
import SwiftData
import CoreLocation
struct HomeView: View {
    var weather: ResponseBody
    
    var body: some View {
        HomeScreen(weather: weather )
    }
}

struct PinView: View {
    @Binding var selectedTab: Int
    var location: CLLocationCoordinate2D
    var body: some View {
//        DiscoveryScroll(selectedTab: $selectedTab)
        DiscoveryView(location: location)
    }
}


struct WalkView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        ActivityListView()
    }
}

 struct ClockView: View {
     var weather: ResponseBody
     
     var body: some View {
         
         ScheduleView(weather:weather)
     }
 }

enum TabbedItems: Int, CaseIterable {
    case home = 0
    case pin
    case walk
    case clock
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .pin:
            return "Discover"
        case .walk:
            return "Activities"
        case .clock:
            return "Schedule"
        }
    }
    
    var iconName: String {
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
    var location: CLLocationCoordinate2D
    @State var selectedTab = 0
    
    var body: some View {
        ZStack (alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeScreen(weather: weather)
                    .tag(0)
                PinView(selectedTab: $selectedTab, location: location)
                    .tag(1)
                WalkView()
                    .tag(2)
                ClockView(weather: weather)
                   .tag(3)
            }
            ZStack {
                HStack {
                    ForEach((TabbedItems.allCases), id: \.self) { item in
                        Button {
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(width: 360, height: 65)
            .background(Color(red: 43/255, green: 58/255, blue: 84/255, opacity: 1.0))
            .cornerRadius(20)
        }
    }
}


extension MainTabbedView {
    func CustomTabItem(imageName: String, isActive: Bool) -> some View {
        HStack {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 30, height: 30)
                .foregroundColor(isActive ? Color(red: 226/255, green: 237/255, blue: 255/255, opacity: 1) : Color(red: 226/255, green: 237/255, blue: 255/255, opacity: 0.4))
            Spacer()
        }
        .cornerRadius(30)
    }
}

#Preview {
    do {
        let previewer = try ActivityPreviewer()
        let mockLocation = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        return MainTabbedView(weather: previewWeather, location: mockLocation )
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
