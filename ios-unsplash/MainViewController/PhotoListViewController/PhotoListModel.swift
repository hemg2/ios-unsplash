//
//  PhotoListModel.swift
//  ios-unsplash
//
//  Created by 1 on 2/6/24.
//

import Foundation

// 사진 정보를 담는 구조체
struct Photo: Decodable {
    let id: String
    let slug: String?
    let createdAt: Date
    let updatedAt: Date
    let promotedAt: Date?
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let description: String?
    let altDescription: String?
    let urls: PhotoURLs
    let links: PhotoLinks
    let likes: Int
    let likedByUser: Bool
    let currentUserCollections: [String]
    let sponsorship: Sponsorship?
    let user: User

    enum CodingKeys: String, CodingKey {
        case id, slug, width, height, color, description, urls, links, likes, user, sponsorship
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case blurHash = "blur_hash"
        case altDescription = "alt_description"
        case likedByUser = "liked_by_user"
        case currentUserCollections = "current_user_collections"
    }
}

// 사진 URL 정보를 담는 구조체
struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

// 사진 링크 정보를 담는 구조체
struct PhotoLinks: Codable {
    let `self`: String
    let html: String
    let download: String
    let downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case `self`
        case html, download
        case downloadLocation = "download_location"
    }
}

// 후원 정보를 담는 구조체
struct Sponsorship: Codable {
    let impressionUrls: [String]
    let tagline: String
    let taglineUrl: String
    let sponsor: User

    enum CodingKeys: String, CodingKey {
        case impressionUrls = "impression_urls"
        case tagline
        case taglineUrl = "tagline_url"
        case sponsor
    }
}

// 사용자 정보를 담는 구조체
struct User: Codable {
    let id: String
    let updatedAt: String
    let username: String
    let name: String
    let firstName: String
    let lastName: String?
    let twitterUsername: String?
    let portfolioUrl: String?
    let bio: String?
    let location: String?
    let links: UserLinks
    let profileImage: UserProfileImage
    let instagramUsername: String?
    let totalCollections: Int
    let totalLikes: Int
    let totalPhotos: Int
    let totalPromotedPhotos: Int
    let acceptedTos: Bool
    let forHire: Bool

    enum CodingKeys: String, CodingKey {
        case id, username, name, bio, location, links
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioUrl = "portfolio_url"
        case profileImage = "profile_image"
        case instagramUsername = "instagram_username"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalPromotedPhotos = "total_promoted_photos"
        case acceptedTos = "accepted_tos"
        case forHire = "for_hire"
    }
}

// 사용자 링크 정보를 담는 구조체
struct UserLinks: Codable {
    let `self`: String
    let html: String
    let photos: String
    let likes: String
    let portfolio: String
    let following: String
    let followers: String
}

// 사용자 프로필 이미지 정보를 담는 구조체
struct UserProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}
