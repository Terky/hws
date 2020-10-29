//
//  ViewController.swift
//  Project 7
//
//  Created by Артём Бурмистров on 3/18/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allPetitions = [Petition]()
    var filteredPetitions = [Petition]()
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Credits",
            style: .plain,
            target: self,
            action: #selector(showCredits)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Filter",
            style: .plain,
            target: self,
            action: #selector(filterResults)
        )
        
        if navigationController?.tabBarItem.tag == 0 {
            title = "Recent petitions"
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            title = "Popular petitions"
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        performSelector(inBackground: #selector(fetchJson), with: nil)
    }
    
    @objc func fetchJson() {
//        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        if let url = URL(string: urlString ?? "") {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
//        performSelector(inBackground: #selector(showError), with: nil)
    }
    
    @objc func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed; please check your connection and try again",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: urlString,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterResults() {
        let ac = UIAlertController(title: "Enter a keyword", message: nil,
                                   preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Apply", style: .default) { [weak self, weak ac] _ in
            guard let keyword = ac?.textFields?[0].text else { return }
            
            self?.applyFilter(by: keyword)
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }
    
    func applyFilter(by keyword: String) {
        guard keyword != "" else {
            filteredPetitions = allPetitions
            return
        }
        
        filteredPetitions = allPetitions.filter { petition in
            petition.title.contains(keyword) || petition.body.contains(keyword)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            filteredPetitions = allPetitions
            
            tableView.performSelector(
                onMainThread: #selector(UITableView.reloadData),
                with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil,
                            waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

