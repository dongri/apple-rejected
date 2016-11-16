//
//  PopularViewController.swift
//  Stagram
//
//  Created by Dongri Jin on 3/19/16.
//  Copyright © 2016 Dongri Jin. All rights reserved.
//

import Foundation
import UIKit

class PopularViewController: PhotosViewController {

    var urlString: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Popular"
        self.collectionView.backgroundColor = UIColor.white

        urlString = API500px.popular()
        requestPhotos(urlString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func refreshAction() {
        super.refreshAction()
        self.requestPhotos(self.urlString)
    }

}
