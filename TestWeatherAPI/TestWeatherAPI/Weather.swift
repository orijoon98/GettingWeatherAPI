import Foundation

struct WeatherResponse: Decodable {
    let timezone: String
    let current: Current
}

struct Current : Decodable {
    let temp: Double
    let feels_like: Double
    let clouds: Int
    let wind_speed: Double
    let weather: [Weather]
}

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}

