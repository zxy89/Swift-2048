//
//  TileView.swift
//  XY2048
//
//  Created by 张兴业 on 2017/3/29.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit

class TileView: UIView {
    
    let colorMap = [
        2:UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 75.0/255.0, alpha: 1.0),
        4:UIColor(red: 190.0/255.0, green: 235.0/255.0, blue: 50.0/255.0, alpha: 1.0),
        8:UIColor(red: 95.0/255.0, green: 235.0/255.0, blue: 100.0/255.0, alpha: 1.0),
        16:UIColor(red: 0.0/255.0, green: 235.0/255.0, blue: 200.0/255.0, alpha: 1.0),
        32:UIColor(red: 70.0/255.0, green: 200.0/255.0, blue: 250.0/255.0, alpha: 1.0),
        64:UIColor(red: 70.0/255.0, green: 165.0/255.0, blue: 250.0/255.0, alpha: 1.0),
        128:UIColor(red: 180.0/255.0, green: 110.0/255.0, blue: 255.0/255.0, alpha: 1.0),
        256:UIColor(red: 235.0/255.0, green: 95.0/255.0, blue: 250.0/255.0, alpha: 1.0),
        512:UIColor(red: 240.0/255.0, green: 90.0/255.0, blue: 155.0/255.0, alpha: 1.0),
        1024:UIColor(red: 235.0/255.0, green: 70.0/255.0, blue: 75.0/255.0, alpha: 1.0),
        2048:UIColor(red: 255.0/255.0, green: 135.0/255.0, blue: 50.0/255.0, alpha: 1.0),
        ]
    
    
    var numberLable: UILabel = UILabel()
    
    var value:Int = 0{
        
        didSet{
            
            backgroundColor = colorMap[value]
            numberLable.text = "\(value)"
            
        }
        
    }
    
    init(pos:CGPoint,width:CGFloat,value:Int) {
        
        numberLable = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
        numberLable.textAlignment = NSTextAlignment.center
        numberLable.minimumScaleFactor = 0.5
        numberLable.font = UIFont(name: "HelveticalNeue-Bold", size: 20)
        numberLable.text = "\(value)"
        
        super.init(frame: CGRect(x: pos.x, y: pos.y, width: width, height: width))
        
        addSubview(numberLable)
        
        self.value = value
        
        backgroundColor = colorMap[value]
        
        switch value {
        case 2,4:
            numberLable.textColor = UIColor(red: 119.0/255.0, green: 110.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        default:
            numberLable.textColor = UIColor.white
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
