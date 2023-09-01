//
//  MarvelComicCollectionViewCell.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/1/23.
//

import UIKit
import SDWebImage

class MarvelComicCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "marvelComicCell"
    
    var comicImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let comicLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        //add views
        contentView.addSubview(comicImage)
        contentView.addSubview(comicLabel)

    }
    
    func configureComicCells(mvComic: Comic){
        
        comicLabel.text = mvComic.title
        
        if let path = mvComic.thumbnail?.path,
           let ext = mvComic.thumbnail?.imageExtension {
            comicImage.sd_setImage(with: URL(string: "\(path).\(ext)"))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        comicLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        comicLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        comicLabel.bottomAnchor.constraint(equalTo: comicImage.topAnchor).isActive = true
        comicLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        comicImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        comicImage.topAnchor.constraint(equalTo: comicLabel.bottomAnchor).isActive = true
        comicImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        comicImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
