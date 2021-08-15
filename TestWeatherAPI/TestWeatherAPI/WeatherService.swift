import Foundation
enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
    
}
class WeatherService {
    let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(String(describing: ViewController.latitude!))&lon=\(String(describing: ViewController.longitude!))&exclude=minutely&appid=YOUR-API-KEY-HERE&units=metric") //개인 API key를 넣은 API call 넣어주기
    func getWeather(completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        guard let url = url else {
            print("badUrl")
            return completion(.failure(.badUrl))
        }
        URLSession.shared.dataTask(with: url) {
            data, response, error in guard let data = data, error == nil else {
                print("noData")
                return completion(.failure(.noData))
            }
        let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
        if let weatherResponse = weatherResponse {
            completion(.success(weatherResponse)) } else {
                print("decodingError")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

