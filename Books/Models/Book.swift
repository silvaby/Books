//
//  Book.swift
//  Book
//
//  Created by Dzmitry on 10/28/19.
//  Copyright © 2019 Dzmitry Krukov. All rights reserved.
//

// MARK: - Book
struct BooksContainer: Codable {
    let items: [Book]?
}

// MARK: - Item
struct Book: Codable {
    let id: String?
    let volumeInfo: VolumeInfo?
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let pageCount: Int?
    let imageLinks: ImageLinks?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let thumbnail: String?
}
