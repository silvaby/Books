//
//  ViewController.swift
//  Books
//
//  Created by Dzmitry on 10/25/19.
//  Copyright © 2019 Dzmitry Krukov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var books = [[String: AnyObject]]() // Array of books
    let idCell = "BookCell"
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
    }

    // MARK: - Actions. Download books using google books API
    func downloadBooks(booksTitle: String) {
        
        let stringURL = "https://www.googleapis.com/books/v1/volumes?q=\(booksTitle)".encodeUrl
        
        guard let url = URL(string: stringURL) else {
            print("URL problem")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared

        let task = session.dataTask(with: urlRequest) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            guard let jsonData = data else {
                print("No data has been downloaded")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: AnyObject]

                if let items = json?["items"] as? [[String: AnyObject]] {
                self.books = items
                } else {
                    print("Error conection to google books API. Change your region!")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error with JSON: ")
            }
        }
        task.resume()
    }
    
}

// MARK: - Create and configure table
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! CustomTableViewCell
        
        // Configure cell
        if let volumeInfo = self.books[indexPath.row]["volumeInfo"] as? [String: AnyObject] {

            if let imageURL = volumeInfo["imageLinks"] as? [String: String]{
                cell.thumbnailOfBook.downloaded(from: imageURL["thumbnail"]!)
            } else {
                print("No image")
            }
            
            cell.titleOfBook?.text = volumeInfo["title"] as? String
            
            if let arrayOfAuthors = volumeInfo["authors"] as? [String] {
                let stringOfAuthors = arrayOfAuthors.joined(separator: ", ")
                cell.authorsOfBook?.text = stringOfAuthors
            } else {
                cell.authorsOfBook?.text = "No info about authors"
            }
                
            if let pageCount = volumeInfo["pageCount"] as? Int {
                let pageCountStr = String(pageCount)
                cell.pageCountOfBook?.text = pageCountStr
            } else {
                cell.pageCountOfBook?.text = "No info about page count"
            }
        }
        return cell
    }
    
}

// MARK: - SearchBar
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let bookTitle = searchBar.text!.removingPercentEncoding
        
        self.downloadBooks(booksTitle: bookTitle!)
        searchBar.resignFirstResponder()
    }
}

// MARK: - Download Images. Info from https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
}

// MARK: - Encode URL. Info from https://stackoverflow.com/questions/35148507/cyrillic-symbols-in-url
extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}
