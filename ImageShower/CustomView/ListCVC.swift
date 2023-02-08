//
//  ListCVC.swift
//  ImageShower
//
//  Created by Андрей Белогородский on 08.02.2023.
//

import UIKit

class ListCVC: UICollectionViewCell {
    private var model: ListItemModel?
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(model: ListItemModel) {
        self.model = model
        self.titleLbl.text = model.title
    }
}
