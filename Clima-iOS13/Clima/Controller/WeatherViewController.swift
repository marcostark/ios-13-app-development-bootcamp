//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    @IBAction func locationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
     @IBAction func searchPressed(_ sender: Any) {
         searchTextField.endEditing(true) // Informando fim da edicao e fechando teclado
         }
     
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           searchTextField.endEditing(true) // Informando fim da edicao e fechando teclado
           return true
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           // Limpar teclado após o fim da edição
           if let city = searchTextField.text {
               weatherManager.fetchWeather(cityName: city)
           }
           
           searchTextField.text = ""
       }
       
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           // Validar o que está sendo digitado
           if textField.text != "" {
               return true
           } else {
               textField.placeholder = "Digite alguma coisa"
               return false
           }
       }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.name
        }
        print(weather.conditionName)
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
