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
    var display_width:CGFloat = 0.0
    var display_height:CGFloat = 0.0
    private let myEventStore:EKEventStore = EKEventStore()
    // NSUserDefaultsインスタンスの生成
    let userDefaults = UserDefaults.standard
    /*
         一番最初に呼ばれる
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        accessApplication()
        display_width = self.view.bounds.width
        display_height = self.view.bounds.height
        labelArray[0] = event1
        labelArray[1] = event2
        labelArray[2] = event3
        time_switch.layer.position = CGPoint(x: display_width/10,y: display_height/10)
        //アプリがアクティブになった瞬間に呼び出す
        let goActive = NotificationCenter.default
        goActive.addObserver(
            self,
            selector: #selector(callAvtive),
        name:NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        //バックグラウンドになった瞬間に呼び出す
        let goBackGround = NotificationCenter.default
        goBackGround.addObserver(
            self,
            selector: #selector(saveDate),
            name:NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        //画面が横になった直後
        let screen_move = NotificationCenter.default
        screen_move.addObserver(
            self,
            selector: #selector(screenMove),
            name:NSNotification.Name.UIApplicationDidChangeStatusBarFrame,
            object: nil)
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
            time_bool=true
        }else {
            time_bool=false
        }
    }
    
        /*
             時刻の表示
         */
    @objc func displayClock() {
        let time_formatter = DateFormatter()
        
        if(time_bool){
            time_formatter.dateFormat = "HH:mm"
        }else{
            time_formatter.dateFormat = "HH時mm分"
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
        time_label.layer.position = CGPoint(x: display_width/2,y: display_height/3)
        time_label.adjustsFontSizeToFitWidth = true;
        time_label.font = UIFont.systemFont(ofSize: display_height/3)
        
        //日付を表示
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "yyyy/MM/dd"
        let displayDate = date_formatter.string(from: Date())
        date_label.text = displayDate
        date_label.sizeToFit()
        date_label.textAlignment = .center
        date_label.layer.position = CGPoint(x: display_width/2,y: display_height/10)
        date_label.font = UIFont.systemFont(ofSize: display_height/20)
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
     */
    func eventGet() {
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
                labelArray[w].font = UIFont.systemFont(ofSize: display_height/20)
                labelArray[w].sizeToFit()
                labelArray[w].textAlignment = .center
                labelArray[w].layer.position = CGPoint(x: display_width/2,y: display_height*CGFloat(5+w)/8)
                
                print(i.title)
                //                print(i.startDate)
                //                print(i.endDate)
                w+=1
            }
        }else{
            print("何もない")
        }
    }
    /*
     ユーザーデフォルトデータを保存
     バックグラウンドになった時に呼び出される
     */
    @objc func saveDate()
    {
        print("保存！")
        userDefaults.set(time_bool, forKey: "time_bool")
    }
    /*
     画面が横になった時に表示される
     */
    @objc func screenMove() {
        print("まじか")
        display_width = self.view.bounds.width
        display_height = self.view.bounds.height
    }
    
    /*
     アプリ起動時に呼べれる関数
     */
    @objc func callAvtive() {
        eventGet()
        time_switch.setOn(userDefaults.bool(forKey: "time_bool"),animated: false)
        time_bool = time_switch.isOn
        // 1秒ごとに「displayClock」を実行する
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        time_label.alpha=1
        UIView.animate(withDuration: 1.0, delay: 0.0,
                       options: UIViewAnimationOptions.repeat, animations: { () -> Void in
                        self.time_label.alpha = 0.0
        }, completion: nil)
        timer.fire()    // 無くても動くけどこれが無いと初回の実行がラグる
    }

}

