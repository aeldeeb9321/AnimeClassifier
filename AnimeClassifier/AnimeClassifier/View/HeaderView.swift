//
//  HeaderView.swift
//  AnimeClassifier
//
//  Created by Ali Eldeeb on 1/21/23.
//

import UIKit

class HeaderView: UICollectionReusableView {
    //MARK: - Properties
    var headerOption: HeaderOptions? {
        didSet {
            guard let headerOption = headerOption else { return }
            self.headerTitleLabel.text = headerOption.description
        }
    }
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel().headerTextLabel()
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureViewUI() {
        addSubview(headerTitleLabel)
        headerTitleLabel.centerY(inView: self)
        headerTitleLabel.anchor(leading: safeAreaLayoutGuide.leadingAnchor, paddingLeading: 12)
    }
}
