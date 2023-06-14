//
//  LocationServiceManager.swift
//  WeatherApp
//
//  Created by Thomson Varghese on 6/13/23.
//

import CoreLocation

protocol LocationRepository {

    func start(completion: @escaping (CLLocation) -> Void)
}

final class LocationServiceManager: NSObject, LocationRepository {

    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    private var locationUpdateHandler: ((CLLocation) -> Void)?

    // MARK: - Initializers
    override init() {

        super.init()
        locationManager.delegate = self
    }

    // MARK: - Public Methods
    func start(completion: @escaping (CLLocation) -> Void) {

        locationUpdateHandler = completion
        handleLocationAuthorizationStatus()
    }
    
    // MARK: - Private Methods
    //Handle location authorization status.
    private func handleLocationAuthorizationStatus() {

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationServiceManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        handleLocationAuthorizationStatus()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            locationManager.stopUpdatingLocation()
            return
        }
        locationUpdateHandler?(location)
        locationManager.stopUpdatingLocation()
    }
}

