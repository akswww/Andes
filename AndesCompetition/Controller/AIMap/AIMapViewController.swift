//
//  MainViewController.swift
//  TestJOSE
//
//  Created by imac-3700 on 2024/6/26.
//

import UIKit
import CoreLocation

class AIMapViewController: UIViewController ,CLLocationManagerDelegate {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var btnCount: UIButton!
    
    @IBOutlet weak var lbLocaion: UITextField!
    
    @IBOutlet weak var toPosition: UITextField!
    
    @IBOutlet weak var vshowPath: UIView!
    
    @IBOutlet weak var ImagePath: UIImageView!
    
    @IBOutlet weak var lbPath: UILabel!
    
    @IBOutlet weak var btnPath: UIButton!
    // MARK: - Property
    
    struct pathRequest: Codable {
        let start: Int
        let end: Int
    }
    
    // MARK: - LifeCycle
    
    let manager = NetworkManager()
    let locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var totalDistance: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
    }
    
    
    private func configureLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 1
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // 當定位授權狀態改變時的回呼
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("位置訪問被拒絕")
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    
    // 成功取得定位資訊時會呼叫此方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let newLocation = locations.last {
            // 取得 latitude 和 longitude，並限制至小數點前三位
            let formattedLatitude = String(format: "%.6f", newLocation.coordinate.latitude)
            let formattedLongitude = String(format: "%.6f", newLocation.coordinate.longitude)
            
            let newlocation = CLLocation(latitude: Double(formattedLatitude)! , longitude: Double(formattedLongitude)!)
            
            
            
//            let accuracy = newlocation.horizontalAccuracy
//            guard accuracy > 0 && accuracy < 50 else {
//                // 代表此筆定位點誤差較大，或是未知誤差 (accuracy < 0)，就不納入計算
//                return
//            }

            
            
            // 3. 與前一個位置比較，計算兩點之間的距離
            if let lastLoc = lastLocation {
                let distance = lastLoc.distance(from: newlocation)
                let roundedNumber = round(distance * 1) / 1
                // 4. 為避免在原地不動時因 GPS 漂移導致距離累加，可設置一個「忽略距離門檻」
                //    例如：若移動小於 5 公尺，就視為誤差或漂移而不記入
                if roundedNumber > 2 {
                    totalDistance += roundedNumber
                    print("本次移動距離：\(roundedNumber / 10) 公尺，累計距離：\(totalDistance / 10) 公尺")
                } else {
                    // 可選：僅印出忽略小距離
                    print("忽略小於 5 公尺的漂移：\(roundedNumber) 公尺")
                }
            } else {
                // 第一次定位，不會有前一個位置可比較
                print("首次定位位置：\(newlocation.coordinate)")
            }

            // 5. 記錄最新位置，以備下次比對
            lastLocation = newlocation

        }
     
    }
    
    // 定位失敗時會呼叫此方法
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失敗：\(error.localizedDescription)")
    }
    
}
