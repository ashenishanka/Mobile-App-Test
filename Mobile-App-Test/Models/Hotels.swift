//
//  Hotels.swift
//  Mobile-App-Test
//
//  Created by Ashen Ishanka on 2024-06-26.
//

import Foundation

struct HotelsData: Codable{
    let data: [HotelItem]
}

struct HotelItem: Codable{
    let id: Int
    let title: String
    let description: String
    let address: String
    let postcode: String
    let phoneNumber: String
    let latitude: String
    let longitude: String
    let image: HotelImage
}
struct HotelImage: Codable{
    let small: String
    let medium: String
    let large: String
}
