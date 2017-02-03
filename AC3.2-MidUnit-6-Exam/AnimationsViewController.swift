//
//  AnimationsViewController.swift
//  AC3.2-MidUnit-6-Exam
//
//  Created by Louis Tur on 2/2/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SnapKit

class AnimationsViewController: UIViewController, CellTitled {
    
    //   -------------------------------------------------------------------------------------------
    //                              DO NOT MODIFY THIS SECTION
    //                              But please do read the code
    //    👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
    
    var titleForCell: String = "Fire + Database - Data"
    
    var springPropertyAnimator: UIViewPropertyAnimator? // this is instantiated for you in viewWillAppear
    var dynamicAnimator: UIDynamicAnimator? // be sure to instantiate this!
    
    var collisionBehavior: UICollisionBehavior? // nothing fancy
    var gravityBehavior: UIGravityBehavior? // nothing fancy, just straight down
    var bounceBehavior: UIDynamicItemBehavior? // add a little bit of a "bounce"
    
    var bouncyViews: [UIView] = [] // use this to store any views you add for the gravity/bounce animation
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = titleForCell
        setupViewHierarchy()
        _ = [fireDatabaseLogo, usernameContainerView, passwordContainerView, loginButton].map{ $0.isHidden = true }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.springPropertyAnimator = UIViewPropertyAnimator(duration: 2.0, dampingRatio: 0.75, animations: nil)
        
        configureConstraints()
        setupBehaviorsAndAnimators()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = [fireDatabaseLogo, usernameContainerView, passwordContainerView, loginButton].map{ $0.isHidden = false }
        
        self.animateLogo()
        
        self.addSlidingAnimationToUsername()
        self.addSlidingAnimationToPassword()
        self.addSlidingAnimationToLoginButton()
        self.startSlidingAnimations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.resetViews()
        self.removeBehaviors()
        self.removeConstraints()
        
