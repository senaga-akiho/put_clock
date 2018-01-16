//
//  ViewController.swift
//  put_clock
//
//  Created by 瀬長顕穂 on 2017/10/24.
//  Copyright © 2017年 table clock. All rights reserved.
//

import UIKit
import EventKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var setting:[Bool] = [true,true,true,true]
    var set_num:[String] = ["one","two","three","fore"]
    var selectedtheme = 0;
    // NSUserDefaultsインスタンスの生成
    let userDefaults = UserDefaults.standard
    
    /*
     一番最初に呼ばれる
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //画面遷移
    @IBAction func ApplyButton(_ sender: Any) {
        if (selectedtheme == 0){
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: "Left") as! LeftViewController
            targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present( targetViewController, animated: true, completion: {
                targetViewController.SaveSetting(change_setting: self.setting)
                targetViewController.callAvtive()
            })
        }
        else if(selectedtheme == 1){
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: "View") as! ViewController
            targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.present( targetViewController, animated: true, completion: {
                targetViewController.SaveSetting(change_setting: self.setting)
                targetViewController.callAvtive()
            })
        }
    }
    /*
    //FirstViewへ移動して，１（View）に移動
    @IBAction func aaa(_ sender: Any) {
        //self.ViewController.callAvtive()
        let targetViewController = storyboard!.instantiateViewController(withIdentifier: "Left") as! LeftViewController
        targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present( targetViewController, animated: true, completion: {
            targetViewController.SaveSetting(change_setting: self.setting)
            targetViewController.callAvtive()
        })
    }
    //FirstViewへ移動して，２（SecondView）に移動
    @IBAction func second(_ sender: Any) {
        let targetViewController = storyboard!.instantiateViewController(withIdentifier: "View") as! ViewController
        targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present( targetViewController, animated: true, completion: {
            targetViewController.SaveSetting(change_setting: self.setting)
            targetViewController.callAvtive()
        })
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var SettingTableView: UITableView!
    let contents = [["テーマ1", "テーマ2"], ["日本語表示", "24時間表示", "秒単位表示", "カレンダーイベント表示"]]
    let images = ["theme1.png", "theme2.png"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contents.count
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
            return contents[0].count
        }
        else if(section == 1){
            return contents[1].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            selectedtheme = indexPath.row
            print(selectedtheme)
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
            themecell.ThemeImageView.image = UIImage(named: images[indexPath.row])
            if (indexPath.row == selectedtheme){
                themecell.CheckLabel.text = "✔️"
            }
            else {
                themecell.CheckLabel.text = ""
            }
            themecell.ThemeLabel.text = contents[indexPath.section][indexPath.row]
            
            return themecell
        }
        else{
            if ((userDefaults.object(forKey: set_num[indexPath.row])) == nil) {
                userDefaults.set(setting[indexPath.row],forKey:set_num[indexPath.row])
            }
            setting[indexPath.row] = userDefaults.bool(forKey: set_num[indexPath.row])
            advancedsettingcell = SettingTableView.dequeueReusableCell(withIdentifier: "AdvancedSettingCell", for: indexPath) as! SwitchTableViewCell
            advancedsettingcell.textLabel?.text = contents[indexPath.section][indexPath.row]
            advancedsettingcell.textLabel?.backgroundColor = .clear
            advancedsettingcell.swtich.addTarget(self, action: #selector(checkButtonTapped), for: UIControlEvents.valueChanged)
            advancedsettingcell.swtich.setOn(setting[indexPath.row], animated: false)
            
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
        let number = touchIndex?.row as!Int
        if(setting[number] == true){
            setting[number] = false
        }else{
            setting[number] = true
        }
        userDefaults.set(setting[number], forKey: set_num[number])
    }
    
}
