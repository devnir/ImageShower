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
        imageView1.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView1.contentMode = .scaleAspectFit
        
        let imageView2 = UIImageView()
        imageView2.image = secondImage
        stack.addArrangedSubview(imageView2)
        imageView2.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView2.contentMode = .scaleAspectFit
        
        
        let imageView3 = UIImageView()
        imageView3.image = thirdImage
        stack.addArrangedSubview(imageView3)
        imageView3.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView3.contentMode = .scaleAspectFit
        
        let details = UILabel()
        details.text = model?.details
        details.numberOfLines = 0
        stack.addArrangedSubview(details)
    }
}
