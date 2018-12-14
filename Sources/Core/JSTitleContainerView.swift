//
//  JSTitleContainerView.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public class JSTitleContainerView: UIView {

    // MARK: 属性
    public var segmentTitle: String? {
        willSet {
            self.segmentTitleLabel.text = newValue
        }
    }
    
    public var segmentImage: UIImage? {
        willSet {
            self.segmentImageView.image = newValue
        }
    }

    public var segmentHighlightedImage: UIImage? {
        willSet {
            self.segmentImageView.highlightedImage = newValue
        }
    }

    public var segmentBadge: Int = 0 {
        willSet {
            self.segmentBadgeLabel.text = newValue == 0 ? nil : "\(newValue)"
        }
    }
    
    public var isSelected: Bool = false {
        willSet {
            self.segmentTitleLabel.isHighlighted = newValue
            self.segmentImageView.isHighlighted = newValue
        }
    }

    private lazy var segmentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(imageView, at: 0)
        return imageView
    }()
    
    private lazy var segmentTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = self.style.containerFont
        label.textColor = self.style.containerTextColor
        label.textAlignment = .center
        label.highlightedTextColor = self.style.containerHighlightedTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(label, at: 1)
        return label
    }()
    
    private lazy var segmentBadgeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = self.style.badgeBackgroundColor
        label.font = self.style.badgeFont
        label.textColor = self.style.badgeTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(label, at: 2)
        return label
    }()

    private let style: JSSegmentControlStyle.JSTitleContainerStyle
    
    // MARK: 初始化
    public init(style: JSSegmentControlStyle.JSTitleContainerStyle) {
        self.style = style
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 重写父类方法
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.segmentBadgeLabel.layer.cornerRadius = self.segmentBadgeLabel.frame.size.height / 2.0
        self.segmentBadgeLabel.layer.masksToBounds = true
    }
    
    public override func updateConstraints() {
        // 移除现有约束
        self.removeConstraints(self.constraints)
        
        // 添加新约束
        switch self.style.containerPosition {
        case .left, .right:
            self.horizontalConstraints(withPosition: self.style.containerPosition)
        case .top, .bottom:
            self.verticalConstraints(withPosition: self.style.containerPosition)
        case .background:
            self.backgroundConstraints()
        }
        
        self.badgeConstraints()
        
        super.updateConstraints()
    }
    
    // MARK: 私有方法
    private func horizontalConstraints(withPosition position: TitleAndImagePosition) {
        let metrics: [String: Any] = ["margin": self.style.containerMargin]
        
        var centerConstraints = [NSLayoutConstraint]()
        centerConstraints.append(NSLayoutConstraint(item: self.segmentImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        centerConstraints.append(NSLayoutConstraint(item: self.segmentTitleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.addConstraints(centerConstraints)
        
        var sideConstraints = [NSLayoutConstraint]()
        
        switch position {
        case .left:
            sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==margin)-[imageView]-(==margin)-[label]-(==margin)-|", options: [], metrics: metrics, views: ["imageView": self.segmentImageView, "label": self.segmentTitleLabel])
        case .right:
            sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==margin)-[label]-(==margin)-[imageView]-(==margin)-|", options: [], metrics: metrics, views: ["imageView": self.segmentImageView, "label": self.segmentTitleLabel])
        default:
            break
        }
        
        sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(==margin)-[imageView]-(==margin)-|", options: [], metrics: metrics, views: ["imageView": self.segmentImageView])
        sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(==margin)-[label]-(==margin)-|", options: [], metrics: metrics, views: ["label": self.segmentTitleLabel])
        
        self.addConstraints(sideConstraints)
    }
    
    private func verticalConstraints(withPosition position: TitleAndImagePosition) {
        let metrics: [String: Any] = ["margin": self.style.containerMargin]
        
        var centerConstraints = [NSLayoutConstraint]()
        centerConstraints.append(NSLayoutConstraint(item: self.segmentImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        centerConstraints.append(NSLayoutConstraint(item: self.segmentTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraints(centerConstraints)
        
        var sideConstraints = [NSLayoutConstraint]()
        
        switch position {
        case .top:
            sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(==margin)-[imageView]-(==margin)-[label]-(==margin)-|", options: [], metrics: metrics, views: ["imageView": self.segmentImageView, "label": self.segmentTitleLabel])
        case .bottom:
            sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(==margin)-[label]-(==margin)-[imageView]-(==margin)-|", options: [], metrics: metrics, views: ["imageView": self.segmentImageView, "label": self.segmentTitleLabel])
        default:
            break
        }
        
        sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==margin)-[imageView]-(==margin)-|", options: [], metrics: metrics, views: ["imageView": self.segmentImageView])
        sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==margin)-[label]-(==margin)-|", options: [], metrics: metrics, views: ["label": self.segmentTitleLabel])
        
        self.addConstraints(sideConstraints)
    }
    
    private func backgroundConstraints() {
        let metrics: [String: Any] = ["margin": self.style.containerMargin]
        
        var centerConstraints = [NSLayoutConstraint]()
        centerConstraints.append(NSLayoutConstraint(item: self.segmentImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        centerConstraints.append(NSLayoutConstraint(item: self.segmentImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        centerConstraints.append(NSLayoutConstraint(item: self.segmentTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        centerConstraints.append(NSLayoutConstraint(item: self.segmentTitleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.addConstraints(centerConstraints)
        
        var sideConstraints = [NSLayoutConstraint]()
        sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==margin)-[imageView]-(==margin)-|", options: [], metrics: metrics, views: ["imageView": self.segmentImageView])
        sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(==margin)-[imageView]-(==margin)-|", options: [], metrics: metrics, views: ["imageView": self.segmentImageView])
        sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==margin)-[label]-(==margin)-|", options: [], metrics: metrics, views: ["label": self.segmentTitleLabel])
        sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(==margin)-[label]-(==margin)-|", options: [], metrics: metrics, views: ["label": self.segmentTitleLabel])
        self.addConstraints(sideConstraints)
    }
    
    private func badgeConstraints() {
        var centerConstraints = [NSLayoutConstraint]()
        centerConstraints.append(NSLayoutConstraint(item: self.segmentBadgeLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0))
        centerConstraints.append(NSLayoutConstraint(item: self.segmentBadgeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraints(centerConstraints)
    }
}
