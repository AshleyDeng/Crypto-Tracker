//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Dongcheng Deng on 2021-05-15.
//

import UIKit

// API Client
// UI to show cryptos
// MVVM


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return tableView
    }()
    
    private var viewModels = [CryptoTableViewCellViewModel]()
    
    static let numberFormatter: NumberFormatter = {
        let formater = NumberFormatter()
        formater.locale = .current
        formater.allowsFloats = true
        formater.numberStyle = .currency
        formater.formatterBehavior = .default
        return formater
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Crypto Tracker"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        APIClient.shared.getAllCryptoData(completion: { [weak self] result in
            switch result {
            case .success(let models):
                self?.viewModels = models.compactMap({ model in
                    let price = model.price_usd ?? 0
                    let priceString = Self.numberFormatter.string(from: NSNumber(floatLiteral: Double(price)))
                    
                    let iconUrl = APIClient.shared.icons.filter({ icon in
                        icon.asset_id == model.asset_id
                    }).first?.url
                    
                    
                    return CryptoTableViewCellViewModel(
                        name: model.name ?? "N/A",
                        symbol: model.asset_id,
                        price: priceString ?? "N/A",
                        iconUrl: iconUrl ?? ""
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CryptoTableViewCell.identifier,
                for: indexPath
        ) as? CryptoTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }

}

