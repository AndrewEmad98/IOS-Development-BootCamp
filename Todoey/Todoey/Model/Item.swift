//
//  Item.swift
//  Todoey
//
//  Created by Andrew Emad on 07/09/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @Persisted var title : String = ""
    @Persisted var isDone : Bool = false
    @Persisted var dateCreated : Date = Date()

    
    @Persisted(originProperty: "items") var parentCategory : LinkingObjects<Category>
    //var parentCategory = LinkingObjects<Category>(fromType: Category.self, property: "items")
}