        //So the app doesn't crash when you re-enter this viewcontroller.
        bouncyViews.removeAll()
    }
    
    // MARK: - Setup
    private func setupViewHierarchy() {
        // View controller appearance changes
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barTintColor = AnimationColors.primary
        self.navigationController?.navigationBar.tintColor = AnimationColors.backgroundWhite
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : AnimationColors.backgroundWhite]
        
        self.view.backgroundColor = AnimationColors.backgroundWhite
        
        self.view.addSubview(usernameContainerView)
        self.view.addSubview(passwordContainerView)
        self.view.addSubview(loginButton)
        self.view.addSubview(fireDatabaseLogo)
        
        usernameContainerView.addSubview(usernameTextField)
        passwordContainerView.addSubview(passwordTextField)
        
        loginButton.addTarget(self, action: #selector(didTapLogin(sender:)), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []

        // logo
        fireDatabaseLogo.snp.makeConstraints { (view) in
            view.top.equalToSuperview().offset(16.0)
            view.centerX.equalToSuperview()
            view.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        // containers
        usernameContainerView.snp.makeConstraints { (view) in
            view.width.equalToSuperview().multipliedBy(0.8)
            view.height.equalTo(44.0)
            view.trailing.equalTo(self.view.snp.leading)
            view.top.equalTo(fireDatabaseLogo.snp.bottom).offset(24.0)
        }
        
        passwordContainerView.snp.makeConstraints { (view) in
            view.width.equalTo(usernameContainerView.snp.width)
            view.height.equalTo(usernameContainerView.snp.height)
            view.top.equalTo(usernameContainerView.snp.bottom).offset(16.0)
            view.trailing.equalTo(self.view.snp.leading)
        }
        
        // textfields
        usernameTextField.snp.makeConstraints { (view) in
            view.leading.top.equalTo(usernameContainerView).offset(4.0)
            view.trailing.bottom.equalTo(usernameContainerView).inset(4.0)
        }
        
        passwordTextField.snp.makeConstraints { (view) in
            view.leading.top.equalTo(passwordContainerView).offset(4.0)
            view.trailing.bottom.equalTo(passwordContainerView).inset(4.0)
        }
        
        // login button
        loginButton.snp.makeConstraints { (view) in
            view.top.equalTo(passwordContainerView.snp.bottom).offset(32.0)
            view.trailing.equalTo(self.view.snp.leading)
        }
    }
    
    // MARK: - Tear Down
    internal func removeBehaviors() {
        self.springPropertyAnimator = nil
        self.gravityBehavior = nil
        self.bounceBehavior = nil
        self.collisionBehavior = nil
    }
    
    internal func resetViews() {
        _ = self.bouncyViews.map { $0.removeFromSuperview() }
        _ = [fireDatabaseLogo, usernameContainerView, passwordContainerView, loginButton].map{ $0.isHidden = true }
        self.fireDatabaseLogo.alpha = 0.0
    }
    
    private func removeConstraints() {
        _ = [usernameContainerView, passwordContainerView, loginButton].map { $0.snp.removeConstraints() }
    }
    
    
    //    ☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️☝️
    //                                  DO NOT MODIFY THIS SECTION
    //                                   But do please read the code
    //   ------------------------------------------------------------------------------------------------------
    
    
    // MARK: -✅🎉 EXAM STARTS HERE 🎉✅-

    // MARK: - Dynamics
    internal func setupBehaviorsAndAnimators() {
        // 1. Instantiate your dynamicAnimator
        self.dynamicAnimator = UIDynamicAnimator(referenceView: view)
        // 2. Instantiate/setup your behaviors
        //      a. Collision
        self.collisionBehavior = UICollisionBehavior(items: self.bouncyViews)
        self.collisionBehavior?.translatesReferenceBoundsIntoBoundary = true
        //      b. Gravity
        self.gravityBehavior = UIGravityBehavior(items: self.bouncyViews)
        self.gravityBehavior?.magnitude = 0.2
        //      c. Bounce
        self.bounceBehavior = UIDynamicItemBehavior(items: self.bouncyViews)
        bounceBehavior?.elasticity = 0.5
        // 3. Add your behaviors to the dynamic animator
        self.dynamicAnimator?.addBehavior(collisionBehavior!)
        self.dynamicAnimator?.addBehavior(gravityBehavior!)
        self.dynamicAnimator?.addBehavior(bounceBehavior!)
    }
    
    // MARK: Slide Animations
    internal func addSlidingAnimationToUsername() {
       
        let animator = UIViewPropertyAnimator(duration: 2.0, dampingRatio: 0.75, animations: nil)

        animator.addAnimations {
            self.usernameContainerView.snp.remakeConstraints { (view) in
                view.width.equalToSuperview().multipliedBy(0.8)
                view.height.equalTo(44.0)
                view.centerX.equalToSuperview()
                view.top.equalTo(self.fireDatabaseLogo.snp.bottom).offset(24.0)
            }
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    internal func addSlidingAnimationToPassword() {
        
        springPropertyAnimator?.addAnimations {
            self.passwordContainerView.snp.remakeConstraints { (view) in
                view.width.equalTo(self.usernameContainerView.snp.width)
                view.height.equalTo(self.usernameContainerView.snp.height)
                view.top.equalTo(self.usernameContainerView.snp.bottom).offset(16.0)
                view.centerX.equalToSuperview()
            }
            
            self.view.layoutIfNeeded()
        }
        springPropertyAnimator?.startAnimation(afterDelay: 0.3)
    }
    
    internal func addSlidingAnimationToLoginButton() {
        let animator = UIViewPropertyAnimator(duration: 2.0, dampingRatio: 0.75, animations: nil)
        animator.addAnimations {
            self.loginButton.snp.remakeConstraints { (view) in
                view.top.equalTo(self.passwordContainerView.snp.bottom).offset(32.0)
                view.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
        animator.startAnimation(afterDelay: 0.5)
    }
    
    internal func startSlidingAnimations() {

        // 1. Begin the animations
    
    }
    
    // MARK:  Scale & Fade-In Logo
    internal func animateLogo() {
        // 2. Can be called and return a animator object for further changes
        self.fireDatabaseLogo.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        let animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear) {
            self.fireDatabaseLogo.transform = CGAffineTransform.identity
            self.fireDatabaseLogo.alpha = 1.0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    // MARK: - Actions
    internal func didTapLogin(sender: UIButton) {
        
        // 1. instantiate a new view (Provided for you!)
        let newView = UIView()
        newView.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        newView.layer.cornerRadius = 20.0
        bouncyViews.append(newView)
        //print(bouncyViews.count)
        // 2. add it to the view hierarchy
        self.view.addSubview(newView)
        // 3. add constraints (make it 40.0 x 40.0)
        newView.snp.makeConstraints { (view) in
            view.top.equalTo(loginButton.snp.bottom)
            view.centerX.equalToSuperview()
            view.size.equalTo(CGSize(width: 40.0, height: 40.0))
        }

        // 4. Add the view to your behaviors
        self.view.layoutSubviews()
        gravityBehavior?.addItem(newView)
        collisionBehavior?.addItem(newView)
        bounceBehavior?.addItem(newView)
        
        
        // 5. (Extra Credit) Add a random angular velocity (between 0 and 15 degrees) to the bounceBehavior
      bounceBehavior?.addAngularVelocity(CGFloat.pi / 6.0, for: bouncyViews.first!)
    }

    // MARK: - ⛔️EXAM ENDS HERE⛔️ -
    
    //   -------------------------------------------------------------------------------------------
    //                              DO NOT MODIFY THIS SECTION
    //                              But please do read the code
    //    👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇

    // MARK: Lazy Inits
    // text fields
    internal lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username..."
        textField.textColor = AnimationColors.primaryDark
        textField.tintColor = AnimationColors.primaryDark
        textField.borderStyle = .bezel
        return textField
    }()
    
    internal lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password..."
        textField.textColor = AnimationColors.primaryDark
        textField.tintColor = AnimationColors.primaryDark
        textField.borderStyle = .bezel
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // containers
    internal lazy var usernameContainerView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    internal lazy var passwordContainerView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    // login button
    internal lazy var loginButton: UIButton = {
        let button: UIButton = UIButton(type: .roundedRect)
        button.setTitle("LOG IN", for: .normal)
        button.backgroundColor = AnimationColors.primaryLight
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
        button.setTitleColor(AnimationColors.backgroundWhite, for: .normal)
        button.layer.cornerRadius = 4.0
        button.layer.borderColor = AnimationColors.primary.cgColor
        button.layer.borderWidth = 2.0
        button.contentEdgeInsets = UIEdgeInsetsMake(8.0, 24.0, 8.0, 24.0)
        return button
    }()
    
    // logo
    internal lazy var fireDatabaseLogo: UIImageView = {
        let image = UIImage(named: "full")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0
        return imageView
    }()
    
}
