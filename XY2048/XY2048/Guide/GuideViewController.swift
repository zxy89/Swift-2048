//
//  GuideViewController.swift
//  XY2048
//
//  Created by 张兴业 on 2017/3/27.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    
    //MARK:scrollView
    lazy var scrollView: UIScrollView = {
        
        let pages = 2
        
        var frame = self.view.frame
        
        var scroll = UIScrollView(frame: frame)
        
        scroll.contentSize = CGSize(width: frame.size.width*CGFloat(pages), height: frame.size.height)
        
        scroll.isPagingEnabled = true
        
        scroll.showsHorizontalScrollIndicator = false
        
        scroll.showsVerticalScrollIndicator = false
        
        scroll.scrollsToTop = false
        
        for k in 0..<pages {
            
            var imagefile = "welcome0\(Int(k+1))"
            
            var image = UIImage(named: imagefile)
            
            var imageView = UIImageView(image: image)
            
            imageView.frame = CGRect(x: frame.size.width*CGFloat(k), y: 0, width: frame.size.width, height: frame.size.height)
            
            if k == pages-1 {
                
                var start = UIButton(type: .custom)
                
                start.frame = CGRect(x: 0, y: 0, width: 120, height: 32)
                start.center = CGPoint(x: frame.size.width/2.0, y: frame.size.height*5.5/6.0)
                
                start.setTitle("开始体验", for: .normal)
                start.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                
                start.backgroundColor = UIColor.orange
                
                start.layer.cornerRadius = 5;
                start.layer.masksToBounds = true
                
                start.addTarget(self, action: #selector(startClick(_:)), for: .touchUpInside)
                
                imageView.isUserInteractionEnabled = true
                
                imageView.addSubview(start)
                
            }
            
            var pageControl: UIPageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
            pageControl.center = CGPoint(x: frame.size.width/2.0, y: frame.size.height*5.25/6.0)
            
            pageControl.numberOfPages = pages
            
            pageControl.currentPage = k
            
            //                pageControl.pageIndicatorTintColor = UIColor.red
            
            //                pageControl.currentPageIndicatorTintColor = UIColor.blue
            
            imageView.addSubview(pageControl)
            
            scroll.addSubview(imageView)
            
        }
        
        return scroll
    }()
    
    //MARK:开始体验事件
    func startClick(_ button: UIButton) -> Void {
        
        UserDefaults.standard.set(true, forKey: "FirstStartSign")
        UserDefaults.standard.set(0, forKey: "BestScore")
        UserDefaults.standard.synchronize()
        
        let mainTB = XYTabBarViewController()
        
        self.present(mainTB, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        creatScrollView()
 
        // Do any additional setup after loading the view.
    }

    //MARK:创建scrollView
    func creatScrollView() -> Void {
        
        self.view.addSubview(self.scrollView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
