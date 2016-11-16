//
//  PhotosViewController.swift
//  Stagram
//
//  Created by Dongri Jin on 3/20/16.
//  Copyright © 2016 Dongri Jin. All rights reserved.
//

import Foundation
import UIKit
import OAuthSwift
import SwiftyJSON
import Alamofire
import AlamofireImage
import Haneke

import SloppySwiper

class PhotosViewController: ViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()

    var photos = [Photo]()
    var populatingPhotos = false
    var nextURLString: String?

    let PhotoCellIdentifier = "PhotoCell"
    let PhotoLoadingIdentifier = "PhotoLoading"
    let PhotoHeaderIdentifier = "PhotoHeader"

    var LAYOUT_LIST = "List"
    var LAYOUT_GRID = "Grid"

    var currentLayout: String = ""

    let TagRetryButton = 1
    
    var swiper: SloppySwiper!

    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        currentLayout = LAYOUT_LIST
        let changeLayoutButton = UIBarButtonItem(title: currentLayout, style: .plain, target: self, action: #selector(PhotosViewController.changePhontoLayout))
        self.navigationItem.rightBarButtonItem = changeLayoutButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupView() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: createLayout())

        
        collectionView!.register(PhotoCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: PhotoCellIdentifier)

        collectionView!.register(PhotoCollectionViewLoading.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PhotoLoadingIdentifier)

        collectionView?.dataSource = self
        collectionView?.delegate = self

        self.view.addSubview(collectionView)

        refreshControl.tintColor = UIColor(white: 0.7, alpha: 0.5)
        let attributedString = NSMutableAttributedString(string:"Loading...")
        let range = NSMakeRange(0, attributedString.length)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(white: 0.7, alpha: 0.5) , range: range)
        refreshControl.attributedTitle = attributedString
        refreshControl.addTarget(self, action: #selector(PhotosViewController.refreshAction), for: .valueChanged)

        collectionView!.addSubview(refreshControl)
        
        LoadingProxy.set(self)
        LoadingProxy.on()
        
        let retryButton = createRetryButton()
        retryButton.isHidden = true
        self.view.addSubview(retryButton)
    }
    
    func changePhontoLayout(){
        if (currentLayout == LAYOUT_LIST) {
            currentLayout = LAYOUT_GRID
        } else {
            currentLayout = LAYOUT_LIST
        }
        let offset = self.collectionView.contentOffset
        self.navigationItem.rightBarButtonItem?.title = currentLayout
        self.collectionView.setCollectionViewLayout(createLayout(), animated: false)
        self.collectionView.reloadData()
        self.collectionView.contentOffset = offset
    }
    
    func createLayout() -> UICollectionViewFlowLayout {
        var column = 1
        if (currentLayout == LAYOUT_GRID) {
            column = 1
        } else {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
                    column = 5
                } else {
                    column = 4
                }
            } else {
                column = 3
            }
        }
        let layout = UICollectionViewFlowLayout()
        let itemWidth = floor((view.bounds.size.width - CGFloat(column - 1)) / CGFloat(column))
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        layout.footerReferenceSize = CGSize(width: self.view.bounds.size.width, height: 100.0)
        return layout
    }
    
    func refreshAction() {
        nextURLString = nil
        refreshControl.beginRefreshing()
        self.photos.removeAll(keepingCapacity: false)
        self.collectionView!.reloadData()
        refreshControl.endRefreshing()
    }

    func requestPhotos(_ urlString: String?){
        if populatingPhotos {
            return
        }
        
        populatingPhotos = true
        let url = String(format: urlString!, page).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        Alamofire.request(url!, method: .get, parameters: nil).responseJSON { response in
            defer {
                self.populatingPhotos = false
            }
            LoadingProxy.off()
            switch response.result {
            case .success:
                self.view.viewWithTag(self.TagRetryButton)?.isHidden = true
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    DispatchQueue.global().async {
                        let pages = json["total_pages"].int!
                        let currentPage = json["current_page"].int!
                        if currentPage == pages {
                            self.nextURLString = nil
                        } else {
                            self.nextURLString = urlString
                        }
                        self.page = currentPage + 1
                        let photos = json["photos"].arrayValue
                        var arrayWithIndexPaths:[NSIndexPath] = []
                        var i = 0
                        for photo in photos {
                            let small = photo["images"][0]["url"].stringValue
                            let big = photo["image_url"].stringValue
                            let p = Photo(smallImageURL: small, bigImageURL: big)
                            self.photos.append(p)
                            arrayWithIndexPaths.append(NSIndexPath(row: i, section: 0))
                            i=i+1
                        }
                        DispatchQueue.main.async {
                            self.collectionView!.insertItems(at: arrayWithIndexPaths as [IndexPath])
                        }
                    }
                }
            case .failure(let error):
                print(error)
                self.view.viewWithTag(self.TagRetryButton)?.isHidden = false
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.nextURLString != nil && scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8) {
            requestPhotos(self.nextURLString)
        }
    }
    
    // MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = nil
        let photo = photos[indexPath.row] as Photo
        cell.imageView.hnk_setImageFromURL(URL(string: photo.SmallImageURL())!, placeholder: nil, format: nil, failure:
            { (error) -> () in
                print(error ?? "")
            }) { (image) -> () in
                cell.imageView.image = image
                cell.imageView.alpha = 0
                UIView.animate(withDuration: 0.5, animations: {
                    cell.imageView.alpha = 1.0
                    cell.imageView.isUserInteractionEnabled = true
                    cell.imageView.layer.setValue(photo, forKey: "photoinfo")
                    cell.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PhotosViewController.imageTapped(_:))))
                })
            }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PhotoLoadingIdentifier, for: indexPath) as! PhotoCollectionViewLoading
        if self.photos.count > 0 {
            footerView.spinner.startAnimating()
        }
        if self.nextURLString == nil {
            footerView.spinner.stopAnimating()
        }
        return footerView
    }

    func imageTapped(_ sender: UITapGestureRecognizer) {
        let photoInfo = sender.view?.layer.value(forKey: "photoinfo") as! Photo
        let viewerViewController = ViewerViewController()
        viewerViewController.respnosePhoto = photoInfo
        self.navigationController?.pushViewController(viewerViewController, animated: true)
        self.swiper = SloppySwiper(navigationController:self.navigationController)
        self.navigationController!.delegate = self.swiper;
        
    }

    func createRetryButton() -> UIButton {
        let button = UIButton()
        button.tag = TagRetryButton
        button.setTitle("Retry", for: UIControlState())
        button.setTitleColor(UIColor.gray, for: UIControlState())
        button.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        button.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        button.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitleColor(UIColor.black, for: .highlighted)
        button.addTarget(self, action: #selector(PhotosViewController.refreshAction), for:.touchUpInside)
        return button
    }

    override func rotatedViews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
                self.collectionView.frame = self.view.frame
                self.collectionView.setCollectionViewLayout(self.createLayout(), animated: false)
            }
            if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
                self.collectionView.frame = self.view.frame
                self.collectionView.setCollectionViewLayout(self.createLayout(), animated: false)
            }
        }
    }

}

class PhotoCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        imageView.frame = bounds
        addSubview(imageView)
    }
    override func prepareForReuse() {
        imageView.hnk_cancelSetImage()
        imageView.frame = bounds
        imageView.image = nil
    }

    internal override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        imageView.frame = bounds
    }
}

class PhotoCollectionViewLoading: UICollectionReusableView {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        spinner.center = self.center
        addSubview(spinner)
        spinner.stopAnimating()
    }
}
