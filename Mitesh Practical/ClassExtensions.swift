//
//  ClassExtensions.swift
//  Mitesh Practical
//
//  Created by MiTESH on 17/07/20.
//  Copyright © 2020 Mrs Product. All rights reserved.
//

import UIKit

//MARK: Global variable
let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!


extension UIView {
    //Set view corner radius and border
    func setBorder(ofWidth width:CGFloat?, withColor color:UIColor?, ofRadius radius: CGFloat?) {
        self.layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor
        self.layer.borderWidth = width ?? 0.5
        self.layer.cornerRadius = radius ?? 5.0
        self.clipsToBounds = true
    }
}

extension UIImageView {
    //Download image from Web URL
    func downloadImageFrom(link:URL, saveAt path: String) {
        URLSession.shared.dataTask( with: link, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    // Set web image
                    self.image = UIImage(data: data)
                    // Save to local
                    self.image?.saveToDocuments(filePath: path)
                }else if FileManager.default.fileExists(atPath: path){
                    // If failed to get data or offline, get data from local path
                    self.image = UIImage(contentsOfFile: path)
                }
            }
        }).resume()
    }
}

extension UIImage {

    func saveToDocuments(filePath:String) {
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                //atomic to overwrite old file
                try data.write(to: URL(fileURLWithPath: filePath), options: .atomic)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }

}


extension Date {

    //Compare date with current date and get elapsed time
    func getElapsedInterval() -> String {

        if let interval = Calendar.current.dateComponents([.year], from: self, to: Date()).year, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "year" :
            "\(interval)" + " " + "years"
        }

        if  let interval = Calendar.current.dateComponents([.month], from: self, to: Date()).month, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "month" :
            "\(interval)" + " " + "months"
        }


        if let interval = Calendar.current.dateComponents([.day], from: self, to: Date()).day, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "day" :
            "\(interval)" + " " + "days"
        }

        
        if let interval = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour" :
            "\(interval)" + " " + "hours"
        }


        if let interval = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "minute" :
            "\(interval)" + " " + "minutes"
        }

        return "a moment ago"
    }
}

extension Int64{
    //To set suffix to large integer number
    func suffixNumber() -> String {
        var num = Double(self)
        
        let sign = ((num < 0) ? "-" : "" )

        num = fabs(num);

        if (num < 1000.0){
            return "\(sign)\(num)";
        }

        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));

        let units:[String] = ["K","M","G","T","P","E"];

        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;

        return "\(sign)\(roundedNum)\(units[exp-1])";
    }
}
