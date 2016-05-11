/**
 * ImageProcessor
 * by Chris Larsen
 */

import UIKit

public class ImageProcessor {
    
    let img: RGBAImage
    
    public init (img: RGBAImage) {
        self.img = img
    }
    
    // Takes an array of filters and returns the process RGBAImage
    public func process(filters: [Filters.Apply]) -> RGBAImage {
        
        var processedImg = img
        
        for filter in filters {
            
            switch filter {
            case Filters.Apply.Darken:
                processedImg = Filters.darken(img: processedImg)
                break
            case Filters.Apply.DoubleBrightness:
                processedImg = Filters.doubleBrightness(img: processedImg)
                break
            case Filters.Apply.Greyscale:
                processedImg = Filters.greyscale(img: processedImg)
                break
            case Filters.Apply.HighContrast:
                processedImg = Filters.highContrast(img: processedImg)
                break
            case Filters.Apply.Saturate:
                processedImg = Filters.saturate(img: processedImg)
                break
            }
            
        }
        
        return processedImg
    }
    
}
