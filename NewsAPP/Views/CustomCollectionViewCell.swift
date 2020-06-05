//
//  CustomCollectionViewCell.swift
//  NewsAPP
//
//  Created by Jason on 6/3/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(vm: ViewModel, article: Article) {
        title.text = article.title
        author.text = article.author
        if let imageData = article.data {
            self.imageView.image = UIImage(data: imageData)
        } else {
            vm.getImageData(article: article, imageURLString: article.urlToImage) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: article.data ?? Data())
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
}
