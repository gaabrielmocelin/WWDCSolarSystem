
import UIKit

class GameHistoryView: UIView {
    public var myState: ControlState
    public var stateDelegate: StateManager?
    
    var historyText: UITextView = {
        var textView = UITextView()
        textView.text = """
        this is where i tell the game history,
        bkabalbak blabla bla blablablabla bla blablabla
        blabla bla blabla bla bla "
        """
        textView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textView.backgroundColor = UIColor.clear
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
        historyText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        historyText.widthAnchor.constraint(equalToConstant: 300).isActive = true
        historyText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        labelCenterYAnchor =  historyText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 200)
        labelCenterYAnchor!.isActive = true
    }
    
    func tellHistory()  {
        UIView.animate(withDuration: 10, delay: 0, options: .curveLinear, animations: {
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

