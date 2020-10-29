//
//  Capital.swift
//  Project 16
//
//  Created by Артём Бурмистров on 4/10/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
