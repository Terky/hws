//
//  NewCountryViewController.swift
//  Country Facts
//
//  Created by Артём Бурмистров on 4/13/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class NewCountryViewController: UIViewController {
    var delegate: NewCountryViewControllerDelegate?
    
    var newCountry: Country?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(save))
        
//        let countryLabel: 
    }
    
    @objc func save() {
        if let country = newCountry {
            delegate?.onDismiss(country)
        }
        dismiss(animated: true)
    }
}

protocol NewCountryViewControllerDelegate {
    func onDismiss(_ country: Country)
}
