//
//  WeatherResponse.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/23/24.
//

import Foundation

// MARK: - WeatherResponse
/// 날씨 응답
struct WeatherResponse: Decodable {
    var current: CurrentWeather  // 현재 날씨 정보
    var hourly: [HourlyWeather]  // 시간별 날씨 정보
    var daily: [DailyWeather]    // 일별 날씨 정보
}

// MARK: - CurrentWeather
/// 현재 날씨 정보
struct CurrentWeather: Decodable {
    var temp: Double           // 현재 온도
    var humidity: Int          // 현재 습도
    var wind_speed: Double     // 현재 풍속
    var pressure: Int          // 현재 기압
    var weather: [Weather]     // 현재 날씨 상태
    var clouds: Int            // 현재 구름량
}

// MARK: - HourlyWeather
/// 시간별 날씨 정보
struct HourlyWeather: Decodable {
    var dt: Int               // 타임스탬프
    var temp: Double          // 시간별 온도
    var weather: [Weather]    // 시간별 날씨 상태
}

// MARK: - DailyWeather
/// 일별 날씨 정보
struct DailyWeather: Decodable {
    var dt: Int               // 타임스탬프
    var temp: Temperature     // 일별 온도
    var weather: [Weather]    // 일별 날씨 상태
}

// MARK: - Temperature
/// 온도 범위
struct Temperature: Decodable {
    var min: Double           // 최저 온도
    var max: Double           // 최고 온도
    
    var minInt: Int { Int(min) } // 정수형 최저 온도
    var maxInt: Int { Int(max) } // 정수형 최고 온도
}

// MARK: - Weather
/// 날씨 상태
struct Weather: Decodable {
    var id: Int               // 날씨 상태 ID
    var main: String          // 주요 날씨 설명
    var description: String   // 상세 날씨 설명
    var icon: String          // 날씨 아이콘 이름

    // 로컬 아이콘 이름 반환
    func localIconName() -> String {
        switch icon {
        case "01d", "01n":
            return "clear_sky"
        case "02d", "02n":
            return "few_clouds"
        case "03d", "03n":
            return "scattered_clouds"
        case "04d", "04n":
            return "broken_clouds"
        case "09d", "09n":
            return "shower_rain"
        case "10d", "10n":
            return "rain"
        case "11d", "11n":
            return "thunderstorm"
        case "13d", "13n":
            return "snow"
        case "50d", "50n":
            return "mist"
        default:
            return "questionmark"
        }
    }
}
