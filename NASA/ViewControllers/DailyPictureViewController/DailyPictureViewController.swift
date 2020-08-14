//
//  DailyPictureViewController.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

class DailyPictureViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var picOfTheDay: UIImageView!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
      }
    
    // MARK: - Methods
    
    func setUpView(){
        APIManager.shared.getDataFromAPI(completion: { [weak self] (spaceModel) in
            DispatchQueue.main.async {
                guard let spaceModel = spaceModel else { return }
                self?.imageTitle.text = spaceModel.title
                self?.explanation.text = spaceModel.explanation
                self?.dateLabel.text = spaceModel.date
                ImageLoader.shared.getImage(from: spaceModel.url) { image in
                    if image != nil {
                        self?.picOfTheDay.image = image
                    } else {
                        self?.picOfTheDay.image = UIImage(named: Constants.defaultImage)
                    }
                }
            }
        }
    )}
}

