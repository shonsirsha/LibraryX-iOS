//
//  DynamicLabel.swift
//  LibraryX
//
//  Created by Sean Saoirse on 27/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import Foundation
import UIKit
extension UILabel {
    func setSizeFont (sizeFont: CGFloat) {
        self.font =  UIFont(name: self.font.fontName, size: sizeFont)!
        self.sizeToFit()
    }
}
