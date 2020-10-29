//
//  DetailViewController.swift
//  Notes
//
//  Created by Артём Бурмистров on 5/1/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    var delegate: DetailViewControllerDelegate?
    
    var note: Note!
    
    var textView: UITextView!
    var originalHash: Int!
    
    var doneButton: UIBarButtonItem!
    var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        doneButton = UIBarButtonItem(
            barButtonSystemItem: .done, target: self,
            action: #selector(donePressed))
        shareButton = UIBarButtonItem(
               barButtonSystemItem: .action, target: self,
               action: #selector(shareNote))
        
        shareButton.tintColor = .systemOrange
        doneButton.tintColor = .systemOrange
        
        navigationItem.rightBarButtonItems = [shareButton]
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
        
        textView.text = note.text
        originalHash = note.text.hashValue
        textView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationController?.navigationBar.tintColor = .systemOrange
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashPressed))
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newNote))
        
        trashButton.tintColor = .systemOrange
        composeButton.tintColor = .systemOrange
        
        toolbarItems = [
            trashButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            composeButton
        ]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if let text = textView.text, text != "" {
            if note.text == "" {
                createNote()
            } else if originalHash != text.hashValue {
                updateNote()
            }
        } else {
            deleteNote()
        }
        
        if let rightBar = navigationItem.rightBarButtonItems {
            if rightBar.contains(doneButton) {
                textView.resignFirstResponder()
            }
        }
    }
    
    @objc func shareNote() {
        let vc = UIActivityViewController(
            activityItems: [textView.text ?? ""], applicationActivities: [])
        
        vc.popoverPresentationController?.barButtonItem =
            navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.textContainerInset = .zero
            navigationItem.rightBarButtonItems = [shareButton]
        } else {
            navigationItem.rightBarButtonItems = [doneButton, shareButton]
            let keyboardInset =
                keyboardViewEndFrame.height - view.safeAreaInsets.bottom
            textView.textContainerInset = UIEdgeInsets(
                top: 0, left: 0, bottom: keyboardInset, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.textContainerInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    @objc func donePressed() {
        textView.resignFirstResponder()
    }
    
    @objc func trashPressed() {
        deleteNote()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func newNote() {
        guard let navController = navigationController else { return }

        let parentController = navController.viewControllers[0]

        if let vc = storyboard?.instantiateViewController(identifier: "NoteDetail") as? DetailViewController {
            vc.note = Note(text: "")
            vc.delegate = self.delegate
            navigationController?.setViewControllers([parentController, vc], animated: true)
        }
    }
    
    func createNote() {
        guard let text = textView.text else { return }
        
        note.text = text
        Note.save(note)
        
        if let delegate = self.delegate, let note = self.note {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                delegate.onNoteCreate(note)
            }
        }
    }
    
    func deleteNote() {
        Note.delete(note)
        
        if let delegate = self.delegate, let note = self.note {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                delegate.onNoteDelete(note)
            }
        }
    }
    
    func updateNote() {
        guard let text = textView.text else {
            deleteNote()
            return
        }
        
        note.text = text
        Note.save(note)
        
        if let delegate = self.delegate, let note = self.note {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                delegate.onNoteUpdate(note)
            }
        }
    }
}

protocol DetailViewControllerDelegate {
    func onNoteDelete(_ note: Note)
    func onNoteUpdate(_ note: Note)
    func onNoteCreate(_ note: Note)
}
