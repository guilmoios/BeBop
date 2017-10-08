//
//  CommomCells.swift
//  BeBop
//
//  Created by Guilherme Mogames on 10/5/17.
//  Copyright © 2017 Mogames. All rights reserved.
//

import UIKit
import YapImageManager

class ArtistCell: UITableViewCell {
    
    @IBOutlet weak var imgArtist: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btFavorite: FavoriteButton!
    var artist: SearchArtist?
    var isFavorite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        btFavorite.addTarget(self, action: #selector(updateFavoriteStatus), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        imgArtist.layer.cornerRadius = imgArtist.width/2
        imgArtist.clipsToBounds = true
        
        btFavorite.imageView?.tintColor = Colors.lightGrey
    }
    
    func setCellData(_ artist: SearchArtist) {
        if artist.mediaId != nil {
            setImageWith(mediaId: artist.mediaId)
        }
        
        if artist.name != nil {
            setArtistName(artist.name!)
        }
        
        self.artist = artist
    }
    
    func setImageWith(mediaId: Int?) {
        
        if mediaId != nil {
            let mediaUrl = String(format: "https://photos.bandsintown.com/thumb/%i.jpeg", mediaId!)
            
            YapImageManager.sharedInstance.asyncImage(forURLString: mediaUrl) { (response) in
                if let image = response.image {
                    self.imgArtist.image = image
                }
            }
        } else {
            imgArtist.image = UIImage(named: "sadMusician")
        }
    }
    
    func setArtistName(_ name: String) {
        lblName.text = name
        isFavorite = FavoritesManager.isArtistInFavorites(name)
        animateFavoriteButton()
    }
    
    @objc func updateFavoriteStatus() {

        isFavorite = FavoritesManager.isArtistInFavorites(lblName.text ?? "nil")
        
        if isFavorite {
            FavoritesManager.removeFromFavorites(lblName.text)
        } else {
            if artist != nil {
                FavoritesManager.addToFavorites(artist!)
            }
        }
        
        isFavorite = !isFavorite
        animateFavoriteButton()
    }
    
    func animateFavoriteButton() {
        
        if isFavorite {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 10.0, initialSpringVelocity: 5.0, options: .preferredFramesPerSecond60, animations: {
                self.btFavorite.imageView?.tintColor = Colors.red
                self.btFavorite.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.btFavorite.isUpsideDown = false
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 10.0, initialSpringVelocity: 5.0, options: .preferredFramesPerSecond60, animations: {
                self.btFavorite.imageView?.tintColor = Colors.lightGrey
                if !self.btFavorite.isUpsideDown {
                    self.btFavorite.transform = CGAffineTransform(rotationAngle: 0)
                }
            }, completion: nil)
        }
        
        
    }
}
