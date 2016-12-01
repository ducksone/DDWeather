//
//  ShowViewController.swift
//  DDWeather
//
//  Created by duck on 2016/11/17.
//  Copyright © 2016年 com.duck.Weather. All rights reserved.
//

import UIKit

//定义每一行显示的个数
let perRowCount : Int = 4
//每列的间隔距离
let perSegWidth : CGFloat = 5
//每行的高度
let perHeigth : CGFloat = 50

class ShowViewController: UIViewController,UIAlertViewDelegate,UIActionSheetDelegate {
    @IBOutlet weak var mainScrollView: UIScrollView!
    var showViewDictionary : Dictionary<String,UIView> = [:]//存放所有生成的视图
    var maxKey : Int = -1//记录最大的一个数字
    var willDeleteTag : Int = -1//记录将要删除的tag
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        
        let rightButton = UIButton(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        rightButton.setTitle("重置", for: .normal)
        rightButton.setTitleColor(UIColor.black, for: .normal)
        rightButton.setTitleColor(UIColor.gray, for: .highlighted)
        rightButton.addTarget(self, action: #selector(ShowViewController.reSet), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem(customView: rightButton)
        let rightItemTwo = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ShowViewController.addOne))
        
        self.navigationItem.rightBarButtonItems = [rightItemTwo,rightItem]
        
        
        self.reSet()
        
        self.mainScrollView.backgroundColor = UIColor.gray
    }
    
    //添加数字 alertView
    func addOne() {
        
        let alertView = UIAlertView()
        alertView.message = "添加一个数字"
        alertView.title = "提示"
        alertView.addButton(withTitle: "确定")
        alertView.addButton(withTitle: "取消")
        alertView.cancelButtonIndex = 0
        alertView.delegate = self
        
        alertView.alertViewStyle = .plainTextInput
        
        let textField : UITextField = alertView.textField(at: 0)!
        textField.keyboardType = .numberPad
        
        alertView.show();
        
    }
    
    //重置
    func reSet() {
        
        self.ddDeleteAllView()
        
        for index in 1...20
        {
            self.createOneView(howCount: index-1)
        }
        
    }
    
    //删除某一个视图
    func ddDeleteOneView(howCount : Int) {
        
        if howCount == -1 {
            
        }else{
            if let oldView = showViewDictionary[String(howCount)]
            {
                oldView.removeFromSuperview()
            }
        }
        
        showViewDictionary.removeValue(forKey: String(howCount))
        
        maxKey = -1
        //重新计算高度
        self.countScrollviewContentSize()
        
    }
    
    //删除所有视图
    func ddDeleteAllView() {
        
        if showViewDictionary.count > 0 {
            for key in showViewDictionary.keys
            {
                if let oldView = showViewDictionary[key]
                {
                    oldView.removeFromSuperview()
                }
            }
        }
        
        showViewDictionary.removeAll()
        
        maxKey = -1
    }
    
    //创建一个视图
    func createOneView(howCount : Int) {
        let screenWidth : CGFloat = UIScreen.main.bounds.size.width
        
        //计算宽度
        let perWidth : CGFloat = (screenWidth - (CGFloat(perRowCount) + CGFloat(1)) * perSegWidth) / CGFloat(perRowCount)
        
        let yuValue : Int = howCount % perRowCount
        let moValue : Int = howCount / perRowCount
        
        var rowCount : Int = moValue
        
        if yuValue > perRowCount
        {
            rowCount += 1
        }
        
//        print("行数\(rowCount)")
        
        let newOneView : UIView = UIView(frame: CGRect(x: (CGFloat(yuValue + 1) * perSegWidth) + CGFloat(yuValue) * perWidth, y: (CGFloat(rowCount + 1) * perSegWidth) + CGFloat(rowCount) * perHeigth, width: perWidth, height: perHeigth))
        newOneView.layer.borderColor = UIColor.orange.cgColor
        newOneView.layer.borderWidth = 0.5
        newOneView.layer.cornerRadius = 3
        newOneView.layer.masksToBounds = true
        newOneView.isUserInteractionEnabled = true
        newOneView.tag = howCount
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShowViewController.perViewAction(tap:)))
        newOneView.addGestureRecognizer(tapGesture)
        
        let showLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: newOneView.bounds.size.width, height: newOneView.bounds.size.height))
        showLabel.text = "第" + String(howCount) + "个"
        showLabel.textColor = UIColor.black
        showLabel.textAlignment = .center
        newOneView.addSubview(showLabel)
        
        self.mainScrollView.addSubview(newOneView)
        
        
        if let oldView : UIView = showViewDictionary[String(howCount)] {
            oldView.removeFromSuperview()
        }
        
        showViewDictionary.updateValue(newOneView, forKey: String(howCount))
        
        self.countScrollviewContentSize()
    }
    
    //一个视图的点击事件
    func perViewAction(tap : UITapGestureRecognizer) {
        let currentView : UIView = tap.view!
        
        willDeleteTag = currentView.tag
        
        let actionSheet : UIActionSheet = UIActionSheet()
        actionSheet.title = String("第《\(currentView.tag)》个")
        actionSheet.addButton(withTitle: "删除")
        actionSheet.addButton(withTitle: "取消")
        actionSheet.delegate = self
        actionSheet.cancelButtonIndex = 1
        actionSheet.show(in: self.view)
        
    }
    
    //计算滑块的高度
    func countScrollviewContentSize()
    {
        let screenHeight : CGFloat = UIScreen.main.bounds.size.height - 64
        for key in showViewDictionary.keys
        {
//            print("key\(key)")
            if maxKey == -1 {
                maxKey = NSString(string: key).integerValue
                self.mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: screenHeight)
//                print("无值\(maxKey)")
            }else{
                let keyValue = NSString(string: key).integerValue
                
                if keyValue > maxKey
                {
                    maxKey = keyValue
                }
//                print("有值\(maxKey)")
            }
        }
//        print("___结果\(maxKey)")
        
        let yuValue : Int = maxKey % perRowCount
        let moValue : Int = maxKey / perRowCount
        
        var rowCount : Int = moValue
        
        if yuValue > perRowCount
        {
            rowCount += 1
        }
        
        
        
        let currentMaxHeight : CGFloat = CGFloat(rowCount + 2) * perSegWidth + CGFloat(rowCount + 1) * perHeigth
        if currentMaxHeight > screenHeight
        {
            self.mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: currentMaxHeight)
        }
        
    }
    
    
    //alertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        let textField : UITextField = alertView.textField(at: 0)!
        
        if buttonIndex == 0 {
            
            
            if let inputString = textField.text {
                let inputStringIntValue : Int = NSString(string: inputString).integerValue
                self.createOneView(howCount: inputStringIntValue)
            }
            
        }else{
            
        }
    }
    
    //actionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0
        {
            self.ddDeleteOneView(howCount: willDeleteTag)
        }
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
