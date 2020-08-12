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
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constants.nibName, bundle: nil), forCellReuseIdentifier: Constants.identifier)
        tableView.dataSource = self
        tableView.delegate = self
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
        APIManager.shared.getMarsPhotoFromAPI(completion: { [weak self] (photos) in
            DispatchQueue.main.async {
                guard let photos = photos else { return }
                self?.photoData = photos
                self?.tableView.reloadData()
            }
            }
        )}
    
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
            if let strUrl = result.img_src,
                let imgUrl = URL(string: strUrl){
//                cell.marsPhoto.loadImageWithUrl(imgUrl)
        ImageLoader.shared.loadImage(from: strUrl) { image in
                    cell.marsPhoto.image = image
                }
        }
        }
        return cell
    }
    
}
