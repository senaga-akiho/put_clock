//
//  ViewController.swift
//  put_clock
//
//  Created by 瀬長顕穂 on 2017/10/24.
//  Copyright © 2017年 table clock. All rights reserved.
//

import UIKit
import EventKit


class FirstViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    var screen_number:Int = 0
    override func viewDidLoad() {
        print("seconde")
        super.viewDidLoad()
        userDefaults.set(1,forKey: "screen_number")
        screen_number=userDefaults.integer(forKey: "screen_number")
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: "View") as! ViewController
            targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present( targetViewController, animated: true, completion: {
                // 画面遷移後に`firstVCMethod`がログに出力されます
                targetViewController.callAvtive()
            })
    }
    func ScreenMove(move_number: Int){
        userDefaults.set(move_number,forKey: "screen_number")
        screen_number = userDefaults.integer(forKey: "screen_number")
        if(screen_number == 1){
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: "View") as! ViewController
            targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present( targetViewController, animated: true, completion: {
                // 画面遷移後に`firstVCMethod`がログに出力されます
                targetViewController.callAvtive()
            })
        }else if(screen_number == 2){
            print("seconde")
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: "Second") as! SecondViewController
            targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present( targetViewController, animated: true, completion: {
                // 画面遷移後に`firstVCMethod`がログに出力されます
                targetViewController.callAvtive()
            })
        }
        
    }
        
//        //アプリがアクティブになった瞬間に呼び出す
//        let goActive = NotificationCenter.default
//        goActive.addObserver(
//            self,
//            selector: #selector(callAvtive),
//            name:NSNotification.Name.UIApplicationDidBecomeActive,
//            object: nil)
//        //バックグラウンドになった瞬間に呼び出す
//        let goBackGround = NotificationCenter.default
//        goBackGround.addObserver(
//            self,
//            selector: #selector(saveDate),
//            name:NSNotification.Name.UIApplicationDidEnterBackground,
//            object: nil)
//        //画面が横になった直後
//        let screen_move = NotificationCenter.default
//        screen_move.addObserver(
//            self,
//            selector: #selector(screenMove),
//            name:NSNotification.Name.UIApplicationDidChangeStatusBarFrame,
//            object: nil)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


