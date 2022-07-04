//
//  WeatherLogic.swift
//  Clima
//
//  Created by Andrew Emad on 27/06/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol DealWithWeatherDelegate {
    func didUpdateWheather (weather : WeatherData)
    func didErrorHappened (error : Error)
}

struct WeatherManagment {
    
    var delegate : DealWithWeatherDelegate? = nil
    
    // ADD YOUR API KEY
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=ADD YOUR API KEY &units=metric"
    
    func getWeatherByCityName (cityName : String){
        

        let urlString = "\(weatherUrl)&q=\(cityName)"
        
        if let url = URL(string: urlString){
            performAPIRequest(url: url)
        }
              
    }
    
    func getWeatherByLatitudeAndLongtude (latitude: Double , longtude : Double ){
        
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longtude)"
        if let url = URL(string: urlString){
            performAPIRequest(url: url)
        }
              
    }

    private func performAPIRequest (url : URL){
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = urlSession.dataTask(with: url){ (data,response,error) in
            if let isErrorHappened = error {
                self.delegate?.didErrorHappened(error: isErrorHappened)
                return
            }
            
            if let safeData = data {
                if let weather = self.parseJson(data: safeData){
                    self.delegate?.didUpdateWheather(weather: weather)
                }
            }
        }
        task.resume()
    }
    private func parseJson(data:Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherDecodedData.self , from: data)
            
            let cityName  = decodedData.name
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            
            let currentWeather = WeatherData(conditionID: id, cityName: cityName, temperature: temperature)
            return currentWeather
            
            
        } catch {
            delegate?.didErrorHappened(error: error)
            return nil
        }
        
    }
    
    
    
}
