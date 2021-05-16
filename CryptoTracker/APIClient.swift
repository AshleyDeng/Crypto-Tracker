//
//  APIClient.swift
//  CryptoTracker
//
//  Created by Dongcheng Deng on 2021-05-15.
//

import Foundation

final class APIClient {
    static let shared = APIClient()
    
    private init() {}
    
    var icons = [Icon]()
    
    private struct Constants {
        static let apiKey = "3B512E73-AB38-470E-A57A-64BDD9F23931"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets/"
        static let iconsEndpoint = "https://rest.coinapi.io/v1/assets/icons/55/"
    }
    
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    func getAllCryptoData(
        completion: @escaping (Result<[Crypto], Error>) -> Void
    ) {
        guard !icons.isEmpty else {
            whenReadyBlock = completion
            return
        }
        
        guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(cryptos.sorted {
                    $0.price_usd ?? 0 > $1.price_usd ?? 0
                }))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getAllIcons() {
        guard let url = URL(string: Constants.iconsEndpoint + "?apikey=" + Constants.apiKey) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let block = self?.whenReadyBlock {
                    self?.getAllCryptoData(completion: block)
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

