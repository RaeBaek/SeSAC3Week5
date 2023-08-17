//
//  Weather.swift
//  SeSAC3Week5
//
//  Created by 백래훈 on 2023/08/17.
//

import Foundation

// MARK: - Welcome
struct WeatherData: Codable {
    let wind: Wind
    let name: String
    let main: Main
    let base: String
    let weather: [Weather]
    let dt, cod: Int
    let sys: Sys
    let coord: Coord
    let id, visibility, timezone: Int
    let clouds: Clouds
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - Main
struct Main: Codable {
    let tempMax: Double
    let seaLevel, grndLevel: Int
    let feelsLike, temp: Double
    let pressure, humidity: Int
    let tempMin: Double

    enum CodingKeys: String, CodingKey {
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case feelsLike = "feels_like"
        case temp, pressure, humidity
        case tempMin = "temp_min"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let sunset, type: Int
    let country: String
    let id, sunrise: Int
}

// MARK: - Weather
struct Weather: Codable {
    let description, main: String
    let id: Int
    let icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let gust, speed: Double
    let deg: Int
}
