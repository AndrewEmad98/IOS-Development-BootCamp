//
//  WeatherData.swift
//  Clima
//
//  Created by Andrew Emad on 27/06/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

struct WeatherDecodedData : Codable {
    let name : String
    let main : Main
    let weather : [WeatherInfo]
}
struct Main : Codable {
    let temp : Double
}
struct WeatherInfo : Codable {
    let description : String
    let id : Int
}



