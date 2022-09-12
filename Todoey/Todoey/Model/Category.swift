//
//  Category.swift
//  Todoey
//
//  Created by Andrew Emad on 07/09/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @Persisted var name : String = ""
    @Persisted var colour : String?
    @Persisted var items : List<Item> = List<Item>()
}
