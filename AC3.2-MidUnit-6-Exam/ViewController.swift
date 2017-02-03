//
//  ViewController.swift
//  DynamicAnimations
//
//  Created by Louis Tur on 1/26/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var dynamicAnimator: UIDynamicAnimator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setupViewHierarchy()
        configureConstraints()
        
        self.dynamicAnimator = UIDynamicAnimator(referenceView: view)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        //why added here? because not guaranteed current geometry/drawing phase has been made yet in viewdidload
        let gravityBehavior = UIGravityBehavior(items: [blueView])
        //gravityBehavior.angle = CGFloat.pi / 6.0 //or
        gravityBehavior.magnitude = 2.0
        self.dynamicAnimator?.addBehavior(gravityBehavior)
        
        //this only tells the computer what items will be affected by collision; but does not yet make boundary
        let collisionBehavior = UICollisionBehavior(items: [blueView])
        
        //makes bounadry
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.dynamicAnimator?.addBehavior(collisionBehavior)
        
        //bounce back up from after it falls (why is this needed to have Snap and deSnap function to work?)
        let elasticBehavior = UIDynamicItemBehavior(items: [blueView])
        elasticBehavior.elasticity = 0.5
        self.dynamicAnimator?.addBehavior(elasticBehavior)
 */
        let bouncyBehavior = BouncyViewBehavior(items: [blueView, redView])
        self.dynamicAnimator?.addBehavior(bouncyBehavior)
        
        let barrierBehavior = UICollisionBehavior(items: [greenView, redView])
        
        greenView.isHidden = true
        barrierBehavior.addBoundary(withIdentifier: "Barrier" as NSString, from: CGPoint(x: greenView.frame.minX, y: greenView.frame.midY), to: CGPoint(x: greenView.frame.maxX, y: greenView.frame.midY))
        self.dynamicAnimator?.addBehavior(barrierBehavior)
    }
    
    //MARK: - Constraints
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        blueView.snp.makeConstraints { (view) in
            view.centerX.top.equalToSuperview()
            view.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        redView.snp.makeConstraints { (view) in
            view.top.equalToSuperview().offset(20.0)
            view.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        greenView.snp.makeConstraints { (view) in
            view.centerY.equalToSuperview()
            view.leading.trailing.equalToSuperview()
            view.size.equalTo(CGSize(width: 160, height: 20))
        }
        
        snapButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.bottom.equalToSuperview().inset(50.0)
        }
        
        deSnapButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(snapButton.snp.bottom).offset(8.0)
        }
        
    }

    
    internal func snapToCenter(_ view: UIView) {
        //usually dont call frames
        let snappingBehavior = UISnapBehavior(item: blueView, snapTo: self.view.center)
        snappingBehavior.damping = 1.0
        
        self.dynamicAnimator?.addBehavior(snappingBehavior)
        
    }
    
    internal func deSnapFromCenter() {
        let _ = dynamicAnimator?.behaviors.map {
            if $0 is UISnapBehavior {
                self.dynamicAnimator?.removeBehavior($0)
            }
        }
        //or remove all behaviors, or filter
    }
    
    
    //MARK: - Hierarchy
    private func setupViewHierarchy() {
        self.view.addSubview(blueView)
        self.view.addSubview(redView)
        self.view.addSubview(greenView)
        self.view.addSubview(snapButton)
        self.view.addSubview(deSnapButton)
        self.snapButton.addTarget(self, action: #selector(snapToCenter), for: .touchUpInside)
        self.deSnapButton.addTarget(self, action: #selector(deSnapFromCenter), for: .touchUpInside)
        //self.blueView.performSelector(onMainThread: #selector(deSnapFromCenter), with: .current, waitUntilDone: false)
    }
    
    //MARK: - Views
    internal lazy var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        //view.layer.cornerRadius = 5/2
        return view
    }()
    internal lazy var redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        //view.layer.cornerRadius = 5/2
        return view
    }()
    
    internal lazy var greenView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        //view.layer.cornerRadius = 5/2
        return view
    }()
    internal lazy var snapButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("SNAP!", for: .normal)
        return button
    }()
    internal lazy var deSnapButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("(de)SNAP!", for: .normal)
        return button
    }()
}


//make class if reusing same behaviors multiple times
class BouncyViewBehavior: UIDynamicBehavior {
    override init() {
    
    }
    
    //made so all items in array mimic same behaviors
    convenience init(items: [UIDynamicItem]) {
        self.init()
        
        let gravityBehavior = UIGravityBehavior(items: items)
        gravityBehavior.magnitude = 2.0
        self.addChildBehavior(gravityBehavior)
        
        
        let collisionBehavior = UICollisionBehavior(items: items)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.addChildBehavior(collisionBehavior)
 
        
        let elasticBehavior = UIDynamicItemBehavior(items: items)
        elasticBehavior.elasticity = 0.5
        self.addChildBehavior(elasticBehavior)
    }
}

