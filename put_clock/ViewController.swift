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
    
    var labelArray = [UILabel(), UILabel(), UILabel()]
    var display_width:CGFloat = 0.0
    var display_height:CGFloat = 0.0
    private let myEventStore:EKEventStore = EKEventStore()
    var setting:[Bool] = [true,true,true,true]
    var set_num:[String] = ["one","two","three","fore"]
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
//    @IBAction func `switch`(_ sender: Any) {
//        if (sender as AnyObject).isOn {
//            time_bool=true
//        }else {
//            time_bool=false
//        }
//    }
    
        /*
             時刻の表示
         */
    @objc func displayClock() {
        let time_formatter = DateFormatter()
        //日付を表示
        let date_formatter = DateFormatter()
        if(setting[0] && setting[1] && setting[2] && setting[3]){
            time_formatter.dateFormat = "HH時mm分ss秒"
            date_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale! as Locale!
            date_formatter.dateFormat = "yyyy年MM月dd日 E曜日"
        }else if(setting[0]==false && setting[1] && setting[2]){
            time_formatter.dateFormat = "HH:mm:ss"
            date_formatter.dateFormat = "yyyy/MM/dd EEE"
        }else if(setting[0] && setting[1]==false && setting[2]){
            time_formatter.dateFormat = "HH時mm分ss秒"
            date_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale! as Locale!
            date_formatter.dateFormat = "yyyy年MM月dd日 E曜日"
        }else if(setting[0] && setting[1] && setting[2]==false){
            time_formatter.dateFormat = "HH時mm分"
            date_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale! as Locale!
            date_formatter.dateFormat = "yyyy年MM月dd日 E曜日"
        }else if(setting[0]==false && setting[1]==false && setting[2]){
            time_formatter.dateFormat = "HH:mm:ss"
            date_formatter.dateFormat = "yyyy/MM/dd EEE"
        }else if(setting[0]==false && setting[1] && setting[2]==false){
            time_formatter.dateFormat = "HH:mm"
            date_formatter.dateFormat = "yyyy/MM/dd EEE"
        }else if(setting[0] && setting[1]==false && setting[2]==false){
            time_formatter.dateFormat = "HH時mm分"
            date_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale! as Locale!
            date_formatter.dateFormat = "yyyy年MM月dd日 E曜日"
        }else if(setting[0]==false && setting[1]==false && setting[2]==false){
            time_formatter.dateFormat = "HH:mm"
            date_formatter.dateFormat = "yyyy/MM/dd EEE"
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
        
        let displayDate = date_formatter.string(from: Date())
        date_label.text = displayDate
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
        GetSetting()
        eventGet()
        // 1秒ごとに「displayClock」を実行する
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        
        timer.fire()    // 無くても動くけどこれが無いと初回の実行がラグる
    }
    /*
     画面遷移後に呼ばれる
     */
    @objc func SaveSetting(change_setting:[Bool]) {
        for i in 0..<change_setting.count {
            self.setting[i] = change_setting[i]
            userDefaults.set(setting[i], forKey: set_num[i])
        }
    }
    /*
     画面遷移後に呼ばれる
     */
    @objc func GetSetting() {
        for i in 0..<setting.count {
            if ((userDefaults.object(forKey: set_num[i])) == nil) {
                userDefaults.set(setting[i],forKey:set_num[i])
                print("asga")
            }
            setting[i] = userDefaults.bool(forKey: set_num[i])
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

