//
//  CreatorViewController.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/1/23.
//

import UIKit
import SDWebImage

class CreatorViewController: UIViewController {
    
    //MARK: - Variables
    
    let networkManager = NetworkManager()
    
    var creators: [Creator] = []
    
    var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    
    let device = UIDevice.current
    
    private var creatorCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flow)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CreatorCollectionViewCell.self, forCellWithReuseIdentifier: "creatorCell")
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    // Searching Variables
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searching = false
    
    var searchCreators: [Creator] = []
    
    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        creatorCollectionView.backgroundColor = .clear
        creatorCollectionView.dataSource = self
        creatorCollectionView.delegate = self
        view.addSubview(creatorCollectionView)
        
        fetchCreatorData()
        
        configureSearchController()
        
    }
    
    //Fetches data from network call
    func fetchCreatorData() {
        
        networkManager.fetchCreators{ [weak self] creators, error in
            if let creators = creators {
                self?.creators = creators
                DispatchQueue.main.async {
                    self?.creatorCollectionView.reloadData()
                }
            } else if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        //invalidate layout on orientation change
        creatorCollectionView.collectionViewLayout.invalidateLayout()
        
        //contraints
        creatorCollectionView.frame = self.view.bounds
        
    }
    
} //MarvelViewController


    // MARK: - CollectionView
    
    extension CreatorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if searching {
                return searchCreators.count
            } else {
                return creators.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "creatorCell", for: indexPath) as! CreatorCollectionViewCell
            if searching {
                cell.creatorLabel.text = searchCreators[indexPath.item].firstName
                
                let sh = searchCreators[indexPath.item]
                var thumbnailURLString = (sh.thumbnail?.path)! + "." + (sh.thumbnail?.imageExtension)!
                thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
                
                if let thumbnailURL = URL(string: thumbnailURLString) {
                    cell.creatorImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
                }
            } else {
        
                let creators = creators[indexPath.item]
                cell.configureCreators(mvCreator: creators)
                cell.layer.cornerRadius = 20
                cell.layer.borderWidth = 5
                cell.layer.borderColor = UIColor.black.cgColor
            
                var thumbnailURLString = (creators.thumbnail?.path)! + "." + (creators.thumbnail?.imageExtension)!
            thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
            
                if let thumbnailURL = URL(string: thumbnailURLString) {
                    cell.creatorImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
                }
            cell.clipsToBounds = true
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let width = (view.frame.width - (2 * 20))
            let itemSize = CGSize(width: width, height: 300)
            return itemSize
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            //checks edges of the screen
            return UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        }
        
    }

// MARK: - Search

extension CreatorViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    private func configureSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Creators"
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        if !searchText.isEmpty{
            searching = true
            searchCreators.removeAll()
                
            searchCreators = creators.filter({ mc in
                return (mc.firstName?.lowercased().contains(searchText.lowercased()) ?? false)
            })
        } else {
            searching = false
            searchCreators = creators
        }
        self.creatorCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchCreators  = creators
        creatorCollectionView.reloadData()
        searchController.resignFirstResponder()
    }
    
    
}
