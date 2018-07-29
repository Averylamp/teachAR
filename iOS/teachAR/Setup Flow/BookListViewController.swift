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

    var username:String = ""
    
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
            print("\(self.allBooks.count) Books downloaded")
            self.delay(0.4, closure: {
                self.bookListTableView.reloadData()
            })
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
        print("Number of cells \(self.allBooks.count)")
        return self.allBooks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 13 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
        print("generatic cell \(indexPath.row)")
        cell.setupWithBook(book: self.allBooks[indexPath.row])
        cell.layoutIfNeeded()
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
                
                DispatchQueue.main.async {
                    SwiftSpinner.show(progress: 0.0, title: "Downloading Book Images...")
                }
                let totalCount:Double = Double(models.count)
                var currentCount = 0
                var finalImages = Array<Image>()
                for model in models{
                    model.downloadImage(completion: { (error) in
                        currentCount += 1
                        if error != nil{
                            print("Failed to download Image: \(error) - \(model.targetImageURL)")
                        }else{
                            finalImages.append(model)
                            DispatchQueue.main.async {
                                SwiftSpinner.show(progress: Double(currentCount) / totalCount, title: "\(currentCount)/\(Int(totalCount)) Images: \(model.title) downloaded")
                            }
                        }
                        if Double(currentCount) == totalCount{
                            DispatchQueue.main.async {
                                SwiftSpinner.show(delay: 0.2, title: "All Images Downloaded!")
                                arVC.allImages = finalImages
                                arVC.instantiateImageReferences()
                                self.delay(1.0, closure: {
                                    SwiftSpinner.hide()
                                    self.navigationController?.pushViewController(arVC, animated: true)
                                })
                            }
                        }
                    })
                }
            }
        }
        
    }
    
    
}
