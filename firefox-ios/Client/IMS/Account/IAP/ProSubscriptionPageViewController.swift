// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


import UIKit

class ProSubscriptionPageViewController: UIPageViewController {
    private var pages: [UIViewController] = []
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                 navigationOrientation: UIPageViewController.NavigationOrientation,
                 options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll,
                  navigationOrientation: .horizontal,
                  options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        
        if let firstPage = pages.first {
            setViewControllers([firstPage],
                             direction: .forward,
                             animated: true)
        }
        
        // Set delegate to handle swipe gestures
        dataSource = self
    }
    
    private func setupPages() {
        let monthVC = ProMonthSubscriptionViewController()
        let yearVC = ProYearSubscriptionViewController()
        pages = [monthVC, yearVC]
    }
}

// MARK: - UIPageViewControllerDataSource
extension ProSubscriptionPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < pages.count else { return nil }
        return pages[nextIndex]
    }
}