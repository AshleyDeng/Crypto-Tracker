//
//  CryptoTableViewCell.swift
//  CryptoTracker
//
//  Created by Dongcheng Deng on 2021-05-15.
//

import UIKit

class CryptoTableViewCellViewModel {
    let name: String
    let symbol: String
    let price: String
    let iconUrl: String
    var iconData: Data?
    
    init(name: String, symbol: String, price: String, iconUrl: String) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
    }
    
}

class CryptoTableViewCell: UITableViewCell {
    static let identifier = "\(CryptoTableViewCell.self)"
    
    // Subviews
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(iconImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Layouts
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.sizeToFit()
        symbolLabel.sizeToFit()
        priceLabel.sizeToFit()
        
        let size: CGFloat = contentView.frame.height / 1.1
        iconImage.frame = CGRect(
            x: 20,
            y: (contentView.frame.height - size) / 2,
            width: size,
            height: size
        )
        
        nameLabel.frame = CGRect(
            x: 30 + size,
            y: 0,
            width: contentView.bounds.size.width / 2,
            height: contentView.bounds.size.height / 2
        )
        
        symbolLabel.frame = CGRect(
            x: 30 + size,
            y: contentView.bounds.size.height / 2,
            width: contentView.bounds.size.width / 2,
            height: contentView.bounds.size.height / 2
        )
        
        priceLabel.frame = CGRect(
            x: contentView.bounds.size.width / 2,
            y: 0,
            width: (contentView.bounds.size.width / 2) - 20,
            height: contentView.bounds.size.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImage.image = nil
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
        
    }
    
    
    // Configure
    func configure(with viewModel: CryptoTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.price
        
        if let data = viewModel.iconData {
            DispatchQueue.main.async {
                self.iconImage.image = UIImage(data: data)
            }
            return
        }
        
        guard let url = URL(string: viewModel.iconUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data {
                viewModel.iconData = data
                DispatchQueue.main.async {
                    self?.iconImage.image = UIImage(data: data)
                }
            }
        }
        
        task.resume()
    }

}
