import UIKit
import EventKit

class ViewController: UIViewController {
    
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var second_label: UILabel!
    
    @IBOutlet weak var Ename_label: UILabel!
    @IBOutlet weak var Etime_label: UILabel!
    var labelArray = [UILabel(), UILabel(), UILabel()]
    private let myEventStore:EKEventStore = EKEventStore()
    let colorManagement = color_switch()
    let s = 設定管理()

    override func viewDidLoad() {
        super.viewDidLoad()
        accessApplication()
        
        colorManagement.mainColorItem = [time_label,date_label,Ename_label]
        colorManagement.subColorItem = [Etime_label,second_label]
        colorManagement.bg = self.view
        
        //バックライトの明るさが変わったら呼び出す
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(screenBrightnessDidChange(_:)),
                                               name: NSNotification.Name.UIScreenBrightnessDidChange,
                                               object: nil)
        
    }
    
    
    @objc func displayClock() {
        let time_formatter = DateFormatter()
        let date_formatter = DateFormatter()
        let second_formatter = DateFormatter()
        
        if((s.設定[.日本語表示にする]?.設定値)! && (s.設定[.秒単位を表示する]?.設定値)!){
            time_formatter.dateFormat = "HH時mm分"
            second_formatter.dateFormat = "ss秒"
            date_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale! as Locale!
            date_formatter.dateFormat = "yyyy年MM月dd日 E曜日"
        }else if !(s.設定[.日本語表示にする]?.設定値)! && (s.設定[.秒単位を表示する]?.設定値)!{
            time_formatter.dateFormat = "HH:mm"
            second_formatter.dateFormat = ":ss"
            date_formatter.dateFormat = "yyyy/MM/dd EEE"
        }else if (s.設定[.日本語表示にする]?.設定値)! && !(s.設定[.秒単位を表示する]?.設定値)!{
            time_formatter.dateFormat = "HH時mm分"
            date_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale! as Locale!
            date_formatter.dateFormat = "yyyy年MM月dd日 E曜日"
        }else if !(s.設定[.日本語表示にする]?.設定値)! && !(s.設定[.秒単位を表示する]?.設定値)!{
            time_formatter.dateFormat = "HH:mm"
            date_formatter.dateFormat = "yyyy/MM/dd EEE"
        }
        // 現在時刻を取得
        var displayTime = time_formatter.string(from: Date())
        let secondTime = second_formatter.string(from: Date())
        
        var ampm:String = ""
        
        //24時間表示か確認
        if(s.設定[.二十四時間表示にする]?.設定値 == false){
            if (s.設定[.日本語表示にする]?.設定値)!{
                ampm = "午前"
            }else{
                ampm = "AM "
            }
            if let one_time = Int(displayTime.substring(to: displayTime.index(displayTime.startIndex, offsetBy: 2))) {
                if(Int(displayTime.substring(to: displayTime.index(displayTime.startIndex, offsetBy: 2)))! > 12) {
                    if (s.設定[.日本語表示にする]?.設定値)!{
                        ampm = "午後"
                    }else{
                        ampm = "PM "
                    }
                    displayTime = time_formatter.string(from: Date()-60*60*12)
                }
            } else {
                print("変換できません")
            }
        }
        // 0から始まる時刻の場合は「 H:MM:SS」形式にする
        if displayTime.hasPrefix("0") {
            // 最初に見つかった0だけ削除(スペース埋め)される
            if let range = displayTime.range(of: "0") {
                displayTime.replaceSubrange(range, with: " ")
            }
        }
        
        displayTime = ampm + displayTime
        
        // ラベルに表示
        time_label.text = displayTime
        second_label.text = secondTime
        
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

    @objc func eventGet() {
        // イベントストアのインスタンスメソッドで述語を生成.
        var predicate = NSPredicate()
        predicate = myEventStore.predicateForEvents(withStart: Date(),
                                                    end: Date()+60*60*24,
                                                    calendars: nil)
        // 述語にマッチする全てのイベントをフェッチ.
        let events = myEventStore.events(matching: predicate)

        
        if !events.isEmpty {
            var w=0
            for i in events{
                if(w==0){
                    Ename_label.text=i.title
                    let DateUtils = DateFormatter()
                    DateUtils.dateFormat = "HH:mm"
                    let displayTime = DateUtils.string(from: i.startDate)
                    Etime_label.text=displayTime
                    w=w+1
                }
            }
        }else{
            print("何もない")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventGet()
        // 一定間隔で実行
        let time2 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(eventGet), userInfo: nil, repeats: true)
        // 1秒ごとに「displayClock」を実行する
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        timer.fire()    // 無くても動くけどこれが無いと初回の実行がラグる
        time2.fire()
        if (s.設定[.カレンダーイベントを非表示にする]?.設定値)!{
            Ename_label.alpha = 0
            Etime_label.alpha = 0
        }
        
        if (s.設定[.夜テーマにする]?.設定値)!{
            colorManagement.dayNightChange("night")
        }else{
            colorManagement.dayNightChange("day")
        }
        
        if (s.設定[.緑ベースの配色にする]?.設定値)!{
            colorManagement.colorThemeChange(colorTheme: "color1")
        }

    }
    
    //明るさが一定閾値を超えたらday,night変更
    @objc func screenBrightnessDidChange(_ notification: Notification) {
        
        if s.設定[.環境光による昼夜モードの自動切り替え]?.設定値 == false {return;}
        if UIScreen.main.brightness < 0.5{//実際には0.2ぐらいが良さそう
            colorManagement.🔅🌙 = "night"
        }else{
            colorManagement.🔅🌙 = "day"
        }
        colorManagement.colorReload()
        print("明るさ変わった->",UIScreen.main.brightness)
    }
    
    //ステータスバーを非表示にする(ipadの横画面だとこれが必要)
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

