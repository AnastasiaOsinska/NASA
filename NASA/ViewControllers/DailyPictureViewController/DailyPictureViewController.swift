//
//  DailyPictureViewController.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit
import AVFoundation

class DailyPictureViewController: UIViewController {
    
    private struct Constants {
        static let defaultImage = "cosmos"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var picOfTheDay: UIImageView!
    
    // MARK: - Properties
    
    var spinner : UIView?
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadIndicator.shared.showSpinner(onView: self.view)
        getData()
        scrollView.refreshControl = myRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    // MARK: - Methods
    
    @objc private func refresh(sender: UIRefreshControl){
        sender.endRefreshing()
        getData()
        scrollView.reloadInputViews()
    }
    
    private func getThumbnailImageFromVideoUrl(url: String?, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async {
            let url = URL(string: "https://img.youtube.com/watch?v=9WKSHMOkWqE/#.jpg")
            let asset = AVAsset(url: url!)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 0, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil) 
                }
            }
        }
    }
    
    func getData() {
        APIManager.shared.getDataFromAPI(completion: { [weak self] (spaceModel) in
            DispatchQueue.main.async {
                LoadIndicator.shared.removeSpinner()
                guard let spaceModel = spaceModel else { return }
                self?.setUpView(with: spaceModel)
            }
        })
    }
    
    func setUpView(with spaceModel: SpaceModel) {
        imageTitle.text = spaceModel.title
        explanation.text = spaceModel.explanation
        dateLabel.text = spaceModel.date
        ImageLoader.shared.getImage(from: spaceModel.url) { image in
            if image != nil {
                self.picOfTheDay.image = image
            } else {
                self.getThumbnailImageFromVideoUrl(url: spaceModel.url) { thumbImage in
                    if thumbImage != nil {
                        self.picOfTheDay.image = thumbImage
                    } else {
                        self.picOfTheDay.image = UIImage(named: Constants.defaultImage)
                    }
                }
            }
        }
    }
}
