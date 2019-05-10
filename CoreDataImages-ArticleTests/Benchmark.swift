//
//  Benchmark.swift
//  CoreDataImages-ArticleTests
//
//  Created by Vadym Bulavin on 5/10/19.
//  Copyright © 2019 Vadim Bulavin. All rights reserved.
//

import Foundation

struct Benchmark {
    
    static var iterationsPerDataPoint = 10
    static var dataPoints = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16_384, 32_768, 65_536, 131_072, 262_144, 524_288, 1_048_576]
    
    static func measureAverage(dataPoint: Int, block: () -> Void) -> TimeInterval {
        var accumulatedResult: TimeInterval = 0
        
        for _ in 0..<dataPoint {
            let result = measure {
                for _ in 0..<iterationsPerDataPoint {
                    block()
                }
            }
            accumulatedResult += result
        }
        
        return accumulatedResult / TimeInterval(iterationsPerDataPoint)
    }
    
    static func measure(block: () -> Void) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        block()
        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = endTime - startTime
        return totalTime
    }
}
