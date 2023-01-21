//
//  ImageCell.swift
//  AnimeClassifier
//
//  Created by Ali Eldeeb on 1/21/23.
//

import UIKit

class ImageCell: UICollectionViewCell {
    //MARK: - Properties
    var anime: Anime? {
        didSet {
            guard let anime = anime else { return }
            
            Service.shared.fetchImage(urlString: anime.imageUrlString) { data, error in
                if let data = data {
                    self.cellImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    private let cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(height: 175, width: 175)
        return iv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureCellUI() {
        addSubview(cellImageView)
        cellImageView.fillSuperView(inView: self)
    }
}
