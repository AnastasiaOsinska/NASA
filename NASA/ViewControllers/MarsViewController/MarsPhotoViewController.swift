//
//  MarsWeatherViewController.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

class MarsPhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate {
    
    private struct Constants {
        static let searchMessage = "Sorry, we couldn't find any information"
        static let nibName = "MarsPhotoTableViewCell"
        static let identifier = "MarsPhotoTableViewCellID"
        static let numberOfRow = 0
        static let standartAnimationDuration: Double = 0.4
        static let duration : Double = 0.5
        static let minCostant : CGFloat = 50
        static let maxConstant : CGFloat = 100
        
    }
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBarView: SearchBarView!
    @IBOutlet weak var infoLabel: UILabel!

    // MARK: - Properties
    
    var loading: Bool = false
    var filteredPhotos: [Photo] = []
    private var cellModels: [Any] = []
    private var photoData: Photos?
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    let searchController = UISearchController(searchResultsController: nil)

    var isFiltering: Bool {
        return !searchBarView.searchStr.isEmpty
    }
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadIndicator.shared.showSpinner(onView: self.view)
        tableView.register(UINib(nibName: Constants.nibName, bundle: nil), forCellReuseIdentifier: Constants.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        setUpView()
        tableView.refreshControl = myRefreshControl
        searchBarView.actionSearch = { [weak self] hidden in
            UIView.animate(withDuration: Constants.duration) {
                self?.searchViewHeight.constant = hidden ? Constants.minCostant : Constants.maxConstant
                self?.view.layoutIfNeeded()
            }
        }
        searchBarView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Methods

    func filterContentForSearchText(_ searchText: String) {
        guard let photos = photoData?.photos else { return }
        filteredPhotos = photos.filter { (photo: Photo) -> Bool in
            return (photo.camera.full_name?.lowercased().contains(searchText.lowercased()) ?? false)
        }
        infoLabel.alpha = !filteredPhotos.isEmpty ? 0 : 1
        infoLabel.isHidden = !filteredPhotos.isEmpty
        tableView.reloadData()
    }
    
    private func searchAction(with text: String) {
        func updateInfoLabel(hide: Bool) {
            infoLabel.text = Constants.searchMessage + "'\(text)'"
            infoLabel.alpha = hide ? 0 : 1
            infoLabel.isHidden = hide
            UIView.animate(withDuration: Constants.standartAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        }
        guard !text.isEmpty else {
            updateInfoLabel(hide: true)
            tableView.reloadData()
            return
        }
        
        updateInfoLabel(hide: !cellModels.isEmpty)
        tableView.reloadData()
    }
    
    @objc private func refresh(sender: UIRefreshControl){
        sender.endRefreshing()
        setUpView()
        tableView.reloadData()
    }
    
    func setUpView(){
        APIManager.shared.getMarsPhotoFromAPI(completion: { [weak self] (photos) in
            DispatchQueue.main.async {
                LoadIndicator.shared.removeSpinner()
                guard photos != nil else { return }
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
        if isFiltering {
          return filteredPhotos.count
        }
        return photoData?.photos.count ?? Constants.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath) as? MarsPhotoTableViewCell else { return UITableViewCell() }
        guard let result = isFiltering ? filteredPhotos[indexPath.row] : photoData?.photos[indexPath.row] else {
            return UITableViewCell()
        }
      //  DispatchQueue.main.async {
            cell.earthDate.text = result.earth_date
            let int: Int = result.sol!
            let string = String(int)
            cell.solDate.text = "SOL: \(string)"
            cell.fullNameLabel.text = result.camera.full_name
     //   }
        cell.marsPhoto.image = nil
        getImage(indexPath: indexPath, imageURL: result.img_src)
        cell.selectionStyle = .none
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    
    // MARK: - HeaderViewDelegate
    
    func search(text: String) {
        searchAction(with: text)
        filterContentForSearchText(text)
    }
    
    func searchBar(is hidden: Bool) {
        if hidden {
            searchAction(with: "")
        }
        UIView.animate(withDuration: Constants.standartAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
