//
//  Forecast.swift
//  WeatherApp
//
//  Created by Nazmi Ceylan on 29.08.2024.
//

import Foundation

//struct Forecast: Codable{
//    struct Daily: Codable{
//        let dt: Date
//        struct Temp: Codable{
//            let min: Double
//            let max: Double
//        }
//        let temp: Temp
//        let humidity: Int
//        struct Weather: Codable{
//            let id: Int
//            let description: String
//            let icon: String
//        }
//        let weather: [Weather]
//        let clouds: Int
//        let pop: Double
//        let icon: String
//        var weatherIconUrl: URL{
//            let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
//            return URL(string: urlString)!
//        }
//
//    }
//    let daily: [Daily]
//}

// MARK: - Forecast
struct Forecast: Codable {
    let daily: [Daily]

    // MARK: - Daily
    struct Daily: Codable {
        let dt: Date
        let summary: String?
        let temp: Temp
        let humidity: Int?
        let weather: [Weather]
        let clouds: Int
        let pop: Double
    }

    // MARK: - Temp
    struct Temp: Codable {
        let day, min, max, night: Double
        let eve, morn: Double
    }

    // MARK: - Weather
    struct Weather: Codable {
        let id: Int
        let main, description, icon: String
    }
}
