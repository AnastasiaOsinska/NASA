//
//  SearchBarView.swift
//  NASA
//
//  Created by Anastasiya Osinskaya on 8/26/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func search(text: String)
    func searchBar(is hidden: Bool)
}

final class SearchBarView: NibLoadingView, UISearchBarDelegate {
    
    // MARK: - Constants
    
    private struct Constants {
        static let closeButtonRadius: CGFloat = 4
        static let animationDuration: TimeInterval = 0.5
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    
    // MARK: - Properties
    
    private var searchStr = ""
    var delegate: HeaderViewDelegate?
    var actionSearch: ((Bool) -> Void)?
    var searchBarIsHidden: Bool = true {
        didSet {
            updateSearchBar()
            delegate?.searchBar(is: searchBarIsHidden)
            guard let actionSearch = actionSearch else {
                return
            }
            actionSearch(searchBarIsHidden)
        }
    }
    
    // MARK: - View life cycle
    
    override func awakeFromNib() {
        searchBar.delegate = self
        searchBarIsHidden = true
    }
    
    
    // MARK: - Private
    
    private func updateSearchBar() {
        if searchBarIsHidden {
            searchBar.text = ""
            searchView.isHidden = true
            searchButton.contentHorizontalAlignment = .trailing
            searchButton.backgroundColor = .clear
            searchButton.setImage(#imageLiteral(resourceName: "searchIconWhite"), for: .normal)
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
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            searchBar.resignFirstResponder()
            return false
        }
        searchStr = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        delegate?.search(text: searchStr)
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setTextFieldColor(color: .white, textColor: .darkGray)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setTextFieldColor(color: .darkGray, textColor: .white)
    }
}

extension UISearchBar {
    func setTextFieldColor(color: UIColor, textColor: UIColor) {
        self.searchTextField.backgroundColor = color
        self.searchTextField.textColor = textColor
        self.searchTextField.tintColor = .darkGray
    }
}
