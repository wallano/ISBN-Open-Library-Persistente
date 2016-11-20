//
//  ProgressView.swift
//  Consulta Persistente ISBN
//
//  Created by Walter Llano on 20/11/2016.
//  Copyright © 2016 Walter Llano. All rights reserved.
//

import UIKit

public class ProgressView {

   private var containerView = UIView()
   private var progressView = UIView()
   private var activityIndicator = UIActivityIndicatorView()

   public class var sharedInstance: ProgressView {

      struct Static {

         static let instance: ProgressView = ProgressView()
      }

      return Static.instance
   }

   public func showProgressView(_ view: UIView) {

      containerView.frame = view.frame
      containerView.center = view.center
      containerView.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.3)

      progressView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
      progressView.center = view.center
      progressView.backgroundColor = UIColor(hex: 0x444444, alpha: 0.7)
      progressView.clipsToBounds = true
      progressView.layer.cornerRadius = 10

      activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
      activityIndicator.activityIndicatorViewStyle = .whiteLarge
      activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)

      progressView.addSubview(activityIndicator)
      containerView.addSubview(progressView)
      view.addSubview(containerView)

      activityIndicator.startAnimating()
   }

   public func hideProgressView() {

      activityIndicator.stopAnimating()
      containerView.removeFromSuperview()
   }
}

extension UIColor {

   convenience init(hex: UInt32, alpha: CGFloat) {

      let r = CGFloat((hex & 0xFF0000) >> 16)/256.0
      let g = CGFloat((hex & 0xFF00) >> 8)/256.0
      let b = CGFloat(hex & 0xFF)/256.0

      self.init(red: r, green: g, blue: b, alpha: alpha)
   }
}
