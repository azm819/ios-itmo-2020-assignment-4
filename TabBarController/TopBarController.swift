import UIKit

fileprivate let TOP_BAR_INSET: CGFloat = 20

class TopBarController: UIViewController {
    let topBar: TopBar
    let viewControllers: [UIViewController]
    let scrollView: UIScrollView

    convenience init(_ viewControllers: UIViewController...) {
        self.init(viewControllers: viewControllers)
    }

    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        topBar = TopBar()
        scrollView = UIScrollView()
        super.init(nibName: nil, bundle: nil)
        view.addSubview(scrollView)
        view.addSubview(topBar)
        updateTopBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width * CGFloat(viewControllers.count), height: view.frame.height))
        for (index, viewController) in viewControllers.enumerated() {
            scrollView.addSubview(viewController.view)
            viewController.view.frame = view.frame
            viewController.view.frame.origin.x = CGFloat(index) * view.frame.width
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTopBar()
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

    // TODO: add orientation change receiver
}

extension TopBarController: TopBarDelegate {
    func changeScreen(to index: Int) {
        scrollView.contentOffset.x = CGFloat(index) * view.frame.width
    }
}
