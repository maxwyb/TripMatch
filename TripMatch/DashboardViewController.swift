//
//  DashboardViewController.swift
//  TripMatch
//
//  Created by Huyanh Hoang on 2017. 2. 18..
//  Copyright © 2017년 Yingbo Wang. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dashHeaderViewController = segue.destination as? DashHeaderViewController {
            dashHeaderViewController.dashboardDelegate = self
        }
    }

}

extension DashboardViewController: DashHeaderViewControllerDelegate {
    
    func dashHeaderViewController(_ controller: DashHeaderViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    
    func dashHeaderViewController(_ controller: DashHeaderViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}
