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
    
    var heroDetails: MarvelCharacter? {
        didSet {
            configureButtonStack()
        }
    }
    
    var heroImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        //image.sizeToFit()
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
    
    let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        scrollView.frame = view.frame
        scrollView.addSubview(heroImage)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(descriptionLabel)
        //scrollView.addSubview(resourceButton)
        scrollView.addSubview(buttonStack)
        
        configureDetails()
        detailsLayout()
        configureButtonStack()

    }
    
    @objc func urlButtonTapped(_ sender: UIButton) {
        
        guard let urlIndex = heroDetails?.urls?.indices.first(where: { $0 == sender.tag }) else { return }
        
        var urlString = heroDetails?.urls?[urlIndex].url ?? "N/A"
        urlString = urlString.replacingOccurrences(of: "http://", with: "https://")
        
        if URL(string: urlString) != nil {
            let web = MarvelHeroWebView()
            web.url = urlString
            web.modalPresentationStyle = .formSheet
            web.modalTransitionStyle = .coverVertical
            self.present(web, animated: true, completion: nil)
        }
        
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
    
    func configureButtonStack() {
        
        for subview in buttonStack.arrangedSubviews {
            buttonStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        //Buttons based on Hero URLs
        heroDetails?.urls?.forEach({ marvelURL in
            
            let button = UIButton(type: .system)
            
            let type = marvelURL.type
            
            switch (type) {
            case "detail":
                button.setTitle("\(heroDetails?.name ?? "")'s Details", for: .normal)
            case "wiki":
                button.setTitle("\(heroDetails?.name ?? "")'s Wiki", for: .normal)
            case "comiclink":
                button.setTitle("\(heroDetails?.name ?? "")'s Comics", for: .normal)
            default:
                button.setTitle(marvelURL.type, for: .normal)
            }

            button.addTarget(self, action: #selector(urlButtonTapped(_ :)), for: .touchUpInside)
            button.frame.size = CGSize(width: view.frame.width/2, height: view.frame.height/8)
            button.tag = buttonStack.arrangedSubviews.count // Set tag to identify the button
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.backgroundColor = .red
            button.titleLabel?.textColor = .white
            buttonStack.addArrangedSubview(button)
        
        })
    }
    
    func detailsLayout(){
        
        heroImage.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        heroImage.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        heroImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        heroImage.heightAnchor.constraint(equalToConstant: view.bounds.height/2).isActive = true
        heroImage.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        heroImage.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 10).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        
        descriptionLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        buttonStack.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        buttonStack.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        buttonStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50).isActive = true

        
    }
    
}
