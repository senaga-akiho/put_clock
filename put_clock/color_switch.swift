import UIKit

//昼夜モードと配色パターンの変更を行うためのclass
class color_switch{
    var 🖍 = "color0"
    var 🔅🌙 = "day"
    var mainColorItem:[UILabel] = []
    var subColorItem:[UILabel] = []
    var bg:UIView? = nil
    
    //昼夜モードの配色に変更
    func colorReload(){
        let filePath = 🖍 + "/" + 🔅🌙
        for i in mainColorItem{
            i.textColor = UIColor(named: filePath + "1")
        }
        for i in subColorItem{
            i.textColor = UIColor(named: filePath + "2")
        }
        bg?.backgroundColor = UIColor(named: filePath + "3")
    }
    
    func dayNightChange(_ a:String){
        🔅🌙 = a
        colorReload()
    }
    
    //配色パターンの変更
    func colorThemeChange(colorTheme:String){
        🖍 = colorTheme
        colorReload()
    }
}

