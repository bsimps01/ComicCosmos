//
//  DashboardVC.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 9/14/23.
//

import UIKit

class DashboardVC: UIViewController {
    
    var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Comic Cosmos"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always

        
        let characterButton: UIButton = {
            let button = UIButton()
            button.setTitle("Characters", for: .normal)
            button.addTarget(self, action: #selector(characterButtonTapped(_ :)), for: .touchUpInside)
            button.backgroundColor = .red
            button.layer.cornerRadius = 10
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 5
            button.frame.size = CGSize(width: 200, height: 150)
            return button
        }()
        
        let comicButton: UIButton = {
            let button = UIButton()
            button.setTitle("Comics", for: .normal)
            button.addTarget(self, action: #selector(comicButtonTapped(_ :)), for: .touchUpInside)
            button.backgroundColor = .red
            button.layer.cornerRadius = 10
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 5
            button.frame.size = CGSize(width: 200, height: 150)
            return button
        }()
        
        let creatorButton: UIButton = {
            let button = UIButton()
            button.setTitle("Creators", for: .normal)
            button.addTarget(self, action: #selector(creatorButtonTapped(_ :)), for: .touchUpInside)
            button.backgroundColor = .red
            button.layer.cornerRadius = 10
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 5
            button.frame.size = CGSize(width: 200, height: 150)
            return button
        }()
        
        let buttonStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [characterButton, comicButton, creatorButton])
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "background")
        view.addSubview(backgroundImage)
        //view.sendSubviewToBack(backgroundImage)
        
        view.addSubview(buttonStack)
        
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        buttonStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func characterButtonTapped(_ sender: UIButton){
        let heroVC = MarvelHeroViewController()
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(heroVC, animated: true)
    }
    
    @objc func comicButtonTapped(_ sender: UIButton){
        let comicVC = MarvelComicViewController()
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(comicVC, animated: true)
    }
    
    @objc func creatorButtonTapped(_ sender: UIButton){
        let creatorVC = CreatorViewController()
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(creatorVC, animated: true)
    }
    
    func layoutView(){

    }
    
}
