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
    
    // MARK: 公开方法
    public func reloadData() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.containerViews.removeAll()
        
        self.setupSubviews()
        self.setNeedsUpdateConstraints()
        
        self.selectedIndexAnimated(fromOldIndex: self.currentIndex, toCurrentIndex: 0)
    }
    
    public func selectedIndex(_ index: Int) {
        guard index >= 0 && index < self.dataSourceCount else {
            fatalError("设置的下标不合法")
        }
        self.selectedIndexAnimated(fromOldIndex: self.currentIndex, toCurrentIndex: index)
    }
    
    public func selectedIndexAnimated(withProgress progress: CGFloat, fromOldIndex oldIndex: Int, toCurrentIndex currentIndex: Int) {
        guard oldIndex >= 0 && oldIndex < self.dataSourceCount else {
            return
        }
        guard currentIndex >= 0 && currentIndex < self.dataSourceCount else {
            return
        }
        
        let oldContainerView = self.containerViews[oldIndex]
        let currentContainerView = self.containerViews[currentIndex]
        
        let xDistance = currentContainerView.frame.minX - oldContainerView.frame.minX
        let widthDistance = currentContainerView.frame.width - oldContainerView.frame.width
        
        if self.style.titleStyle.isShowLines {
            self.titleLine.frame.origin.x = oldContainerView.frame.minX + xDistance * progress
            self.titleLine.frame.size.width = oldContainerView.frame.width + widthDistance * progress
        }
        if self.style.titleStyle.isShowMasks {
            self.titleMask.frame.origin.x = oldContainerView.frame.minX + xDistance * progress
            self.titleMask.frame.size.width = oldContainerView.frame.width + widthDistance * progress
        }
        if self.style.titleStyle.isTitleScale {
            let scaleDistance = self.style.titleStyle.maxTitleScale - 1.0
            oldContainerView.scale = self.style.titleStyle.maxTitleScale - scaleDistance * progress
            currentContainerView.scale = 1.0 + scaleDistance * progress
        }
    }
    
    public func selectedIndexScrollAnimated(toCurrentIndex currentIndex: Int) {
        let margin = self.style.titleStyle.containerMargin
        
        if self.contentSize.width != self.bounds.width + margin {
            let currentContainerView = self.containerViews[currentIndex]
            var offSetX = currentContainerView.center.x - self.bounds.width * 0.5
            if offSetX < 0.0 {
                offSetX = 0.0
            }
            var maxOffSetX = self.contentSize.width - self.bounds.width
            if maxOffSetX < 0.0 {
                maxOffSetX = 0.0
            }
            if offSetX > maxOffSetX {
                offSetX = maxOffSetX
            }
            self.setContentOffset(CGPoint(x: offSetX, y: 0.0), animated: true)
        }
        
        self.titleDelegate?.title(self, didSelectAt: currentIndex)
        self.titleDelegate?.title(self, didDeselectAt: self.currentIndex)
        
        self.currentIndex = currentIndex
    }
    
    // MARK: 重写父类方法
    public override func updateConstraints() {
        super.updateConstraints()
        self.makeConstraints()
        self.setupCurrentSelectScale()
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
            self.insertSubview(self.titleMask, at: 0)
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
    
    private func setupCurrentSelectScale() {
        let currentContainer = self.containerViews[self.currentIndex]
        if self.style.titleStyle.isTitleScale {
            currentContainer.scale = self.style.titleStyle.maxTitleScale
        }
    }
    
    private func setupScrollContentSize() {
        let margin = self.style.titleStyle.containerMargin
        
        if self.style.titleStyle.isTitleScroll {
            if let lastContainerView = self.containerViews.last {
                self.contentSize = CGSize(width: lastContainerView.frame.maxX + margin, height: 0.0)
            }
        }
    }
    
    // MARK: 私有方法
    private func makeConstraints() {
        self.makeTitleContainerConstraints()
        self.makeTitleLineAndMaskConstraints()
        self.setupScrollContentSize()
    }
    
    private func makeTitleLineAndMaskConstraints() {
        let lineHeight = self.style.titleStyle.lineHeight
        let maskHeight = self.style.titleStyle.maskHeight
        
        let currentContainer = self.containerViews[self.currentIndex]
        
        if self.style.titleStyle.isShowLines {
            self.titleLine.frame.origin.y = currentContainer.frame.maxY
            self.titleLine.frame.size = CGSize(width: currentContainer.bounds.width, height: lineHeight)
            self.titleLine.center.x = currentContainer.center.x
        }
        
        if self.style.titleStyle.isShowMasks {
            self.titleMask.frame.size = CGSize(width: currentContainer.bounds.width, height: maskHeight)
            self.titleMask.center = currentContainer.center
        }
    }
    
    private func makeTitleContainerConstraints() {
        // TitleView 禁止滚动, Container 宽度平分
        if !self.style.titleStyle.isTitleScroll {
            var containerX: CGFloat = 0.0
            let containerY: CGFloat = 0.0
            let containerWidth: CGFloat = self.bounds.width / CGFloat(self.dataSourceCount)
            let containerHeight: CGFloat = self.bounds.height - self.style.titleStyle.lineHeight
            for index in 0..<self.dataSourceCount {
                containerX = CGFloat(index) * containerWidth
                self.containerViews[index].frame = CGRect(x: containerX, y: containerY, width: containerWidth, height: containerHeight)
            }
        }
        else {
            let margin = self.style.titleStyle.containerMargin
            var oldIndex: Int = 0
            for index in 0..<self.dataSourceCount {
                let currentContainer = self.containerViews[index]
                let oldContainer = self.containerViews[oldIndex]
                
                currentContainer.frame.origin.x = index == 0 ? margin : oldContainer.frame.maxX + margin
                currentContainer.frame.size = self.style.titleStyle.containerSize != .zero ?self.style.titleStyle.containerSize : currentContainer.containerSize
                currentContainer.center.y = self.bounds.height / 2.0
                
                oldIndex = index
            }
        }
    }
    
    private func selectedIndexAnimated(fromOldIndex oldIndex: Int, toCurrentIndex currentIndex: Int) {
        guard oldIndex != currentIndex else {
            return
        }
        
        let oldContainerView = (oldIndex < 0 || oldIndex >= self.dataSourceCount) ? nil : self.containerViews[oldIndex]
        let currentContainerView = self.containerViews[currentIndex]
        
        UIView.animate(withDuration: 0.3, animations: {
            oldContainerView?.isSelected = false
            currentContainerView.isSelected = true
            if self.style.titleStyle.isTitleScale {
                oldContainerView?.scale = 1.0
                currentContainerView.scale = self.style.titleStyle.maxTitleScale
            }
            if self.style.titleStyle.isShowLines {
                self.titleLine.frame.size.width = currentContainerView.bounds.width
                self.titleLine.center.x = currentContainerView.center.x
            }
            if self.style.titleStyle.isShowMasks {
                self.titleMask.frame.size.width = currentContainerView.bounds.width
                self.titleMask.center.x = currentContainerView.center.x
            }
        }, completion: { (_) in
            self.selectedIndexScrollAnimated(toCurrentIndex: currentIndex)
        })
    }
    
    // MARK: Tap Gesture Action
    @objc private func containerViewPressed(_ tapGesture: UITapGestureRecognizer) {
        guard let selectContainer = tapGesture.view as? JSTitleContainerView else {
            fatalError("请检查 tapGesture 所属的 View")
        }
        self.selectedIndexAnimated(fromOldIndex: self.currentIndex, toCurrentIndex: selectContainer.tag)
    }
}
