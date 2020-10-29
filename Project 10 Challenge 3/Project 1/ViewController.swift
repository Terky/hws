//
//  ViewController.swift
//  Project 1
//
//  Created by Артём Бурмистров on 2/2/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {//UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    self?.pictures.append(item)
                }
            }
            
            self?.pictures.sort()
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action, target: self,
            action: #selector(shareTapped)
        )
    }
    
    @objc func shareTapped(_ sender: Any) {
        let vc = UIActivityViewController(
            activityItems: ["You should try Storm Viewer, that's a cool app!"],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem =
            navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to deque PictureCell")
        }
        
        let picture = pictures[indexPath.item]
        cell.imageView.image = UIImage(named: picture)
        cell.imageName.text = picture
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail")
            as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.newTitle = "Picture \(indexPath.item + 1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pictures.count
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
//
//        cell.textLabel?.text = pictures[indexPath.row]
//
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(identifier: "Detail")
//            as? DetailViewController {
//            vc.selectedImage = pictures[indexPath.row]
//            vc.newTitle = "Picture \(indexPath.row + 1) of \(pictures.count)"
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
}

