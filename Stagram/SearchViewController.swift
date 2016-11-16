//
//  SearchViewController.swift
//  Stagram
//
//  Created by Dongri Jin on 3/20/16.
//  Copyright © 2016 Dongri Jin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: PhotosViewController, UISearchBarDelegate {
    
    var searchBar: UISearchBar!
    let searchBarHeight = CGFloat(50)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.white
        
        let f = self.collectionView.frame
        self.collectionView.frame = CGRect(x: f.origin.x, y: f.origin.y + searchBarHeight, width: f.size.width, height: f.size.height-searchBarHeight)
        let viewframe = view.frame
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height

        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: 0, width: viewframe.size.width, height: searchBarHeight)
        searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: navigationBarHeight! * 2)
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.barStyle = UIBarStyle.default
        searchBar.placeholder = "Keyword"
        self.view.addSubview(searchBar)
        
        LoadingProxy.off()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doSearch() {
        search(API500px.search(searchBar.text!))
    }

    // Mark search bar

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            
        }
    }
    
    // Mark segmented controll

    func valueChanged(_ segmentedControl: UISegmentedControl) {
        self.view.endEditing(true)
        if searchBar.text == "" {
            return
        }
        self.doSearch()
    }
    
    // Mark Search
    func search(_ urlString: String?) {
        refreshAction()
        requestPhotos(urlString)
    }
    
    // MARK rotated
    override func rotatedViews() {
        super.rotatedViews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let viewframe = self.view.frame
            let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
            
            self.searchBar.frame = CGRect(x: 0, y: viewframe.origin.y, width: viewframe.size.width, height: self.searchBarHeight)
            self.searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: navigationBarHeight! * 2)
        }
    }
    
}
