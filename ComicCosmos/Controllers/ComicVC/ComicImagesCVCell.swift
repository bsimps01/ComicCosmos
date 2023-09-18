//
//  ComicImagesCVCell.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/16/23.
//

import UIKit

class ComicImagesCVCell: UICollectionViewCell {
    
    static let identifier = "marvelImagesCell"
    
    var comicImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        //add views
        contentView.addSubview(comicImage)

    }
    
    func configureComicImageCells(mvComic: Image){
        
        if let path = mvComic.path,
           let ext = mvComic.imageExtension {
            var thumbnailURLString = (path) + "." + (ext)
            thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
            
            if let thumbnailURL = URL(string: thumbnailURLString) {
                comicImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        comicImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        comicImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        comicImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        comicImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
