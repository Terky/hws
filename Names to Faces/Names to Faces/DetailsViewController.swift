//
//  DetailsViewController.swift
//  Names to Faces
//
//  Created by Артём Бурмистров on 4/5/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var person: Person!
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = person.name

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor)
        ])
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let imageName = self?.person.image else { return }
            let imagePath = Utils.getDocumentsDirectory()
                .appendingPathComponent(imageName)
            
            if let image = UIImage(contentsOfFile: imagePath.path) {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
