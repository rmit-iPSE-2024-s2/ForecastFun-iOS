//
//  DayPickerView.swift
//  a2-s3841083-s3971510
//
//  Created by Francis Z on 6/10/2024.
//

import SwiftUI

struct DayPickerView: View {
    
    let customColor = UIColor(red: 36/255, green: 50/255, blue: 71/255, alpha: 1.0)
    let selectedColor = UIColor(red: 36/255, green: 50/255, blue: 71/255, alpha: 1.0)
    
    @State private var selectedSegment = 0
    let segments = ["MON", "TUE", "WED", "THU"]
    
    var weather: ResponseBody
    
    var dayForecasts: [ResponseBody.DailyWeatherResponse] {
        // Extract the first 4 days from the weather response
        Array(weather.daily.prefix(4)) // This returns an array of 4 daily forecasts
    }

    var body: some View {
        VStack {
            Picker("Select an Option", selection: $selectedSegment) {
                ForEach(0..<dayForecasts.count, id: \.self) { index in
                    Text(dayForecasts[index].dt.convertToDayOfWeek())
                        .tag(index)
                        .cornerRadius(10)
                        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onAppear {
                // Set UISegmentedControl appearance when the view appears
                UISegmentedControl.appearance().backgroundColor = .clear
                UISegmentedControl.appearance().tintColor = .white
                UISegmentedControl.appearance().selectedSegmentTintColor = selectedColor
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            }
        }
    }
}

#Preview {
    do {
        let previewer = try ActivityPreviewer()
        return DayPickerView(weather: previewWeather)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
