//
//  UpcomingViewController.swift
//  Stagram
//
//  Created by Dongri Jin on 2016/11/15.
//  Copyright © 2016 Dongri Jin. All rights reserved.
//

import Foundation
import UIKit

class UpcomingViewController: PhotosViewController {
    
    var urlString: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Upcoming"
        self.collectionView.backgroundColor = UIColor.white
        
        urlString = API500px.upcoming()
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
