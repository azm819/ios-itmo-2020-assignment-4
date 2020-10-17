//
//  TopBar.swift
//  TabBarController
//
//  Created by Azamat on 17.10.2020.
//

import UIKit

fileprivate let TOP_BAR_CORNER_RADIUS: CGFloat = 20
fileprivate let TOP_BAR_ALPHA: CGFloat = 0.5

protocol TopBarDelegate {
    func changeScreen(to index: Int)
}

class TopBar: UIView {
    var delegate: TopBarDelegate?

    private var buttons = [TopBarButton]()
    private var lastSelectedButton: TopBarButton? {
        willSet {
            lastSelectedButton?.isSelected.toggle()
        }
        didSet {
            lastSelectedButton?.isSelected.toggle()
            if let lastSelectedButton = lastSelectedButton {
                delegate?.changeScreen(to: lastSelectedButton.tag)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        alpha = TOP_BAR_ALPHA
        layer.cornerRadius = TOP_BAR_CORNER_RADIUS
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func recountFrame(width: CGFloat, topBarItems items: [TopBarItem]) {
        buttons.forEach({ $0.removeFromSuperview() })
        buttons.removeAll()
        guard items.count != .zero else {
            return
        }

        let buttonSideSize = (width - TOP_BAR_CORNER_RADIUS * 2) / CGFloat(items.count)
        frame.size = CGSize(width: width, height: buttonSideSize)
        for (index, item) in items.enumerated() {
            let topBarButton = TopBarButton(image: item.icon, text: item.title)
            topBarButton.frame = CGRect(x: CGFloat(index) * buttonSideSize + TOP_BAR_CORNER_RADIUS,
                                        y: .zero,
                                        width: buttonSideSize,
                                        height: buttonSideSize)
            topBarButton.setupInsets()
            addSubview(topBarButton)
            topBarButton.tag = index
            topBarButton.addTarget(self, action: #selector(touchUpButton), for: .touchUpInside)
            topBarButton.isSelected = false
            buttons.append(topBarButton)
        }
        lastSelectedButton = buttons.first
    }

    @objc func touchUpButton(button: TopBarButton) {
        lastSelectedButton = button
    }
}
