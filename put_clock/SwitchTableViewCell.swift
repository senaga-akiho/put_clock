//
//  SwitchTableViewCell.swift
//  put_clock
//
//  Created by 瀬長顕穂 on 2017/11/28.
//  Copyright © 2017年 table clock. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var swtich: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
//    @IBAction func value_change(_ sender: Any) {
//        let hoge = self.superview as!UITableView
//        // touchIndexは選択したセルが何番目かを記録しておくプロパティ
//        let touchIndex = hoge.indexPath(for: self)
//        print(touchIndex?.row as!Int)
//        let targetViewController = storyboard!.instantiateViewController(withIdentifier: "View") as! ViewController
//    }
    
}
