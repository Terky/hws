//
//  MainTableViewController.swift
//  Notes
//
//  Created by Артём Бурмистров on 5/1/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    var notes = [Note]() {
        didSet {
            notesCountLabel.text = "\(notes.count) Notes"
        }
    }
    
    var notesCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
        title = "Notes"
        
        let documentsUrl = Utils.documentsUrl
        let documentsPath = documentsUrl.path
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let savedNotesPaths = try? FileManager.default
                .contentsOfDirectory(atPath: documentsPath) else { return }
            
            var notes = Set<Note>()
            
            for case let notePath in savedNotesPaths
                where notePath.starts(with: "note_") && notePath.hasSuffix(".json")
            {
                let url = documentsUrl.appendingPathComponent(notePath)
                if let note = Note.restore(from: url) {
                    notes.insert(note)
                }
            }
            
            DispatchQueue.main.async {
                self?.notes = notes.map { $0 }
                self?.tableView.reloadData()
            }
        }
        
        notesCountLabel = UILabel()
        notesCountLabel.text = "0 Notes"
        notesCountLabel.font = .systemFont(ofSize: 13)
        notesCountLabel.bounds.size.width = 200
        notesCountLabel.textAlignment = .center
        let notesCountButton = UIBarButtonItem(customView: notesCountLabel)
        notesCountButton.width = 200
        notesCountLabel.isUserInteractionEnabled = false
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newNote))
        newNoteButton.tintColor = .systemOrange
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [space, notesCountButton, space, newNoteButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: "NoteCell")
            as? NoteTableViewCell else {
            fatalError("NoteCell not found")
        }
        
        let lines = notes[indexPath.row].text.components(separatedBy: .newlines)
        
        cell.titleLabel.text = lines.first
        cell.desctiptionLabel.text = lines.dropFirst().first
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        
        if let vc = storyboard?
            .instantiateViewController(identifier: "NoteDetail")
            as? DetailViewController {
            vc.note = note
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func newNote() {
        if let vc = storyboard?
            .instantiateViewController(identifier: "NoteDetail")
            as? DetailViewController {
            vc.note = Note(text: "")
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainTableViewController: DetailViewControllerDelegate {
    func onNoteDelete(_ note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        
        notes.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    func onNoteUpdate(_ note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        
        notes[index] = note
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func onNoteCreate(_ note: Note) {
        notes.insert(note, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}
