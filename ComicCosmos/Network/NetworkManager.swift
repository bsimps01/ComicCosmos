//
//  NetworkManager.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 8/30/23.
//

import Foundation
import UIKit
import CryptoKit

public enum Route: String {
    case characters = "/characters"
    case comics = "/comics"
    case creators = "/creators"
    case events = "/events"
    case series = "/series"
}

class NetworkManager {
    
    //MARK: - Character Fethcer
    func fetchMarvelCharacters(query: String? = nil, offSet: Int? = nil, completion: @escaping ([MarvelCharacter]?, Error?) -> Void) {
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        let hashInput = timeStamp + Key.privateKey + Key.publicKey
        let hash = Insecure.MD5.hash(data: Data(hashInput.utf8)).map { String(format: "%02hhx", $0) }.joined()
        
        guard var components = URLComponents(string: MarvelURL.marvelBaseURL.rawValue + Route.characters.rawValue) else { fatalError("Error while unwrapping URL")}
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: Key.publicKey),
            URLQueryItem(name: "ts", value: timeStamp),
            URLQueryItem(name: "hash", value: hash)
        ]

        if let query = query {
            components.queryItems?.append(URLQueryItem(name: "nameStartsWith", value: query))
        }
        
        // Add offset to the query parameters
        components.queryItems?.append(URLQueryItem(name: "offset", value: String(offSet ?? 0)))

        guard let url = components.url else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MarvelCharacterResponse?.self, from: data)
                let characters = response?.data?.results
                completion(characters, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()

    }
    
    //MARK: - Comic Fetcher
    func fetchMarvelComics(query: String? = nil, offSet: Int? = nil, completion: @escaping ([Comic]?, Error?) -> Void) {
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        let hashInput = timeStamp + Key.privateKey + Key.publicKey
        let hash = Insecure.MD5.hash(data: Data(hashInput.utf8)).map { String(format: "%02hhx", $0) }.joined()
        
        guard var components = URLComponents(string: MarvelURL.marvelBaseURL.rawValue + Route.comics.rawValue) else { fatalError("Error while unwrapping URL")}
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: Key.publicKey),
            URLQueryItem(name: "ts", value: timeStamp),
            URLQueryItem(name: "hash", value: hash)
        ]
        
        if let query = query {
            components.queryItems?.append(URLQueryItem(name: "titleStartsWith", value: query))
        }
        
        // Add offset to the query parameters
        components.queryItems?.append(URLQueryItem(name: "offset", value: String(offSet ?? 0)))
        
        guard let url = components.url else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ComicResponse?.self, from: data)
                let comics = response?.data?.results
                completion(comics, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()

    }
    
    //MARK: - Creator Fetcher
    func fetchCreators(query: String? = nil, offSet: Int? = nil, completion: @escaping ([Creator]?, Error?) -> Void) {
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        let hashInput = timeStamp + Key.privateKey + Key.publicKey
        let hash = Insecure.MD5.hash(data: Data(hashInput.utf8)).map { String(format: "%02hhx", $0) }.joined()
        
        guard var components = URLComponents(string: MarvelURL.marvelBaseURL.rawValue + Route.creators.rawValue) else { fatalError("Error while unwrapping URL")}
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: Key.publicKey),
            URLQueryItem(name: "ts", value: timeStamp),
            URLQueryItem(name: "hash", value: hash)
        ]
        
        if let query = query {
            components.queryItems?.append(URLQueryItem(name: "firstNameStartsWith", value: query))
        }
        
        // Add offset to the query parameters
        components.queryItems?.append(URLQueryItem(name: "offset", value: String(offSet ?? 0)))
        
        guard let url = components.url else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(CreatorResponse?.self, from: data)
                let comics = response?.data?.results
                completion(comics, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()

    }
}

