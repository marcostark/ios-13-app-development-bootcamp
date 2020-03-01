//
//  WeatherManager.swift
//  Clima
//
//  Created by Marcos on 01/03/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=e72ca729af228beabd5d20e3b7749713&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        self.performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        self.performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        // 0. Cria a URL
        
        if let url = URL(string: urlString) {
            // 1. Cria a URLSession
            
            let session = URLSession(configuration: .default)
            
            // 2. Recupera a tarefa da sessão
            
            let task  = session.dataTask(with: url) {(data,response,error) in
                // Responsabilidade de processar a chamada a rede
                if error != nil {
                    //print(error)
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
                   
            // 3. Inicia a tarefa
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        print(weatherData)
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodeData.name
            let temperatute = decodeData.main.temp
            let id = decodeData.weather[0].id
            
            let weatherModel = WeatherModel(conditionId: id, name: name, temperature: temperatute)
            
            return weatherModel

        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
