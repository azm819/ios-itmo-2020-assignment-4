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
                let changeCircleView: (CGFloat, CGPoint, CGSize, CGFloat) -> Void = {
                    (alpha: CGFloat,
                     origin: CGPoint,
                     size: CGSize,
                     radius: CGFloat) -> Void in
                    self.circleView.alpha = alpha
                    self.circleView.frame.origin = origin
                    self.circleView.frame.size = size
                    self.circleView.layer.cornerRadius = radius
                }

                let halfWidth = self.frame.width / 2
                if self.isSelected {
                    changeCircleView(CIRCLE_VIEW_ALPHA,
                                     .zero,
                                     self.frame.size,
                                     halfWidth)
                }
                else {
                    changeCircleView(.zero,
                                     CGPoint(x: halfWidth, y: halfWidth),
                                     .zero,
                                     .zero)
                }
            })
        }
    }

    override var frame: CGRect {
        didSet {
            circleView.center = center
            setupInsets()
        }
    }

    init(image: UIImage, text: String) {
        circleView = UIView()
        circleView.backgroundColor = .black
        super.init(frame: .zero)
        addSubview(circleView)

        setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        setTitle(text, for: .normal)
        setTitleColor(.black, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInsets() {
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
