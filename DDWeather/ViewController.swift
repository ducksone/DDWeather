//
//  ViewController.swift
//  DDWeather
//
//  Created by duck on 15/12/14.
//  Copyright © 2015年 com.duck.Weather. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var functionTableView: UITableView!
    
    var functionDataSource : [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        functionTableView.dataSource = self
        functionTableView.delegate = self
//        functionTableView.separatorStyle = .None
        
        functionDataSource.append("定位")
        functionDataSource.append("视图控制")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var functionCell : UITableViewCell? = tableView.cellForRow(at: indexPath)
        
        if let _ = functionCell {
            
        }else{
            functionCell = UITableViewCell(style: .default, reuseIdentifier: "FUNCTIONCELLIDENTITY")
        }
        
        functionCell!.textLabel!.text = functionDataSource[(indexPath as NSIndexPath).row]
        
//        let lineRect = CGRectMake(0, 59.5, UIScreen.mainScreen().bounds.size.width, 0.5)
//        
//        var lineView : UIView = UIView(frame: lineRect)
//        
//        lineView.backgroundColor = UIColor.orangeColor()
//        
//        functionCell!.addSubview(lineView)
        
        return functionCell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functionDataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if functionDataSource[(indexPath as NSIndexPath).row] == "定位" {
            self.performSegue(withIdentifier: "locationSegue", sender: self)
        }else if functionDataSource[indexPath.row] == "视图控制" {
            self.performSegue(withIdentifier: "viewSegue", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: 跳转到定位
//        if segue.identifier! == "locationSegue" {
//            let lvc = segue.destinationViewController as! LocationViewController
//            
//            lvc.locationOpen = true
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

