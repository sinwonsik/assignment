//
//  APIEndpoint.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/23/24.
//

import Foundation
import Combine

/// API 엔드포인트를 정의하는 열거형
enum APIEndpoint {
    case weather(lat: Double, lon: Double, exclude: [String]?, lang: String = "kr")
    
    private var baseURL: String {
        return "https://api.openweathermap.org/data/3.0/onecall"
    }
    
    private var apiKey: String {
        return "ed727bbb771e3c155688471163f844c9"
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .weather(let lat, let lon, let exclude, let lang):
            var items = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "lang", value: lang)
            ]
            if let exclude = exclude, !exclude.isEmpty {
                items.append(URLQueryItem(name: "exclude", value: exclude.joined(separator: ",")))
            }
            return items
        }
    }
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = queryItems
        return components?.url
    }

    var httpMethod: String {
        return "GET"
    }
    
    var body: Data? {
        return nil
    }
}
