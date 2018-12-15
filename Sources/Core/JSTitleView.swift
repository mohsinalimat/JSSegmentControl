//
//  JSTitleView.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public class JSTitleView: UIScrollView {

    // MARK: 属性
    public weak var titleDataSource: JSTitleDataSource?
    public weak var titleDelegate: JSTitleDelegate?

    private lazy var titleLine: UIView = {
        let view = UIView()
        view.backgroundColor = self.style.titleStyle.lineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleMask: UIView = {
        let view = UIView()
        view.backgroundColor = self.style.titleStyle.maskColor
        view.layer.cornerRadius = self.style.titleStyle.maskCornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var currentIndex: Int = 0

    private var containerViews: [JSTitleContainerView] = [JSTitleContainerView]()
    
    private var dataSourceCount: Int {
        get {
            guard let titleDataSource = self.titleDataSource else {
                fatalError("请实现 JSTitleDataSource 协议")
            }
            return titleDataSource.numberOfTitles()
        }
    }
    
    public let style: JSSegmentControlStyle

    // MARK: 初始化
    public init(frame: CGRect, segmentStyle style: JSSegmentControlStyle) {
        self.style = style
        super.init(frame: frame)
        self.setupScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 重写父类方法
    public override func updateConstraints() {
        super.updateConstraints()
        self.makeConstraints()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setupSubviews()
        self.setupCurrentSelect()
    }
    
    // MARK: 设置方法
    private func setupScrollView() {
        self.bounces = self.style.titleStyle.isTitleBounces
        self.isScrollEnabled = self.style.titleStyle.isTitleScroll
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollsToTop = false
    }

    private func setupSubviews() {
        self.setupTitleContainer()
        self.setupTitleLineAndMask()
    }
    
    private func setupTitleLineAndMask() {
        if self.style.titleStyle.isShowLines {
            self.addSubview(self.titleLine)
        }
        if self.style.titleStyle.isShowMasks {
            self.addSubview(self.titleMask)
        }
    }
    
    private func setupTitleContainer() {
        for index in 0..<self.dataSourceCount {
            guard let containerView = self.titleDataSource?.title(self, containerAt: index) else {
                fatalError("请实现 JSTitleDataSource 协议")
            }
            containerView.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerViewPressed(_:)))
            containerView.addGestureRecognizer(tapGesture)
            self.containerViews.append(containerView)
            self.addSubview(containerView)
        }
    }
    
    private func setupCurrentSelect() {
        let currentContainer = self.containerViews[self.currentIndex]
        currentContainer.isSelected = true
        self.titleDelegate?.title(self, didSelectAt: self.currentIndex)
    }
    
    // MARK: 私有方法
    private func makeConstraints() {
        // 移除现有约束
        self.removeConstraints(self.constraints)

        self.makeTitleContainerConstraints()
        self.makeTitleLineAndMaskConstraints()
    }
    
    private func makeTitleLineAndMaskConstraints() {
        let currentContainer = self.containerViews[self.currentIndex]
        
        if self.style.titleStyle.isShowLines {
            let metrics = ["lineHeight": self.style.titleStyle.lineHeight]
            
            let centerConstraint = NSLayoutConstraint(item: self.titleLine, attribute: .centerX, relatedBy: .equal, toItem: currentContainer, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            self.addConstraint(centerConstraint)

            var sideConstraints = [NSLayoutConstraint]()
            sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[currentContainer]-0-[titleLine]", options: [], metrics: nil, views: ["currentContainer": currentContainer, "titleLine": self.titleLine])
            self.addConstraints(sideConstraints)
            
            var sizeConstraints = [NSLayoutConstraint]()
            sizeConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[titleLine(==currentContainer)]", options: [], metrics: nil, views: ["currentContainer": currentContainer, "titleLine": self.titleLine])
            sizeConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLine(==lineHeight)]", options: [], metrics: metrics, views: ["titleLine": self.titleLine])
            self.addConstraints(sizeConstraints)
        }
        
        if self.style.titleStyle.isShowMasks {
            let metrics = ["maskHeight": self.style.titleStyle.maskHeight]
            
            var centerConstraints = [NSLayoutConstraint]()
            centerConstraints.append(NSLayoutConstraint(item: self.titleMask, attribute: .centerX, relatedBy: .equal, toItem: currentContainer, attribute: .centerX, multiplier: 1.0, constant: 0.0))
            centerConstraints.append(NSLayoutConstraint(item: self.titleMask, attribute: .centerY, relatedBy: .equal, toItem: currentContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0))
            self.addConstraints(centerConstraints)
            
            var sizeConstraints = [NSLayoutConstraint]()
            sizeConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[titleMask(==currentContainer)]", options: [], metrics: nil, views: ["currentContainer": currentContainer, "titleMask": self.titleMask])
            sizeConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[titleMask(==maskHeight)]", options: [], metrics: metrics, views: ["titleMask": self.titleMask])
            self.addConstraints(sizeConstraints)
        }
    }
    
    private func makeTitleContainerConstraints() {
        // TitleView 禁止滚动, Container 宽度平分
        if !self.style.titleStyle.isTitleScroll {
            let metrics: [String: Any] = ["containerWidth": self.bounds.width / CGFloat(self.dataSourceCount), "containerHeight": self.bounds.height - self.style.titleStyle.lineHeight]
            var oldIndex: Int = 0
            for index in 0..<self.dataSourceCount {
                let currentContainer = self.containerViews[index]
                let oldContainer = self.containerViews[oldIndex]

                var sideConstraints = [NSLayoutConstraint]()
                sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:\(index == 0 ? "|" : "[oldContainer]")-0-[currentContainer]", options: [], metrics: nil, views: ["oldContainer": oldContainer, "currentContainer": currentContainer])
                sideConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[currentContainer]", options: [], metrics: nil, views: ["oldContainer": oldContainer, "currentContainer": currentContainer])
                self.addConstraints(sideConstraints)
                
                var sizeConstraints = [NSLayoutConstraint]()
                sizeConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[currentContainer(containerWidth)]", options: [], metrics: metrics, views: ["currentContainer": currentContainer])
                sizeConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[currentContainer(containerHeight)]", options: [], metrics: metrics, views: ["currentContainer": currentContainer])
                self.addConstraints(sizeConstraints)
                
                oldIndex = index
            }
        }
        else {
            let metrics: [String: Any] = ["margin": self.style.titleStyle.containerMargin, "containerWidth": self.style.titleStyle.containerSize.width, "containerHeight": self.style.titleStyle.containerSize.height]
            var oldIndex: Int = 0
            for index in 0..<self.dataSourceCount {
                let currentContainer = self.containerViews[index]
                let oldContainer = self.containerViews[oldIndex]
                
                let centerConstraint = NSLayoutConstraint(item: currentContainer, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
                self.addConstraint(centerConstraint)

                let sideConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:\(index == 0 ? "|" : "[oldContainer]")-(==margin)-[currentContainer]\(index == self.dataSourceCount - 1 ? "-(==margin)-|" : "")", options: [], metrics: metrics, views: ["oldContainer": oldContainer, "currentContainer": currentContainer])
                self.addConstraints(sideConstraints)

                if self.style.titleStyle.containerSize != .zero {
                    var sizeConstraints = [NSLayoutConstraint]()
                    sizeConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[currentContainer(containerWidth)]", options: [], metrics: metrics, views: ["currentContainer": currentContainer])
                    sizeConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[currentContainer(containerHeight)]", options: [], metrics: metrics, views: ["currentContainer": currentContainer])
                    self.addConstraints(sizeConstraints)
                }
                
                oldIndex = index
            }
        }
    }
    
    // MARK: Tap Gesture Action
    @objc private func containerViewPressed(_ tapGesture: UITapGestureRecognizer) {
        guard let selectContainer = tapGesture.view as? JSTitleContainerView else {
            fatalError("请检查 tapGesture 所属的 View")
        }
        print("选中了: \(selectContainer.tag) ")
    }
}
