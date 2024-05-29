import UIKit


final class OnboardingPageViewController: UIPageViewController {

    private let pagesText: [(String, String)] = [
        ("Добро пожаловать в наше приложение!", "Здесь вы найдете интересные и познавательные подкасты по различным темам."),
        ("Удобное прослушивание", "Свайпайте вправо и влево, чтобы листать ленту подкастов. Включите автопереход, чтобы не отвлекаться на переключение подкаста. "),
        ("Создайте свои подкасты", "Загрузите свои аудиофайлы или запишите подкаст в приложении. Наше приложение поможет вам его распространить"),
        ("Лайк и подписка", "Поставьте лайк подкастам, которые вам понравились, и следите за авторами, чтобы всегда быть в курсе их новых выпусков.")
    ]

    private lazy var pages: [OnboardingViewController] = {
        pagesText.map({ OnboardingViewController(text: $0) })
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray

        return pageControl
    }()

    private lazy var button: BaseButtonView = {
        let button = BaseButtonView()
        button.config(text: "Закрыть", backgroundColor: UIColor(named: "ProfileButtonBackgorund") ?? .blue)
        return button
    }()

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension OnboardingPageViewController {

    func setup() {
        setupPageViewController()
        addSubviews()
        activateConstraints()
        setupActions()
    }

    func setupPageViewController() {
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        delegate = self
        dataSource = self
    }

    func addSubviews() {
        [button,
         pageControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    func activateConstraints() {
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

    func setupActions() {
        button.addTarget(self, action: #selector(Self.didTapFinishButton), for: .touchUpInside)
    }

    @objc
    func didTapFinishButton() {
        UserDefaultsHelper.shared.setBool(true, forKey: "onboarding")
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first as? OnboardingViewController,
           let currentIndex = pages.firstIndex(of: currentViewController) {
                pageControl.currentPage = currentIndex
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingViewController,
              let viewControllerIndex = pages.firstIndex(of: vc) else {
           return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
           return nil
        }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingViewController,
              let viewControllerIndex = pages.firstIndex(of: vc) else {
           return nil
        }


        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else {
            return nil
        }

        return pages[nextIndex]
    }
}
