//
//  ViewController.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 8/30/23.
//

import UIKit
import SDWebImage

class MarvelHeroViewController: UIViewController {
    
    //MARK: - Variables
    
    let networkManager = NetworkManager()
    
    var characters: [MarvelCharacter] = []
    
    var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    
    let device = UIDevice.current
    
    private var marvelHeroCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flow)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MarvelHeroCollectionViewCell.self, forCellWithReuseIdentifier: "marvelHeroCell")
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    // Searching Variables
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searching = false
    
    var searchCharacters: [MarvelCharacter] = []
    
    var offSet = 0
    
    //MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        marvelHeroCollectionView.backgroundColor = .clear
        marvelHeroCollectionView.dataSource = self
        marvelHeroCollectionView.delegate = self
        view.addSubview(marvelHeroCollectionView)
        
        fetchHeroData()
        
        configureSearchController()
        
    }
    
    //Fetches network call
    func fetchHeroData(query: String? = nil, offSet: Int? = nil) {
        
        networkManager.fetchMarvelCharacters(query: query, offSet: offSet) { [weak self] characters, error in
            if let characters = characters {
                self?.characters = characters
                DispatchQueue.main.async {
                    self?.marvelHeroCollectionView.reloadData()
                }
            } else if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func loadMoreCharacters() {
        offSet += 20 // Increment by the number of characters per page
        networkManager.fetchMarvelCharacters(offSet: offSet) { [weak self] characters, error in
            if let characters = characters {
                // Append the fetched characters to your existing list
                self?.characters.append(contentsOf: characters)
                DispatchQueue.main.async {
                    self?.marvelHeroCollectionView.reloadData()
                }
            } else if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        //invalidate layout on orientation change
        marvelHeroCollectionView.collectionViewLayout.invalidateLayout()
        
        //contraints
        marvelHeroCollectionView.frame = self.view.bounds
        
    }
    
} //MarvelHeroViewController


    // MARK: - CollectionView
    
    extension MarvelHeroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if searching {
                return searchCharacters.count
            } else {
                return characters.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marvelHeroCell", for: indexPath) as! MarvelHeroCollectionViewCell
            cell.layer.cornerRadius = 20
            cell.layer.borderWidth = 5
            cell.layer.borderColor = UIColor.black.cgColor
            cell.clipsToBounds = true
            
            if searching {

                cell.heroLabel.text = self.searchCharacters[indexPath.item].name
                    
                let sh = self.searchCharacters[indexPath.item]
                    
                var thumbnailURLString = (sh.thumbnail?.path)! + "." + (sh.thumbnail?.imageExtension)!
                    thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
                    
                if let thumbnailURL = URL(string: thumbnailURLString) {
                        cell.heroImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
                }

            } else {
                let heroes = characters[indexPath.item]
                cell.configureHeroCells(mvHero: heroes)
                cell.heroLabel.text = heroes.name
                
                var thumbnailURLString = (heroes.thumbnail?.path)! + "." + (heroes.thumbnail?.imageExtension)!
                thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
                
                if let thumbnailURL = URL(string: thumbnailURLString) {
                    cell.heroImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
                }
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let details = characters[indexPath.item]
            let detailVC = MarvelDetailViewController(heroDetails: details)
            navigationController?.modalPresentationStyle = .fullScreen
            navigationController?.modalTransitionStyle = .crossDissolve
            navigationController?.pushViewController(detailVC, animated: true)
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
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.item == characters.count - 1 {  // last cell
                loadMoreCharacters()
            }
        }
        
    }

//MARK: - Search

extension MarvelHeroViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    private func configureSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        searchController.searchBar.backgroundColor = .white
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Characters"
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        if !searchText.isEmpty{
            searching = true
            searchCharacters.removeAll()
                
            searchCharacters = characters.filter({ mc in
                return (mc.name?.lowercased().contains(searchText.lowercased()) ?? false)
            })
            fetchHeroData(query: searchText)
        } else {
            searching = false
            //searchCharacters = characters
            fetchHeroData()
        }
        self.marvelHeroCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchCharacters  = characters
        marvelHeroCollectionView.reloadData()
        searchController.resignFirstResponder()
    }
    
    
}
