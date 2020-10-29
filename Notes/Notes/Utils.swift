//
//  Utils.swift
//  Notes
//
//  Created by Артём Бурмистров on 5/1/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import Foundation

struct Utils {
    static var documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
