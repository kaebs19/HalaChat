//
//  AcountTVCell.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 09/05/2025.
//

import UIKit

class AcountTVCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension AcountTVCell {
    
    func setupUI() {
        
        setSelectionStyle(.none)
        backgroundView?.backgroundColor = ThemeManager.shared.color(.background)
    }
    
    func configure(with acount: Accounts) {
        titleLbl.customize(text: acount.title.textName,
                           color: .text, ofSize: .size_12,
                           font: .poppins ,fontStyle: .semiBold )
        iconImg.image = UIImage(named: acount.icon.rawValue)
    }
}
