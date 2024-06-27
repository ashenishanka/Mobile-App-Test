//
//  HotelTableViewCell.swift
//  Mobile-App-Test
//
//  Created by Ashen Ishanka on 2024-06-26.
//

import UIKit

// MARK: - This is a custom cell class for the Hotel Table view
class HotelTableViewCell: UITableViewCell {

    @IBOutlet weak var hotelImageOutet: UIImageView!
    
    @IBOutlet weak var hotelAddressTextOutlet: UILabel!
    @IBOutlet weak var hotelTitleOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
}
