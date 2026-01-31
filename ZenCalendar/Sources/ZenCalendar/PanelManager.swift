import Foundation
import AppKit

/// Shared manager to allow SwiftUI views to resize the panel
class PanelManager: ObservableObject {
    static let shared = PanelManager()
    
    weak var panel: NSPanel?
    
    private init() {}
    
    /// Updates panel height to a specific value
    func updateHeight(_ height: CGFloat) {
        guard let panel = panel else { return }
        
        let currentFrame = panel.frame
        
        // Only update if difference is significant to avoid infinite loops
        if abs(currentFrame.height - height) < 1 { return }
        
        // Animate from top (menu bar), so adjust origin
        let newOrigin = NSPoint(
            x: currentFrame.origin.x,
            y: currentFrame.origin.y + currentFrame.height - height
        )
        
        let newFrame = NSRect(origin: newOrigin, size: NSSize(width: currentFrame.width, height: height))
        
        // Animate the resize
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            panel.animator().setFrame(newFrame, display: true)
        }
    }
}
