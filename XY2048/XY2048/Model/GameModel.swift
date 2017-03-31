//
//  GameModel.swift
//  XY2048
//
//  Created by 张兴业 on 2017/3/29.
//  Copyright © 2017年 zxy. All rights reserved.
//

import Foundation


class GameModel {
    
    var dimension:Int = 0
    var tiles:Array<Int> = []
    var mtiles: Array<Int> = []
    
    var maxNumber:Int = 0
    
    
    init(dimension:Int, maxnumber:Int) {
        self.dimension = dimension
        self.maxNumber = maxnumber
        self.tiles = Array<Int>(repeatElement(0, count: self.dimension*self.dimension))
        self.mtiles = Array<Int>(repeatElement(0, count: self.dimension*self.dimension))
    }
    
    func initTiles() {
        self.tiles = Array<Int>(repeatElement(0, count: self.dimension*self.dimension))
        self.mtiles = Array<Int>(repeatElement(0, count: self.dimension*self.dimension))
    }

    
    //MARK: 交换tiles和mtiles的数据
    //将tiles搬到mtiles
    func copyToMtiles() {
        
        for k in 0..<self.dimension*self.dimension {
            
            mtiles[k] = tiles[k]
            
        }
        
    }
    //将mtiles搬到tiles
    func copyFromMtiles() {
        
        for k in 0..<self.dimension*self.dimension {
            
            tiles[k] = mtiles[k]
            
        }
        
    }
    
    //MARK: 数据重排
    //数据向上重排
    func reflowUp() {
        
        copyToMtiles()
        var index: Int
        
        //i>0 表示第一行不动  用户控制行数
        for temp in 1..<dimension {
            let i = dimension - temp
            //要执行4次  用于控制列数
            for j in 0..<dimension {
                
                index = self.dimension*i + j
                
                if mtiles[index-self.dimension] == 0 && (mtiles[index] > 0) {
                    
                    mtiles[index-self.dimension] = mtiles[index]
                    mtiles[index] = 0
                    
                    var subindex:Int = index
                    while (subindex+self.dimension < mtiles.count) {
                        if mtiles[subindex+self.dimension] > 0 {
                            mtiles[subindex] = mtiles[subindex+self.dimension]
                            mtiles[subindex+self.dimension] = 0
                        }
                        subindex += self.dimension
                    }
                    
                    
                }
                
            }
        }
        
        copyFromMtiles()
        
    }
    
    //数据向下重排
    func reflowDown() {
        
        copyToMtiles()
        var index: Int
        
        
        for i in 0..<dimension-1 {
            
            for j in 0..<dimension {
                
                index = self.dimension*i + j
                
                if mtiles[index+self.dimension] == 0 && (mtiles[index] > 0) {
                    
                    mtiles[index+self.dimension] = mtiles[index]
                    mtiles[index] = 0
                    
                    var subindex:Int = index
                    while (subindex-self.dimension >= 0) {
                        if mtiles[subindex-self.dimension] > 0 {
                            mtiles[subindex] = mtiles[subindex-self.dimension]
                            mtiles[subindex-self.dimension] = 0
                        }
                        subindex -= self.dimension
                    }
                    
                    
                }
                
            }
        }
        
        copyFromMtiles()
        
    }
    
    //数据向左重排
    func reflowLeft() {
        
        copyToMtiles()
        var index: Int
        
        
        for i in 0..<dimension {
            
            for temp in 1..<dimension {
                let j = dimension-temp
                index = self.dimension*i + j
                
                if mtiles[index-1] == 0 && (mtiles[index] > 0) {
                    
                    mtiles[index-1] = mtiles[index]
                    mtiles[index] = 0
                    
                    var subindex:Int = index
                    while (subindex+1 < i*dimension+dimension) {
                        if mtiles[subindex+1] > 0 {
                            mtiles[subindex] = mtiles[subindex+1]
                            mtiles[subindex+1] = 0
                        }
                        subindex += 1
                    }
                    
                    
                }
                
            }
        }
        
        copyFromMtiles()
        
    }
    
    //数据向右重排
    func reflowRight() {
        
        copyToMtiles()
        var index: Int
        
        for i in 0..<dimension {
            
            for j in 0..<dimension-1 {
                
                index = self.dimension*i + j
                
                if mtiles[index+1] == 0 && (mtiles[index] > 0) {
                    
                    mtiles[index+1] = mtiles[index]
                    mtiles[index] = 0
                    
                    var subindex:Int = index
                    while (subindex-1 > i*dimension-1) {
                        if mtiles[subindex-1] > 0 {
                            mtiles[subindex] = mtiles[subindex-1]
                            mtiles[subindex-1] = 0
                        }
                        subindex -= 1
                    }
                    
                    
                }
                
            }
        }
        
        copyFromMtiles()
        
    }
    
