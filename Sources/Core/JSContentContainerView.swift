//
//  JSContentContainerView.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/18.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

public class JSContentContainerView: UICollectionViewCell {
    
    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupContainerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 设置方法
    private func setupContainerView() {
        self.contentView.backgroundColor = UIColor.white
    }
}
