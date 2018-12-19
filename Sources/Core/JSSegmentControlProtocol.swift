//
//  JSSegmentControlProtocol.swift
//  JSSegmentControl
//
//  Created by Max on 2018/12/14.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation

}

}

@objc public protocol JSTitleDataSource: NSObjectProtocol {
    @objc func numberOfTitles() -> Int
    @objc func title(_ title: JSTitleView, containerAt index: Int) -> JSTitleContainerView
}

    func content(_ content: JSContentView, didSelectAt index: Int)
    func content(_ content: JSContentView, didDeselectAt index: Int)
@objc public protocol JSTitleDelegate: NSObjectProtocol {
    @objc func title(_ title: JSTitleView, didSelectAt index: Int)
    @objc func title(_ title: JSTitleView, didDeselectAt index: Int)
}

@objc public protocol JSContentDataSource: NSObjectProtocol {
    @objc func numberOfContents() -> Int
    @objc func content(_ content: JSContentView, containerAt index: Int) -> UIViewController
}

@objc public protocol JSContentDelegate: NSObjectProtocol {
