//
//  Benchmark.swift
//  CoreDataImages-ArticleTests
//
//  Created by Vadym Bulavin on 5/10/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import Foundation

struct Benchmark {
    
    static var numberOfIterations = 100
    
    static func measureAverage(prepare: () -> Void, block: () -> Void) -> TimeInterval {
        var accumulatedResult: TimeInterval = 0
        
        for _ in 0..<numberOfIterations {
            prepare()
            accumulatedResult += measure(block: block)
        }
        
        return accumulatedResult / TimeInterval(numberOfIterations)
    }
    
    static func measure(block: () -> Void) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        block()
        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = endTime - startTime
        return totalTime
    }
}

struct Measurement {
    let sizeInBytes: Int
    let duration: TimeInterval
}
