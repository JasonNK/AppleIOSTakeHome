//
//  DetailViewController.swift
//  NewsAPP
//
//  Created by Jason on 6/4/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var article: Article?
    
    @IBAction func webDetail(_ sender: UIButton) {
        let vc = WebViewController()
        vc.url = article?.url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(data: self.article?.data ?? Data())
        self.titleLabel.text = self.article?.title
        self.descriptionLabel.text = self.article?.description
        self.authorLabel.text = self.article?.author
        self.dateLabel.text = self.article?.publishedAt
        self.contentLabel.text = self.article?.content
    }
    
    func configure(article: Article) {
        self.article = article
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
