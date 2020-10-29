//
//  ThrustedWebsites.swift
//  Project 3
//
//  Created by Артём Бурмистров on 2/15/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import Foundation

final class ThrustedWebsites {
    public let websites = ["apple.com", "hackingwithswift.com"]
    
    private init() {}
    
    public static let shared = ThrustedWebsites()
}
