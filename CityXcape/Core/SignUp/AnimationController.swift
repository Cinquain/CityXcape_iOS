//
//  AnimationController.swift
//  CityXcape
//
//  Created by James Allan on 9/5/21.
//


import UIKit
import SwiftUI

class AnimationController: UIViewController {

    //MARK: - Variable Declaration
    var BubbleTimer:Timer?
    
    
    //MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        view.backgroundColor = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BubbleTimer?.invalidate()
        BubbleTimer = nil
    }
    
    //MARK: - Function Declaration
    func setupUI() {
        BubbleTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.startBubble), userInfo: nil, repeats: true)
    }
    
    
}

//MARK: - Bubble Configuration
extension AnimationController{
    
    @objc func startBubble() ->Void{

        let bubbleImageView = UIImageView()
        bubbleImageView.image = UIImage(named: "dot")
        
        let intRandom = self.generateIntRandomNumber(min: 1, max: 6)
        let size = self.randomFloatBetweenNumbers(firstNum: 9, secondNum: 40)
        
        let randomOriginX = self.randomFloatBetweenNumbers(firstNum: self.view.frame.minX, secondNum: self.view.frame.maxX)
        let originy = self.view.frame.maxY - 35
        
        
        bubbleImageView.frame = CGRect(x: randomOriginX, y: originy, width: CGFloat(size), height: CGFloat(size))
        bubbleImageView.alpha = self.randomFloatBetweenNumbers(firstNum: 0.0, secondNum: 1.0)
        bubbleImageView.layer.cornerRadius = bubbleImageView.frame.size.height / 2
        bubbleImageView.clipsToBounds = true
        self.view.addSubview(bubbleImageView)
        
        let zigzagPath: UIBezierPath = UIBezierPath()
        let oX: CGFloat = bubbleImageView.frame.origin.x
        let oY: CGFloat = bubbleImageView.frame.origin.y
        let eX: CGFloat = oX
        let eY: CGFloat = oY - (self.randomFloatBetweenNumbers(firstNum: self.view.frame.midY, secondNum: self.view.frame.maxY))
        let t = self.randomFloatBetweenNumbers(firstNum: 20, secondNum: 100)
        var cp1 = CGPoint(x: oX - t, y: ((oY + eY) / 2))
        var cp2 = CGPoint(x: oX + t, y: cp1.y)
        
        let r = arc4random() % 2
        if (r == 1){
            let temp:CGPoint = cp1
            cp1 = cp2
            cp2 = temp
        }
        
        zigzagPath.move(to: CGPoint(x: oX, y: oY))
        
        zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
        CATransaction.begin()
        CATransaction.setCompletionBlock({() -> Void in
            
            UIView.transition(with: bubbleImageView, duration: 0.1, options: .transitionCrossDissolve, animations: {() -> Void in
                bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {(_ finished: Bool) -> Void in
                bubbleImageView.removeFromSuperview()
            })
        })
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 3.5
        pathAnimation.path = zigzagPath.cgPath
        
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        CATransaction.commit()
        
    }
    
    func generateIntRandomNumber(min: Int, max: Int) -> Int {
        let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
        return randomNum
    }
    
    func randomFloatBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
}


struct AnimationContainer: View {
    
    var body: some View {
        AnimationView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct Animation_Preview: PreviewProvider {
    
    static var previews: some View {
        AnimationContainer()
    }
    
}



struct AnimationView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AnimationController {
        return AnimationController()
    }
    
    func updateUIViewController(_ uiViewController: AnimationController, context: Context) {
        
    }
    
    typealias UIViewControllerType = AnimationController
    
    
    
    
}

