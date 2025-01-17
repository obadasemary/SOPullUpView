//
//  PullUpController+Animation.swift
//  PullUpController
//
//  Created by Ahmad Sofi on 12/4/19.
//

import Foundation
@available(iOS 10.0, *)
extension SOPullUpControl {

    func animateTransitionIfNeeded (state:PullUpStatus, duration:TimeInterval) {
         // Check if frame animator is empty
         if runningAnimations.isEmpty {
             // Create a UIViewPropertyAnimator depending on the state of the popover view
             let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                 switch state {
                 case .expanded:
                     // If expanding set popover y to the ending height and blur background
                    self.pullUpViewControl.view.frame.origin.y = self.heightView - self.endCardHeight
                     self.visualEffectView.effect = UIBlurEffect(style: .dark)
                 case .collapsed:
                     // If collapsed set popover y to the starting height and remove background blur
                    self.pullUpViewControl.view.frame.origin.y =  self.heightView -    self.startCardHeight
                     self.visualEffectView.effect = nil
                 }
             }
             
             // Complete animation frame
             frameAnimator.addCompletion { _ in
                 self.cardVisible = !self.cardVisible
                 self.runningAnimations.removeAll()
             }
             
             // Start animation
             frameAnimator.startAnimation()
             
             // Append animation to running animations
             runningAnimations.append(frameAnimator)
         }
        spreadDelegate(state: state)
     }
    
    func spreadDelegate(state:PullUpStatus) {
        switch state {
        case .expanded:
            delegate?.pullUpViewStatus(didChangeTo: .expanded)
        case .collapsed:
            delegate?.pullUpViewStatus(didChangeTo: .collapsed)
        }
    }
     
     // Function to start interactive animations when view is dragged
     func startInteractiveTransition(state:PullUpStatus, duration:TimeInterval) {
         
         // If animation is empty start new animation
         if runningAnimations.isEmpty {
             animateTransitionIfNeeded(state: state, duration: duration)
         }
         
         // For each animation in runningAnimations
         for animator in runningAnimations {
             // Pause animation and update the progress to the fraction complete percentage
             animator.pauseAnimation()
             animationProgressWhenInterrupted = animator.fractionComplete

         }
     }
     
     // Funtion to update transition when view is dragged
     func updateInteractiveTransition(fractionCompleted:CGFloat) {
            
         // For each animation in runningAnimations
         for animator in runningAnimations {
             
             // Update the fraction complete value to the current progress
             animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
           
         }
     }
     
     // Function to continue an interactive transisiton
     func continueInteractiveTransition () {
         // For each animation in runningAnimations
         for animator in runningAnimations {
             // Continue the animation forwards or backwards
             animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
         }
     }
}
