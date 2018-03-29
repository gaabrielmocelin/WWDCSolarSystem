
import UIKit

public class WelcomeView: UIView {
    public var myState: ControlState
    
    var welcomeView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "BackgroundView.png")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var descriptionText: UITextView = {
        let textView = UITextView()
        textView.text = "Please, make sure you are in full screen mode."
        textView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textView.textAlignment = .center
        textView.backgroundColor = UIColor.clear
        textView.font = Fonts.shared.regularFont(withSize: 20)
        return textView
    }()
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to my playground!!"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.font = Fonts.shared.boldFont(withSize: 32)
        return label
    }()
    
    var readyButton: UIButton = {
        let button = UIButton(frame: CGRect())
        button.setTitle("I'm Ready", for: .normal)
        button.addTarget(self, action: #selector(handleReadyButton), for: .touchUpInside)
        button.setBackgroundImage(UIImage.init(named: "Button.png"), for: .normal)
        button.titleLabel?.font = Fonts.shared.boldFont(withSize: 20)
        return button
    }()
    
    public var stateDelegate: StateManager?
    
    public override init(frame: CGRect) {
        self.myState = .welcome
        
        super.init(frame: frame)
        setupBackgroundBlur()
        setupReadyButton()
        setupWelcomeView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWelcomeView() {
        
        self.addSubview(welcomeView)
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        welcomeView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        welcomeView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30).isActive = true
        welcomeView.heightAnchor.constraint(equalToConstant: 404).isActive = true
        welcomeView.widthAnchor.constraint(equalToConstant: 661).isActive = true
        
        welcomeView.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: welcomeView.widthAnchor, constant: 0).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: welcomeView.topAnchor, constant: 150).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        welcomeView.addSubview(descriptionText)
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.centerXAnchor.constraint(equalTo: welcomeView.centerXAnchor).isActive = true
        descriptionText.widthAnchor.constraint(equalToConstant: 300).isActive = true
        descriptionText.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20).isActive = true
        descriptionText.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupBackgroundBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    func setupReadyButton() {
        self.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.heightAnchor.constraint(equalToConstant: 73).isActive = true
        readyButton.widthAnchor.constraint(equalToConstant: 207).isActive = true
        readyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        readyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc func handleReadyButton() {
        fadeOut { (bool) in
            self.stateDelegate?.nextState(currentState: self.myState)
        }
    }
}

extension WelcomeView: OverLay{
    public func hide() {
        fadeOut()
    }
    
    public func show() {
        fadeIn()
    }
}

