//
//  CustomTableViewCell.swift
//  Books
//
//  Created by Dzmitry on 10/26/19.
//  Copyright © 2019 Dzmitry Krukov. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var titleOfBook: UILabel!
    @IBOutlet weak var authorsOfBook: UILabel!
    @IBOutlet weak var pageCountOfBook: UILabel!
    @IBOutlet weak var thumbnailOfBook: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
