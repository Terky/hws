//
//  Peson.swift
//  Project 10
//
//  Created by Артём Бурмистров on 3/31/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

