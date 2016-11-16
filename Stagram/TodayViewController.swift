//
//  TodayViewController.swift
//  Stagram
//
//  Created by Dongri Jin on 3/20/16.
//  Copyright © 2016 Dongri Jin. All rights reserved.
//

import Foundation
import UIKit

class TodayViewController: PhotosViewController {
    
    var urlString: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Today"
        self.collectionView.backgroundColor = UIColor.white

        urlString = API500px.today()
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
