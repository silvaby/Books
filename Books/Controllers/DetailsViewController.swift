//
//  DetailsViewController.swift
//  Books
//
//  Created by Dzmitry on 11/12/19.
//  Copyright © 2019 Dzmitry Krukov. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var imageOfBook: UIImageView!
    @IBOutlet weak var titleOfBook: UILabel!
    @IBOutlet weak var authorsOfBook: UILabel!
    @IBOutlet weak var descriptionOfBook: UILabel!
    
    var textOfTitle: String = "No book title"
    var textOfAuthors: String = "No books authors"
    var textOfDescription: String = "No book description"
    var textOfURL: String = "No URL"
    var textOfInfoLink = "No link"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataDisplay()
    }
    
    @IBAction func goLink(_ sender: Any) {
        if let url = URL(string: textOfInfoLink) {
            UIApplication.shared.open(url)
        }  else { print("NIL") }
    }
    
    private func dataDisplay() {
        titleOfBook.text = textOfTitle
        authorsOfBook.text = textOfAuthors
        descriptionOfBook.text = textOfDescription
        imageDisplay()
    }
    
    private func imageDisplay() {
        if let url = URL(string: textOfURL) {
            imageOfBook.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "open-book"), options: .scaleDownLargeImages, completed: nil)
        } else { print("NIL") }
    }
    
}
