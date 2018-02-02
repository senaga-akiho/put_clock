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
    
    init(_ a:タイトル一覧,_ b:Bool){
        self.タイトル = a
        self.設定値 = b
    }
}

struct テーマ仕様 {
    enum タイトル一覧:String{
        case 左右分割
        case スタンダード
        case シンプル
    }
    
    let タイトル:タイトル一覧?
    let サムネ画像:UIImage?
    let viewController名:String?
    init(_ a:タイトル一覧,_ b:UIImage,_ c :String){
        self.タイトル = a
        self.サムネ画像 = b
        self.viewController名 = c
    }
}

class 設定管理{
    var 設定:[設定仕様.タイトル一覧:設定仕様]=[:]
    var テーマ:[テーマ仕様]
    var 選択されたテーマのタイトル:テーマ仕様.タイトル一覧 = .スタンダード
    
    let uD = UserDefaults.standard
    
    let 選択されたテーマの保存キー:String = "選択中のテーマ"
    
    let 表示する設定項目の順番:[設定仕様.タイトル一覧] = [
        .二十四時間表示にする,
        .日本語表示にする,
        .秒単位を表示する,
        .カレンダーイベントを非表示にする,
        .夜テーマにする,
        .環境光による昼夜モードの自動切り替え,
        .緑ベースの配色にする
    ]
    
    init() {
        
        for i in 表示する設定項目の順番{
            設定[i] = .init(i,uD.bool(forKey: i.rawValue))
        }
        
        テーマ=[
            .init(.左右分割,#imageLiteral(resourceName: "二列"),"LeftViewController"),
            .init(.スタンダード,#imageLiteral(resourceName: "スタンダード"),"ViewController"),
            .init(.シンプル,#imageLiteral(resourceName: "シンプル"),"onlyViewController")
        ]
        for i in テーマ{
            if i.タイトル?.rawValue == uD.string(forKey: 選択されたテーマの保存キー){
                選択されたテーマのタイトル = i.タイトル!
            }
        }
    }
    
    func 設定値を保存(変更するkey:String,保存する値:Bool){
        uD.set(保存する値, forKey: 変更するkey)
    }
    func テーマをこれに変更し保存する(_ a:テーマ仕様.タイトル一覧){
        uD.set(a.rawValue, forKey: 選択されたテーマの保存キー)
    }
}


