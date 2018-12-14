//
//  JSSegmentControlStyle.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation

public enum TitleAndImagePosition: Int {
    case left        // 文字在左侧, 图片在右侧
    case top         // 文字在上侧, 图片在下侧
    case right       // 文字在右侧, 图片在左侧
    case bottom      // 文字在下侧, 图片在上侧
    case background  // 图片被设置为背景图片
}

public struct JSSegmentControlStyle {

    // MARK: JSTitleContainerStyle
    public struct JSTitleContainerStyle {
        
        /// 标题容器中文字的字体, 默认值为 UIFont.systemFont(ofSize: 14.0)
        public var containerFont: UIFont = UIFont.systemFont(ofSize: 14.0)
        
        /// 标题容器中文字的默认颜色, 默认值为 UIColor.clear
        public var containerTextColor: UIColor = UIColor.clear
        
        /// 标题容器中文字的高亮颜色, 默认值为 UIColor.clear
        public var containerHighlightedTextColor: UIColor = UIColor.clear
        
        /// 标题容器中 Badge 背景的默认颜色, 默认值为 UIColor.red
        public var badgeBackgroundColor: UIColor = UIColor.red
        
        /// 标题容器中 Badge 文字的字体, 默认值为 UIFont.boldSystemFont(ofSize: 10.0)
        public var badgeFont: UIFont = UIFont.boldSystemFont(ofSize: 10.0)
        
        /// 标题容器中 Badge 文字的默认颜色, 默认值为 UIColor.white
        public var badgeTextColor: UIColor = UIColor.white
        
        /// 标题容器中文字、图像位置, 默认值为 .left
        public var containerPosition: TitleAndImagePosition = .left
        
        /// 标题容器中固定间隔, 默认值为 4.0
        public var containerMargin: CGFloat = 4.0
    }
    
    // MARK: 公开属性
    public var titleContainerStyle: JSTitleContainerStyle = JSTitleContainerStyle()
    
    // MAKR: 初始化
    public init() {
        
    }
}
