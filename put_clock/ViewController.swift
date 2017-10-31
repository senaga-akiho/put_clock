//
//  ViewController.swift
//  put_clock
//
//  Created by 瀬長顕穂 on 2017/10/24.
//  Copyright © 2017年 table clock. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var event1: UILabel!
    @IBOutlet weak var event2: UILabel!
    @IBOutlet weak var event3: UILabel!
    @IBOutlet weak var time_switch: UISwitch!
    
    var labelArray = [UILabel(), UILabel(), UILabel()]
    var time_bool:Bool = true
    private let myEventStore:EKEventStore = EKEventStore()
    // NSUserDefaultsインスタンスの生成
    let userDefaults = UserDefaults.standard
    /*
         一番最初に呼ばれる
     */
    override func viewDidLoad() {
        accessApplication()
        super.viewDidLoad()
        labelArray[0] = event1
        labelArray[1] = event2
        labelArray[2] = event3
        time_switch.layer.position = CGPoint(x: self.view.bounds.width/2,y: self.view.bounds.height/2)
        //アプリがアクティブになった瞬間に呼び出す
        let goActive = NotificationCenter.default
        goActive.addObserver(
            self,
            selector: #selector(eventGet),
            name:NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        
        let goBackGround = NotificationCenter.default
        goBackGround.addObserver(
            self,
            selector: #selector(saveDate),
            name:NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        //eventGet()
        // 1秒ごとに「displayClock」を実行する
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        UIView.animate(withDuration: 1.0, delay: 0.0,
                       options: UIViewAnimationOptions.repeat, animations: { () -> Void in
                        self.time_label.alpha = 0.0
        }, completion: nil)
        timer.fire()    // 無くても動くけどこれが無いと初回の実行がラグる
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
         スイッチの切り替え時
     */
    @IBAction func `switch`(_ sender: Any) {
        if (sender as AnyObject).isOn {
            print(time_bool)
            time_bool=true
        }else {
            print(time_bool)
            time_bool=false
        }
    }
    
        /*
             時刻の表示
         */
    @objc func displayClock() {
        let time_formatter = DateFormatter()
        
        if(time_bool){
            time_formatter.dateFormat = "HH:mm:ss"
        }else{
            time_formatter.dateFormat = "HH時mm分ss秒"
        }
        // 時間を表示
        var displayTime = time_formatter.string(from: Date())    // Date()だけで現在時刻を表す
        // 0から始まる時刻の場合は「 H:MM:SS」形式にする
        if displayTime.hasPrefix("0") {
            // 最初に見つかった0だけ削除(スペース埋め)される
            if let range = displayTime.range(of: "0") {
                displayTime.replaceSubrange(range, with: " ")
            }
        }
        // ラベルに表示
        time_label.text = displayTime
        time_label.sizeToFit()
        time_label.textAlignment = .center
        time_label.layer.position = CGPoint(x: self.view.bounds.width/2,y: self.view.bounds.height/5)
        
        //日付を表示
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy/MM/dd"
        let displayDate = date_formatter.string(from: Date())
        date_label.text = displayDate
        date_label.sizeToFit()
        date_label.textAlignment = .center
        date_label.layer.position = CGPoint(x: self.view.bounds.width/2,y: time_label.layer.position.y+self.view.bounds.height/10)
    }
    /*
     ユーザーデフォルトデータを保存
     */
    @objc func saveDate()
    {
        print("保存！")
        userDefaults.set(time_bool, forKey: "time_bool")
    }
    
    /*
         アクセス権の表示
     */
    func accessApplication()
    {
        // カレンダー追加の権限ステータスを取得
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        
        switch authStatus {
        case .authorized: break
        case .denied: break
        case .restricted: break
        case .notDetermined:
            self.myEventStore.requestAccess(to: .event, completion: { (result:Bool, error:Error?) in
                if result {
//                    self.eventGet()
                } else {
                    // 使用拒否
                }
            })
        }
    }
    
    /*
     イベントの取得
     アプリ起動時に呼べれる関数
     */
    @objc func eventGet() {
        time_switch.setOn(userDefaults.bool(forKey: "time_bool"),animated: false)
        time_bool = time_switch.isOn
        // イベントストアのインスタンスメソッドで述語を生成.
        var predicate = NSPredicate()
        predicate = myEventStore.predicateForEvents(withStart: Date()-60*60*24,
                                                    end: Date()+60*60*24,
                                                    calendars: nil)
        // 述語にマッチする全てのイベントをフェッチ.
        let events = myEventStore.events(matching: predicate)
        // イベントが見つかった.
        
        if !events.isEmpty {
            var w=0
            for i in events{
                labelArray[w].text = i.title
                labelArray[w].sizeToFit()
                labelArray[w].textAlignment = .center
                labelArray[w].layer.position = CGPoint(x: self.view.bounds.width/2,y: self.view.bounds.height*CGFloat(5+w)/8)
                
                print(i.title)
//                print(i.startDate)
//                print(i.endDate)
                w+=1
            }
        }else{
            print("何もない")
        }
    }

}

