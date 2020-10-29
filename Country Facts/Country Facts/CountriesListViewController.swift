//
//  CountriesListViewController.swift
//  Country Facts
//
//  Created by Артём Бурмистров on 4/13/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class CountriesListViewController: UITableViewController {
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addNewCountry))
        
        let fileUrl = FileManager.getDocumentsDirectoryURL()
            .appendingPathComponent("countries.json")
        let filePath = fileUrl.path
        
        let fm = FileManager.default

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if fm.fileExists(atPath: filePath) {
                fm.createFile(atPath: filePath, contents: nil, attributes: nil)
            } else if let json = try? Data(contentsOf: fileUrl) {
                let jsonDecoder = JSONDecoder()
                if let data = try? jsonDecoder.decode([Country].self, from: json) {
                    DispatchQueue.main.async {
                        self?.countries = data
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)

        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "Capital: \(country.capital)"

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    @objc func addNewCountry() {
        fatalError("Not implemented")
    }
}

extension FileManager {
    static func getDocumentsDirectoryURL() -> URL {
        self.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
