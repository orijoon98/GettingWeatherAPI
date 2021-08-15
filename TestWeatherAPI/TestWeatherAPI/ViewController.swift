import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tempLabel: UILabel!
    // Privacy - Location When In Use Usage Description - 앱이 사용중일때만 가져오기
    // Privacy - Location Always and When In Use Usage Description - 앱을 사용안해도 항상 가져오기
    
    var locationManager = CLLocationManager()
    
    static var latitude: Double?
    static var longitude: Double?
    
    var currentWeather: Current?
    var temperature: Double = 0.0
    var icon: String = ""
    let weatherLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        // 델리게이트 설정
        locationManager.delegate = self
        // 거리 정확도 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 허용 받기 alert 띄우기
        locationManager.requestWhenInUseAuthorization()
        // 아이폰 설정에서의 위치 서비스가 켜진 상태라면
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation() // 위치 정보 받아오기 시작
            print(locationManager.location?.coordinate)
        } else {
            print("위치 서비스 Off 상태")
        }
    }
    
    // 위도 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let location = locations.first {
            ViewController.latitude = location.coordinate.latitude
            ViewController.longitude = location.coordinate.longitude
            print("위도: \(ViewController.latitude!)")
            print("경도: \(ViewController.longitude!)")
            fetchWeather()
        }
    }
    
    // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func fetchWeather() {
        print("fetchWeather")
        WeatherService().getWeather { result in
            switch result {
            case .success(let weatherResponse): DispatchQueue.main.async {
                self.currentWeather = weatherResponse.current
                self.temperature = self.currentWeather?.temp ?? 0.0
                self.weatherLabel.text = "temp: \(self.temperature)"
                self.tempLabel.text = "\(self.temperature)"
            }
            case .failure(_ ): print("error")
            }
        }
    }
}

