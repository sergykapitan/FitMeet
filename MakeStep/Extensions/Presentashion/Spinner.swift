//
//  Spinner.swift
//  MakeStep
//
//  Created by Sergey on 23.05.2022.
//

import UIKit

open class Spinner {
    internal static var spinner: UIActivityIndicatorView?
    public static var style: UIActivityIndicatorView.Style = .large
    public static var baseBackColor = UIColor.black.withAlphaComponent(0.5)
    public static var baseColor = UIColor.white

    public static func start(style: UIActivityIndicatorView.Style = style, backgroundColor: UIColor = baseBackColor, color: UIColor = baseColor) {
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner?.backgroundColor = backgroundColor
            spinner?.style = style
            spinner?.color = color
            window.addSubview(spinner!)
            spinner?.startAnimating()
        }
    }

    public static func stop() {
        if spinner != nil {
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
            spinner = nil
        }
    }
}
