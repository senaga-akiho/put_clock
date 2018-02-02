import UIKit
import EventKit

class onlyViewController: UIViewController {
    
    @IBOutlet weak var hour_label: UILabel!
    @IBOutlet weak var minute_label: UILabel!
    @IBOutlet weak var second_label: UILabel!
    
    @IBOutlet weak var kari_label: UILabel!
    
    let s = 設定管理()
    let colorManagement = color_switch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorManagement.mainColorItem = [hour_label,minute_label,second_label]
        colorManagement.subColorItem = [kari_label]
        colorManagement.bg = self.view
        
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        timer.fire()
        //昼夜モード、配色パターン読み込む
        if (s.設定[.夜テーマにする]?.設定値)!{
            colorManagement.dayNightChange("night")
            kari_label.backgroundColor = UIColor(named: colorManagement.🖍 + "/" + colorManagement.🔅🌙 + "2")

        }else{
            colorManagement.dayNightChange("day")
            kari_label.backgroundColor = UIColor(named: colorManagement.🖍 + "/" + colorManagement.🔅🌙 + "2")
        }
        
        if (s.設定[.緑ベースの配色にする]?.設定値)!{
            colorManagement.colorThemeChange(colorTheme: "color1")
        }
    }
    //明るさが一定閾値を超えたらday,night変更
    @objc func screenBrightnessDidChange(_ notification: Notification) {
        if s.設定[.夜テーマにする]?.設定値 == false {return;}
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
