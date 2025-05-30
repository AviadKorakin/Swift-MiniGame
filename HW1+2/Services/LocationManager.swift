import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdate(latitude: Double)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }

    func stopUpdates() {
        manager.stopUpdatingLocation()
    }

    func locationManager(_ mgr: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        if let lat = locs.first?.coordinate.latitude {
            delegate?.didUpdate(latitude: lat)
        }
    }

    func locationManager(_ mgr: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
    }
}
