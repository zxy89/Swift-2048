//
//  XYTabBarViewController.swift
//  XY2048
//
//  Created by 张兴业 on 2017/3/28.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit

class XYTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gameVC = GameViewController()
        gameVC.title = "游戏"
        gameVC.tabBarItem = UITabBarItem(title: "游戏", image: UIImage(named: "tab_game_un"), selectedImage: UIImage(named: "tab_game")?.withRenderingMode(.alwaysOriginal))
        let gameNB = UINavigationController(rootViewController: gameVC)
        
        
        let setterVC = SetterViewController.init(gameview: gameVC)
        setterVC.title = "设置"
        setterVC.tabBarItem = UITabBarItem(title: "设置", image: UIImage(named: "tab_setter_un"), selectedImage: UIImage(named: "tab_setter")?.withRenderingMode(.alwaysOriginal))
        let setterNB = UINavigationController(rootViewController: setterVC)
        
        
        self.viewControllers = [gameNB,setterNB]
        
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
