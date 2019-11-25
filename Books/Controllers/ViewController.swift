//
//  ViewController.swift
//  Books
//
//  Created by Dzmitry on 10/25/19.
//  Copyright © 2019 Dzmitry Krukov. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleSignIn

class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var books = [Book]()
    let idCell = "BookCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        searchBar.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(singOutButtonTapped))
    }
    
    // MARK: - Download books using google books API
    func downloadBooks(booksTitle: String) {
        
        let stringURL = "https://www.googleapis.com/books/v1/volumes?q=\(booksTitle)&maxResults=40".encodeUrl
        
        guard let url = URL(string: stringURL) else {
            print("URL problem")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let jsonData = data else {
                print("No data has been downloaded")
                return
            }
            
            do {
                let json = try JSONDecoder().decode(BooksContainer.self, from: jsonData)

                if let items = json.items {
                    self.books = items
                } else { print("Error conection to google books API. Change your region!") }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch { print("Error with JSON") }
        }.resume()
    }
    
    // MARK: - LogOut
    @objc func singOutButtonTapped() {
        GIDSignIn.sharedInstance()?.signOut()
        navigateToLogInScreen()
    }
        
    // MARK: - navigateToLogInScreen
    private func navigateToLogInScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let logInVC = mainStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController else { return }
        
        present(logInVC, animated: true, completion: nil)
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
        if let volumeInfo = books[indexPath.row].volumeInfo {

            if let titleOfBook = volumeInfo.title {
                cell.titleOfBook.text = titleOfBook
            } else { cell.titleOfBook.text = "No book title" }

            if let arrayOfAuthors = volumeInfo.authors {
                let stringOfAuthors = arrayOfAuthors.joined(separator: ", ")
                cell.authorsOfBook?.text = stringOfAuthors
            } else { cell.authorsOfBook?.text = "No authors information" }

            if let pageCount = volumeInfo.pageCount {
                let pageCountStr = String("\(pageCount) pages")
                cell.pageCountOfBook?.text = pageCountStr
            } else { cell.pageCountOfBook?.text = "No info about page count" }

            if let imageURL = volumeInfo.imageLinks?.thumbnail {
                let url = URL(string: imageURL)
                cell.thumbnailOfBook.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "open-book"), options: .scaleDownLargeImages, completed: nil)
            } else { print("No image") }

        } else { print("No volumeInfo") }
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destinationVC: DetailsViewController = segue.destination as? DetailsViewController,
            let selectedItem = tableView.indexPathForSelectedRow?.item {
               
            let volumeInfo = books[selectedItem].volumeInfo
            
            // URL of books image
            if let imageURL = volumeInfo?.imageLinks?.thumbnail {
                destinationVC.textOfURL = imageURL
            } else { print("No image link! :(") }
                
            // Title of book
            destinationVC.textOfTitle = volumeInfo?.title ?? "No title! :("
                
            // Authors of book
            let arrayOfAuthors = volumeInfo?.authors
            let stringOfAuthors = arrayOfAuthors?.joined(separator: ", ")
            destinationVC.textOfAuthors = stringOfAuthors ?? "No authors! :("
                
            // Description of book
            destinationVC.textOfDescription = volumeInfo?.description ?? "No description! :("
            
            // Info link of book
            destinationVC.textOfInfoLink = volumeInfo?.infoLink ?? "No info link! :("
        }
    }
    
}

// MARK: - SearchBar
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let booksTitle = searchBar.text {
            self.downloadBooks(booksTitle: booksTitle)
        } else { print("Problem with text in SearchBar") }
        
        searchBar.resignFirstResponder()
    }
    
}
