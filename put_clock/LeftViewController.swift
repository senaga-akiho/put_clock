import UIKit
import EventKit

class LeftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var table: UITableView!
     @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var half_label: UILabel!
    var labelArray = [UILabel(), UILabel(), UILabel()]
    private let myEventStore:EKEventStore = EKEventStore()
    var タイムライン取得:TWGetHomeTL = TWGetHomeTL()
    // NSUserDefaultsインスタンスの生成
    let s = 設定管理()
    
    let manage🖍 = color_switch()
    
    /*
     一番最初に呼ばれる
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        accessApplication()
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        table.delegate = self as UITableViewDelegate
        table.dataSource = self as UITableViewDataSource
        
        manage🖍.mainColorItem = [time_label,half_label,date_label]
        manage🖍.subColorItem = []
        manage🖍.bg = self.view

        //バックライトの明るさが変わったら呼び出す
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(screenBrightnessDidChange(_:)),
                                               name: NSNotification.Name.UIScreenBrightnessDidChange,
                                               object: nil)
    }
    
    /*
     時刻の表示
     */
    @objc func displayClock() {
        let time_formatter = DateFormatter()
        time_formatter.dateFormat = "HH mm"
        // 時間を表示
        var displayTime = time_formatter.string(from: Date())    // Date()だけで現在時刻を表す
        //24時間表示か確認
        if(s.設定[.二十四時間表示にする]?.設定値 == false){
            half_label.alpha = 1
            if(s.設定[.日本語表示にする]?.設定値 == true){
                half_label.text = "午前"
            }else{
                half_label.text = "AM"
            }
            if let one_time = Int(displayTime.substring(to: displayTime.index(displayTime.startIndex, offsetBy: 2))) {
                if(Int(displayTime.substring(to: displayTime.index(displayTime.startIndex, offsetBy: 2)))! > 12) {
                    if(s.設定[.日本語表示にする]?.設定値 == true){
                        half_label.text = "午後"
                    }else{
                        half_label.text = "PM"
                    }
                    displayTime = time_formatter.string(from: Date()-60*60*12)
                }
            } else {
                print("変換できません")
            }
        }else{
            half_label.alpha = 0
        }
        // 0から始まる時刻の場合は「 H:MM:SS」形式にする
        if displayTime.hasPrefix("0") {
            // 最初に見つかった0だけ削除(スペース埋め)される
            if let range = displayTime.range(of: "0") {
                displayTime.replaceSubrange(range, with: " ")
            }
        }
        // ラベルに表示
        time_label.text = displayTime
        
        //日付を表示
        let date_formatter = DateFormatter()
        if(s.設定[.日本語表示にする]?.設定値 == true){
            date_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale! as Locale!
            date_formatter.dateFormat = "yyyy年MM月dd日 E曜日"
        }else{
           date_formatter.dateFormat = "yyyy/MM/dd EEE"
        }
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
     アプリ起動時に呼べれる関数
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 一定間隔で実行
        let time2 = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(Table_Reload), userInfo: nil, repeats: true)
        // 1秒ごとに「displayClock」を実行する
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        timer.fire()    // 無くても動くけどこれが無いと初回の実行がラグる
        time2.fire()
        DispatchQueue.main.async {
            self.タイムライン取得.twConect(TLcount:"10")
            self.tableView.reloadData()
        }
        if (s.設定[.カレンダーイベントを非表示にする]?.設定値)!{
            table.alpha = 0
        }
        
        if (s.設定[.夜テーマにする]?.設定値)!{
            manage🖍.dayNightChange("night")
        }else{
            manage🖍.dayNightChange("day")
        }
        
        if (s.設定[.緑ベースの配色にする]?.設定値)!{
            manage🖍.colorThemeChange(colorTheme: "color1")
        }
    }
    @objc func Table_Reload(){
        table.reloadData()
        tableView.reloadData()
    }
    // セルの高さ指定をする処理
    func tableView(_ tableFunc: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // UITableViewCellの高さを自動で取得する値
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableFunc: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if tableFunc.tag == 1 {
            print("テーブルの更新ですよ")
            // イベントストアのインスタンスメソッドで述語を生成.
            var predicate = NSPredicate()
            predicate = myEventStore.predicateForEvents(withStart: Date(),
                                                        end: Date()+60*60*24,
                                                        calendars: nil)
            // 述語にマッチする全てのイベントをフェッチ.
            let events = myEventStore.events(matching: predicate)
            return events.count
        } else {
            // tweetsの配列内の要素数分を指定]
            if(self.タイムライン取得.tweets == nil){
                return 0
            }
            print("タイムライン取得")
            print(self.タイムライン取得.tweets.count)
            return self.タイムライン取得.tweets.count
            
        }
    }
    
    func tableView(_ tableFunc: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableFunc.tag == 1 {
            print("イヴェントの取得")
            // イベントストアのインスタンスメソッドで述語を生成.
            var predicate = NSPredicate()
            predicate = myEventStore.predicateForEvents(withStart: Date(),
                                                        end: Date()+60*60*24,
                                                        calendars: nil)
            // 述語にマッチする全てのイベントをフェッチ.
            let events = myEventStore.events(matching: predicate)
            // tableCell の ID で UITableViewCell のインスタンスを生成
            let cell = table.dequeueReusableCell(withIdentifier: "eventCell",
                                                 for: indexPath)
            if !events.isEmpty {
                cell.textLabel?.text = events[indexPath.row].title
            
                //        print(events[indexPath.row].startDate)
                let DateUtils = DateFormatter()
                DateUtils.dateFormat = "HH:mm"
                let displayTime = DateUtils.string(from: events[indexPath.row].startDate)
                cell.detailTextLabel?.text = displayTime
            
                let testDraw = draw(frame: CGRect(x: 0, y: 0,width: 1000, height: 1000))
                cell.addSubview(testDraw)
                testDraw.isOpaque = false
                return cell
            }
            return cell
        } else {
            print("タイムライン取得")
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
            
            // TweetTableViewCellの描画内容となるtweetを渡す
            cell.fill(tweet: (self.タイムライン取得.tweets[indexPath.row]))
            
            return cell
        }
    }
    
    @objc func screenBrightnessDidChange(_ notification: Notification) {
        
        if s.設定[.夜テーマにする]?.設定値 == false {return;}
        if UIScreen.main.brightness < 0.5{
            manage🖍.🔅🌙 = "night"
        }else{
            manage🖍.🔅🌙 = "day"
        }
        manage🖍.colorReload()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


