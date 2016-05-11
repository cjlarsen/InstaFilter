/**
 * ImageProcessor Assignment by Chris Larsen
 * 
 * All Filters in Sources/Filters.swift
 * Image Processor in Sources/ImageProcessor.swift
 *
 * To view open left sidebar in playground
 */

import UIKit

let image = UIImage(named: "sample.png")!
let myRGBA = RGBAImage (image: image)!

// Initialize our image processor
let imageProcessor: ImageProcessor = ImageProcessor(img: myRGBA)

// Process the image
// Available filters are:
// - Filters.Apply.Darken
// - Filters.Apply.DoubleBrightness
// - Filters.Apply.Greyscale
// - Filters.Apply.HighContrast
// - Filters.Apply.Saturate

let processedImage = imageProcessor.process([
    Filters.Apply.Saturate,
    Filters.Apply.Darken,
    Filters.Apply.HighContrast
    ]).toUIImage()