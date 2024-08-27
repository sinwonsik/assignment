//
//  LocationManager.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/24/24.
//

import Foundation
import CoreLocation

/// 위치 업데이트를 관리하고 지역 정보를 가져오는 클래스
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var locality: String?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 100
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            fetchLocality(for: location)
        }
    }
    
    private func fetchLocality(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                self.locality = placemark.locality
            } else {
                self.locality = "Unknown Location"
            }
        }
    }
}
