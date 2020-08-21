//
//  EarthPictureViewController.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

class EarthPictureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var imageData = [Image?]()
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadIndicator.shared.showSpinner(onView: self.view)
        tableView.register(UINib(nibName: Constants.xibName, bundle: nil), forCellReuseIdentifier: Constants.earthId)
        tableView.dataSource = self
        tableView.delegate = self
        setUpView()
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Methods
    
    @objc private func refresh(sender: UIRefreshControl){
        sender.endRefreshing()
        setUpView()
        tableView.reloadData()
    }
    
    func setUpView(){
        APIManager.shared.getEarthPhotoFromAPI(completion: { [weak self] (images) in
            LoadIndicator.shared.removeSpinner()
            DispatchQueue.main.async {
                guard let images = images else { return }
                self?.imageData = images
                self?.tableView.reloadData()
            }
        })
    }
    
    private func getImage(indexPath: IndexPath, imageURL: String?){
        ImageLoader.shared.getImage(from: imageURL, completion: { [weak self] (image) in
            DispatchQueue.main.async {
                (self?.tableView.cellForRow(at: indexPath) as? EarthPictureTableViewCell)?.earthImageView.image = image
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.earthId, for: indexPath) as? EarthPictureTableViewCell else { return UITableViewCell() }
        if imageData[indexPath.row] != nil {
            guard let result = imageData[indexPath.row] else { return UITableViewCell() }
            DispatchQueue.main.async {
                cell.identifierLabel.text = result.identifier
                cell.captionLabel.text = result.caption
                cell.versionLabel.text = result.version
                cell.dateLabel.text = result.date
                cell.earthImageView.image = nil
            }
            let url = APIManager.shared.buildUrl(stringDate: result.date!, imageName: result.image!)
            self.getImage(indexPath: indexPath, imageURL: url)
        }
        return cell
    }

}
