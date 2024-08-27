//
//  WeatherViewModel.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/23/24.
//

import SwiftUI
import Combine
import MapKit

class WeatherViewModel: ObservableObject {
    // MARK: - Published 프로퍼티
    // 날씨 데이터를 저장하는 Published 프로퍼티
    @Published var weather: WeatherResponse? {
        didSet {
            if let temp = weather?.current.temp {
                cachedTemperature = "\(Int(temp))°"
            } else {
                cachedTemperature = "--°"
            }
            print("Weather data updated: \(String(describing: weather))")
        }
    }

    // MARK: - 캐시된 데이터 프로퍼티
    // 캐시된 온도 데이터를 저장하는 프로퍼티
    private(set) var cachedTemperature: String = "--°"

    // 현재 온도를 반환하는 계산된 프로퍼티
    var currentTemperature: String {
        return cachedTemperature
    }

    // 최대 온도를 반환하는 계산된 프로퍼티
    var maxTemperature: String {
        guard let maxTemp = weather?.daily.first?.temp.maxInt else {
            return "--"
        }
        return "\(maxTemp)°"
    }

    // 최소 온도를 반환하는 계산된 프로퍼티
    var minTemperature: String {
        guard let minTemp = weather?.daily.first?.temp.minInt else {
            return "--"
        }
        return "\(minTemp)°"
    }
 
    // MARK: - 내부에서 사용하는 프로퍼티
    private var cancellables = Set<AnyCancellable>()
    
    let fixedLatitude: Double = 37.5244
    let fixedLongitude: Double = 126.7409

    // 현재 날씨 설명을 반환하는 계산된 프로퍼티
    var currentWeatherDescription: String {
        return weather?.current.weather.first?.description ?? "정보 없음"
    }
    
    // MARK: - 날씨 데이터 페치 메서드
    // 주어진 위도와 경도를 기반으로 날씨 데이터를 가져오는 메서드
    func fetchWeather(lat: Double, lon: Double, lang: String = "kr") {
        print("lat=\(lat) lon=\(lon)")
        LoadingIndicator.shared.show()
        print(#function)
        APIService.shared.fetchWeather(lat: lat, lon: lon, lang: lang)
            .sink(receiveCompletion: { completion in
                LoadingIndicator.shared.hide()
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] weatherResponse in
                print("Weather data received: \(weatherResponse)")
                self?.weather = weatherResponse
            })
            .store(in: &cancellables)
    }
    
    // MARK: - 필터링된 시간별 날씨 데이터
    // 3시간 간격으로 필터링된 시간별 날씨 데이터를 반환하는 계산된 프로퍼티
    var filteredHourlyWeather: [HourlyWeather] {
        guard let hourlyWeather = weather?.hourly else {
            return []
        }
        return Array(hourlyWeather.enumerated().compactMap { index, element in
            return index % 3 == 0 ? element : nil
        }.prefix(16))
    }
}


