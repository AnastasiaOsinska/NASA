//
//  SearchBarView.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/26/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

final class SearchBarView: NibLoadingView {
    
    enum Style {
        case black
        case white
        
        var color: UIColor {
            switch self {
            case .black:
                return UIColor.black
            case .white:
                return UIColor.blue
            }
        }
        var searchImage: UIImage {
            switch self {
            case .black:
                return #imageLiteral(resourceName: "searchIconBlack")
            case .white:
                return #imageLiteral(resourceName: "searchIconWhite")
            }
        }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let closeButtonRadius: CGFloat = 4
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    
    // MARK: - Properties

    var searchAction: ((Bool) -> Void)?
    var searchBarIsHidden: Bool = true {
        didSet {
            updateSearchBar()
            guard let searchAction = searchAction else {
                return
            }
            searchAction(searchBarIsHidden)
        }
    }
    var style: Style = .white {
        didSet {
            searchButton.setImage(style.searchImage, for: .normal)
        }
    }
    
    // MARK: - View life cycle
    
    override func awakeFromNib() {
     
    }
    
    
    // MARK: - Private
    
    private func updateSearchBar() {
        if searchBarIsHidden {
            searchView.isHidden = true
            searchButton.contentHorizontalAlignment = .trailing
            searchButton.backgroundColor = .clear
            searchButton.setImage(style.searchImage, for: .normal)
        } else {
            searchView.isHidden = false
            searchButton.contentHorizontalAlignment = .center
            searchButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        }
        stackView.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @IBAction func searchButtonAction(_ sender: Any) {
        searchBarIsHidden = !searchBarIsHidden
        if searchBarIsHidden {
            searchBar.resignFirstResponder()
        } else {
            searchBar.becomeFirstResponder()
        }
    }
}
