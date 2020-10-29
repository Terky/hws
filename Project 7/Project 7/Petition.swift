//
//  Petition.swift
//  Project 7
//
//  Created by Артём Бурмистров on 3/18/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
