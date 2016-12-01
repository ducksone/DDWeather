//
//  DDLocation.swift
//  DDWeather
//
//  Created by duck on 15/12/14.
//  Copyright © 2015年 com.duck.Weather. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

typealias locationBack = (_ info : String?) -> Void

/// 未开启授权
let DDLOCATIONSTATENOTOPEN : String! = "定位未打开"
/// 得到经纬度后，反地理编码失败
let DDLOCATIONSTATEGEOCODEFALSE : String! = "反地理编码失败"
/// 得到经纬度后，根据经纬度找不到相应的地址
let DDLOCATIONSTATENOTFIND : String! = "根据经纬度，未找到相应的地址"

// MARK: 关于定位的CLLocationManager必须是全局变量 不然会被释放 导致无法定位
/// 定位帮助类  需要初始化使用 let DLocation : DDLocation = DDLocation() 定位: DLocation.DDStarLocation { (locationInfo) -> () in }
class DDLocation: NSObject,CLLocationManagerDelegate {

    // MARK: 定位管理
    var DDLocationManager : CLLocationManager = CLLocationManager()
    
    // MARK: 回调的闭包
    var DDLocationComplete : locationBack?
    
    // MARK: 是否正在定位 默认为开启定位
    var DDLocationIng : Bool = false
    
    // MARK: 开始定位
    func DDStarLocation(_ clousure : locationBack?) {

        if let _ = self.DDLocationManager.delegate {
            print("已设置代理")
        }else{
            DDLocationComplete = clousure
            print("未设置代理")
            self.DDLocationManager.delegate = self
            //每隔多少米定位一次
            self.DDLocationManager.distanceFilter = kCLDistanceFilterNone
            //精准度
            self.DDLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        
        //ios版本号大于8之后必须要做的一件事情  还得在plist中添加 key : NSLocationWhenInUseUsageDescription value : 为空都可以
        if #available(iOS 8.0, *) {
            self.DDLocationManager.requestWhenInUseAuthorization()
        } else {
            // Fallback on earlier versions
        }
        
        // MARK: 判断当前定位是否可用
        if CLLocationManager.locationServicesEnabled()
        {
            if self.DDLocationIng {
                print("上次定位未结束")
            }else{
                self.DDLocationManager.startUpdatingLocation()
                self.DDLocationIng = true
                print("开始定位")
            }
        }else{
            //定位服务未开启
            print("定位未开启")
            self.DDLocationComplete!(DDLOCATIONSTATENOTOPEN)
        }
    }
    
    // MARK: 定位成功，回调
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        // MARK: 得到经纬度的地方
//        let backString = String("经度:\(location!.coordinate.latitude)  维度:\(location!.coordinate.longitude)")
//        
//        self.DDLocationComplete!(info: backString)
        
        //定位成功就停止定位
        self.DDLocationManager.stopUpdatingLocation()
        
        if let l = location
        {
            self.getCoordinateName(l)
        }
    }
    
    // MARK: 反地理编码
    func getCoordinateName(_ location : CLLocation!) {
        let geocoder = CLGeocoder()
                
//        ([CLPlacemark]?, Error?) -> Swift.Void
        geocoder.reverseGeocodeLocation(location, completionHandler:  {(placemarks : [CLPlacemark]?, error : Error?) -> () in

            // 判断 places这个optional是否存在
            if let _ = placemarks {

                if placemarks!.count > 0 {
                    let placeMark : CLPlacemark? = placemarks![0]

                    var city : String? = placeMark!.locality

                    if let _ = city {

                    }else{
                        city = placeMark!.administrativeArea
                    }

                    var nextCity : String? = placeMark!.subLocality

                    if let _ = nextCity {

                    }else{
                        nextCity = ""
                    }

                    //                print(placeMark)
                    let finalArea : String = String("定位得到的位置:\(city!),\(nextCity!)")

                    self.DDLocationComplete!(finalArea)
                    self.DDLocationIng = false
                }else{
                    self.DDLocationComplete!(DDLOCATIONSTATEGEOCODEFALSE)
                    self.DDLocationIng = false
                }
            }else{
                self.DDLocationComplete!(DDLOCATIONSTATENOTFIND)
                self.DDLocationIng = false
            }
            
//            print("________placemarks:\(placemarks)   error:\(error)")
        })
    }
    
    
}
