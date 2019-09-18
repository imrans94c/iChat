//
//  AppDelegate.swift
//  iChat
//
//  Created by Imran Rahman on 10/3/18.
//  Copyright © 2018 Imran Rahman. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    
    var window: UIWindow?
    var authListener: AuthStateDidChangeListenerHandle?
    
    var locationManager: CLLocationManager?
    var coordinates : CLLocationCoordinate2D?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        FirebaseApp.configure()
        //AutoLogin
        authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            
            if user != nil{
                if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil{
                    
                    DispatchQueue.main.async {
                        self.goToApp()
                    }
                    
                }
            }
        })
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        locationManagerStart()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        locationManagerStop()
    }
    
    
    //MARK: GoToApp
    
    func goToApp(){
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID:FUser.currentId()])
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        self.window?.rootViewController = mainView
    }
    
    
    
    //MARK: Location Manager
    
    func locationManagerStart(){
        if locationManager == nil{
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        }
        locationManager!.startUpdatingLocation()
    }
    
    func locationManagerStop(){
        
        if locationManager != nil{
            
            locationManager!.stopUpdatingLocation()
        }
        
    }
    
    //MARK: Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get location")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .restricted:
            print("restricted")
        case .denied:
            locationManager = nil
            print("denied location access")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinates = locations.last!.coordinate
    }
}



