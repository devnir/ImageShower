//
//  NetworkManager.swift
//  ImageShower
//
//  Created by Андрей Белогородский on 08.02.2023.
//

import UIKit

class NetworkManager {
    let dispatchQueue = DispatchQueue(label: "dispatchQueue", qos:.userInitiated)
    private let dispatchGroup = DispatchGroup.init()
    static let shared = NetworkManager()
    
    var firstImg: UIImage?
    var secondImg: UIImage?
    var thirdImg: UIImage?
    
    
    init(){}
    
    func getImages(for model: ListItemModel, handler: @escaping ((UIImage, UIImage, UIImage)->Void)){
        firstImg = nil
        secondImg = nil
        thirdImg = nil
        
        getImage(from: model.firstImg, imgNum: 0)
        getImage(from: model.secondImg, imgNum: 1)
        getImage(from: model.thirdimg, imgNum: 2)
        
        dispatchGroup.notify(queue: dispatchQueue) {
            print("all img getted")
            handler(self.firstImg ?? UIImage(), self.secondImg ?? UIImage(), self.thirdImg ?? UIImage())
        }
    }
    
    private func getImage(from urlStr: String, imgNum: Int) {
        dispatchGroup.enter()
        print("get image from: \(urlStr)")
        let url = URL(string: urlStr)
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, response, error)  in
            if error != nil {
                print(error!)
                self?.dispatchGroup.leave()
                return
            }
            if let image = UIImage(data: data!) {
                switch imgNum {
                case 0:
                    self?.firstImg = image
                case 1:
                    self?.secondImg = image
                case 2:
                    self?.thirdImg = image
                default:
                    break
                }
            }
            self?.dispatchGroup.leave()
        }).resume()
    }
}
