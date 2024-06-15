//
//  PasswordViewController+Search.swift
//  PassLock
//
//  Created by Melo on 2024/5/30.
//

import KakaFoundation

extension PasswordViewController: UISearchBarDelegate {
    func configSearchBar() {
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debugPrint("searchText = \(searchText)")
        self.searchController.searchWithKey(searchText)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.count > 0 else {
            self.searchController.dismiss(animated: true)
            return
        }
        
        self.searchController.searchWithKey(searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 && kaka_IsMacOS() {
            self.searchController.dismiss(animated: true)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.cancelSearchAction()
    }
    
    func removeSearchController() {
        if navigationItem.searchController != nil {
            navigationItem.searchController = nil
        }
    }
        
    func restoreSearchController() {
        if navigationItem.searchController == nil {
            navigationItem.searchController = self.searchController
        }
    }
    
}
