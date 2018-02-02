import UIKit
import EventKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let ⚙️ = 設定管理()
    
    //画面遷移
    @IBAction func ApplyButton(_ sender: Any) {
        if (⚙️.選択されたテーマのタイトル == .左右分割){
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: "Left") as! LeftViewController
            self.present( targetViewController, animated: true)
        }
        else if(⚙️.選択されたテーマのタイトル == .スタンダード){
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: "View") as! ViewController
            self.present( targetViewController, animated: true)
        }else if(⚙️.選択されたテーマのタイトル == .シンプル){
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: "Only") as! onlyViewController
            self.present( targetViewController, animated: true)
        }
    }
    
    @IBOutlet weak var SettingTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "テーマ"
        }
        else if(section == 1){
            return "詳細設定"
        }
        return "ラベル"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return ⚙️.テーマ.count
        }
        else if(section == 1){
            return ⚙️.設定.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            ⚙️.選択されたテーマのタイトル = ⚙️.テーマ[indexPath.row].タイトル!
            ⚙️.設定値を保存(変更するkey: ⚙️.選択されたテーマの保存キー, 保存する値:  ⚙️.テーマ[indexPath.row].タイトル?.rawValue as! String)
            self.SettingTableView.reloadSections([indexPath.section], with: UITableViewRowAnimation.fade)
        }
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 100
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let themecell: ThemeTableViewCell
        let advancedsettingcell: SwitchTableViewCell
        
        if(indexPath.section == 0){
            themecell = SettingTableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as! ThemeTableViewCell
            themecell.ThemeImageView.image = UIImage(named: ⚙️.テーマ[indexPath.row].サムネ画像!)
            
            if (⚙️.テーマ[indexPath.row].タイトル == ⚙️.選択されたテーマのタイトル){
                themecell.CheckLabel.text = "✔️"
//                s設定管理.設定値を保存(変更するkey: "選択中のテーマ", 保存する値:  s設定管理.テーマ設定[indexPath.row].theme?.rawValue)
            }
            else {
                themecell.CheckLabel.text = ""
            }
            themecell.ThemeLabel.text = ⚙️.テーマ[indexPath.row].タイトル?.rawValue
            
            return themecell
        }
        else{
//            if ((userDefaults.object(forKey: set_num[indexPath.row])) == nil) {
//                userDefaults.set(setting[indexPath.row],forKey:set_num[indexPath.row])
//            }
//            setting[indexPath.row] = uD.bool(forKey: set_num[indexPath.row])
            advancedsettingcell = SettingTableView.dequeueReusableCell(withIdentifier: "AdvancedSettingCell", for: indexPath) as! SwitchTableViewCell
            advancedsettingcell.textLabel?.text = ⚙️.設定[indexPath.row].タイトル?.rawValue
            advancedsettingcell.textLabel?.backgroundColor = .clear
            advancedsettingcell.swtich.addTarget(self, action: #selector(checkButtonTapped), for: UIControlEvents.valueChanged)
            advancedsettingcell.swtich.setOn(⚙️.設定[indexPath.row].設定値,animated: false)
            
            return advancedsettingcell
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    /*
     accessoryButtonTappedForRowWithIndexPathへパスを出す。
     これでOK.
     */
    @objc func checkButtonTapped(sender: UISwitch, event: UIEvent) {
        let hoge = sender.superview?.superview as! SwitchTableViewCell
        let touchIndex = SettingTableView.indexPath(for: hoge)
        print(touchIndex?.row as!Int)
        ⚙️.設定[touchIndex?.row as!Int].設定値 = !s設定管理.設定[touchIndex?.row as!Int].設定値
        ⚙️.設定値を保存(変更するkey: ⚙️.設定[touchIndex?.row as!Int].タイトル!.rawValue, 保存する値: s設定管理.設定[touchIndex?.row as!Int].設定値)
        
    }
    
    @IBAction func backToTop(segue: UIStoryboardSegue) {}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisAppearです")
//        uD.set(s設定管理, forKey: "設定の値")

        //        print("viewWillDisAppearです")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

