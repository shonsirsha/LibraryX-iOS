//
//  BookTitleForProfileCell.swift
//  LibraryX
//
//  Created by Sean Saoirse on 28/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import Foundation

class BookTitleForProfileCell{
    private var _bookTitle: String
    
    var bookTitle: String{
        return _bookTitle
    }
    
    init(bookTitle: String){
        self._bookTitle = bookTitle
    }
}
