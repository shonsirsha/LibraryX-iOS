//
//  DataService.swift
//  LibraryX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
let DB_BASE = Database.database().reference()
let STORAGE = Storage.storage().reference()
class DataService{
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USER = DB_BASE.child("users")
    private var _REF_BOOK = DB_BASE.child("books")
    private var _REF_STORAGE = STORAGE
    
    
    var REF_BASE:DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USER:DatabaseReference{
        return _REF_USER
    }
    
    var REF_BOOK:DatabaseReference{
        return _REF_BOOK
    }
    
    var REF_STORAGE: StorageReference{
        return _REF_STORAGE
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
    
    func getGenresFromImgTitle(imgTitleInMS: Double, myGenresInStr: @escaping(_ genres: String)->()){
        var allGenres = [String]()
        var unwrappedGenre2 = ""
        var unwrappedGenre3 = ""
        REF_BOOK.queryOrdered(byChild: "image").queryEqual(toValue: imgTitleInMS).observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for book in snapshot{

            let genre1 = book.childSnapshot(forPath: "genre1").value as! String
            
            if let genre2 = book.childSnapshot(forPath: "genre2").value as? String {
                unwrappedGenre2 = genre2
            }
            if let genre3 = book.childSnapshot(forPath: "genre3").value as? String {
                unwrappedGenre3 = genre3
            }
                allGenres.append(genre1)
                allGenres.append(unwrappedGenre2)
                allGenres.append(unwrappedGenre3)

            }
            
            for (ix, genre) in allGenres.enumerated() {
                if genre == ""{
                    allGenres.remove(at: ix)
                }
            }
            
            let stringGenres = allGenres.joined(separator: ", ")
            
            myGenresInStr(stringGenres)
            
        }
    }
    
    func scannedBookFromImgTitle(imgTitleinMS: Double, myBookTitle: @escaping(_ bookTitle: String)->(), maximumBorrow: @escaping(_ max: Int)->()){ //qrcode is image title in ms
      
        REF_BOOK.queryOrdered(byChild: "image").queryEqual(toValue: imgTitleinMS).observe(DataEventType.value) { (snapshot) in
            if snapshot.exists(){
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                for book in snapshot{
                    
                    let bookTitle = book.childSnapshot(forPath: "bookTitle").value as! String
                    
                    let max = book.childSnapshot(forPath: "max").value as! Int
                    
                    
                    myBookTitle(bookTitle)
                    maximumBorrow(max)
                }
            }else{
                myBookTitle("")
                maximumBorrow(0)
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
    
    func getABookStatus(imgTitleInMS: Double,handler: @escaping(_ status: String)->()){
        REF_BOOK.queryOrdered(byChild: "image").queryEqual(toValue: imgTitleInMS).observe(DataEventType.value) { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for book in snapshot{
                let status = book.childSnapshot(forPath: "status").value as! String
                handler(status)
            }
            
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
