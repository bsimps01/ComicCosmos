//
//  MarvelComicViewController.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/1/23.
//

import UIKit
import SDWebImage

class MarvelComicViewController: UIViewController {
    
    let networkManager = NetworkManager()
    
    var comics: [Comic] = []
    
    var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    
    let device = UIDevice.current
    
    private var marvelComicCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flow)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MarvelComicCollectionViewCell.self, forCellWithReuseIdentifier: "marvelComicCell")
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    // Searching Variables
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searching = false
    
    var searchComics: [Comic] = []

    var offSet = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        marvelComicCollectionView.backgroundColor = .clear
        marvelComicCollectionView.dataSource = self
        marvelComicCollectionView.delegate = self
        view.addSubview(marvelComicCollectionView)
        
        fetchComicData()
        
        configureSearchController()
        
    }
    
    func fetchComicData(query: String? = nil, offSet: Int? = nil) {
        
        networkManager.fetchMarvelComics(query: query, offSet: offSet) { [weak self] comics, error in
            if let comics = comics {
                self?.comics = comics
                DispatchQueue.main.async {
                    self?.marvelComicCollectionView.reloadData()
                }
            } else if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func loadMoreComics() {
        offSet += 20 // Increment by the number of characters per page
        networkManager.fetchMarvelComics(offSet: offSet) { [weak self] comics, error in
            if let comics = comics {
                // Append the fetched characters to your existing list
                self?.comics.append(contentsOf: comics)
                DispatchQueue.main.async {
                    self?.marvelComicCollectionView.reloadData()
                }
            } else if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        //invalidate layout on orientation change
        marvelComicCollectionView.collectionViewLayout.invalidateLayout()
        
        //contraints
        marvelComicCollectionView.frame = self.view.bounds
        
    }
    
} //MarvelViewController


    // MARK: - CollectionView
    
    extension MarvelComicViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if searching {
                return searchComics.count
            } else {
                return comics.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marvelComicCell", for: indexPath) as! MarvelComicCollectionViewCell
            cell.layer.cornerRadius = 20
            cell.layer.borderWidth = 5
            cell.layer.borderColor = UIColor.black.cgColor
            cell.clipsToBounds = true
            
            if searching {
                cell.comicLabel.text = searchComics[indexPath.item].title
                
                let sh = searchComics[indexPath.item]
                var thumbnailURLString = (sh.thumbnail?.path)! + "." + (sh.thumbnail?.imageExtension)!
                thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
                
                if let thumbnailURL = URL(string: thumbnailURLString) {
                    cell.comicImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
                }
            } else {
                
                //Access Cell
                let comics = comics[indexPath.item]
                cell.configureComicCells(mvComic: comics)
                cell.comicLabel.text = comics.title
                
                //Comic Image
                var thumbnailURLString = (comics.thumbnail?.path)! + "." + (comics.thumbnail?.imageExtension)!
                thumbnailURLString = thumbnailURLString.replacingOccurrences(of: "http://", with: "https://")
                
                if let thumbnailURL = URL(string: thumbnailURLString) {
                    cell.comicImage.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "background"))
                }
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let details = comics[indexPath.item]
            let detailVC = MarvelComicDetailViewController(comicDetails: details)
            detailVC.hidesBottomBarWhenPushed = true
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
            if indexPath.item == comics.count - 1 {  // last cell
                loadMoreComics()
            }
        }
        
    }

// MARK: - Search

extension MarvelComicViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
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
        searchController.searchBar.placeholder = "Search Comics"
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        if !searchText.isEmpty{
            searching = true
            searchComics.removeAll()
                
            searchComics = comics.filter({ mc in
                return (mc.title?.lowercased().contains(searchText.lowercased()) ?? false)
            })
            fetchComicData(query: searchText)
            
        } else {
            searching = false
            fetchComicData()
        }
        
        self.marvelComicCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchComics  = comics
        marvelComicCollectionView.reloadData()
        searchController.resignFirstResponder()
    }
    
    
}
