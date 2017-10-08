//
//  FavoritesViewController.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/7/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import UIKit

class FavoritesViewController: MainViewController {

    @IBOutlet weak var tblFavorites: UITableView!
    @IBOutlet var vwNoContent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = "Favorites"
        
        tblFavorites.rowHeight = UITableViewAutomaticDimension
        tblFavorites.estimatedRowHeight = 60
        tblFavorites.tableFooterView = UIView()
        tblFavorites.scrollIndicatorInsets = UIEdgeInsetsMake(56, 0, 0, 0)
        tblFavorites.contentInset = UIEdgeInsetsMake(10, 0, 20, 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.tblFavorites.reloadData()
        }
        
        if FavoritesManager.shared.favorites.count == 0 {
            tblFavorites.backgroundView = vwNoContent
        } else {
            tblFavorites.backgroundView = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailsVC = segue.destination as? ArtistDetailsViewController, let artistObject = sender as? Artist {
            detailsVC.artist = artistObject
        }
    }

}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesManager.shared.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteArtistCell") as! ArtistCell
        
        let savedArtistCD = FavoritesManager.shared.favorites[indexPath.row]
        let artist = FavoritesManager.getSearchArtistFromData(savedArtistCD)
        cell.setCellData(artist)
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let savedArtistCD = FavoritesManager.shared.favorites[indexPath.row]
        let artist = FavoritesManager.getSearchArtistFromData(savedArtistCD)
        
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
