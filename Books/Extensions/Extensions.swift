//
//  Extensions.swift
//  Books
//
//  Created by Dzmitry on 10/28/19.
//  Copyright © 2019 Dzmitry Krukov. All rights reserved.
//

import UIKit

// MARK: - Encode URL. Info from https://stackoverflow.com/questions/35148507/cyrillic-symbols-in-url
extension String {
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String {
        return self.removingPercentEncoding!
    }
}
