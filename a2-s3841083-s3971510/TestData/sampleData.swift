//
//  ScheduledActivity.swift
//  A1
//
//  Created by Francis Z on 31/8/2024.
//

import Foundation

struct ScheduledActivity: Identifiable {
    var id = UUID().uuidString
    let title: String
    let condition: String
    let time: String
    let location: String
}

var mondaySchedule: [ScheduledActivity] = [
    .init(title: "Walking", condition:"good", time: "2:00pm", location:"Pittsburgh Park"),
    .init(title: "Running", condition:"good", time: "6:00pm", location:"Pittsburgh Park")
]

var tuesdaySchedule: [ScheduledActivity] = [
    .init(title: "Swimming", condition:"good", time: "2:00pm", location:"None")
]

var wednesdaySchedule: [ScheduledActivity] = [
//    .init(title: "Walking", condition:"moderate", time: "2:00pm", location:"Pittsburgh Park")
]

var thursdaySchedule: [ScheduledActivity] = [
    .init(title: "Walking", condition:"bad", time: "2:00pm", location:"Pittsburgh Park")
]


struct DayForecast: Hashable {
    let day: String
    let temp: String
    let maxTemp: String
    let minTemp: String
    let mainCondition: String
    let humidity: String
    let precipitation: String
    let wind: String
}



let mondayForecast: [DayForecast] = [
    DayForecast(day: "Monday", temp: "22°C", maxTemp: "24°C", minTemp: "20°C", mainCondition: "sun.min", humidity: "60%", precipitation: "0 mm", wind: "15 km/h")
]

let tuesdayForecast: [DayForecast] = [
    DayForecast(day: "Tuesday", temp: "18°C", maxTemp: "20°C", minTemp: "16°C", mainCondition: "cloud", humidity: "65%", precipitation: "1 mm", wind: "10 km/h")
]

let wednesdayForecast: [DayForecast] = [
    DayForecast(day: "Wednesday", temp: "14°C", maxTemp: "17°C", minTemp: "12°C", mainCondition: "cloud", humidity: "70%", precipitation: "2 mm", wind: "12 km/h")
]

let thursdayForecast: [DayForecast] = [
    DayForecast(day: "Thursday", temp: "10°C", maxTemp: "12°C", minTemp: "8°C", mainCondition: "cloud.rain", humidity: "80%", precipitation: "5 mm", wind: "20 km/h")
]


