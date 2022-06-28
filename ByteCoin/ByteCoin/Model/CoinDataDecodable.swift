//
//  CoinDataDecodable.swift
//  ByteCoin
//
//  Created by Andrew Emad on 28/06/2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData : Decodable {
    let asset_id_base : String
    let asset_id_quote : String
    let rate : Double
}
