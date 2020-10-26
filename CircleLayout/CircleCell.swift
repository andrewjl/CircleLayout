//
//  CircleCell.swift
//  CircleLayout
//
//  Created by Andrew Lauer Barinov on 10/26/20.
//  Copyright © 2020 Elysian Fields. All rights reserved.
//

import UIKit

class CircleCell: UICollectionViewCell {
    static let reuseIdentifier = "CircleCellReuseIdentifier"

    var color: UIColor = .systemRed {
        didSet {
            self.updateImageView()
        }
    }
    
    var radius: CGFloat {
        didSet {
            let format = UIGraphicsImageRendererFormat()
            self.renderer = UIGraphicsImageRenderer(size: CGSize(width: self.radius + 8,
                                                                 height: self.radius + 8),
                                                    format: format)
            self.updateImageView()
        }
    }
    
    var imageView: UIImageView
    var renderer: UIGraphicsImageRenderer
    
    override init(frame: CGRect) {
        self.imageView = UIImageView()
        self.imageView.contentMode = .center
        let format = UIGraphicsImageRendererFormat()
        self.radius = 40.0
        self.renderer = UIGraphicsImageRenderer(size: CGSize(width: self.radius, height: self.radius),
                                                format: format)
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        self.imageView = UIImageView()
        self.imageView.contentMode = .center
        let format = UIGraphicsImageRendererFormat()
        self.radius = 40.0
        self.renderer = UIGraphicsImageRenderer(size: CGSize(width: self.radius, height: self.radius),
                                                format: format)
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageView)
        
        self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        
        self.layer.speed = 0.5
    }
    
    func updateImageView() {
        let borderWidth: CGFloat = 4.0
        let adjustedRadius = self.radius - borderWidth
        self.imageView.image = self.renderer.image(actions: circleRenderer(fillColor: self.color,
                                                                           radius: adjustedRadius,
                                                                           borderWidth: borderWidth))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateImageView()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.radius = layoutAttributes.size.height * 0.9
    }
}
