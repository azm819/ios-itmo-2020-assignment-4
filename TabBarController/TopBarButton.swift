//
//  TopBarButton.swift
//  TabBarController
//
//  Created by Azamat on 17.10.2020.
//

import UIKit

fileprivate let PADDING_BETWEEN_IMAGE_AND_LABEL: CGFloat = 25
fileprivate let FONT_SIZE: CGFloat = 10
fileprivate let ANIMATION_DURATION: TimeInterval = 0.5
fileprivate let CIRCLE_VIEW_ALPHA: CGFloat = 0.3

class TopBarButton: UIButton {
    private let circleView: UIView
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: ANIMATION_DURATION, animations: {
                self.circleView.alpha = self.isSelected ? CIRCLE_VIEW_ALPHA : .zero
            })
        }
    }

    override var frame: CGRect {
        didSet {
            circleView.frame = CGRect(origin: .zero, size: frame.size)
            circleView.layer.cornerRadius = frame.width / 2
        }
    }

    init(image: UIImage, text: String) {
        circleView = UIView()
        super.init(frame: .zero)
        addSubview(circleView)
        circleView.backgroundColor = .black
        circleView.alpha = .zero

        setImage(image, for: .normal)
        setTitle(text, for: .normal)
        setTitleColor(.black, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupInsets() {
        titleLabel?.font = titleLabel?.font.withSize(FONT_SIZE)
        guard let imageViewSize = imageView?.frame.size, let _ = titleLabel?.frame.size else {
            return
        }

        imageEdgeInsets = UIEdgeInsets(
            top: .zero,
            left: (frame.width - imageViewSize.width) / 2,
            bottom: PADDING_BETWEEN_IMAGE_AND_LABEL,
            right: .zero
        )

        titleEdgeInsets = UIEdgeInsets(
            top: PADDING_BETWEEN_IMAGE_AND_LABEL,
            left: -imageViewSize.width,
            bottom: .zero,
            right: .zero
        )

        contentEdgeInsets = .zero
    }
}
