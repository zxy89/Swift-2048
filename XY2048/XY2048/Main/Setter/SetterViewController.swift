//
//  SetterViewController.swift
//  XY2048
//
//  Created by 张兴业 on 2017/3/28.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit

class SetterViewController: BaseViewController,UITextFieldDelegate {
    
    var gameview = GameViewController()
    
    init(gameview:GameViewController) {
        self.gameview = gameview
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var max_value: UITextField = {
       
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.black
        textField.text = "2048"
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.keyboardType = UIKeyboardType.numberPad
        textField.delegate = self
        
        return textField
        
    }()
    
    lazy var dimension: UISegmentedControl = {
       
        let segment = UISegmentedControl(items: ["3x3","4x4","5x5"])
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(segmentValueDidChange(_:)), for: .valueChanged)
        
        return segment
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        creatMaxGameValue()
        
        creatDimensionSegment()
        
    }
    //MARK: 创建游戏阈值
    func creatMaxGameValue() -> Void {
        
        let max_mark: UILabel = {
           
            let lable = UILabel()
            lable.text = "阈值:"
            lable.font = UIFont.systemFont(ofSize: 14)
            lable.textColor = UIColor.black
            lable.textAlignment = NSTextAlignment.center
            
            return lable
            
        }()
        
        self.view.addSubview(max_mark)
        max_mark.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.view.snp.left).inset(12)
            make.top.equalTo(self.view.snp.top).inset(76)
            make.size.equalTo(CGSize(width: 40, height: 32))
            
        }
        
        self.view.addSubview(max_value)
        max_value.snp.makeConstraints { (make) in
            
            make.left.equalTo(max_mark.snp.right).inset(-8)
            make.right.equalTo(self.view.snp.right).inset(24)
            make.centerY.equalTo(max_mark.snp.centerY)
            make.height.equalTo(max_mark.snp.height)
            
        }
        
        
    }
    
    //MARK: 创建游戏维度
    func creatDimensionSegment() -> Void {
        
        let dimension_mark: UILabel = {
            
            let lable = UILabel()
            lable.text = "维度:"
            lable.font = UIFont.systemFont(ofSize: 14)
            lable.textColor = UIColor.black
            lable.textAlignment = NSTextAlignment.center
            
            return lable
            
        }()
        
        self.view.addSubview(dimension_mark)
        dimension_mark.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.view.snp.left).inset(12)
            make.top.equalTo(max_value.snp.bottom).inset(-12)
            make.size.equalTo(CGSize(width: 40, height: 32))
            
        }
        
        self.view.addSubview(dimension)
        dimension.snp.makeConstraints { (make) in
            
            make.left.equalTo(dimension_mark.snp.right).inset(-8)
            make.right.equalTo(self.view.snp.right).inset(24)
            make.height.equalTo(dimension_mark.snp.height)
            make.centerY.equalTo(dimension_mark.snp.centerY)
            
        }
        
    }
    
    //MARK: segmenControl值变化事件
    func segmentValueDidChange(_ segment:UISegmentedControl) -> Void {
        
        switch segment.selectedSegmentIndex {
        case 0:
            gameview.dimension = 3
        case 2:
            gameview.dimension = 5
        default:
            gameview.dimension = 4
        }
        
        gameview.reStart()
        
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text != "\(gameview.maxNumber)" {
            gameview.maxNumber = Int(textField.text!)!
        }
        
    }
    
    //MARK: 点击屏幕响应事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        print(UserDefaults.standard.object(forKey: "DIMENSION_VALUE") as! String)
        
        max_value.resignFirstResponder()
        
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
