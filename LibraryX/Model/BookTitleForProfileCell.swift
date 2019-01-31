//
//  BookTitleForProfileCell.swift
//  LibraryX
//
//  Created by Sean Saoirse on 28/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import Foundation

class BookTitleForProfileCell{ // for ActivitesCell as well
    private var _bookTitle: String
    private var _imgTitleInMS: Double
    private var _start: Double
    private var _until: Double
    private var _opened: Int
    private var _status: String
    private var _actualReturned: Double

    
    var bookTitle: String{
        return _bookTitle
    }
    
    var imgTitleInMS: Double{
        return _imgTitleInMS
    }
    
    var start: Double{
        return _start
    }
    
    var until: Double{
        return _until
    }
    var opened: Int{
        return _opened
    }
    
    
    var status: String{
        return _status
    }
    
    var actualReturned: Double{
        return _actualReturned
    }
    
    init(bookTitle: String, imgTitleInMS: Double, start: Double, until: Double, opened: Int, status: String, actualReturned: Double){
        self._bookTitle = bookTitle
        self._imgTitleInMS = imgTitleInMS
        self._start = start
        self._until = until
        self._opened = opened
        self._status = status
        self._actualReturned = actualReturned
    }
}
