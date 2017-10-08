//
//  SearchArtistsViewController.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/5/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import UIKit

class SearchArtistsViewController: MainViewController {

    @IBOutlet weak var vwSearchControl: UIView!
    @IBOutlet weak var cstSearchControlTop: NSLayoutConstraint!
    @IBOutlet weak var schArtistSearch: UISearchBar!
    @IBOutlet weak var actSearching: UIActivityIndicatorView!
    @IBOutlet weak var tblArtists: UITableView!
    @IBOutlet var vwNoContent: UIView!
    @IBOutlet weak var imgMusician: UIImageView!
    @IBOutlet weak var lblNoResults: UILabel!
    
    var scrollViewContentOffset: CGFloat = 0.0
    var tapToDismiss: UITapGestureRecognizer?
    var searchTimer: Timer = Timer()
    
    var dataSource: [SearchArtist] = ArtistsManager.shared.searchedArtists
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "Artists"
        
        tblArtists.rowHeight = UITableViewAutomaticDimension
        tblArtists.estimatedRowHeight = 60
        tblArtists.tableFooterView = UIView()
        tblArtists.scrollIndicatorInsets = UIEdgeInsetsMake(56, 0, 0, 0)
        tblArtists.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        
        setMusicianMood(isHeSad: false)
        tblArtists.backgroundView = vwNoContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.tblArtists.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailsVC = segue.destination as? ArtistDetailsViewController, let artistObject = sender as? Artist {
            detailsVC.artist = artistObject
        }
    }
    
    func setMusicianMood(isHeSad: Bool, customMessage: String? = nil) {
        if isHeSad {
            imgMusician.image = UIImage(named: "sadMusician")
            lblNoResults.text = customMessage ?? "No results were found using your search query. Please try again using a different one."
        } else {
            imgMusician.image = UIImage(named: "happyMusician")
            lblNoResults.text = customMessage ?? "Start searching for an artist or band using the field above. We'll show them automagically after you finish typing."
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchArtistsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchArtistCell") as! ArtistCell
        
        let artist = dataSource[indexPath.row]
        cell.setCellData(artist)
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension SearchArtistsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let artist = dataSource[indexPath.row]
        if artist.name != nil {
            ArtistsManager.getArtistDetails(artist.name!, completionHandler: { (artistObject) in
                
                if artistObject != nil {
                    self.performSegue(withIdentifier: "goToArtistDetails", sender: artistObject!)
                } else {
                    NetworkManager.shared.handleError()
                }
            })
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchArtistsViewController: UISearchBarDelegate {
    @objc func tappedToDismiss(_ sender: UITapGestureRecognizer) {
        view.removeGestureRecognizer(tapToDismiss!)
        schArtistSearch.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(tappedToDismiss(_:)))
        view.addGestureRecognizer(tapToDismiss!)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer.invalidate()
        searchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(doSearch(_:)), userInfo: searchText, repeats: false)
        
        if searchText.length == 0 {
            DispatchQueue.main.async {
                self.dataSource = []
                self.setMusicianMood(isHeSad: false)
                self.tblArtists.backgroundView = self.vwNoContent
                self.tblArtists.reloadData()
            }
        }
    }
    
    @objc func doSearch(_ timer: Timer) {
        
        if let searchQuery = timer.userInfo as? String {
            if searchQuery.length > 1 {
                self.setSearchingStatus(true)
                updateDataSource(search: searchQuery)
            }
        }
        timer.invalidate()
    }
    
    func updateDataSource(search: String) {
        
        ArtistsManager.searchForArtists(search, completionHandler: { (response) in
            self.dataSource = response
            
            DispatchQueue.main.async {
                if self.dataSource.count == 0 {
                    self.setMusicianMood(isHeSad: true)
                    self.tblArtists.backgroundView = self.vwNoContent
                } else {
                    self.tblArtists.backgroundView = nil
                }
                
                self.tblArtists.reloadData()
                self.setSearchingStatus(false)
            }
        })
    }
    
    func setSearchingStatus(_ active: Bool) {
        UIView.animate(withDuration: 0.35, animations: {
            self.actSearching.alpha = active ? 1 : 0
        })
    }
}

// MARK: - UIScrollViewDelegate
extension SearchArtistsViewController: UIScrollViewDelegate {
    // All functions in the scrollview delegate are handling the hiding and showing of the search bar
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let saveOffset = shouldMenuViewHideOrShow(scrollView, initialContentOffset: 0, currentContentOffset: scrollViewContentOffset)
        if saveOffset {
            scrollViewContentOffset = scrollView.contentOffset.y
        }
    }
    
    open func shouldMenuViewHideOrShow(_ scrollView: UIScrollView, initialContentOffset: CGFloat, currentContentOffset: CGFloat) -> Bool {
        if scrollView.contentOffset.y - scrollView.contentInset.bottom < scrollView.contentSize.height - scrollView.bounds.size.height && scrollView.contentOffset.y >= initialContentOffset && scrollView.contentOffset.y > 0.0  {
            if currentContentOffset > scrollView.contentOffset.y {
                updateToolbarVisibilityStatus(true)
                return true
            } else if currentContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y + scrollView.frame.size.height < scrollView.contentSize.height {
                if currentContentOffset > 56 {
                    updateToolbarVisibilityStatus(false)
                }
                return true
            }
            return false
        }
        return false
    }
    
    func updateToolbarVisibilityStatus(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.cstSearchControlTop.constant = 0
            } else {
                self.cstSearchControlTop.constant = -56
            }
            
            UIView.animate(withDuration: 0.35, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
