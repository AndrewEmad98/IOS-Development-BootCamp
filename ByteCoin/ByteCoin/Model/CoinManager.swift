//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinableDelegate {
    func errorHappned (error : Error)
    func updateCoinData(rate : Double?)
}
struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "644A390B-8A7B-40CE-9AFE-49B690BFCA66"
    var delegate : CoinableDelegate? = nil
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency : String ){
        let urlString = "\(baseURL)BTC/\(currency)?apiKey=\(apiKey)"
        if let url = URL(string: urlString){
            requestFromCoinApi(url: url)
        }
    }
    
    func requestFromCoinApi(url : URL){
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url){ (data,response,error) in
            if let errorHappned = error {
                self.delegate?.errorHappned(error: errorHappned)
            }
            if let safeData = data {
                let rate = parseJson(data: safeData)
                self.delegate?.updateCoinData(rate: rate)
            }
        }
        task.resume()
    }
    func parseJson(data : Data)->Double?{
        let decoder = JSONDecoder()
        do {
            let dataDecoded = try decoder.decode(CoinData.self, from: data)
            let rate = dataDecoded.rate
            return rate
        }catch {
            delegate?.errorHappned(error: error)
            return nil
        }
    }
}
