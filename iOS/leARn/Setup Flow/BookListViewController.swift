//
//  BookListViewController.swift
//  leARn
//
//  Created by Avery on 7/28/18.
//  Copyright © 2018 Avery Lamp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class BookListViewController: UIViewController {

    private var listener: ListenerRegistration?
    private var allBooks: [Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


    // MARK: Firebase Update Methods
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
    
    fileprivate func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        // Display data from Firestore, part one
        
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            
            let models = snapshot.documents.map { (document) -> Book in
                if let model = Book(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(Book.self) with dictionary \(document.data())")
                }
            }
            
            self.allBooks = models
            
//            self.updateVisiblePostsWithCurrentCategory()
        }
    }
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("books").limit(to: 100)
    }

    
    
}
