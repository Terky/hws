//
//  ViewController.swift
//  Names to Faces
//
//  Created by Артём Бурмистров on 4/5/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Names"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load saved people.")
            }
        }
    }

    @objc func addPerson() {
        let imagePicker = UIImagePickerController()
        
        let completionBlock = { [weak self] in
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self?.present(imagePicker, animated: true)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let ac = UIAlertController(title: "Choose photo source", message: nil, preferredStyle: .actionSheet)
            
            ac.addAction(UIAlertAction(title: "Camera", style: .default) { action in
                imagePicker.sourceType = .camera
                CATransaction.setCompletionBlock {
                    completionBlock()
                }
            })
            ac.addAction(UIAlertAction(title: "Photo library", style: .default) { action in
                CATransaction.setCompletionBlock {
                    completionBlock()
                }
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(ac, animated: true)
        } else {
            completionBlock()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        cell.textLabel?.text = people[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailsViewController {
            vc.person = people[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = Utils.getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.insert(person, at: 0)
        save()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        dismiss(animated: true)
    }
}

// Helper methods
extension ViewController {
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedPeople = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedPeople, forKey: "people")
        } else {
            print("Failed to save pe")
        }
    }
}
