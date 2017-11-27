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
    /*
     一番最初に呼ばれる
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //FirstViewへ移動して，１（View）に移動
    @IBAction func aaa(_ sender: Any) {
        //self.ViewController.callAvtive()
        let targetViewController = storyboard!.instantiateViewController(withIdentifier: "Left") as! LeftViewController
        targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present( targetViewController, animated: true, completion: {
            targetViewController.callAvtive()
        })
    }
    //FirstViewへ移動して，２（SecondView）に移動
    @IBAction func second(_ sender: Any) {
        let targetViewController = storyboard!.instantiateViewController(withIdentifier: "View") as! ViewController
        targetViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present( targetViewController, animated: true, completion: {
            targetViewController.callAvtive()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //こっからTableViewのやつ↓

    
    @IBOutlet weak var SettingTableView: UITableView!
    let contents = [["テーマ1", "テーマ2"], ["日本語表示", "24時間表示", "秒単位表示", "カレンダーイベント表示"]]
    let images = ["theme1.png", "theme2.png"]
    
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
            return contents[0].count
        }
        else if(section == 1){
            return contents[1].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //return 70
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let themecell: ThemeTableViewCell
        let advancedsettingcell: UITableViewCell
        
        if(indexPath.section == 0){
            themecell = SettingTableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as! ThemeTableViewCell
            themecell.ThemeImageView.image = UIImage(named: images[indexPath.row])
            return themecell
        }
        else{
            advancedsettingcell = SettingTableView.dequeueReusableCell(withIdentifier: "AdvancedSettingCell", for: indexPath)
            advancedsettingcell.textLabel?.text = contents[indexPath.section][indexPath.row]
            return advancedsettingcell
        }
    }
    
}
