import UIKit
import EventKit

class onlyViewController: UIViewController {
    
    @IBOutlet weak var hour_label: UILabel!
    @IBOutlet weak var minute_label: UILabel!
    @IBOutlet weak var second_label: UILabel!
    
    @IBOutlet weak var kari_label: UILabel!
    
    var display_width:CGFloat = 0.0
    var display_height:CGFloat = 0.0
    var setting:[Bool] = [true,true,true,true,false,false,false]
    var set_num:[String] = ["one","two","three","fore","five","six","seven"]
    let colorManagement = color_switch()
    
    // NSUserDefaultsインスタンスの生成
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorManagement.mainColorItem = [hour_label,minute_label,second_label]
        colorManagement.subColorItem = [kari_label]
        colorManagement.bg = self.view
        
        //アプリがアクティブになった瞬間に呼び出す
        let goActive = NotificationCenter.default
        goActive.addObserver(
            self,
            selector: #selector(callAvtive),
            name:NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        //バックライトの明るさが変わったら呼び出す
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(screenBrightnessDidChange(_:)),
                                               name: NSNotification.Name.UIScreenBrightnessDidChange,
                                               object: nil)
        
    }
    
    /* 時刻の表示 */
    @objc func displayClock() {
        let hour_formatter = DateFormatter()
        let minute_formatter = DateFormatter()
        let second_formatter = DateFormatter()
        
        hour_formatter.dateFormat = "HH"
        minute_formatter.dateFormat = ":mm"
        second_formatter.dateFormat = ":ss"
        
        
        // 現在時刻を取得
        let hour = hour_formatter.string(from: Date())
        let minute = minute_formatter.string(from: Date())
        let second = second_formatter.string(from: Date())
        
        // ラベルに表示
        hour_label.text = hour
        minute_label.text = minute
        second_label.text = second
    }

    @objc func callAvtive() {
        GetSetting()
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        timer.fire()
        //昼夜モード、配色パターン読み込む
        if setting[4]{
            colorManagement.dayNightChange("night")
        }else{
            colorManagement.dayNightChange("day")
        }
        
        if setting[6]{
            colorManagement.colorThemeChange(colorTheme: "color1")
        }
        if setting[4]{
            kari_label.backgroundColor = UIColor(named: colorManagement.🖍 + "/" + colorManagement.🔅🌙 + "2")
            
        }else{
            kari_label.backgroundColor = UIColor(named: colorManagement.🖍 + "/" + colorManagement.🔅🌙 + "2")
            
        }
    }

    @objc func SaveSetting(change_setting:[Bool]) {
        for i in 0..<change_setting.count {
            self.setting[i] = change_setting[i]
            userDefaults.set(setting[i], forKey: set_num[i])
        }
    }
    
    @objc func GetSetting() {
        for i in 0..<setting.count {
            if ((userDefaults.object(forKey: set_num[i])) == nil) {
                userDefaults.set(setting[i],forKey:set_num[i])
                print("asga")
            }
            setting[i] = userDefaults.bool(forKey: set_num[i])
        }
    }
    
    //明るさが一定閾値を超えたらday,night変更
    @objc func screenBrightnessDidChange(_ notification: Notification) {
        if setting[5] == false {return;}
        if UIScreen.main.brightness < 0.5{//実際には0.2ぐらいが良さそう
            colorManagement.🔅🌙 = "night"
        }else{
            colorManagement.🔅🌙 = "day"
        }
        colorManagement.colorReload()
        print("明るさ変わった->",UIScreen.main.brightness)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
