//
//  LocationViewController.swift
//  DDWeather
//
//  Created by duck on 15/12/15.
//  Copyright © 2015年 com.duck.Weather. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    var locationOpen : Bool!
    
    var DLocation : DDLocation = DDLocation()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let delayInSections = 1.0
//        
//        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSections * Double(NSEC_PER_SEC)))
//        
//        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
//            if (self.locationOpen != nil)
//            {
//                
//            }
//        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.DLocation.DDStarLocation { (locationInfo) -> () in
            print(locationInfo!)
            
            if locationInfo! == DDLOCATIONSTATEGEOCODEFALSE {
                
            }else if locationInfo == DDLOCATIONSTATENOTFIND {
                
            }else if locationInfo == DDLOCATIONSTATENOTOPEN {
                
            }else{
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
