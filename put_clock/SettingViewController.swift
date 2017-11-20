//
//  ViewController.swift
//  put_clock
//
//  Created by 瀬長顕穂 on 2017/10/24.
//  Copyright © 2017年 table clock. All rights reserved.
//

import UIKit
import EventKit

class SettingViewController: UIViewController {
    /*
     一番最初に呼ばれる
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //FirstViewへ移動して，１（View）に移動
    @IBAction func aaa(_ sender: Any) {
        //self.ViewController.callAvtive()
        let targetViewController = storyboard!.instantiateViewController(withIdentifier: "First") as! FirstViewController
        targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present( targetViewController, animated: true, completion: {
            targetViewController.ScreenMove(move_number:1)
        })
    }
    //FirstViewへ移動して，２（SecondView）に移動
    @IBAction func second(_ sender: Any) {
        let targetViewController = storyboard!.instantiateViewController(withIdentifier: "First") as! FirstViewController
        targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present( targetViewController, animated: true, completion: {
            targetViewController.ScreenMove(move_number:2)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
