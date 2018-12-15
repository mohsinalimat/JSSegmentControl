//
//  JSSegmentControlProtocol.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation

public protocol JSTitleDataSource: NSObjectProtocol {
    func numberOfTitles() -> Int
    func title(_ title: JSTitleView, containerAt index: Int) -> JSTitleContainerView
}

public protocol JSTitleDelegate: NSObjectProtocol {
    func title(_ title: JSTitleView, didSelectAt index: Int)
    func title(_ title: JSTitleView, didDeselectAt index: Int)
}
