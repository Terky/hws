//
//  ViewController.swift
//  ShoppingList
//
//  Created by Артём Бурмистров on 3/19/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping list"
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self,
                            action: #selector(addItem)),
            UIBarButtonItem(barButtonSystemItem: .action, target: self,
                            action: #selector(shareList))
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .trash, target: self,
            action: #selector(clearList))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter item you wanted to add",
                                   message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default)
        { [weak self, weak ac] action in
            guard let item = ac?.textFields?[0].text else {
                self?.promptError(message: "Unable to read input")
                return
            }
            
            self?.submitNewItem(item: item)
        })
        present(ac, animated: true)
    }
    
    func submitNewItem(item: String) {
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func promptError(message: String) {
        let ac = UIAlertController(title: "Error", message: message,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func clearList() {
        guard !shoppingList.isEmpty else { return }
        
        let ac = UIAlertController(title: "Confirm action",
                    message: "Are you sure you want to clear shopping list?",
                    preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        ac.addAction(UIAlertAction(title: "Yes", style: .default)
        { [weak self] action in
            self?.shoppingList.removeAll()
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }
    
    @objc func shareList() {
        guard !shoppingList.isEmpty else {
            promptError(message: "Nothing to share!")
            return
        }
        
        let vc = UIActivityViewController(
            activityItems: ["Shopping list:\n" + shoppingList.joined(separator: "\n")],
            applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem
            .rightBarButtonItems?[0]
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

