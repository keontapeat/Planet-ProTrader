//
//  PerformanceMonitor.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer on 1/25/25.
//

import Foundation
import SwiftUI
import os.log

@MainActor
class PerformanceMonitor: ObservableObject {
    static let shared = PerformanceMonitor()
    
    @Published var isMonitoring = false
    @Published var currentFPS: Double = 60.0
    @Published var memoryUsage: Double = 0.0
    @Published var cpuUsage: Double = 0.0
    @Published var performanceScore: Double = 100.0
    
    private var displayLink: CADisplayLink?
    private var fpsCounter = 0
    private var lastTimestamp: CFTimeInterval = 0
    private let logger = Logger(subsystem: "com.planetprotrader.performance", category: "monitoring")
    
    private init() {}
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        logger.info("🚀 Performance monitoring started")
        
        setupDisplayLink()
        startSystemMetricsTimer()
    }
    
    func stopMonitoring() {
        isMonitoring = false
        displayLink?.invalidate()
        displayLink = nil
        logger.info("⏹️ Performance monitoring stopped")
    }
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateFPS))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    @objc private func updateFPS(_ displayLink: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = displayLink.timestamp
            return
        }
        
        fpsCounter += 1
        
        let elapsed = displayLink.timestamp - lastTimestamp
        if elapsed >= 1.0 {
            currentFPS = Double(fpsCounter) / elapsed
            fpsCounter = 0
            lastTimestamp = displayLink.timestamp
            
            updatePerformanceScore()
        }
    }
    
    private func startSystemMetricsTimer() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] timer in
            guard let self = self, self.isMonitoring else {
                timer.invalidate()
                return
            }
            
            Task { @MainActor in
                self.updateSystemMetrics()
            }
        }
    }
    
    private func updateSystemMetrics() {
        memoryUsage = getMemoryUsage()
        cpuUsage = getCPUUsage()
        updatePerformanceScore()
        
        // Log performance issues
        if performanceScore < 70 {
            logger.warning("⚠️ Performance degradation detected: Score \(self.performanceScore)")
            
            Task {
                await AutoDebugSystem.shared.logAppError(
                    "performance",
                    message: "Performance score dropped to \(performanceScore)"
                )
            }
        }
    }
    
    private func getMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMemory = Double(info.resident_size)
            let totalMemory = Double(ProcessInfo.processInfo.physicalMemory)
            return (usedMemory / totalMemory) * 100
        }
        
        return 0.0
    }
    
    private func getCPUUsage() -> Double {
        var info = processor_info_array_t.allocate(capacity: 1)
        var numCpuInfo: mach_msg_type_number_t = 0
        var numCpus: natural_t = 0
        
        let result = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCpus, &info, &numCpuInfo)
        
        if result == KERN_SUCCESS {
            // Simplified CPU calculation
            return Double.random(in: 5...25) // Placeholder for real CPU usage
        }
        
        return 0.0
    }
    
    private func updatePerformanceScore() {
        var score = 100.0
        
        // FPS impact
        if currentFPS < 30 {
            score -= 30
        } else if currentFPS < 45 {
            score -= 15
        } else if currentFPS < 55 {
            score -= 5
        }
        
        // Memory impact
        if memoryUsage > 80 {
            score -= 25
        } else if memoryUsage > 60 {
            score -= 10
        } else if memoryUsage > 40 {
            score -= 5
        }
        
        // CPU impact
        if cpuUsage > 70 {
            score -= 20
        } else if cpuUsage > 50 {
            score -= 10
        } else if cpuUsage > 30 {
            score -= 5
        }
        
        performanceScore = max(0, score)
    }
    
    func getPerformanceReport() -> String {
        return """
        📊 PERFORMANCE REPORT:
        
        🖼️ FPS: \(String(format: "%.1f", currentFPS))
        🧠 Memory: \(String(format: "%.1f", memoryUsage))%
        ⚡ CPU: \(String(format: "%.1f", cpuUsage))%
        
        📈 Overall Score: \(String(format: "%.0f", performanceScore))/100
        
        Status: \(performanceScore >= 80 ? "🟢 Excellent" : performanceScore >= 60 ? "🟡 Good" : "🔴 Needs Optimization")
        """
    }
    
    deinit {
        stopMonitoring()
    }
}