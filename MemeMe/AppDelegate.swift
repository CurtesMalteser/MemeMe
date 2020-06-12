//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Antonio on 02.05.20.
//  Copyright © 2020 CurtesMalteser. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var memes = [Meme]()
    
    override init() {
        super.init()
        
        memes.append(Meme(topText: "lol",
                          bottomText: "String",
                          originalImage: UIImage(),
                          memedImage: UIImage.randomImage()))
        
        memes.append(Meme(topText: "test",
                          bottomText: "ok",
                          originalImage: UIImage(),
                          memedImage: UIImage.randomImage()))
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension UIImage {
    static func randomImage() -> UIImage {
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50, height: 50))
        let cgImage = CIContext().createCGImage(CIImage(color: CIColor(
            red:  .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )), from: frame)!
        return UIImage(cgImage: cgImage)
    }
}
