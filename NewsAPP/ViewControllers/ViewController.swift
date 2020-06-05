//
//  ViewController.swift
//  NewsAPP
//
//  Created by Jason on 6/3/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var newsCollection: UICollectionView!
    private let vm: ViewModel = ViewModel(service: WebAPI.init(session: URLSession.shared))
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        vm.onError = {
            [weak self] in
            self?.handleError(error: $0)
        }
        vm.onSuccess = {
            DispatchQueue.main.async {
                self.newsCollection.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.newsCollection.dataSource = self
        self.newsCollection.delegate = self
        self.searchBar.delegate = self
        vm.getNews()
    }
    

    private func handleError(error: Error) {
        let title: String, message: String

        switch (error as? WebAPI.ResponseError) {
        case .unableToConnect:
            title = NSLocalizedString("NewsListConnectionFailureTitle", comment: "")
            message = NSLocalizedString("NewsListConnectionFailureMessage", comment: "")
        case .badResponseStatusCode, .unknown:
            title = NSLocalizedString("NewsListLoadFailureTitle", comment: "")
            message = NSLocalizedString("NewsListLoadFailureMessage", comment: "")
        case .badURL:
            title = NSLocalizedString("NewsListBadURLTitle", comment: "")
            message = NSLocalizedString("NewsListBadURLMessage", comment: "")
        default:
            title = NSLocalizedString("NewsListUnknownErrorTitle", comment: "")
            message = NSLocalizedString("NewsListUnknownErrorMessage", comment: "")
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)
        
        alert.addAction(action)
        alert.preferredAction = action
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.searchedResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as CustomCollectionViewCell
        cell.configure(vm: vm, article: vm.searchedResult[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(identifier: DetailViewController.identifier) as! DetailViewController
        detailVC.configure(article: vm.searchedResult[indexPath.row])
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchTarget = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !searchTarget.isEmpty {
            vm.searchedResult = vm.data.filter({ (article) -> Bool in
                article.title.lowercased().contains(searchTarget) || article.description.lowercased().contains(searchTarget) || article.content.lowercased().contains(searchTarget)
                })
        } else {
            vm.searchedResult = vm.data
        }
        self.newsCollection.reloadData()
    }
}