    //MARK: 合并数字
    //向上合并
    func mergeUp() {
        
        copyToMtiles()
        var index:Int
        
        for temp in 1..<dimension {
            let i = dimension-temp
            for j in 0..<dimension {
                index = self.dimension*i+j
                if mtiles[index] > 0 && mtiles[index-self.dimension] == mtiles[index] {
                    mtiles[index-self.dimension] = mtiles[index]*2
                    sendChangeScoreNotification(s: "\(mtiles[index]*2)")
                    mtiles[index] = 0
                }
            }
        }
        
        copyFromMtiles()
    }
    
    //向下合并
    func mergeDown() {
        
        copyToMtiles()
        var index:Int
        
        for i in 0..<dimension-1 {
            for j in 0..<dimension {
                index = self.dimension*i+j
                if mtiles[index] > 0 && mtiles[index+self.dimension] == mtiles[index] {
                    mtiles[index+self.dimension] = mtiles[index]*2
                    sendChangeScoreNotification(s: "\(mtiles[index]*2)")
                    mtiles[index] = 0
                }
            }
        }
        
        copyFromMtiles()
    }
    
    //向左合并
    func mergeLeft() {
        
        copyToMtiles()
        var index:Int
        
        for i in 0..<dimension {
            for temp in 1..<dimension {
                let j = dimension-temp
                index = self.dimension*i+j
                if mtiles[index] > 0 && mtiles[index-1] == mtiles[index] {
                    mtiles[index-1] = mtiles[index]*2
                    sendChangeScoreNotification(s: "\(mtiles[index]*2)")
                    mtiles[index] = 0
                }
            }
        }
        
        copyFromMtiles()
    }
    
    //向右合并
    func mergeRight() {
        
        copyToMtiles()
        var index:Int
        
        for i in 0..<dimension {
            for j in 0..<dimension-1 {
                index = self.dimension*i+j
                if mtiles[index] > 0 && mtiles[index+1] == mtiles[index] {
                    mtiles[index+1] = mtiles[index]*2
                    sendChangeScoreNotification(s: "\(mtiles[index]*2)")
                    mtiles[index] = 0
                }
            }
        }
        
        copyFromMtiles()
        
    }
    
    func sendChangeScoreNotification(s:String) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHANGE_SCORE"), object: nil, userInfo: ["score":"\(s)"])
        
    }
    
    //MARK: 判断某个位置是否有值
    func setPosition(row:Int, col:Int, value:Int) -> Bool {
        
        print(dimension)
        
        assert(row >= 0 && row < dimension)
        assert(col >= 0 && col < dimension)
        let index = self.dimension * row + col
        let val = tiles[index]
        
        if val > 0 {
            print("该位置已经有值了")
            return false
        }
        
        print(index)
        
        tiles[index] = value
        
        return true
        
    }
    
    //MARK: 检测剩余的空位置
    func emptyPosition() -> [Int] {
        
        var emptytiles = Array<Int>()
        
        for k in 0..<dimension*dimension {
            if tiles[k] == 0 {
                emptytiles.append(k)
            }
        }
        
        return emptytiles
    }
    
    //MARK: 检测是否满了
    func isFull() -> Bool {
        
        if emptyPosition().count == 0 {
            return true
        }
        
        return false
        
    }
    
    //MARK: 检测是否成功
    func isSuccess() -> Bool {
        for i in 0..<dimension*dimension {
            if tiles[i] >= maxNumber {
                return true
            }
        }
        return false
    }
    
    //MARK: 检测垂直方向相邻值是否相等
    func checkVertical() -> Bool {
        
        var index = 0
        //从下往上检查
        for temp in 1..<dimension {
            let  i = dimension - temp
            for j in 0..<dimension {
                index = self.dimension * i + j
                while mtiles[index-self.dimension] == mtiles[index] {
                    return false//没有失败
                }
            }
        }
        
        return true
    }
    
    //MARK: 检测水平方向相邻值是否相等
    func checkHorizontal() -> Bool {
        
        var index = 0
        
        for i in 0..<dimension {
            for temp in 1..<dimension {
                let  j = dimension - temp
                index = self.dimension * i + j
                while mtiles[index-1] == mtiles[index] {
                    return false//没有失败
                }
            }
        }
        
        return true
    }

    
    //MARK: 检测游戏是否失败
    func isFailure() -> Bool {
        if isFull() {
            copyToMtiles()
            print("满了")
            print(mtiles[0])
            print(checkVertical())
            print(checkHorizontal())
            if checkVertical() && checkHorizontal(){
                return true//失败
            }
            else{
                return false
            }
        }
        return false
    }
    
}
