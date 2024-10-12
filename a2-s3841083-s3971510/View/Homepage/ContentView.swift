import SwiftUI
import SwiftData
import CoreLocation

/// Displays the home screen from the navigation controller
struct HomeView: View {
    var weather: ResponseBody
    var location: CLLocationCoordinate2D
    var body: some View {
        
        HomeScreen(weather: weather, location: location)
    }
}

/// Displays the DiscoveryView from the navigation controller
struct MapView: View {

    var location: CLLocationCoordinate2D
    @State private var selectedLocation: String? = nil
    
    var body: some View {
        
        DiscoveryView(location: location, selectedLocation: $selectedLocation)
    }
}

/// Displays the ActivityListView from the navigation controller
struct TargetView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        ActivityListView()
    }
}

/// Displays the ScheduleView  from the navigation controller
 struct CalendarView: View {
     var weather: ResponseBody
     var location: CLLocationCoordinate2D
     var body: some View {
         ScheduleView(weather:weather, location: location)
     }
 }

/// An enumeration representing the items in a tabbed interface.
///
/// This enum defines the different tabs available in the tabbed interface of the application.
/// Each case represents a specific tab and provides a title and icon associated with it.
enum TabbedItems: Int, CaseIterable {
    case home = 0
    case map
    case target
    case calendar
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .map:
            return "Discover"
        case .target:
            return "Activities"
        case .calendar:
            return "Schedule"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .map:
            return "map"
        case .target:
            return "target"
        case .calendar:
            return "calendar"
        }
    }
}

/// View for the navigation tab bar
struct MainTabbedView: View {
    var weather: ResponseBody
    var location: CLLocationCoordinate2D
    @State var selectedTab = 0
    
    var body: some View {
        ZStack (alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeScreen(weather: weather, location: location)
                    .tag(0)
                MapView(location: location)
                    .tag(1)
                TargetView()
                    .tag(2)
                CalendarView(weather: weather, location: location)
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
    
    /// Creates a custom tab item view with an icon and active state.
    ///
    /// This function generates a tab item with an image and a visual representation
    /// that indicates whether the tab is currently active or not. The tab item is styled
    /// with a specific size and color that changes based on the active state.
    ///
    /// - Parameters:
    ///   - imageName: A `String` representing the name of the system image to display
    ///     in the tab item. This should correspond to an image in the SF Symbols library.
    ///   - isActive: A `Bool` indicating whether the tab item is currently active.
    ///     If `true`, the item will be rendered with full opacity; if `false`, it will
    ///     appear with reduced opacity.
    ///
    /// - Returns: A view that displays the tab item with the specified icon and state.
    ///
    /// Usage Example:
    /// ```
    /// CustomTabItem(imageName: "house", isActive: true)
    /// ```
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
