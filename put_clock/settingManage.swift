//設定周りのクラス
import UIKit
struct 設定情報 {
    var name:設定項目?
    var onOff:Bool = false
    
    init(_ name:設定項目){
        self.name = name
    }
}
enum 設定項目:String{
    case 日本語表示にする
    case 二十四時間表示にする
    case 秒単位表示
    case カレンダーイベント表示
    case 夜テーマ
    case 環境光による昼夜モードの自動切り替え
    case 緑ベースの配色にする
}

struct テーマ情報 {
    let theme:テーマ?
    let image:String?
    init(_ theme:テーマ,_ image:String){
        self.theme = theme
        self.image = image
    }
}
enum テーマ:String{
    case 左右分割
    case スタンダード
    case シンプル
}


class settingManage{
    var 個別設定:[設定情報]
    var テーマ設定:[テーマ情報]
    var 選択されたテーマ:テーマ = .スタンダード
    
    let uD = UserDefaults.standard
    
    init() {
        個別設定 = []
        let 表示する設定項目の順番:[設定項目] = [.二十四時間表示にする,.日本語表示にする,.秒単位表示,.カレンダーイベント表示,.夜テーマ,.環境光による昼夜モードの自動切り替え,.緑ベースの配色にする]
        for i in 0 ..< 表示する設定項目の順番.count{
            個別設定.append(.init(表示する設定項目の順番[i]))
            個別設定[i].onOff = uD.bool(forKey: 表示する設定項目の順番[i].rawValue)
            uD.set(個別設定[i].onOff, forKey: 表示する設定項目の順番[i].rawValue)
        }
        テーマ設定=[.init(.左右分割, "theme1.png"),.init(.スタンダード, "theme2.png"),.init(.シンプル, "timeonly.png")]
        選択されたテーマ = テーマ(rawValue: uD.string(forKey: "選択中のテーマ")!)!
//        uD.set(選択されたテーマ.rawValue, forKey: "選択中のテーマ")

    }
    
    func 設定値を保存(変更するkey:String,保存する値:Any){
        uD.set(保存する値, forKey: 変更するkey)
    }
}


