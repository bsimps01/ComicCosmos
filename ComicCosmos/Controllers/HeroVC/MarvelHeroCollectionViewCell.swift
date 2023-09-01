//
//  MarvelCollectionViewCell.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 8/31/23.
//

import UIKit
import SDWebImage

class MarvelHeroCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Variables
    static let identifier = "marvelHeroCell"
    
    var heroImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let heroLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    //MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        //add views
        contentView.addSubview(heroImage)
        contentView.addSubview(heroLabel)

    }
    //MARK: - Functions
    func configureHeroCells(mvHero: MarvelCharacter){
        
        heroLabel.text = mvHero.name
        
        if let path = mvHero.thumbnail?.path,
           let ext = mvHero.thumbnail?.imageExtension {
            heroImage.sd_setImage(with: URL(string: "\(path).\(ext)"))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heroLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        heroLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        heroLabel.bottomAnchor.constraint(equalTo: heroImage.topAnchor).isActive = true
        heroLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        heroImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        heroImage.topAnchor.constraint(equalTo: heroLabel.bottomAnchor).isActive = true
        heroImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        heroImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
