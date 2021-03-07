//
//  AllowLocationViewController.swift
//  Nibm Cafeteria
//
//  Created by Nimesh Lakshan on 2021-03-02.
//

import UIKit
import CoreLocation

class AllowLocationViewController: BaseViewController {
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestAlwaysAuthorization()
    }
    
    @IBAction func onAllowLocationClicked(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .restricted, .denied, .notDetermined:
                NSLog("Location services disabled")
                displayErrorMessage(message: "Application requires location access to continue!")
            case .authorizedAlways, .authorizedWhenInUse:
                NSLog("Location services enabled")
                self.performSegue(withIdentifier: "allowLocationToHome", sender: nil)
            default:
                displayErrorMessage(message: "Application requires location access to continue!")
                NSLog("Location services disabled")
            }
        } else {
            displayWarningMessage(message: "Please enable location services")
        }
    }

}
