import UIKit

public class Fonts {
    public static let shared = Fonts()
    
    private init(){
        var fontURL = Bundle.main.url(forResource: "Mina-Regular", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        fontURL = Bundle.main.url(forResource: "Mina-Bold", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
    }
    
    public func regularFont(withSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Mina-Regular", size: size){
            return font
        }
        return UIFont()
    }
    
    public func boldFont(withSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Mina-Bold", size: size){
            return font
        }
        return UIFont()
    }
}
