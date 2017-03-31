//
//  GameViewController.swift
//  XY2048
//
//  Created by 张兴业 on 2017/3/28.
//  Copyright © 2017年 zxy. All rights reserved.
//

import UIKit


enum AnimationSlipType {
    case none//无动画
    case new//新出现动画
    case merge//合并动画
}

class GameViewController: BaseViewController {
    
    var score:Int = 0
    
    lazy var mark_2048: UILabel = {
        
        let lable = UILabel()
        lable.text = "2048"
        lable.font = UIFont.systemFont(ofSize: 20)
        lable.textColor = UIColor.white
        lable.backgroundColor = UIColor.orange
        lable.layer.cornerRadius = 5;
        lable.layer.masksToBounds = true
        lable.textAlignment = NSTextAlignment.center
        
        return lable
        
    }()
    
    lazy var restart : UIButton = {
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "reStart"), for: .normal)
//        btn.setTitle("重新开始", for: UIControlState.normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.orange
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(reStart), for: UIControlEvents.touchUpInside)
        
        return btn
        
    }()
    
    lazy var current_score_back: UIView = {
        
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
        
    }()
    
    lazy var current_score: UILabel = {
        
        let lable = UILabel()
        lable.text = "0"
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.black
        
        return lable
        
    }()
    
    lazy var history_score_back: UIView = {
        
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
        
    }()
    
    lazy var history_max_score: UILabel = {
        
        let best_score = UserDefaults.standard.object(forKey: "BestScore") as! Int
        
        let lable = UILabel()
        lable.text = "\(best_score)"
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.black
        
        return lable
        
    }()
    
    //游戏方格维度
    var dimension: Int = 4{
        didSet{
            gameModel.dimension = dimension
        }
    }
    //数字格子的宽度
    var width: CGFloat = 58.0
    //格子之间的间隙
    var padding: CGFloat = 7.0
    //保存背景图数据
    var backgrounds: Array<UIView> = []
    //白色方块底图
    var whiteView:UIView = UIView()
    
    //游戏数据模型
    var gameModel:GameModel
    
    var tiles:Dictionary<NSIndexPath,TileView>
    
    var tileVals:Dictionary<NSIndexPath,Int>
    
    var maxNumber:Int = 2048
        {
        didSet{
            gameModel.maxNumber = maxNumber
        }
    }
    
    init(){
        
        self.gameModel = GameModel(dimension: self.dimension,maxnumber: maxNumber)
        
        self.tiles = Dictionary()
        
        self.tileVals = Dictionary()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeScore(notification:)), name: NSNotification.Name(rawValue: "CHANGE_SCORE"), object: nil)
        
        creatMark_2048()
        
        creatRestart()
        
        creatCurrentScore()
        
        creatHistoryMaxScore()
        
        setupBackground()
        
        for _ in 0..<2 {
            genRandom()
        }
        
        setupSwipeGuetureRecognizer()
        
    }
    //MARK: 创建2048标志
    func creatMark_2048() -> Void {
        
        self.view.addSubview(mark_2048)
        mark_2048.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.view.snp.left).inset(12)
            make.top.equalTo(self.view.snp.top).inset(76)
            make.width.equalTo(72)
            make.height.equalTo(64)
            
        }
        
    }
    //MARK: 创建重新开始按钮
    func creatRestart() -> Void {
        
        self.view.addSubview(restart)
        restart.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(mark_2048.snp.centerY)
            make.right.equalTo(self.view.snp.right).inset(12)
            make.width.height.equalTo(mark_2048.snp.height)
            
        }
    
    }
    //MARK: 当前分数
    func creatCurrentScore() -> Void {
        
        self.view.addSubview(current_score_back)
        current_score_back.snp.makeConstraints { (make) in
            
            make.left.equalTo(mark_2048.snp.right).inset(-8)
            make.right.equalTo(restart.snp.left).inset(-8)
            make.top.equalTo(mark_2048.snp.top)
            make.height.equalTo(30)
            
        }
        
        let score_mark : UILabel = {
           
            let lable = UILabel()
            lable.text = "分    数:"
            lable.font = UIFont.systemFont(ofSize: 14)
            lable.textColor = UIColor.black
            lable.sizeToFit()
            
            return lable
            
        }()
        
        current_score_back.addSubview(score_mark)
        score_mark.snp.makeConstraints { (make) in
            
            make.left.equalTo(current_score_back.snp.left).inset(8)
            make.centerY.equalTo(current_score_back.snp.centerY)
            make.height.greaterThanOrEqualTo(1)
            make.width.equalTo(50)
            
        }
        
        current_score_back.addSubview(current_score)
        current_score.snp.makeConstraints { (make) in
            
            make.left.equalTo(score_mark.snp.right).inset(-4)
            make.centerY.equalTo(score_mark.snp.centerY)
            make.width.height.greaterThanOrEqualTo(1)
            
        }
        
    }
    //MARK: 历史最高分
    func creatHistoryMaxScore() -> Void {
        
        self.view.addSubview(history_score_back)
        history_score_back.snp.makeConstraints { (make) in
            
            make.left.equalTo(mark_2048.snp.right).inset(-8)
            make.right.equalTo(restart.snp.left).inset(-8)
            make.bottom.equalTo(mark_2048.snp.bottom)
            make.height.equalTo(30)
            
        }
        
        let score_mark : UILabel = {
            
            let lable = UILabel()
            lable.text = "最高分:"
            lable.font = UIFont.systemFont(ofSize: 14)
            lable.textColor = UIColor.black
            lable.sizeToFit()
            
            return lable
            
        }()
        
        history_score_back.addSubview(score_mark)
        score_mark.snp.makeConstraints { (make) in
            
            make.left.equalTo(history_score_back.snp.left).inset(8)
            make.centerY.equalTo(history_score_back.snp.centerY)
            make.height.greaterThanOrEqualTo(1)
            make.width.equalTo(50)
            
        }
        
        history_score_back.addSubview(history_max_score)
        history_max_score.snp.makeConstraints { (make) in
            
            make.left.equalTo(score_mark.snp.right).inset(-4)
            make.centerY.equalTo(score_mark.snp.centerY)
            make.width.height.greaterThanOrEqualTo(1)
            
        }
        
    }
    
    func setupBackground() -> Void {
        
        if UIScreen.main.bounds.size.height == 480.0 && dimension == 5 {
            width = 40
        }
        else if UIScreen.main.bounds.size.height == 480.0 && dimension == 4 {
            width = 48
        }
        else if UIScreen.main.bounds.size.height == 568.0 && dimension == 5 {
            width = 48
        }
        else if UIScreen.main.bounds.size.height == 736.0{
            width = 60
        }
        
        //设置白色地图背景
        setUpWhiteView()
        
        //根据屏幕尺寸计算插入的位置
        var x: CGFloat = 10
        var y: CGFloat = 10
        
        //竖行逐一排列
        for _ in 0..<dimension {
            //y重置
            y = 10
            
            for _ in 0..<dimension {
                
                //添加方格地图背景
                let backgroundView = UIView(frame: CGRect(x: x, y: y, width: width, height: width));
                backgroundView.backgroundColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)
                backgroundView.layer.cornerRadius = 4
                backgroundView.layer.masksToBounds = true
                
                whiteView.addSubview(backgroundView)
                
                backgrounds.append(backgroundView)
                
                y += padding + width
                
            }
            
            x += padding + width
        }
        
    }
    
    //MARK: 创建半透明的方块底图
    func setUpWhiteView() -> Void {
        
        let rect = UIScreen.main.bounds
        
        let w: CGFloat = rect.size.width
        
        let backWidth = width*CGFloat(dimension)+padding*CGFloat(dimension-1)+20
        
        let backX = (w-backWidth)/2.0
        
        whiteView.frame = CGRect(x: backX, y: 160, width: backWidth, height: backWidth)
        
        whiteView.backgroundColor = UIColor(red: 253.0/255.0, green: 143.0/255.0, blue: 28.0/255.0, alpha: 0.6)
        
        self.view.addSubview(whiteView)
        
    }
    //创建随机数
    func genRandom() -> Void {
        
        let randomNum = Int(arc4random_uniform(10))
        
        var seed:Int = 2
        if randomNum == 1 {
            seed = 4
        }
        
        print(dimension)
        
        let col = Int(arc4random_uniform(UInt32(dimension)))
        let row = Int(arc4random_uniform(UInt32(dimension)))
        
        print("---\(col)")
        print("---\(row)")
        
        if gameModel.isFull() {
            print("满了")
            return
        }
        
        if gameModel.setPosition(row: row, col: col, value: seed) == false {
            genRandom()
            return
        }
        
        if gameModel.isFailure() {
            let alertVC = UIAlertController(title: "游戏结束！", message: "抱歉！！您失败了！！！", preferredStyle: UIAlertControllerStyle.alert)
            
            let reTry = UIAlertAction(title: "再玩一次", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction!) in
                
                self.reStart()
                
            })
            
            alertVC.addAction(reTry)
            
            self.present(alertVC, animated: true, completion: nil)
        }

        insertTile((row, col), value: seed,aType: AnimationSlipType.new)
        
    }
    
    func insertTile(_ pos:(Int,Int),value:Int,aType:AnimationSlipType) -> Void {
        
        let (row, col) = pos
        let x = 10 + CGFloat(col)*(width+padding)//x值
        let y = 10 + CGFloat(row)*(width+padding)//y值
        
        let tile = TileView(pos:CGPoint(x:x,y:y),width:width,value:value)
        
        tile.layer.cornerRadius = 4
        tile.layer.masksToBounds = true
        
        self.whiteView.addSubview(tile)
        
        self.view.bringSubview(toFront: tile)
        
        //将tile保存到字典
        let index = IndexPath(row: row, section: col)
        tiles[index as NSIndexPath] = tile
        tileVals[index as NSIndexPath] = value
        
        //动画展示数字
        if aType == AnimationSlipType.none {
            return
        }else if aType == AnimationSlipType.new {
            tile.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1, y: 0.1))
        }else if aType == AnimationSlipType.merge {
            tile.layer.setAffineTransform(CGAffineTransform(scaleX: 0.8, y: 0.8))
        }
        
        //设置动画效果，动画时长0.3s
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions(), animations: {() in
            
            tile.layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
            
        }) { (finished:Bool) in
            
            UIView.animate(withDuration: 0.08, animations: { () in
                
                tile.layer.setAffineTransform(CGAffineTransform.identity)
                
            })
            
        }
        
    }
    
    //MARK: 界面重排
    func resetUI() {
        for (_ ,tile) in tiles {
            
            tile.removeFromSuperview()
            
        }
        //清空字典的内容
        tiles.removeAll(keepingCapacity: true)
        tileVals.removeAll(keepingCapacity: true)
        
        for background in backgrounds {
            background.removeFromSuperview()
        }
        
        setupBackground()
        
        gameModel = GameModel.init(dimension: dimension, maxnumber: maxNumber)
        
    }
    //根据模型数据更新界面
    func initUI() {
        
        var index:Int
        var key:IndexPath
        var tile:TileView
        var tileVal:Int
        
        for i in 0..<dimension {
            for j in 0..<dimension {
                
                index = i*self.dimension+j
                
                key = IndexPath(row: i, section: j)
                //原来界面没有值，数据模型中有值
                if gameModel.tiles[index] > 0 && (tileVals.index(forKey: key as NSIndexPath) == nil) {
                    insertTile((i,j), value: gameModel.tiles[index],aType: AnimationSlipType.merge)
                }
                //原来界面中有值，现在模型数据中没有值
                if gameModel.tiles[index] == 0 && tileVals.index(forKey: key as NSIndexPath) != nil {
                    tile = tiles[key as NSIndexPath]!
                    tile.removeFromSuperview()
                    tiles.removeValue(forKey: key as NSIndexPath)
                    tileVals.removeValue(forKey: key as NSIndexPath)
                }
                //原来有值，现在仍然有值
                if gameModel.tiles[index] > 0 && tileVals.index(forKey: key as NSIndexPath) != nil {
                    tileVal = tileVals[key as NSIndexPath]!
                    //如果不相等，直接换掉值就可以了
                    if tileVal != gameModel.tiles[index] {
                        tile = tiles[key as NSIndexPath]!
                        tile.removeFromSuperview()
                        tiles.removeValue(forKey: key as NSIndexPath)
                        tileVals.removeValue(forKey: key as NSIndexPath)
                        insertTile((i,j), value: gameModel.tiles[index], aType: AnimationSlipType.merge)
                    }
                }
            }
        }
        
        //检测是否通关
        if gameModel.isSuccess() {
            let alertVC = UIAlertController(title: "恭喜过关！", message: "嘿，真棒！！您过关了！！！", preferredStyle: UIAlertControllerStyle.alert)
            
            let makeSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction!) in
                
                
                
            })
            
            let reTry = UIAlertAction(title: "再玩一次", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction!) in
                
                self.reStart()
                
            })
            
            alertVC.addAction(makeSure)
            alertVC.addAction(reTry)
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
    }
    
    //MARK: 重新开始
    func reStart() {
        
        //重置分数
        score = 0
        self.current_score.text = "\(score)"
        
        //重设界面
        resetUI()
        //同步数据
        gameModel.initTiles()
        
        for _ in 0..<2 {
            genRandom()
        }
        
    }
    
    //MARK: 添加4个方向的手势识别器
    func setupSwipeGuetureRecognizer(){
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.up
        
        self.view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        
        self.view.addGestureRecognizer(downSwipe)
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(leftSwipe)
        
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        
        self.view.addGestureRecognizer(rightSwipe)
        
        
        
        
    }
    
    //MARK: 手势响应的方法
    func swipeUp() {
        
        if !gameModel.isSuccess() {
            
            //        printTiles(tiles: gameModel.tiles)
            gameModel.reflowUp()
            gameModel.mergeUp()
            gameModel.reflowUp()
            //        printTiles(tiles: gameModel.mtiles)
            
            //        resetUI()
            initUI()
            
            genRandom()
            
        }
        
    }
    
    func swipeDown() {
        
        if !gameModel.isSuccess() {
            //        printTiles(tiles: gameModel.tiles)
            gameModel.reflowDown()
            gameModel.mergeDown()
            gameModel.reflowDown()
            //        printTiles(tiles: gameModel.mtiles)
            
            //        resetUI()
            initUI()
            
            genRandom()
        }
        
    }
    
    func swipeLeft() {
        
        if !gameModel.isSuccess() {
            //        printTiles(tiles: gameModel.tiles)
            gameModel.reflowLeft()
            gameModel.mergeLeft()
            gameModel.reflowLeft()
            //        printTiles(tiles: gameModel.mtiles)
            
            //        resetUI()
            initUI()
            
            genRandom()
        }
        
    }
    
    func swipeRight() {
        
        if !gameModel.isSuccess() {
            //        printTiles(tiles: gameModel.tiles)
            gameModel.reflowRight()
            gameModel.mergeRight()
            gameModel.reflowRight()
            //        printTiles(tiles: gameModel.mtiles)
            
            //        resetUI()
            initUI()
            
            genRandom()
        }
        
    }
    
    func changeScore(notification:Notification) {
        
        let userinfo = notification.userInfo as! [String:AnyObject]
        
        let value = userinfo["score"] as! String
        
        changeScoreUI(s: Int(value)!)
        
    }
    
    func changeScoreUI(s:Int) {
        
        score += s
        
        let best_score = UserDefaults.standard.object(forKey: "BestScore") as! Int
        
        if score > best_score {
            UserDefaults.standard.set(score, forKey: "BestScore")
            UserDefaults.standard.synchronize()
            
            self.history_max_score.text = "\(score)"
        }
        
        self.current_score.text = "\(score)"
        
    }
    
    //打印矩阵的方法
    func printTiles(tiles:Array<Int>) {
        
        let count = tiles.count
        for k in 0..<count {
            if (k+1)%Int(dimension) == 0 {
                print(tiles[k])
            }
            else{
                print(tiles[k],separator:"",terminator:"\t")
            }
        }
        
        print("")
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
