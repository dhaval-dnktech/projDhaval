//
//  VKPopover.swift
//  Ziba
//
//  Created by dnk on 03/10/16.
//  Copyright © 2016 DNKTechnologies. All rights reserved.
//

public enum POPOVER_ANIMATION: Int {
    case popover_ANIMATION_CROSS_DISSOLVE
    case popover_ANIMATION_RIGHT_TO_LEFT
    case popover_ANIMATION_BOTTOM_TO_TOP
    case popover_ANIMATION_FADE_IN_OUT
    case popover_ANIMATION_BLUR
}
import UIKit

protocol VKPopoverDelegate {
    
    func vkPopoverClose()
}


class VKPopover: UIView ,UIGestureRecognizerDelegate{

    //MARK: PROPERTIES
    var delegate: VKPopoverDelegate!
    
    //MARK: CONSTANTS
    internal let TAG_SUPER:Int = 101
    internal let TAG_SUB:Int = 1101

    //MARK: VARIABLES
    var _POPOVER_ANIMATION = POPOVER_ANIMATION(rawValue: 0)
    var _animationDuration:TimeInterval = 0.3
    static let sharedInstance = VKPopover()
    var _subView:UIView!
    var viewBG = UIView.init()
    
    //MARK: VIEW METHODS
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   /*class func customPopOverWithView(_ view:UIView) -> VKPopover {
        return sharedInstance.initWithCustomPopoverWithView(view, animation:POPOVER_ANIMATION.popover_ANIMATION_CROSS_DISSOLVE  , animationDuration: VK_POPOVER_DURATION, isBGTransparent: VK_POPOVER_BG_TRANSPARENT, borderColor: COLOUR_GREEN, borderWidth: VK_POPOVER_BORDER_WIDTH, borderCorner: VK_POPOVER_CORNER_RADIUS, isOutSideClickedHidden: VK_POPOVER_OUT_SIDE_CLICK_HIDDEN) as! VKPopover
    }

    class func customPopOverView(_ view:UIView , animation:POPOVER_ANIMATION , animationDuration:TimeInterval , isBGTransparent:Bool , borderColor:UIColor , borderWidth:CGFloat , borderCorner:CGFloat , isOutSideClickedHidden:Bool) -> VKPopover{
        
        return sharedInstance.initWithCustomPopoverWithView(view, animation: animation, animationDuration: animationDuration, isBGTransparent: isBGTransparent, borderColor: borderColor, borderWidth: borderWidth, borderCorner: borderCorner, isOutSideClickedHidden: isOutSideClickedHidden) as! VKPopover
    }*/
    
    required init(_ view: UIView , animation:POPOVER_ANIMATION , animationDuration:TimeInterval , isBGTransparent:Bool , borderColor:UIColor , borderWidth:CGFloat , borderCorner:CGFloat , isOutSideClickedHidden:Bool) {
        
        let frame: CGRect = CGRect(x: 0, y: 0, width: FRAME_SCREEN.width, height: FRAME_SCREEN.height)
        super.init(frame: frame)
        
        self.frame = frame
        self.alpha = 0
        self.tag = TAG_SUPER
        self.backgroundColor = RGBCOLOR(0, g: 0, b: 0, alpha: 0.4)
        _animationDuration = animationDuration
        _POPOVER_ANIMATION = animation
    
        if isOutSideClickedHidden{
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(self.closeVKPopoverAction))
            tapGesture.delegate = self
            self.tag = TAG_SUPER
            self.addGestureRecognizer(tapGesture)
            self.isMultipleTouchEnabled = true
            self.isUserInteractionEnabled = true
        }
        
        _subView = UIView.init()
        _subView = view
        _subView.tag = TAG_SUB
        _subView.clipsToBounds = true
        self.addSubview(_subView)
        
        
        //SET AUTO LAYOUT
        let padding:CGFloat = 10
        let viewHeight:CGFloat = _subView.frame.height
        let viewWidth:CGFloat = (self.frame.width - (padding*2))
        let viewTopSpace:CGFloat = (self.frame.height - viewHeight) / 2
        
       _ = DesignModel.setConstraint_ConWidth_ConHeight_Leading_Top(_subView, superView: self, leading: padding, top: viewTopSpace, width: viewWidth, height: viewHeight)
        
        _subView.layer.borderWidth = borderWidth
        _subView.layer.borderColor = borderColor.cgColor
        _subView.layer.cornerRadius = borderCorner
        
        if _POPOVER_ANIMATION == POPOVER_ANIMATION.popover_ANIMATION_CROSS_DISSOLVE{
            self.alpha = 0
            UIView.animate(withDuration: _animationDuration, delay: 0.0, options:UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.alpha = 1
            }, completion: nil)
        }
        
       else if _POPOVER_ANIMATION == POPOVER_ANIMATION.popover_ANIMATION_RIGHT_TO_LEFT{
            
            var sframe:CGRect = _subView.frame
            sframe.origin.x = self.frame.width
            _subView.frame = sframe
            
            UIView.animate(withDuration: _animationDuration, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { 
                let xOrigin = (self.frame.width / 2) - (self._subView.frame.width / 2)
                let frame:CGRect = CGRect(x: xOrigin, y: self._subView.frame.origin.y, width: self._subView.frame.width, height: self._subView.frame.height)
                self._subView.frame = frame
            }, completion: { (finshed) in
                self.layer.removeAllAnimations()
           })
        }
        
        else if _POPOVER_ANIMATION == POPOVER_ANIMATION.popover_ANIMATION_BOTTOM_TO_TOP{
            
            var sFrame:CGRect = _subView.frame
            sFrame.origin.y = self.frame.height + 10
            _subView.frame = sFrame
            
            UIView.animate(withDuration: _animationDuration, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                
                let yOrigin =   (self.frame.height / 2) - (self._subView.frame.height / 2)
                let frame:CGRect = CGRect(x: self._subView.frame.origin.x, y: yOrigin, width: self._subView.frame.width, height: self._subView.frame.height)
                self._subView.frame = frame
                
                }, completion: { (finished) in
                    self.layer.removeAllAnimations()
            })
        }
        
        else if _POPOVER_ANIMATION == POPOVER_ANIMATION.popover_ANIMATION_FADE_IN_OUT{
            
            self.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.alpha = 0
        
            UIView.animate(withDuration: _animationDuration, delay: 0.0, options:UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                }, completion:{(finished) in
                    self.layer.removeAllAnimations()
                })
        }
    }
        
    func closeVKPopoverAction(){
        
        if _POPOVER_ANIMATION == POPOVER_ANIMATION.popover_ANIMATION_CROSS_DISSOLVE{
        
            self.alpha = 1
            UIView.animate(withDuration: _animationDuration, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.alpha = 0
                self.removeFromSuperview()
                },  completion:{ (finished) in
                self.layer.removeAllAnimations()
                self.delegate.vkPopoverClose()
            })
        }
        else if _POPOVER_ANIMATION == POPOVER_ANIMATION.popover_ANIMATION_FADE_IN_OUT{
          
           
            UIView.animate(withDuration: _animationDuration, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { 
                self.transform = CGAffineTransform(scaleX: 3, y: 3)
                self.alpha = 0.0
                }, completion: { (finished) in
                    self.layer.removeAllAnimations()
                    self.removeFromSuperview()
                    self.delegate.vkPopoverClose()
            })

        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let view = touch.view
        
        if view!.tag != TAG_SUPER{
            return false
        }
        return true
    }
}
