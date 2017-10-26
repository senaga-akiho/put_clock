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
    var labelArray = [UILabel(), UILabel(), UILabel()]
    private let myEventStore:EKEventStore = EKEventStore()
    override func viewDidLoad() {
        accessApplication()
        super.viewDidLoad()
        labelArray[0] = event1
        labelArray[1] = event2
        labelArray[2] = event3
        print("通る")
        //アプリがアクティブになった瞬間に呼び出す
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(eventGet),
            name:NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        eventGet()
        // 1秒ごとに「displayClock」を実行する
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        timer.fire()    // 無くても動くけどこれが無いと初回の実行がラグる
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 現在時刻を表示する処理
    @objc func displayClock() {
        // 現在時刻を「HH:MM:SS」形式で取得する
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
        var displayTime = formatter.string(from: Date())    // Date()だけで現在時刻を表す
        
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
        
    }
    // アクセス権申請
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
     Buttonが押されたときに呼ばれるメソッド.
     */
    @objc func eventGet() {
        print("通ってる")
        // イベントストアのインスタンスメソッドで述語を生成.
        var predicate = NSPredicate()
        // ユーザーの全てのカレンダーからフェッチせよ
        predicate = myEventStore.predicateForEvents(withStart: Date()-60*60*24,
                                                    end: Date()+60*60*24,
                                                    calendars: nil)
        // 述語にマッチする全てのイベントをフェッチ.
        let events = myEventStore.events(matching: predicate)
        print(type(of: events))
        // イベントが見つかった.
        
        if !events.isEmpty {
            var w=0
            for i in events{
                labelArray[w].text = i.title
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

