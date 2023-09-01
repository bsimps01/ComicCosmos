//
//  MarvelComicDetailViewController.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/1/23.
//

import UIKit
import SDWebImage

class MarvelComicDetailViewController: UIViewController {
    
    var comicDetails: Comic?
    
    var comicImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.sizeToFit()
        return image
    }()
    
    let comicLabel: UILabel = {
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
    
    let formatLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let pageCountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
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
    init(comicDetails: Comic) {
        super.init(nibName: nil, bundle: nil)
        self.comicDetails = comicDetails
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.frame = view.frame
        
        scrollView.addSubview(comicImage)
        scrollView.addSubview(comicLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(formatLabel)
        scrollView.addSubview(pageCountLabel)
    }
    
    override func viewDidLayoutSubviews() {
        configureDetails()
        detailsLayout()
        
    }
    
    func configureDetails(){
        
        if let comicDetails = comicDetails {
            comicLabel.text = comicDetails.title
            descriptionLabel.text = comicDetails.description
            formatLabel.text = "Format: \(String(describing: comicDetails.format!))"
            if comicDetails.pageCount! > 0 {
                let pageCounttext = "Total Pages: \(String(describing: comicDetails.pageCount!))"
                pageCountLabel.text = pageCounttext
            }
            var thumbnailURLString = (comicDetails.thumbnail?.path)! + "." + (comicDetails.thumbnail?.imageExtension)!
            thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
            
            if let thumbnailURL = URL(string: thumbnailURLString) {
                comicImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
            }
        }
    }
    
    func detailsLayout(){
        
        comicImage.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        comicImage.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        comicImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        comicImage.bottomAnchor.constraint(equalTo: comicLabel.topAnchor).isActive = true
        comicImage.heightAnchor.constraint(equalToConstant: view.bounds.height/2).isActive = true
        comicImage.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        
        comicLabel.topAnchor.constraint(equalTo: comicImage.bottomAnchor).isActive = true
        comicLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        comicLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        //nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: comicLabel.bottomAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        //descriptionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        formatLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        formatLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        formatLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        
        pageCountLabel.topAnchor.constraint(equalTo: formatLabel.bottomAnchor).isActive = true
        pageCountLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        pageCountLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        pageCountLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25).isActive = true
    }
    
}
