//
//  DetailVc.swift
//  ImageShower
//
//  Created by Андрей Белогородский on 08.02.2023.
//

import UIKit

class DetailVc: UIViewController {
    var model: ListItemModel?
    var firstImage: UIImage?
    var secondImage: UIImage?
    var thirdImage: UIImage?
    
    @IBOutlet weak var stack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setData()
    }
    
    private func setData(){
        let title = UILabel()
        title.text = model?.title
        stack.addArrangedSubview(title)
        
        let imageView1 = UIImageView()
        imageView1.image = firstImage
        stack.addArrangedSubview(imageView1)
        
        let imageView2 = UIImageView()
        imageView2.image = secondImage
        stack.addArrangedSubview(imageView2)
        
        let imageView3 = UIImageView()
        imageView3.image = thirdImage
        stack.addArrangedSubview(imageView3)
        
        let details = UILabel()
        details.text = model?.details
        stack.addArrangedSubview(details)
    }
}
