//
//  EKButtonView.swift
//  SwiftEntryKit
//
//  Created by Daniel Huri on 12/8/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

final class EKButtonView: UIView {

    // MARK: - Properties
    
    private let button = UIButton()
    private let titleLabel = UILabel()
    //private let imageView = UIImageView.init()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer.init()
        layer.startPoint = .init(x: 0, y: 0)
        layer.endPoint = .init(x: 0, y: 1)
        return layer
    }()
    
    private let content: EKProperty.ButtonContent
    
    // MARK: - Setup
    
    init(content: EKProperty.ButtonContent) {
        self.content = content
        super.init(frame: .zero)
        self.layer.masksToBounds = true
        self.layer.addSublayer(self.gradientLayer)
        //setupImageView()
        setupTitleLabel()
        setupButton()
        setupAcceessibility()
        setupInterfaceStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAcceessibility() {
        isAccessibilityElement = false
        button.isAccessibilityElement = true
        button.accessibilityIdentifier = content.accessibilityIdentifier
        button.accessibilityLabel = content.label.text
    }
    
    private func setupButton() {
        addSubview(button)
        button.fillSuperview()
        button.addTarget(self, action: #selector(buttonTouchUp),
                         for: [.touchUpInside, .touchUpOutside, .touchCancel])
        button.addTarget(self, action: #selector(buttonTouchDown),
                         for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUpInside),
                         for: .touchUpInside)
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = content.label.style.numberOfLines
        titleLabel.font = content.label.style.font
        titleLabel.text = content.label.text
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        addSubview(titleLabel)
        titleLabel.layoutToSuperview(axis: .horizontally,
                                     offset: content.contentEdgeInset)
        titleLabel.layoutToSuperview(axis: .vertically,
                                     offset: content.contentEdgeInset)
    }
    
//    private func setupImageView() {
//        imageView.layer.masksToBounds = true
//        imageView.layer.addSublayer(self.gradientLayer)
//        addSubview(imageView)
//        imageView.fillSuperview()
//    }
    
    private func setBackground(by content: EKProperty.ButtonContent,
                               isHighlighted: Bool) {
        if let gradient = content.gradient {
            self.gradientLayer.colors = gradient.colors.map { $0.light.cgColor }
            self.setNeedsLayout()
            return
        }
        if isHighlighted {
            backgroundColor = content.highlightedBackgroundColor(for: traitCollection)
        } else {
            backgroundColor = content.backgroundColor(for: traitCollection)
        }
    }
    
    private func setupInterfaceStyle() {
        backgroundColor = content.backgroundColor(for: traitCollection)
        titleLabel.textColor = content.label.style.color(for: traitCollection)
        // imageView.image = content.backgroundImage
        if let gradient = content.gradient {
            self.gradientLayer.colors = gradient.colors.map { $0.light.cgColor }
            self.setNeedsLayout()
            return
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //imageView.layer.cornerRadius = imageView.bounds.size.height / 2.0
        self.layer.cornerRadius = self.bounds.size.height / 2.0
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradientLayer.frame = self.layer.bounds
    }
    
    // MARK: - Selectors
    
    @objc func buttonTouchUpInside() {
        content.action?()
    }
    
    @objc func buttonTouchDown() {
        setBackground(by: content, isHighlighted: true)
    }
    
    @objc func buttonTouchUp() {
        setBackground(by: content, isHighlighted: false)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupInterfaceStyle()
    }
}
