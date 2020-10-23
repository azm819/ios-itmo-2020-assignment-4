import UIKit

fileprivate let TOP_BAR_INSET: CGFloat = 20

protocol TopBarControllerDelegate: class {
    func wasSelectController(byIndex: Int)
    func selectedControllerIndex() -> Int
}

class TopBarController: UIViewController {
    let topBar: TopBar
    let viewControllers: [UIViewController]
    let scrollView: UIScrollView

    private let delegate: TopBarControllerDelegate
    private var didScrollByController = false

    convenience init(_ viewControllers: UIViewController...) {
        self.init(viewControllers: viewControllers)
    }

    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        topBar = TopBar()
        delegate = topBar
        scrollView = UIScrollView()
        super.init(nibName: nil, bundle: nil)
        view.addSubview(scrollView)
        view.addSubview(topBar)
        updateTopBar()

        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTopBar()
        updateScrollView()
    }

    private func updateScrollView() {
        scrollView.frame = view.frame
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(viewControllers.count), height: view.frame.height)
        for (index, viewController) in viewControllers.enumerated() {
            scrollView.addSubview(viewController.view)
            viewController.view.frame = view.frame
            viewController.view.frame.origin.x = CGFloat(index) * view.frame.width
        }
    }

    private func updateTopBar() {
        let items: [TopBarItem] = viewControllers.reduce([], { result, viewController in
            if let item = viewController.topBarItem {
                return result + [item]
            }
            else {
                return result
            }
        })
        topBar.recountFrame(width: UIScreen.main.bounds.width - TOP_BAR_INSET * 2, topBarItems: items)
        topBar.frame.origin = CGPoint(x: TOP_BAR_INSET, y: view.safeAreaInsets.top + TOP_BAR_INSET)
        topBar.delegate = self
    }

    private func updateSelectedView(byIndex index: Int, animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(index) * view.frame.width, y: .zero), animated: animated)
    }
}

extension TopBarController: TopBarDelegate {
    func changeScreen(to index: Int) {
        didScrollByController = true
        updateSelectedView(byIndex: index, animated: false)
    }
}

extension TopBarController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !didScrollByController else {
            didScrollByController = false
            return
        }
        let controllerIndex: Int = Int(scrollView.contentOffset.x / view.frame.width + 0.5)
        delegate.wasSelectController(byIndex: controllerIndex)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateSelectedView(byIndex: delegate.selectedControllerIndex(), animated: true)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        updateSelectedView(byIndex: delegate.selectedControllerIndex(), animated: true)
    }
}
