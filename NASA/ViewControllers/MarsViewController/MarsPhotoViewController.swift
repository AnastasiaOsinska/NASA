//
//  MarsWeatherViewController.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

class MarsPhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var photoData : Photos?
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadIndicator.shared.showSpinner(onView: self.view)
        tableView.register(UINib(nibName: Constants.nibName, bundle: nil), forCellReuseIdentifier: Constants.identifier)
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
        APIManager.shared.getMarsPhotoFromAPI(completion: { [weak self] (photos) in
            DispatchQueue.main.async {
                LoadIndicator.shared.removeSpinner()
                guard let photos = photos else { return }
                self?.photoData = photos
                self?.tableView.reloadData()
            }
            }
        )}
    
    private func getImage(indexPath: IndexPath, imageURL: String?){
        ImageLoader.shared.getImage(from: imageURL, completion: { [weak self] (image) in
            DispatchQueue.main.async {
                (self?.tableView.cellForRow(at: indexPath) as? MarsPhotoTableViewCell)?.marsPhoto.image = image
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoData?.photos.count ?? Constants.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath) as? MarsPhotoTableViewCell else { return UITableViewCell() }
        if let result = self.photoData?.photos[indexPath.row] {
            DispatchQueue.main.async {
                cell.earthDate.text = result.earth_date
                cell.solDate.text = (String(describing: result.sol))
            }
            cell.marsPhoto.image = nil
            self.getImage(indexPath: indexPath, imageURL: result.img_src)
        }
        return cell
    }
}
