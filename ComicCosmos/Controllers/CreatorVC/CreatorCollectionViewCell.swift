//
//  CreatorCollectionViewCell.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/1/23.
//

import UIKit
import SDWebImage

class CreatorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "creatorCell"
    
    var creatorImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let creatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var searching = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        //add views
        contentView.addSubview(creatorImage)
        contentView.addSubview(creatorLabel)

    }
    
    func configureCreators(mvCreator: Creator){
        
        creatorLabel.text = mvCreator.firstName
        
        if let path = mvCreator.thumbnail?.path,
           let ext = mvCreator.thumbnail?.imageExtension {
            creatorImage.sd_setImage(with: URL(string: "\(path).\(ext)"))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        creatorLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        creatorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        creatorLabel.bottomAnchor.constraint(equalTo: creatorImage.topAnchor).isActive = true
        creatorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        creatorImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        creatorImage.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor).isActive = true
        creatorImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        creatorImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
