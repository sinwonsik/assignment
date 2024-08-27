//
//  APIService.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/23/24.
//

import Foundation
import Combine

/// API 요청을 처리하는 서비스 클래스
class APIService {
    static let shared = APIService()
    
    private init() {}
    
    private func makeRequest(for endpoint: APIEndpoint) -> URLRequest? {
        guard let url = endpoint.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        return request
    }
    
    func fetch<T: Decodable>(from endpoint: APIEndpoint, as type: T.Type) -> AnyPublisher<T, Error> {
        guard let request = makeRequest(for: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    print("JSON Response: \(jsonString)")
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchWeather(lat: Double, lon: Double, exclude: [String]? = nil, lang: String = "kr") -> AnyPublisher<WeatherResponse, Error> {
        return fetch(from: .weather(lat: lat, lon: lon, exclude: exclude, lang: lang), as: WeatherResponse.self)
    }
}
