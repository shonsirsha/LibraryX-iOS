//
//  BookDetailForCell.swift
//  LibraryX
//
//  Created by Sean Saoirse on 25/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import Foundation

class EbookDetailCell{
    private var _bookTitle: String
    private var _authorName: String
    private var _genre1: String
    private var _genre2: String
    private var _genre3: String
    private var _year: String
    private var _imgTitle: Double
    
    var bookTitle: String{
        return _bookTitle
    }
    
    var authorName: String{
        return _authorName
    }
    
    var genre1: String{
        return _genre1
    }
    
    var genre2: String{
        return _genre2
    }
    
    var genre3: String{
        return _genre3
    }
    
    
    var year: String{
        return _year
    }
    
    var imgTitle: Double{
        return _imgTitle
    }
    
 
    
    init(bookTitle: String, authorName: String, genre1: String, genre2: String, genre3: String, year: String, imgTitle: Double){
        self._bookTitle = bookTitle
        self._authorName = authorName
        self._genre1 = genre1
        self._genre2 = genre2
        self._genre3 = genre3
        self._year = year
        self._imgTitle = imgTitle
    }
}
