//
//  MarvelDetailViewController.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/1/23.
//

import UIKit
import SDWebImage

class MarvelDetailViewController: UIViewController {
    
    //MARK: - Variables
    
    var heroDetails: MarvelCharacter?
    
    var heroImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.sizeToFit()
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 35)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    //MARK: - Initializers
    init(heroDetails: MarvelCharacter) {
        super.init(nibName: nil, bundle: nil)
        self.heroDetails = heroDetails
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(heroImage)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(descriptionLabel)
        
        configureDetails()
        detailsLayout()
    }
    
    //MARK: - Functions
    
    func configureDetails(){
        if let heroDetails = heroDetails {
            nameLabel.text = heroDetails.name
            descriptionLabel.text = heroDetails.description
            
            var thumbnailURLString = (heroDetails.thumbnail?.path)! + "." + (heroDetails.thumbnail?.imageExtension)!
            thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
            
            if let thumbnailURL = URL(string: thumbnailURLString) {
                heroImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
            }
        }
    }
    
    func detailsLayout(){
        
        scrollView.frame = view.frame
        
        heroImage.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        heroImage.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        heroImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        heroImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        heroImage.heightAnchor.constraint(equalToConstant: view.bounds.height/2).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: heroImage.bottomAnchor).isActive = true
        
        descriptionLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true

        
    }
    
}
