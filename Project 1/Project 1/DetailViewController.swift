//
//  DetailViewController.swift
//  Project 1
//
//  Created by Артём Бурмистров on 2/12/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var newTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = newTitle
        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageName = selectedImage {
            imageView.image = UIImage(named: imageName)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func shareTapped(_ sender: Any) {
        guard let image = imageView.image?.jpegData(compressionQuality: 1) else {
            print("No image found")
            return
        }
        
        guard let imageName = selectedImage else {
            print("No image name found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [imageName, image],
                                          applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem =
            navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
