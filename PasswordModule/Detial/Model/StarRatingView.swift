//
//  StarRatingView.swift
//  PassLock
//
//  Created by Melo on 2024/5/31.
//

import Foundation
import SnapKit

class StarRatingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        self.addSubview(stackView)
    }
    
    private func preSetupContains() {
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
        }
    }
    
    private func preSetupHandleBuness() {
        for _ in 0..<starCount {
            let imageView = UIImageView(image: Reasource.systemNamed("star", color: starColor))
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
            stars.append(imageView)
        }
        
    }
    
    func setRating(_ rating: Int) {
        for (index, imageView) in stars.enumerated() {
            if index < rating {
                imageView.image = Reasource.systemNamed("star.fill", color: starColor)
            } else {
                imageView.image = Reasource.systemNamed("star", color: starColor)
            }
        }
    }
    
    // MARK:  GET && SET
    private let starCount = 5
    private var stars = [UIImageView]()
    private let starColor = UIColor.hexColor("#FFA500")
    
    // MARK:  Lazy init
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.distribution = .fillEqually
        view.spacing = 1.ckValue()
        return view
    }()
    
}
