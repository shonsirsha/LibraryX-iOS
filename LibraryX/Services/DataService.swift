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
    private var _REF_EBOOK = DB_BASE.child("ebooks")
    private var _REF_WIFI = DB_BASE.child("wifiscanner")
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
    
    var REF_EBOOK: DatabaseReference{
        return _REF_EBOOK
    }
    
    var REF_WIFI:DatabaseReference{
        return _REF_WIFI
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
    
    func checkIfUserDeleted(uid: String, myPassword: @escaping(_ pw: String)->()){
        REF_USER.queryOrdered(byChild: "uid").queryEqual(toValue: uid).observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else{return}
            for user in snapshot{
                let pw = user.childSnapshot(forPath: "password").value as! String
                myPassword(pw)
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
            
            allGenres = allGenres.filter{!$0.isEmpty}
        
            
            let stringGenres = allGenres.joined(separator: ", ")
            
            myGenresInStr(stringGenres)
            
        }
    }
    
    func getEbookGenres(imgTitleInMS: Double, myGenresInStr: @escaping(_ genres: String)->()){
        var allGenres = [String]()
        var unwrappedGenre2 = ""
        var unwrappedGenre3 = ""
        REF_EBOOK.queryOrdered(byChild: "image").queryEqual(toValue: imgTitleInMS).observe(DataEventType.value) { (snapshot) in
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
            
            allGenres = allGenres.filter{!$0.isEmpty}
            
            
            let stringGenres = allGenres.joined(separator: ", ")
            
            myGenresInStr(stringGenres)
            
        }
    }
    
    func getEbookURL(imgTitleInMS: Double, url: @escaping(_ url: String)->()){
        REF_EBOOK.queryOrdered(byChild: "image").queryEqual(toValue: imgTitleInMS).observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for ebook in snapshot{
                let ebookUrl = ebook.childSnapshot(forPath: "eBookURL").value as! String
                url(ebookUrl)
            }
        }
    }
    
    func scannedBookFromImgTitle(imgTitleinMS: Double, bookStatusAndTitleHandler: @escaping(_ bookStatusAndTitleHandler: [String])->(), maximumBorrow: @escaping(_ max: Int)->()){ //qrcode is image title in ms
      var bookStatusAndTitle = [String]()
        
        REF_BOOK.queryOrdered(byChild: "image").queryEqual(toValue: imgTitleinMS).observe(DataEventType.value) { (snapshot) in
            if snapshot.exists(){
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                print("kodk")
                for book in snapshot{
                   
                    let status = book.childSnapshot(forPath: "status").value as! String
                    let bookTitle = book.childSnapshot(forPath: "bookTitle").value as! String
                    let max = book.childSnapshot(forPath: "max").value as! Int
                    
                    
                    bookStatusAndTitle.append(status)
                    bookStatusAndTitle.append(bookTitle)
                    bookStatusAndTitleHandler(bookStatusAndTitle)
                    maximumBorrow(max)
                }
            }else{
                print("Kodok2")
                bookStatusAndTitle.append("")
                bookStatusAndTitle.append("")
                bookStatusAndTitleHandler(bookStatusAndTitle)
                maximumBorrow(0)
            }
            
        }
    }
    
    /*func notifRemover(uid: String, imgTitleinMS: Double){ //qrcode is image title in ms
        
        REF_USER.child(uid).child("mybooks").queryOrdered(byChild: "image").queryEqual(toValue: imgTitleinMS).observe(DataEventType.value) { (snapshot) in
            if snapshot.exists(){
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                for book in snapshot{
                  
                    let opened = book.childSnapshot(forPath: "opened").value as! Int
                    let bookKey = book.key
                    
                    if opened == 0{
                        self.REF_USER.child(uid).child("mybooks").child(bookKey).updateChildValues(["opened":1])
                    }
                    
     
                }
            }else{
     
            }
            
        }
    }*/
    
    func myBookDetail(uid: String, startDate: Double, status: @escaping( _ bookStatus:String)->(), start: @escaping(_ startDate: Double)->(), until: @escaping(_ untilDate: Double)->(), title: @escaping(_ bookTitle: String)->(), actualReturned: @escaping(_ returnedDate: Double)->()){
        REF_USER.child(uid).child("mybooks").queryOrdered(byChild: "start").queryEqual(toValue: startDate).observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for book in snapshot{
                let bookTitle = book.childSnapshot(forPath: "title").value as! String
                let startDate = book.childSnapshot(forPath: "start").value as! Double
                let untilDate = book.childSnapshot(forPath: "until").value as! Double
                let hasOpened = book.childSnapshot(forPath: "hasOpened").value as! Int
                let bookStatus = book.childSnapshot(forPath: "status").value as! String
                let actualReturnedDate = book.childSnapshot(forPath: "actualReturned").value as! Double
                let bookKey = book.key
                
                status(bookStatus)
                print(bookStatus)
                start(startDate)
                until(untilDate)
                title(bookTitle)
                actualReturned(actualReturnedDate)
                
                self.REF_USER.child(uid).child("mybooks").child(bookKey).updateChildValues(["hasOpened":1])
                
            }
        }
    }
    
    func get10RecentActivities(uid: String, handler: @escaping(_ eachBookObj: [BookTitleForProfileCell])->()){
        REF_USER.child(uid).child("mybooks").queryOrdered(byChild: "actualReturned").queryLimited(toFirst: 10).observe(DataEventType.value) { (snapshot) in
            var bookTitlesArr = [BookTitleForProfileCell]()
            var needsAttentionBookArr = [BookTitleForProfileCell]()
            if snapshot.exists(){
      
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                for book in snapshot{
                    let bookTitle = book.childSnapshot(forPath: "title").value as! String
                    let imgTitleInMS = book.childSnapshot(forPath: "bookImgTitleInMS").value as! Double
                    let startDate = book.childSnapshot(forPath: "start").value as! Double
                    let untilDate = book.childSnapshot(forPath: "until").value as! Double
                    let hasOpened = book.childSnapshot(forPath: "hasOpened").value as! Int
                    let status = book.childSnapshot(forPath: "status").value as! String
                    let actualReturned = book.childSnapshot(forPath: "actualReturned").value as! Double
                    let late = book.childSnapshot(forPath: "late").value as! String
                    print(book)
                    let bookTitleObj = BookTitleForProfileCell(bookTitle: bookTitle, imgTitleInMS: imgTitleInMS, start: startDate, until: untilDate, opened: hasOpened, status: status, actualReturned: actualReturned)
                   
                    if late == "no"{
                        bookTitlesArr.append(bookTitleObj)
                    }else{
                        needsAttentionBookArr.append(bookTitleObj)
                    }
                }
                
                bookTitlesArr.append(contentsOf:needsAttentionBookArr)
                handler(bookTitlesArr.reversed())
                bookTitlesArr = [BookTitleForProfileCell]()
                needsAttentionBookArr = [BookTitleForProfileCell]()
                
            }else{ // no book borrowed yet
            }
        }

    }
    
    func getUnamePwForScannedLogin(scannedUid: String, email: @escaping(_ email: String)->(), password: @escaping(_ password: String)->()){
        REF_USER.queryOrdered(byChild: "uid").queryEqual(toValue: scannedUid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.exists(){
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                for user in snapshot{
                    let returnedEmail = user.childSnapshot(forPath: "email").value as! String
                    let returnedPassword = user.childSnapshot(forPath: "password").value as! String
                    email(returnedEmail)
                    password(returnedPassword)
                }
            }else{
                email("")
                password("")
            }
        })
        
        
    }
    
    func getAllActivities(uid: String, handler: @escaping(_ eachBookObj: [BookTitleForProfileCell])->()){ // for ActivitesCell
        REF_USER.child(uid).child("mybooks").queryOrdered(byChild: "actualReturned").observe(DataEventType.value) { (snapshot) in
            var bookTitlesArr = [BookTitleForProfileCell]()
            var needsAttentionBookArr = [BookTitleForProfileCell]()
            if snapshot.exists(){
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                for book in snapshot{
                    let bookTitle = book.childSnapshot(forPath: "title").value as! String
                    let imgTitleInMS = book.childSnapshot(forPath: "bookImgTitleInMS").value as! Double
                    let startDate = book.childSnapshot(forPath: "start").value as! Double
                    let untilDate = book.childSnapshot(forPath: "until").value as! Double
                    let hasOpened = book.childSnapshot(forPath: "hasOpened").value as! Int
                    let status = book.childSnapshot(forPath: "status").value as! String
                    let actualReturned = book.childSnapshot(forPath: "actualReturned").value as! Double
                    let late = book.childSnapshot(forPath: "late").value as! String
                    let bookTitleObj = BookTitleForProfileCell(bookTitle: bookTitle, imgTitleInMS: imgTitleInMS, start: startDate, until: untilDate, opened: hasOpened, status: status, actualReturned: actualReturned)
                    
                    if late == "no"{
                        bookTitlesArr.append(bookTitleObj)
                    }else{
                        needsAttentionBookArr.append(bookTitleObj)
                    }
                }
                
                bookTitlesArr.append(contentsOf: needsAttentionBookArr)
                handler(bookTitlesArr.reversed())
                bookTitlesArr = [BookTitleForProfileCell]()
                
            }else{ // no book borrowed yet
            }
        }
        
    }
    
    func everBorrow(uid: String, everBorrow: @escaping(_ ever: Bool)->()){
        REF_USER.child(uid).child("mybooks").observe(DataEventType.value) { (snapshot) in
            if snapshot.exists(){
                everBorrow(true)
            }else{
                everBorrow(false)
            }
        }
    }
    
    func amIBorrowing(uid: String, imgTitleInMS: Double, statusBorrowing: @escaping(_ borrow: String)->()){
        var actualStatus = ""
        REF_USER.child(uid).child("mybooks").queryOrdered(byChild: "bookImgTitleInMS").queryEqual(toValue: imgTitleInMS).observe(DataEventType.value) { (snapshot) in
            if snapshot.exists(){
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                for book in snapshot{
                    let status = book.childSnapshot(forPath: "status").value as! String
                    actualStatus = status
                }
                if actualStatus == "borrowing"{
                    statusBorrowing("borrow")
                }else if actualStatus == "returned"{
                    statusBorrowing("returned")
                }

            }else{
                 statusBorrowing("notByMe")
            }
            
        }
    }
    
    func getSearchedBooks(keyWord: String, handler: @escaping(_ eachBookObj: [BookDetailForCell])->()){
        REF_BOOK.queryOrdered(byChild: "bookTitle").queryStarting(atValue: keyWord).queryEnding(atValue: "\(keyWord)\("uF7FF")").observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for book in snapshot{
                print(book)
            }
            
        }
    }
    
    func getAllBooks(handler: @escaping(_ eachBookObj: [BookDetailForCell])->()){ // browse book
        var allBooksArray = [BookDetailForCell]()
        var unwrappedGenre2 = ""
        var unwrappedGenre3 = ""
        var unwrappedYear = ""
        REF_BOOK.queryOrdered(byChild: "image").observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for book in snapshot{
                let bookStatus = book.childSnapshot(forPath: "status").value as! String
                if bookStatus != "del"{
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
                
            }
            
            handler(allBooksArray.reversed())
            allBooksArray = [BookDetailForCell]()
            
        }
    }
    
    func getAllEbooks(handler: @escaping(_ eachEbookObj: [EbookDetailCell])->()){
        var allEbooksArray = [EbookDetailCell]()
        var unwrappedGenre2 = ""
        var unwrappedGenre3 = ""
        var unwrappedYear = ""
        
        REF_EBOOK.queryOrdered(byChild: "image").observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for ebook in snapshot{
                let bookTitle = ebook.childSnapshot(forPath: "bookTitle").value as! String
                let authorName = ebook.childSnapshot(forPath: "authorName").value as! String
                let genre1 = ebook.childSnapshot(forPath: "genre1").value as! String
                if let genre2 = ebook.childSnapshot(forPath: "genre2").value as? String {
                    unwrappedGenre2 = genre2
                }
                if let genre3 = ebook.childSnapshot(forPath: "genre3").value as? String {
                    unwrappedGenre3 = genre3
                }
                if let year = ebook.childSnapshot(forPath: "year").value as? String {
                    unwrappedYear = year
                }
                let imgTitle = ebook.childSnapshot(forPath: "image").value as! Double
                let ebookURL = ebook.childSnapshot(forPath: "eBookURL").value as! String
                print("ASU!")
                print(imgTitle)
                let ebook = EbookDetailCell(bookTitle: bookTitle, authorName: authorName, genre1: genre1, genre2: unwrappedGenre2, genre3: unwrappedGenre3, year: unwrappedYear, imgTitle: imgTitle, ebookURL: ebookURL)
                allEbooksArray.append(ebook)
            }
            
            handler(allEbooksArray.reversed())
            allEbooksArray = [EbookDetailCell]()
        }
    }
    
    func getABookStatus(imgTitleInMS: Double, handler: @escaping(_ status: [String])->()){
        REF_BOOK.queryOrdered(byChild: "image").queryEqual(toValue: imgTitleInMS).observe(DataEventType.value) { (snapshot) in
            var theBook = [String]()
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
           
            for book in snapshot{
                let status = book.childSnapshot(forPath: "status").value as! String
                let availAt = book.childSnapshot(forPath: "availAt").value as! String
                print(status)
                if status == "avail"{
                    theBook.append(availAt)
                    
                }else{
                    theBook.append("")

                }
                
                theBook.append(status)
                print(theBook)
                handler(theBook)

            }
            
        }
        
    }
    
    func getLastBookDetailFromActivity(uid: String, imgTitleInMS: Double, bookStart: @escaping(_ start: Double)->()){ //book start borrowing is diff for each books, it's being used as an ID here. Biggest borrowing value means the latest of that book with that imgTitleInMS.
        var allStartBook = [Double]()
        var theBook: Double = 0.0
        REF_USER.child(uid).child("mybooks").queryOrdered(byChild: "bookImgTitleInMS").queryEqual(toValue: imgTitleInMS).observe(DataEventType.value) { (snapshot) in
            
            if snapshot.exists(){
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                for book in snapshot{
                    let start = book.childSnapshot(forPath: "start").value as! Double
                    allStartBook.append(start)
                }
                
                if allStartBook.count > 1{
                    theBook = allStartBook.max()!
                }else{
                    theBook = allStartBook[0]
                }
                
                bookStart(theBook)

            }
            
        }
        
    }

    func borrowBook(imgTitleInMS: Double, uid: String, title: String, start: Double, until: Double){
        REF_BOOK.queryOrdered(byChild: "image").queryEqual(toValue: imgTitleInMS).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            var bookKey = ""
            for book in snapshot{
                bookKey = book.key
            }
            self.REF_USER.queryOrdered(byChild: "uid").queryEqual(toValue: (Auth.auth().currentUser?.uid)!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                var fullName = ""
                for user in snapshot{
                    fullName = user.childSnapshot(forPath: "fullName").value as! String
                }
                self.REF_BOOK.child(bookKey).updateChildValues(["start":start, "until":until, "status":"no", "borrowedBy":(Auth.auth().currentUser?.uid)!])
                
                self.REF_BOOK.child(bookKey).child("history").childByAutoId().updateChildValues(["start":start, "until":until, "borrowedBy":(Auth.auth().currentUser?.uid)!, "actualReturned": start, "bookImgTitleInMS": imgTitleInMS, "status": "borrowed", "fullname":fullName])
                self.REF_USER.child(uid).child("mybooks").childByAutoId().updateChildValues(["start":start, "until":until, "title":title ,"bookImgTitleInMS":imgTitleInMS, "status":"borrowing", "hasOpened": 0, "actualReturned": start, "late": "no"])
            })
            
        })
        
        
        
    }
    
    func returnBook(imgTitleInMS: Double, uid: String, title: String, actualReturned: Double){
        
        REF_BOOK.queryOrdered(byChild: "image").queryEqual(toValue: imgTitleInMS).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            print("AAA!!!")
            var bookKey = ""
            var myBookKey = ""
            var myBookKey2 = ""
            for book in snapshot{
                bookKey = book.key
            }
            print(bookKey)
        self.REF_BOOK.child(bookKey).updateChildValues(["actualReturned":actualReturned,"status":"avail"])
            
            self.REF_BOOK.child(bookKey).child("history").queryOrdered(byChild: "bookImgTitleInMS").queryEqual(toValue: imgTitleInMS).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                for book in snapshot{
                    myBookKey2 = book.key
                    
                }
                self.REF_BOOK.child(bookKey).child("history").child(myBookKey2).updateChildValues(["status": "returned", "actualReturned": actualReturned])
            })
            
            self.REF_USER.child(uid).child("mybooks").queryOrdered(byChild: "bookImgTitleInMS").queryEqual(toValue: imgTitleInMS).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
                
                for book in snapshot{
                    myBookKey = book.key
                }
                
                self.REF_USER.child(uid).child("mybooks").child(myBookKey).updateChildValues(["status":"returned", "actualReturned": actualReturned, "late": "no"])

            })
           
        })
        
        
        
    }
    
    func updateLateStatus(start: Double){
        var myBookKey = ""

        self.REF_USER.child((Auth.auth().currentUser?.uid)!).child("mybooks").queryOrdered(byChild: "start").queryEqual(toValue: start).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for book in snapshot{
                myBookKey = book.key
                self.REF_USER.child((Auth.auth().currentUser?.uid)!).child("mybooks").child(myBookKey).updateChildValues(["late": "yes"])
            }
        }
    }
    
    func sendReport(uid: String, reportTime: Double, report: String, fullName: String, imgTitleInMS: Double){
        REF_BOOK.queryOrdered(byChild: "image").queryEqual(toValue: imgTitleInMS).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            var bookKey = ""
            for book in snapshot{
                bookKey = book.key
            }
            self.REF_BOOK.child(bookKey).child("reports").childByAutoId().updateChildValues(["bookImgTitleInMS":imgTitleInMS,"reportTime": reportTime, "report": report, "reportedBy": uid, "fullName":fullName])
            
        })
    }
    
    func getWifiUser(peopleAndTime: @escaping(_ arr: [Int])->()){
        REF_WIFI.observe(DataEventType.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            var myArr = [Int]()
            for wifidetail in snapshot{
                var detail = wifidetail.value as! Int
                myArr.append(detail)
            }
            
            peopleAndTime(myArr)
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
