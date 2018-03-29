
import UIKit

class IntroduceSolarSystemView: UIView {
    public var myState: ControlState
    
    public var stateDelegate: StateManager?
    
    var nextButton: UIButton = {
        let button = UIButton(frame: CGRect())
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: "Button.png"), for: .normal)
        return button
    }()
    
    public override init(frame: CGRect) {
        myState = .solarSystem
        
        super.init(frame: frame)
        setupButton()
        alpha = 0
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        self.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 73).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 207).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc func handleNextButton(sender: UIButton) {
        stateDelegate?.nextState(currentState: myState)
    }
    
}

extension IntroduceSolarSystemView: OverLay {
    
    public func hide() {
        fadeOut()
    }
    
    public func show() {
        fadeIn()
    }
}
