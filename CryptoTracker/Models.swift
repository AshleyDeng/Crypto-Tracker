//
//  Models.swift
//  CryptoTracker
//
//  Created by Dongcheng Deng on 2021-05-15.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String
    let name: String?
    let price_usd: Float?
    let id_icon: String?
}

struct Icon: Codable {
    let asset_id: String
    let url: String
}
