//
//  ListVC.swift
//  ImageShower
//
//  Created by Андрей Белогородский on 08.02.2023.
//

import UIKit

class ListVC: UIViewController {
    var activityIndicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var collection: UICollectionView!
    let listItems = DataParser.shared.getListModels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Collection
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib(nibName: "ListCVC", bundle: nil), forCellWithReuseIdentifier: "ListCVC")
        // Activity
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
}


extension ListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCVC", for: indexPath) as! ListCVC
        cell.setData(model: listItems[indexPath.row])
        return cell
    }
}

extension ListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        activityIndicator.startAnimating()
        NetworkManager.shared.getImages(for: listItems[indexPath.row]) { [weak self] firstImg, secondImg, thirdimg in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let vc = DetailVc()
                vc.model = self?.listItems[indexPath.row]
                vc.firstImage = firstImg
                vc.secondImage = secondImg
                vc.thirdImage = thirdimg
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        //self.activityIndicator.startAnimating()
    }
}

extension ListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 40)
    }

}
