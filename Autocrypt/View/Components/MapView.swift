//
//  MapView.swift
//  Autocrypt
//
//  Created by Wonsik Sin on 8/23/24.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    // MARK: - Properties
    /// 지도의 중심이 될 위도와 경도, 그리고 온도를 나타내는 변수
    var latitude: Double
    var longitude: Double
    var temperature: String

    // MARK: - TemperatureAnnotation 클래스
    /// 지도에 표시될 온도 주석을 나타내는 클래스
    class TemperatureAnnotation: MKPointAnnotation {
        var temperature: String = ""
    }

    // MARK: - Coordinator 클래스
    /// MKMapViewDelegate를 구현하는 코디네이터 클래스
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(parent: MapView) {
            self.parent = parent
        }

        /// 주석(annotation)에 대한 뷰를 반환하는 메서드
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? TemperatureAnnotation else {
                return nil
            }

            let identifier = "CustomMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
            } else {
                annotationView?.annotation = annotation
            }

            annotationView?.glyphText = "\(annotation.temperature)°"
            annotationView?.markerTintColor = .blue

            return annotationView
        }
    }

    // MARK: - UIViewRepresentable 메서드
    
    /// Coordinator 객체를 생성하는 메서드
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    /// MKMapView를 생성하고 초기 설정을 하는 메서드
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = false
        return mapView
    }

    /// MKMapView를 업데이트하는 메서드
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if let existingAnnotation = uiView.annotations.first(where: { ($0.coordinate.latitude == latitude) && ($0.coordinate.longitude == longitude) }) as? TemperatureAnnotation {
            if existingAnnotation.temperature != temperature {
                existingAnnotation.temperature = temperature
            
                if let annotationView = uiView.view(for: existingAnnotation) as? MKMarkerAnnotationView {
                    annotationView.glyphText = "\(existingAnnotation.temperature)°"
                }
            }
        } else {
            uiView.removeAnnotations(uiView.annotations)
    
            let annotation = TemperatureAnnotation()
            annotation.coordinate = coordinate
            annotation.temperature = temperature
            
            uiView.addAnnotation(annotation)
        }
        
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        uiView.setRegion(region, animated: true)
    }
}


