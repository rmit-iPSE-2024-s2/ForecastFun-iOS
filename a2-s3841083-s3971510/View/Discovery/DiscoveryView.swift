//
//  SwiftUIView.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 9/10/2024.
//

import SwiftUI
import CoreLocation
import SwiftData

struct DiscoveryView: View {
    var location: CLLocationCoordinate2D
    var yelpManager = YelpManager() // YelpManager instance
    
    @Query var activities: [Activity]
    @State private var activityLocations: YelpResponse? = nil // Store Yelp activities
    @State private var isLoadingWeather = true
    @State private var isLoadingActivities = true
    
    @State private var selectedActivityIndex: Int = 0
    @Binding var selectedLocation: String?
    
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    let textColor = Color(red: 226/255, green: 237/255, blue: 255/255)
    
    var body: some View {
        ZStack{
            backgroundColor.ignoresSafeArea(.all)
            
            let addedActivities = activities.filter { $0.added }
            
            VStack{
                HStack{
                    Text("Discovery")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 30))
                    
                    Picker("Select an Activity", selection: $selectedActivityIndex) {
                        ForEach(0..<addedActivities.count, id: \.self) { index in
                            Text(addedActivities[index].activityName)
                                .tint(.white)
                                .tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(Color(red: 36/255, green: 50/255, blue: 71/255, opacity: 1))
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .onChange(of: selectedActivityIndex) { newIndex in
                        
                        // Fetch activity locations for the selected activity
                        Task {
                            await fetchActivityLocations(
                                latitude: location.latitude,
                                longitude: location.longitude,
                                keyword: addedActivities[newIndex].activityName
                            )
                        }
                        
                        
                    }
                }
                .padding(.horizontal)
                if !addedActivities.isEmpty {
                    VStack {
                        
                        let selectedActivity = addedActivities[selectedActivityIndex]
                        
                        Text("Locations for: \(selectedActivity.activityName)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 18))
                        
                            if let activityLocations = activityLocations {
                                ScrollView{
                                    ForEach(activityLocations.businesses, id: \.id){ business in

                                        if let imageUrl = business.image_url {
                                            // Safely unwrap the imageUrl and pass it to DiscoveryCardView
                                            DiscoveryCardView(selectedLocation:$selectedLocation, locationName: business.name, imageUrl: imageUrl, distance: business.distance, url: business.url)
                                                .padding(.top, 12)
                                            Rectangle()
                                                .frame(width: 348, height: 1)
                                                .foregroundColor(textColor)
                                                .opacity(0.7)
                                                .padding(.top, 10)
                                        } else {
                                            // Provide a fallback if the image URL is nil, like passing a default image
                                            DiscoveryCardView(selectedLocation:$selectedLocation, locationName: business.name, imageUrl: "", distance: business.distance, url: business.url)
                                                .padding(.top, 12)
                                            Rectangle()
                                                .frame(width: 348, height: 1)
                                                .foregroundColor(textColor)
                                                .opacity(0.7)
                                                .padding(.top, 10)
                                        }
                                        }
                                        
                                        Spacer()
                                        
                                    
                                }
                                .frame(height: 570)
                            } else if isLoadingActivities {
                     
                                ProgressView()
                                    .tint(.white)// Show loading indicator while fetching
                                    .task {

                                            await fetchActivityLocations(
                                                latitude: location.latitude,
                                                longitude: location.longitude,
                                                keyword: selectedActivity.activityName
                                            )
                                        
                                    }
                                    .frame(maxHeight: .infinity)
                                    
                            }
                        
                        
                        else {
                            Spacer()
                            Text("Error finding your locations")
                                .multilineTextAlignment(.center)
                                .frame(width:300)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .foregroundColor(textColor)
                } else {
                    Text("You have no added activities")
                        .frame(height: 570)
                }
            }
            .padding()
            .foregroundColor(textColor)
            
        }
    }
    
    private func fetchActivityLocations(latitude: CLLocationDegrees, longitude: CLLocationDegrees, keyword: String) async {
        do {
            isLoadingActivities = true // Set loading state to true
            activityLocations = try await yelpManager.getNearbyActivityLocations(
                latitude: latitude,
                longitude: longitude,
                activity: keyword
            )
        } catch {
            print("Error fetching activity locations: \(error.localizedDescription)")
        }
        isLoadingActivities = false // Set loading state to false
    }
}


#Preview {
    do {
        let previewer = try ActivityPreviewer()
        @State var selectedLocation: String? = ""
        
        let mockLocation = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        return DiscoveryView(location: mockLocation, selectedLocation: $selectedLocation )
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}


struct DiscoveryCardView : View {
    @Binding var selectedLocation: String?
    var locationName: String
    var imageUrl: String
    var distance: Double
    var url: String
    
    let backgroundColor = Color(red: 43/255, green: 58/255, blue: 84/255)
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        VStack{
            // Add new scheduled activity
            
            AsyncImage(url: URL(string: imageUrl)) { phase in
                if let image = phase.image {
                    ZStack{
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350,height: 200)
                            .cornerRadius(6)
                            .padding(.bottom, 7)
                        
                        Button(action: {
                                // Change the selectedLocation when the button is tapped
                                selectedLocation = locationName
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                if selectedLocation != nil {
                                    ZStack {
                                        Image(systemName: "plus")
                                            .font(.system(size: 30))
                                            .padding()
                                    }
                                    .background(backgroundColor)
                                    .cornerRadius(15)
                                }
                        }
                            .offset(x:130, y: 60)
                        
                            
                    }
                } else if phase.error != nil {
                    Image("japan")
                        .resizable()
                        .frame(height:200)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(6)
                } else {
                    ProgressView() // Show a loading indicator while the image is being fetched
                        .frame(height: 200)
                }
            }
            
            
            HStack{
                HStack{
                    Image(systemName :"mappin.and.ellipse")
                        .font(.system(size: 40))
                    
                    
                    Text("\(locationName)")
                        .fontWeight(.light)
                        .font(.system(size:20))
                        .foregroundColor(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 1.0))
                        .frame(width: 150, alignment:.leading)
                        .padding(.leading,10)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing,spacing: 5) {
                        Text("\((distance / 1000).roundDouble()) km away")
                        
                        if let validUrl = URL(string: url), UIApplication.shared.canOpenURL(validUrl) {
                            Link("See more", destination: validUrl)
                                .buttonStyle(PlainButtonStyle()) // Ensure the link is styled as a button
                        } else {
                            Text("Invalid URL")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                
            }
            .frame(width: 360)
            .background(Color(red:36/255, green:50/255, blue: 71/255, opacity: 1))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 226/255, green:237/255 , blue: 255/255, opacity: 0.2), lineWidth: 1)
            )

        }
    }
}
