/**
 * Filters 
 * by Chris Larsen
 */
import UIKit

/**
 * Collection of image filters
 */

public class Filters {
    
    //MARK: Class Enums
    
    public enum Apply {
        case Greyscale
        case DoubleBrightness
        case Darken
        case HighContrast
        case Saturate
    }
    
    enum Constants {
        case avgRed
        case avgGreen
        case avgBlue
    }
    
    //MARK: Filters
    
    /**
     * Makes image greyscale
     */
    static public func greyscale (img img:RGBAImage) -> RGBAImage {
        var img = img
        
        for y in 0..<img.height {
            for x in 0..<img.width {
                let index = y * img.width + x
                var pixel = img.pixels[index]
                
                let red = UInt16(pixel.red)
                let green = UInt16(pixel.green)
                let blue = UInt16(pixel.blue)
                
                let gray: UInt16 = (red + green + blue) / 3
                
                pixel.red = UInt8(gray)
                pixel.green = UInt8(gray)
                pixel.blue = UInt8(gray)
                
                img.pixels[index] = pixel
            }
        }
        
        return img
    }
    
    /**
     * Brighten an image
     */
    static public func doubleBrightness(img img:RGBAImage) -> RGBAImage {
        var img = img
        
        for y in 0..<img.height {
            for x in 0..<img.width {
                let index = y * img.width + x
                var pixel = img.pixels[index]
                
                pixel.red = UInt8(max(min(255, Int(pixel.red) * 2), 0))
                pixel.green = UInt8(max(min(255, Int(pixel.green)  * 2), 0))
                pixel.blue = UInt8(max(min(255, Int(pixel.blue) * 2), 0))
                
                img.pixels[index] = pixel
            }
        }
        
        return img
    }
    
    /**
     * Darken an image
     */
    static public func darken(img img:RGBAImage) -> RGBAImage {
        var img = img
        let darkness = 50
        
        for y in 0..<img.height {
            for x in 0..<img.width {
                let index = y * img.width + x
                var pixel = img.pixels[index]
                
                pixel.red = UInt8(max(min(255, Int(pixel.red) - darkness), 0))
                pixel.green = UInt8(max(min(255, Int(pixel.green) - darkness), 0))
                pixel.blue = UInt8(max(min(255, Int(pixel.blue) - darkness), 0))
                
                img.pixels[index] = pixel
            }
        }
        
        return img
    }
    
    /**
     * Increases img contrast
     */
    static public func highContrast(img img:RGBAImage) -> RGBAImage {
        var img = img
        let contrast = 2
        
        let avgs = Filters.getAvgs(img: img)
        let avgRed = avgs[Constants.avgRed]
        let avgGreen = avgs[Constants.avgGreen]
        let avgBlue = avgs[Constants.avgBlue]
        
        // Adjust contrast for each color
        for y in 0..<img.height {
            for x in 0..<img.width {
                let index = y * img.width + x
                var pixel = img.pixels[index]
                
                let redDelta = Int(pixel.red) - avgRed!
                let greenDelta = Int(pixel.green) - avgGreen!
                let blueDelta = Int(pixel.blue) - avgBlue!
                
                pixel.red = UInt8(max(min(255, avgRed! + contrast * redDelta), 0))
                pixel.green = UInt8(max(min(255, avgGreen!  + contrast * greenDelta), 0))
                pixel.blue = UInt8(max(min(255, avgBlue! + contrast * blueDelta), 0))
                
                img.pixels[index] = pixel
            }
        }
        
        return img
    }
    
    /**
     * Increases img saturation
     */
    static public func saturate(img img:RGBAImage) -> RGBAImage {
        var img = img
        let saturation = 30
        
        let avgs = Filters.getAvgs(img: img)
        let avgRed = avgs[Constants.avgRed]
        let avgGreen = avgs[Constants.avgGreen]
        let avgBlue = avgs[Constants.avgBlue]
        
        // Increase primary color
        for y in 0..<img.height {
            for x in 0..<img.width {
                let index = y * img.width + x
                var pixel = img.pixels[index]
                
                // Red is primary
                if avgRed > avgGreen && avgRed > avgBlue
                {
                    pixel.red = UInt8(max(min(255, Int(pixel.red) + saturation), 0))
                    
                    if avgGreen > avgBlue
                    {
                        pixel.green = UInt8(max(min(255, Int(pixel.green) - saturation), 0))
                    }
                    else
                    {
                        pixel.blue = UInt8(max(min(255, Int(pixel.blue) - saturation), 0))
                    }
                }
                
                // Green is primary
                if avgGreen > avgRed && avgGreen > avgBlue
                {
                    pixel.green = UInt8(max(min(255, Int(pixel.green) + saturation), 0))
                    
                    if avgRed > avgBlue
                    {
                        pixel.red = UInt8(max(min(255, Int(pixel.red) - saturation), 0))
                    }
                    else
                    {
                        pixel.blue = UInt8(max(min(255, Int(pixel.blue) - saturation), 0))
                    }
                }
                
                // Blue is primary
                if avgBlue > avgGreen && avgBlue > avgRed
                {
                    pixel.blue = UInt8(max(min(255, Int(pixel.red) + saturation), 0))
                    
                    if avgGreen > avgRed
                    {
                        pixel.green = UInt8(max(min(255, Int(pixel.green) - saturation), 0))
                    }
                    else
                    {
                        pixel.red = UInt8(max(min(255, Int(pixel.red) - saturation), 0))
                    }
                }
                
                img.pixels[index] = pixel
            }
        }
        
        return img
    }
    
    
    // MARK: Util methods
    /**
    * Returns avgs of colors in img
    **/
    
    static func getAvgs(img img: RGBAImage) -> [Constants:Int] {
        
        var img = img
        
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        
        // Get totals for each color
        for y in 0..<img.height {
            for x in 0..<img.width {
                let index = y * img.width + x
                var pixel = img.pixels[index]
                
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        
        // Create averages
        let pixelCount = img.width * img.height
        let avgRed = totalRed / pixelCount
        let avgGreen = totalGreen / pixelCount
        let avgBlue = totalBlue / pixelCount
        
        return [Constants.avgRed: avgRed, Constants.avgGreen:avgGreen, Constants.avgBlue:avgBlue]
    }
    
}