//
//  Test.swift
//  DynamicAnimations
//
//  Created by Ilmira Estil on 2/2/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class Test: UIViewController {
    let squareSize = CGSize(width: 300.0, height: 320.0)
    let smallSize = CGSize(width: 50.0, height: 50.0)
    
    var animator: UIViewPropertyAnimator? = nil
    let tealAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: nil)
    var resetThis = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
    }
    
    //MARK: - Animations
    internal func animateSmallTeal() {
        self.teal.snp.remakeConstraints { (view) in
            view.center.equalToSuperview()
            view.size.equalTo(squareSize)
        }
        self.teal.layer.cornerRadius = 50.0
        
        tealAnimator.addAnimations {
            self.view.layoutIfNeeded()
        }
        
        tealAnimator.startAnimation()
    }
    
    internal func reset() {
        teal.snp.removeConstraints()
        tealAnimator.stopAnimation(true)
        teal.transform = CGAffineTransform.identity
        self.configureConstraints()
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let touchedTeal = teal.frame.contains(touch.location(in: view))
        if touchedTeal && !self.resetThis {
            animateSmallTeal()
            self.resetThis = true
        }
        
        print("touches: \(touches)")
        
    }
    
    
    
    
    //MARK: - Constraints
    private func configureConstraints() {
        blue.snp.makeConstraints { (view) in
            view.center.equalToSuperview()
            view.size.equalTo(squareSize)
        }
        
        teal.snp.makeConstraints { (view) in
            view.top.equalTo(blue.snp.top)
            view.trailing.equalTo(blue.snp.trailing)
            view.size.equalTo(smallSize)
        }
    }
    
    //MARK: - Hierarchy
    private func setupViewHierarchy() {
        self.view.backgroundColor = .white
        self.view.isUserInteractionEnabled = true
        self.view.isMultipleTouchEnabled = true
        view.addSubview(blue)
        view.addSubview(teal)
    }
    
    //MARK: - Views
    internal lazy var blue: UIView = {
        let view: UIView = UIView()
        view.layer.cornerRadius = 50.0
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    internal lazy var teal: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
}

