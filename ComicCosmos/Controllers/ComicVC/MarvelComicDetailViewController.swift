//
//  MarvelComicDetailViewController.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/1/23.
//

import UIKit
import SDWebImage
import SwiftSoup

class MarvelComicDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var comicDetails: Comic?
    
    var comics: [Comic] = []
    
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
    
    let pageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 20
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        return button
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
    
    let imageScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.4)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    var mvImages: [UIImageView] = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return [image]
    }()
    
    var testImages: [Image] = []
    
    var imagesCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let ic = UICollectionView(frame: .zero, collectionViewLayout: flow)
        ic.translatesAutoresizingMaskIntoConstraints = false
        ic.register(ComicImagesCVCell.self, forCellWithReuseIdentifier: "marvelImagesCell")
        ic.alwaysBounceHorizontal = true
        ic.isPagingEnabled = true
        return ic
    }()
    
    //MARK: - Initializers
    init(comicDetails: Comic) {
        super.init(nibName: nil, bundle: nil)
        self.comicDetails = comicDetails
        print(comicDetails)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.frame = view.frame
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        pageControl.numberOfPages = testImages.count
        pageControl.currentPage = 0
        
        if let comicDetails = comicDetails {
            testImages = comicDetails.images ?? []
        }
        
        
        scrollView.addSubview(comicImage)
        scrollView.addSubview(comicLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(formatLabel)
        //scrollView.addSubview(pageButton)
        scrollView.addSubview(imagesCollectionView)
        scrollView.addSubview(buttonStack)
        
        configureButtonStack()
    }
    
    override func viewDidLayoutSubviews() {
        configureDetails()
        detailsLayout()
        
    }
    
    func configureDetails(){
        
        if let comicDetails = comicDetails {
            
            comicLabel.text = comicDetails.title
            
            if let attributedString = parseHTMLString(comicDetails.description ?? "") {
                descriptionLabel.attributedText = attributedString
            }
            
            //formatLabel.text = "Format: \(String(describing: comicDetails.format!))"
            if comicDetails.pageCount! > 0 {
                //pageButton.frame.size = CGSize(width: view.frame.width/4, height: view.frame.height/8)
                let title = "Total Pages"
                let pageCounttext = "\(String(describing: comicDetails.pageCount!))"
                let subtitle = pageCounttext
                
                let attributedString = NSMutableAttributedString(string: title + "\n" + subtitle)

                attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.black], range: NSRange(location: 0, length: title.count))
                attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.white], range: NSRange(location: title.count + 1, length: subtitle.count))
                
                scrollView.addSubview(pageButton)
                pageButton.titleLabel?.numberOfLines = 0
                pageButton.titleLabel?.textAlignment = .center
                pageButton.setAttributedTitle(attributedString, for: .normal)

            }
            var thumbnailURLString = (comicDetails.thumbnail?.path)! + "." + (comicDetails.thumbnail?.imageExtension)!
            thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
            
            if let thumbnailURL = URL(string: thumbnailURLString) {
                comicImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
            }
        }
    }
    
    func parseHTMLString(_ htmlString: String) -> NSAttributedString? {
        do {
            let document = try SwiftSoup.parse(htmlString)
            
            // Convert parsed document to plain text
            let plainText = try document.text()
            
            // Convert plainText to NSAttributedString (basic)
            let attributedString = NSAttributedString(string: plainText)
            
            return attributedString
        } catch {
            print("Could not parse HTML: \(error)")
            return nil
        }
    }
    
    func configureButtonStack() {
        
        for subview in buttonStack.arrangedSubviews {
            buttonStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        //Buttons based on Hero URLs
        comicDetails?.urls?.forEach({ marvelURL in
            
            let button = UIButton(type: .roundedRect)
            
            let type = marvelURL.type
            
            switch (type) {
            case "detail":
                button.setTitle("Comic's Details", for: .normal)
            case "purchase":
                button.setTitle("Purchase Comic", for: .normal)
            case "inAppLink":
                button.setTitle("Comic's Comics", for: .normal)
            case "reader":
                button.setTitle("Comic's Reader", for: .normal)
            default:
                button.setTitle(marvelURL.type, for: .normal)
            }

            button.addTarget(self, action: #selector(urlButtonTapped(_ :)), for: .touchUpInside)
            button.frame.size = CGSize(width: view.frame.width/4, height: view.frame.height/8)
            button.tag = buttonStack.arrangedSubviews.count // Set tag to identify the button
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 20
            button.backgroundColor = .red
            button.setTitleColor(.white, for: .normal)
            buttonStack.addArrangedSubview(button)
        
        })
        
//        comicDetails?.images?.forEach({ image in
//
//            var thumbnailURLString = (image.path)! + "." + (image.imageExtension)!
//            thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
//
//            if let thumbnailURL = URL(string: thumbnailURLString) {
//                comicImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
//            }
//        })
    }
    
    @objc func urlButtonTapped(_ sender: UIButton) {
        
        guard let urlIndex = comicDetails?.urls?.indices.first(where: { $0 == sender.tag }) else { return }
        
        var urlString = comicDetails?.urls?[urlIndex].url ?? "N/A"
        urlString = urlString.replacingOccurrences(of: "http://", with: "https://")
        
        if URL(string: urlString) != nil {
                    let web = MarvelHeroWebView()
                    web.url = urlString
                    web.modalPresentationStyle = .formSheet
                    web.modalTransitionStyle = .coverVertical
                    self.present(web, animated: true, completion: nil)
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
        
        if (comicDetails?.pageCount)! > 0 {
            pageButton.topAnchor.constraint(equalTo: formatLabel.bottomAnchor).isActive = true
            pageButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: view.frame.width/4 + 15).isActive = true
            //pageButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
            pageButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            pageButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        
        if (comicDetails?.pageCount)! > 0 {
            imagesCollectionView.topAnchor.constraint(equalTo: pageButton.bottomAnchor).isActive = true
        } else {
            imagesCollectionView.topAnchor.constraint(equalTo: formatLabel.bottomAnchor).isActive = true
        }
        imagesCollectionView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        imagesCollectionView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        imagesCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        imagesCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height/8).isActive = true

        buttonStack.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: view.frame.width/4).isActive = true
        //buttonStack.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -50).isActive = true
        buttonStack.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 10).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50).isActive = true
        buttonStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marvelImagesCell", for: indexPath) as! ComicImagesCVCell
        let comic = testImages[indexPath.item]
        cell.configureComicImageCells(mvComic: comic)
            return cell
    }
    
}
