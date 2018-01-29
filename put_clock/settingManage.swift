//設定周りのクラス
import UIKit
struct 設定仕様 {
    
    enum タイトル一覧:String{
        case 日本語表示にする
        case 二十四時間表示にする
        case 秒単位を表示する
        case カレンダーイベントを非表示にする
        case 夜テーマにする
        case 環境光による昼夜モードの自動切り替え
        case 緑ベースの配色にする
    }
    
    var タイトル:タイトル一覧?
    var 設定値:Bool = false
    
    init(_ a:タイトル一覧){
        self.タイトル = a
    }
}

struct テーマ仕様 {
    enum タイトル一覧:String{
        case 左右分割
        case スタンダード
        case シンプル
    }
    
    let タイトル:タイトル一覧?
    let 画像ファイル名:String?
    init(_ a:タイトル一覧,_ b:String){
        self.タイトル = a
        self.画像ファイル名 = b
    }
}

class settingManage{
    var 設定:[設定仕様]
    var テーマ:[テーマ仕様]
    var 選択されたテーマのタイトル:テーマ仕様.タイトル一覧 = .スタンダード
    
    let uD = UserDefaults.standard
    
    init() {
        設定 = []
        let 表示する設定項目の順番:[設定仕様.タイトル一覧] = [
            .二十四時間表示にする,
            .日本語表示にする,
            .秒単位を表示する,
            .カレンダーイベントを非表示にする,
            .夜テーマにする,
            .環境光による昼夜モードの自動切り替え,
            .緑ベースの配色にする
        ]
        for i in 0 ..< 表示する設定項目の順番.count{
            設定.append(.init(表示する設定項目の順番[i]))
            設定[i].設定値 = uD.bool(forKey: 表示する設定項目の順番[i].rawValue)
        }
        テーマ=[
            .init(.左右分割, "theme1.png"),
            .init(.スタンダード, "theme2.png"),
            .init(.シンプル, "timeonly.png")
        ]
        for i in テーマ{
            if i.タイトル?.rawValue == uD.string(forKey: "選択中のテーマ"){
                選択されたテーマのタイトル = i.タイトル!
            }
        }
    }
    
    func 設定値を保存(変更するkey:String,保存する値:Any){
        uD.set(保存する値, forKey: 変更するkey)
    }
}


