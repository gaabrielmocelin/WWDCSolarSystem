
import UIKit

class GameHistoryView: UIView {
    public var myState: ControlState
    public var stateDelegate: StateManager?
    
    var historyText: UITextView = {
        var textView = UITextView()
        textView.text = "2764 AD\n The death of a star suddenly creates a black hole that swallows our solar system. The United Nations activated the Noah's ark mission, trying to send people and different animal species to a planet recently discovered. The planet is 200.000 light years away and you are the ship's pilot in charge to complete the mission. \nGood Luck!"
        textView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.font = Fonts.shared.regularFont(withSize: 26)
        return textView
    }()
    var labelCenterYAnchor: NSLayoutConstraint?
    
    public  override init(frame: CGRect) {
        myState = .gameHistory
        
        super.init(frame: frame)
        
        setupLabel()
    }
    
    func setupLabel()  {
        self.addSubview(historyText)
        historyText.translatesAutoresizingMaskIntoConstraints = false
        historyText.heightAnchor.constraint(equalToConstant: 550).isActive = true
        historyText.widthAnchor.constraint(equalToConstant: 400).isActive = true
        historyText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        labelCenterYAnchor =  historyText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 550)
        labelCenterYAnchor!.isActive = true
    }
    
    func tellHistory()  {
        UIView.animate(withDuration: 30, delay: 0, options: .curveLinear, animations: {
            self.labelCenterYAnchor?.isActive = false
            self.historyText.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.layoutIfNeeded()
        }) { (_) in
            self.stateDelegate?.nextState(currentState: self.myState)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameHistoryView: EndOfTheSystemDelegate{
    public func didBeginTheEndOfSystem() {
        DispatchQueue.main.async {
            
            self.tellHistory()
            UIView.animate(withDuration: 2, animations: {
                self.backgroundColor = UIColor(red: 17/255, green: 34/255, blue: 51/255, alpha: 1)
            })
        }
    }
}

extension GameHistoryView: OverLay{
    public func hide() {
        fadeOut()
    }
    
    public func show() {
        fadeIn()
    }
}

