//
//  DataModels.swift
//  ComicCosmos
//
//  Created by Benjamin Simpson on 8/30/23.
//

import Foundation
import UIKit

//MARK: - Heroes

struct MarvelCharacterResponse: Codable {
    let data: MarvelCharacterData?
}

struct MarvelCharacterData: Codable {
    let results: [MarvelCharacter]?
}

struct MarvelCharacter: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let resourceURL: String?
    let urls: [URLs]?
    let thumbnail: Image?
    let comics: ComicList?
    let stories: StoryList?
}

struct ComicList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURL: String?
    let items: [ComicSummary]?
}

struct StoryList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURL: String?
    let items: [StorySummary]?
}

struct StorySummary: Codable {
    let resourceURL: String?
    let name: String?
    let type: String?
}

struct URLs: Codable {
    let type: String?
    let url: String?
}

struct Image: Codable {
    let path: String?
    let imageExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}

//MARK: - Comic

struct ComicResponse: Codable {
    let data: ComicData?
}

struct ComicData: Codable {
    let results: [Comic]?
}

struct Comic: Codable {
    let title: String?
    let description: String?
    let format: String?
    let pageCount: Int?
    let resourceURL: String?
    let series: ComicSummary?
    let thumbnail: Image?
    let images: [Image]?
    let urls: [URLs]?
}

struct ComicSummary: Codable {
    let resourceURL: String?
    let name: String?
}

//MARK: - Creator

struct CreatorResponse: Codable {
    let data: CreatorData?
}

struct CreatorData: Codable {
    let results: [Creator]?
}

struct Creator: Codable {
    let id: Int?
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let suffix: String?
    let fullname: String?
    let thumbnail: Image?
}
