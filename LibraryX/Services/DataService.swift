//
//  DataService.swift
//  LibraryX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService{
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USER = DB_BASE.child("users")
    private var _REF_BOOK = DB_BASE.child("books")
    
    var REF_BASE:DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USER:DatabaseReference{
        return _REF_USER
    }
    
    var REF_BOOK:DatabaseReference{
        return _REF_BOOK
    }
    


    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        REF_USER.child(uid).updateChildValues(userData)
    }
    
    func getEmail(uid: String, myEmail: @escaping(_ email: String)->()){
        REF_USER.observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else{return}
            for user in snapshot{
                if user.key == uid{
                    myEmail(user.childSnapshot(forPath: "email").value as! String)
                }
            }
            
        }
    }
    
    func getFullName(uid: String, myFullName: @escaping(_ fullName: String)->()){
        REF_USER.observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else{return}
            for user in snapshot{
                if user.key == uid{
                    myFullName(user.childSnapshot(forPath: "fullName").value as! String)
                }
            }
            
        }
    }
    
    func getAllBooks(handler: @escaping(_ eachBookObj: [BookDetailForCell])->()){ // browse book
        var allBooksArray = [BookDetailForCell]()
        var unwrappedGenre2 = ""
        var unwrappedGenre3 = ""
        var unwrappedYear = ""
        REF_BOOK.queryOrdered(byChild: "genre1").observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for book in snapshot{
                let bookTitle = book.childSnapshot(forPath: "bookTitle").value as! String
                let authorName = book.childSnapshot(forPath: "authorName").value as! String
                let genre1 = book.childSnapshot(forPath: "genre1").value as! String
                if let genre2 = book.childSnapshot(forPath: "genre2").value as? String {
                    unwrappedGenre2 = genre2
                }
                if let genre3 = book.childSnapshot(forPath: "genre3").value as? String {
                    unwrappedGenre3 = genre3
                }
                if let year = book.childSnapshot(forPath: "year").value as? String {
                    unwrappedYear = year
                }
                let imgTitle = book.childSnapshot(forPath: "image").value as! Double
                
                let book = BookDetailForCell(bookTitle: bookTitle, authorName: authorName, genre1: genre1, genre2: unwrappedGenre2, genre3: unwrappedGenre3, year: unwrappedYear, imgTitle: imgTitle)
                
                
                allBooksArray.append(book)
            }
            
            handler(allBooksArray)
            allBooksArray = [BookDetailForCell]()
            
        }
        
    }
    
  /*  func getABookByImgTitle(imageTitleInMs: Double ,handler: @escaping(_ bookObj: [BookDetailForCell])->()){ // img title is in ms
        var bookArr = [BookDetailForCell]()
        var unwrappedGenre2 = ""
        var unwrappedGenre3 = ""
        var unwrappedYear = ""
        REF_BOOK.queryOrdered(byChild: "image").queryEqual(toValue: imageTitleInMs).observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for book in snapshot{
                let bookTitle = book.childSnapshot(forPath: "bookTitle").value as! String
                let authorName = book.childSnapshot(forPath: "authorName").value as! String
                let genre1 = book.childSnapshot(forPath: "genre1").value as! String
                if let genre2 = book.childSnapshot(forPath: "genre2").value as? String {
                    unwrappedGenre2 = genre2
                }
                if let genre3 = book.childSnapshot(forPath: "genre3").value as? String {
                    unwrappedGenre3 = genre3
                }
                if let year = book.childSnapshot(forPath: "year").value as? String {
                    unwrappedYear = year
                }
                let imgTitle = book.childSnapshot(forPath: "image").value as! Double
                
                let book = BookDetailForCell(bookTitle: bookTitle, authorName: authorName, genre1: genre1, genre2: unwrappedGenre2, genre3: unwrappedGenre3, year: unwrappedYear, imgTitle: imgTitle)
                
                
                bookArr.append(book)
            }
            
            handler(bookArr)
            bookArr = [BookDetailForCell]()
            
        }
        
    }
    */
    

    
    
}
