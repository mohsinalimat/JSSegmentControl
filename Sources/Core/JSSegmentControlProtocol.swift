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

public protocol JSContentDataSource: NSObjectProtocol {
    func numberOfContents() -> Int
    func content(_ content: JSContentView, containerAt index: Int) -> UIViewController
}

public protocol JSContentDelegate: NSObjectProtocol {
    func content(_ content: JSContentView, didSelectAt index: Int)
    func content(_ content: JSContentView, didDeselectAt index: Int)
}
