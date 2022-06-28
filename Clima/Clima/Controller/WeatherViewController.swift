//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController  {
    
    var weatherBrain = WeatherManagment()
    let locationManager = CLLocationManager()
    
    var latitude :Double? = nil
    var longtude :Double? = nil
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherBrain.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()

    }

    
}
//MARK: - UITextFieldDelegate


extension WeatherViewController : UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherBrain.getWeatherByCityName(cityName: searchTextField.text ?? "")
        searchTextField.text = ""
    }
}

//MARK: - DealWithWeatherDelegate

extension WeatherViewController : DealWithWeatherDelegate {
    
    func didUpdateWheather(weather : WeatherData){
        DispatchQueue.main.async {
            
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
        }
    }
    func didErrorHappened (error : Error){
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController : CLLocationManagerDelegate {
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location")
        if let currentLocation = locations.last {
            latitude = Double(currentLocation.coordinate.latitude)
            longtude = Double(currentLocation.coordinate.longitude)
        }
        weatherBrain.getWeatherByLatitudeAndLongtude(latitude: self.latitude ?? 0.0 , longtude: self.longtude ?? 0.0)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
