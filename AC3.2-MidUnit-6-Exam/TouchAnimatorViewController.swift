//
//  TouchAnimatorViewController.swift
//  AC3.2-AnimationBasics
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 Access Code. All rights reserved.
//

import UIKit
import SnapKit

class TouchAnimatorViewController: UIViewController {
    //offset = left to the right
    //inset = right to the left
    var animator: UIViewPropertyAnimator? = nil
    //.easeInOut, .easeIn, .easeOut
    let blueAnimator = UIViewPropertyAnimator(duration: 2.0, curve: .linear, animations: nil)
    let tealAnimator = UIViewPropertyAnimator(duration: 2.0, curve: .easeInOut , animations: nil)
    let yellowAnimator = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn, animations: nil)
    let orangeAnimator = UIViewPropertyAnimator(duration: 2.0, curve: .easeOut, animations: nil)
    
    let squareSize = CGSize(width: 100.0, height: 100.0)
    var viewIsCurrentlyHeld: Bool = false
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHierarchy()
        //configureConstraints()
        configureBlueConstraints()
        
        //buttonSetup()
        //animateDarkBlue()
        //animateDarkBlueViewWithSnapkit()
    }
    
    //MARK: - Frames
    internal func animateDarkBlue() {
        let newFrame = darkBlueView.frame.offsetBy(dx: 100.0, dy: 400.0)
        UIView.animate(withDuration: 8.0) {
            self.darkBlueView.frame = newFrame
            self.darkBlueView.alpha = 0.5
            self.darkBlueView.backgroundColor = UIColor.blue
        }
    }
    
    
    //MARK: - Animations
    //Snapkit
    internal func animateDarkBlueViewWithSnapkit() {
        
        // we use remakeConstraints for.. well, remaking a view's constraints in Snapkit
        self.darkBlueView.snp.remakeConstraints({ (view) in
            view.trailing.equalToSuperview().inset(20.0)
            view.top.equalToSuperview().offset(20.0)
            view.size.equalTo(self.squareSize)
        })
        
        // this one will be .linear, add 3 more views for .easeInOut, .easeIn, .easeOut
        /*
         let propertyAnimation = UIViewPropertyAnimator(duration: 1.0, curve: .linear) {
         self.view.layoutIfNeeded()
         }
         */
        
        blueAnimator.addAnimations {
            self.view.layoutIfNeeded()
        }
        
        blueAnimator.startAnimation()
        
        //more stuffs
        blueAnimator.addAnimations({
            self.darkBlueView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, delayFactor: 0.25) //delay = halfway through your animation
        
        blueAnimator.addCompletion { (position: UIViewAnimatingPosition) in
            switch position {
            case .start: print("At the start of the animation")
            case .end: print("At the end of the animation")
            case .current: print("Somewhere in the middle")
            }
        }
    }
    
    internal func animateTealViewWithSnapkit() {
        self.tealView.snp.remakeConstraints({ (view) in
            view.trailing.equalToSuperview().inset(20.0)
            view.top.equalTo(darkBlueView.snp.bottom).offset(20.0)
            view.size.equalTo(self.squareSize)
        })
        
        tealAnimator.addAnimations({
            self.tealView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, delayFactor: 0.25)
        
        tealAnimator.addAnimations {
            self.view.layoutIfNeeded()
        }
        
        tealAnimator.startAnimation()
    }
    
    internal func animateYellowViewWithSnapkit() {
        
        
        self.yellowView.snp.remakeConstraints({ (view) in
            view.trailing.equalToSuperview().inset(20.0)
            view.top.equalTo(tealView.snp.bottom).offset(20.0)
            view.size.equalTo(self.squareSize)
        })
        
        yellowAnimator.addAnimations({
            self.yellowView.transform = CGAffineTransform(translationX: 0.0, y: 1000.0)
            
            //multiple positions?
            //UIViewPropertyAnimator(duration: 2.0, controlPoint1: CGPoint(x: 1.0, y: 0.0), controlPoint2: CGPoint(x: 0.3, y:))
        }, delayFactor: 0.3)
        
        yellowAnimator.addAnimations {
            self.view.layoutIfNeeded()
        }
        
        yellowAnimator.startAnimation()
    }
    
    internal func animateOrangeViewWithSnapkit() {
        
        self.orangeView.snp.remakeConstraints({ (view) in
            view.trailing.equalToSuperview().inset(20.0)
            view.top.equalTo(yellowView.snp.bottom).offset(20.0)
            view.size.equalTo(self.squareSize)
        })
        
        orangeAnimator.addAnimations {
            self.view.layoutIfNeeded()
        }
        
        orangeAnimator.startAnimation()
    }
    
    // MARK: - Setup
    private func configureBlueConstraints() {
        darkBlueView.snp.makeConstraints { (view) in
            view.leading.equalToSuperview().offset(20.0)
            view.top.equalToSuperview().offset(20.0)
            view.size.equalTo(squareSize)
        }
        
        blackHole.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.centerY.equalToSuperview()
            view.size.equalTo(CGSize(width: 150, height: 150))
        }
    }
    
    private func configureConstraints() {
        //Buttons
        animateButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.bottom.equalToSuperview().inset(50.0)
        }
        
        resetButton.snp.makeConstraints { (view) in
            view.top.equalTo(animateButton.snp.bottom).offset(10.0)
            view.centerX.equalToSuperview()
        }
        
        sliderPosition.snp.makeConstraints { (view) in
            view.bottom.equalTo(animateButton.snp.top).offset(8.0)
            view.trailing.equalToSuperview().offset(8.0)
            view.leading.equalToSuperview().inset(8.0)
        }
        
        //Views
        darkBlueView.snp.makeConstraints { (view) in
            view.leading.equalToSuperview().offset(20.0)
            view.top.equalToSuperview().offset(20.0)
            view.size.equalTo(squareSize)
        }
        
        tealView.snp.makeConstraints { (view) in
            view.leading.equalToSuperview().offset(20.0)
            view.top.equalTo(darkBlueView.snp.bottom).offset(20.0)
            view.size.equalTo(squareSize)
        }
        
        yellowView.snp.makeConstraints { (view) in
            view.leading.equalToSuperview().offset(20.0)
            view.top.equalTo(tealView.snp.bottom).offset(20.0)
            view.size.equalTo(squareSize)
        }
        
        orangeView.snp.makeConstraints { (view) in
            view.leading.equalToSuperview().offset(20.0)
            view.top.equalTo(yellowView.snp.bottom).offset(20.0)
            view.size.equalTo(squareSize)
        }
        
        
    }
    
    
    private func setupViewHierarchy() {
        self.view.backgroundColor = .white
        self.view.isUserInteractionEnabled = true
        
        //buttons, outlets
        //view.addSubview(animateButton)
        //view.addSubview(resetButton)
        //view.addSubview(sliderPosition)
        
        //views
        view.addSubview(blackHole)
        view.addSubview(darkBlueView)
        //view.addSubview(orangeView)
        //view.addSubview(yellowView)
        //view.addSubview(tealView)
        
    }
    
    
    // MARK: - Movement
    private func buttonSetup() {
        self.animateButton.addTarget(self, action: #selector(animate), for: .touchUpInside)
        self.resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
    }
    
    internal func animate() {
        animateDarkBlueViewWithSnapkit()
        animateTealViewWithSnapkit()
        animateYellowViewWithSnapkit()
        animateOrangeViewWithSnapkit()
    }
    
    internal func reset() {
        //remove constraints first to add new constraints
        darkBlueView.snp.removeConstraints()
        tealView.snp.removeConstraints()
        yellowView.snp.removeConstraints()
        orangeView.snp.removeConstraints()
        
        
        //stop animations -> instantiate UIPropertyAnimator constants use this in animate function then set to stop to truly reset animation
        let _ = [
            blueAnimator,
            tealAnimator,
            yellowAnimator,
            orangeAnimator
            ].map{ $0.stopAnimation(true)}
        
        //or//.map { $0.isReversed = true }
        
        //where to put this?
        blueAnimator.addCompletion { (position: UIViewAnimatingPosition) in
            switch position {
            case .start: print("At the start of the animation")
            case .end: print("At the end of the animation")
            case .current: print("Somewhere in the middle")
            }
        }
        
        let _ = [
            darkBlueView,
            tealView,
            yellowView,
            orangeView
            ].map{ $0.transform = CGAffineTransform.identity }
        
        self.configureConstraints()
    }
    
    internal func move(view: UIView, to point: CGPoint) {
        if animator!.isRunning {
            animator?.addAnimations {
                self.view.layoutIfNeeded()
            }
        }
        
        view.snp.remakeConstraints { (view) in
            view.center.equalTo(point)
            view.size.equalTo(squareSize)
        }
        
    }
    
    internal func pickUp(view: UIView) {
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
        
        animator?.startAnimation()
    }
    
    internal func putDown(view: UIView) {
        /*
         animator = UIViewPropertyAnimator(duration: 0.15, curve: .easeIn, animations: {
         view.transform = CGAffineTransform.identity
         })
         */
        animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeIn, animations: {
            view.transform = CGAffineTransform.identity
        })
        
        animator?.startAnimation()
    }
    
    
    // MARK: - Tracking Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchWasInsideOfDarkBlueView = darkBlueView.frame.contains(touch.location(in: view))
        
        if touchWasInsideOfDarkBlueView {
            pickUp(view: darkBlueView)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        putDown(view: darkBlueView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        move(view: darkBlueView, to: touch.location(in: view))
    }
    
    //MARK: - Buttons/Outlets
    
    internal lazy var animateButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Animate", for: .normal)
        return button
    }()
    
    internal lazy var resetButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Reset", for: .normal)
        return button
    }()
    
    internal lazy var sliderPosition: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = UIColor.blue
        return slider
    }()
    
    
    // MARK: - Views
    
    internal lazy var darkBlueView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    internal lazy var orangeView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    internal lazy var yellowView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.yellow
        return view
    }()
    
    internal lazy var tealView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    internal lazy var blackHole: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 150/2
        return view
    }()
    
    
}
