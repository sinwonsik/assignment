//
//  City.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/24/24.
//

import Foundation

// MARK: - City
/// 도시 정보
struct City: Identifiable, Decodable, Equatable {
    let id: Int          // 도시 ID
    let name: String     // 도시 이름
    let country: String  // 국가 이름
    let coord: Coord     // 도시 좌표

    // 두 도시가 동일한지 비교하는 메서드
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Coord
/// 좌표 정보
struct Coord: Decodable {
    let lon: Double      // 경도
    let lat: Double      // 위도
}
