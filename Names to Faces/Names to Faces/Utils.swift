//
//  Utils.swift
//  Names to Faces
//
//  Created by Артём Бурмистров on 4/6/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import Foundation

struct Utils {
    static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
