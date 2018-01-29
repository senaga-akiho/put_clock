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
    var setting😀 = settingManage()
    /*
         一番最初に呼ばれる
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        accessApplication()
        
        colorManagement.mainColorItem = [time_label,date_label,Ename_label]
        colorManagement.subColorItem = [Etime_label,second_label]
        colorManagement.bg = self.view

        callAvtive()
        
        //バックライトの明るさが変わったら呼び出す
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(screenBrightnessDidChange(_:)),
//                                               name: NSNotification.Name.UIScreenBrightnessDidChange,
//                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ここまでok?")
//        setting😀 = uD.object(forKey: "設定の値") as! settingManage
    }
    
    /*
             時刻の表示
         */
    @objc func displayClock() {
//        print("ディスプレイクロック動いてますよ")
        let time_formatter = DateFormatter()
        //日付を表示
        let date_formatter = DateFormatter()
        let second_formatter = DateFormatter()
        //if(setting[0] && setting[2]){
//        if(setting😀.setting["日本語表示にする"]! && setting😀.setting["24時間表示にする"]!){
            time_formatter.dateFormat = "HH時mm分"
            second_formatter.dateFormat = "ss秒"
            date_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale! as Locale!
            date_formatter.dateFormat = "yyyy年MM月dd日 E曜日"
//        }else if(setting[0]==false && setting[2]){
//            time_formatter.dateFormat = "HH:mm"
//            second_formatter.dateFormat = ":ss"
//            date_formatter.dateFormat = "yyyy/MM/dd EEE"
//        }else if(setting[0] && setting[2]==false){
//            time_formatter.dateFormat = "HH時mm分"
//            date_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale! as Locale!
//            date_formatter.dateFormat = "yyyy年MM月dd日 E曜日"
//        }else if(setting[0]==false && setting[2]==false){
//            time_formatter.dateFormat = "HH:mm"
//            date_formatter.dateFormat = "yyyy/MM/dd EEE"
//        }
        // 現在時刻を取得
        var displayTime = time_formatter.string(from: Date())
        let secondTime = second_formatter.string(from: Date())
        
        var ampm:String = ""
        
        //24時間表示か確認
        if(setting😀.設定[0].設定値 == false){
            if(setting😀.設定[1].設定値 == true){
                ampm = "午前"
            }else{
                ampm = "AM "
            }
            if let one_time = Int(displayTime.substring(to: displayTime.index(displayTime.startIndex, offsetBy: 2))) {
                if(Int(displayTime.substring(to: displayTime.index(displayTime.startIndex, offsetBy: 2)))! > 12) {
                    if(setting😀.設定[1].設定値 == true){
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
//        if displayTime.hasPrefix("0") {
//            // 最初に見つかった0だけ削除(スペース埋め)される
//            if let range = displayTime.range(of: "0") {
//                displayTime.replaceSubrange(range, with: " ")
//            }
//        }
        
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
    
    /*
     イベントの取得
     */
    @objc func eventGet() {
//        print("いゔぇんとげっとうごいてますよ")
        // イベントストアのインスタンスメソッドで述語を生成.
        var predicate = NSPredicate()
        predicate = myEventStore.predicateForEvents(withStart: Date(),
                                                    end: Date()+60*60*24,
                                                    calendars: nil)
        // 述語にマッチする全てのイベントをフェッチ.
        let events = myEventStore.events(matching: predicate)
        // イベントが見つかった.
        
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
    
    /*
     アプリ起動時に呼べれる関数
     */
    func callAvtive() {
        //GetSetting()
        eventGet()
        // 一定間隔で実行
        let time2 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(eventGet), userInfo: nil, repeats: true)
        // 1秒ごとに「displayClock」を実行する
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        timer.fire()    // 無くても動くけどこれが無いと初回の実行がラグる
        time2.fire()
//        if(setting[3] == false){
//            Ename_label.alpha = 0
//            Etime_label.alpha = 0
//        }
        //昼夜モード、配色パターン読み込む
//        if setting[4]{
//            colorManagement.dayNightChange("night")
//        }else{
//            colorManagement.dayNightChange("day")
//        }
        
//        if setting[6]{
//            colorManagement.colorThemeChange(colorTheme: "color1")
//        }
    }
    /*
     画面遷移後に呼ばれる
     */
//    func SaveSetting(change_setting:[Bool]) {
//        for i in 0..<change_setting.count {
//            self.setting[i] = change_setting[i]
//            userDefaults.set(setting[i], forKey: set_num[i])
//        }
//    }
//    /*
//     画面遷移後に呼ばれる
//     */
//    func GetSetting() {
//        for i in 0..<setting.count {
//            setting[i] = userDefaults.bool(forKey: set_num[i])
//        }
//    }
    
    //明るさが一定閾値を超えたらday,night変更
//    @objc func screenBrightnessDidChange(_ notification: Notification) {
//        if setting[5] == false {return;}
//        if UIScreen.main.brightness < 0.5{//実際には0.2ぐらいが良さそう
//            colorManagement.🔅🌙 = "night"
//        }else{
//            colorManagement.🔅🌙 = "day"
//        }
//        colorManagement.colorReload()
//        print("明るさ変わった->",UIScreen.main.brightness)
//    }
//
    //ステータスバーを非表示にする(ipadの横画面だとこれが必要)
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

