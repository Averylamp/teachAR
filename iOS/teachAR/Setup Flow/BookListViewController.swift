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

    @IBOutlet weak var bookListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookListTableView.separatorStyle = .none
        bookListTableView.dataSource = self
        bookListTableView.delegate = self
        
        query = baseQuery()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        observeQuery()
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
            
            let models = snapshot.documents.filter({ (document) -> Bool in
                if  Book(dictionary: document.data()) != nil {
                    return true
                }
                print("Stripped book = \(document)")
                return false
            }).map({ (document) -> Book in
                if let model = Book(dictionary: document.data()) {
                    return model
                }
                fatalError("This shouldn't happen oops")
            })
            
            self.allBooks = models
            self.bookListTableView.reloadData()
        }
    }
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("books").order(by: "bookID", descending: false)
    }

    
    
}
extension BookListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allBooks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
        
        cell.setupWithBook(book: self.allBooks[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = self.allBooks[indexPath.row]
        
        if let arVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ARVC") as? ARViewController{
            print("Book selected =\(book.bookID)=")
            let db = Firestore.firestore()
            db.collection("books/\(book.bookID)/images").limit(to: 200).getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }
                
                let models = snapshot.documents.filter({ (document) -> Bool in
                    if Image(dictionary: document.data()) != nil{
                        return true
                    }
                        print("Stripped doc \(document)")
                    return false
                }).map({ (document) -> Image in
                    if let model = Image(dictionary: document.data()) {
                        return model
                    }
                    fatalError("Unable to initialize type \(Image.self) with dictionary \(document.data())")
                })
                
                for model in models{
                    print(model.targetImageURL)
                }
            }
//            self.navigationController?.pushViewController(arVC, animated: true)
        }
        
    }
    
    
}
