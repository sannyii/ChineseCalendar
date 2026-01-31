import SwiftUI
import AppKit

// Custom transparent panel that can achieve Ghostty-style transparency
class TransparentPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
    
    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        // Critical for transparency
        isOpaque = false
        backgroundColor = .clear
        
        // Window behavior
        level = .floating
        hasShadow = false  // No shadow to avoid extra layer
        isMovableByWindowBackground = false
        
        // Don't show in mission control / expose
        collectionBehavior = [.canJoinAllSpaces, .transient]
        
        // Ensure content view is also transparent and clipped
        contentView?.wantsLayer = true
        contentView?.layer?.backgroundColor = NSColor.clear.cgColor
        contentView?.layer?.cornerRadius = 12
        contentView?.layer?.masksToBounds = true
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var panel: TransparentPanel!
    var eventMonitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize Status Item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            let image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "Calendar")
            image?.isTemplate = true  // Ensures proper dark/light mode handling
            // Configure symbol to be slightly larger
            let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .regular)
            button.image = image?.withSymbolConfiguration(config)
            button.action = #selector(handleStatusItemClick(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Initialize Transparent Panel
        let panelSize = NSSize(width: 320, height: 560)
        panel = TransparentPanel(contentRect: NSRect(origin: .zero, size: panelSize))
        
        // Host SwiftUI view
        let hostingView = NSHostingView(rootView: MainView())
        hostingView.frame = NSRect(origin: .zero, size: panelSize)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor
        
        // Frosted glass effect view (Apple-style blur)
        let visualEffectView = NSVisualEffectView(frame: NSRect(origin: .zero, size: panelSize))
        visualEffectView.material = .hudWindow  // Frosted glass material
        visualEffectView.blendingMode = .behindWindow  // Blend with desktop behind
        visualEffectView.state = .active
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 12
        visualEffectView.layer?.masksToBounds = true
        
        // Add SwiftUI view on top of blur
        visualEffectView.addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor)
        ])
        
        panel.contentView = visualEffectView
        
        // Register panel with manager for dynamic resizing
        PanelManager.shared.panel = panel
    }
    
    @objc func handleStatusItemClick(_ sender: AnyObject?) {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            // Right Click -> Show Menu
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "Quit ZenCalendar", action: #selector(terminateApp), keyEquivalent: "q"))
            
            statusItem.menu = menu
            statusItem.button?.performClick(nil)
            statusItem.menu = nil
        } else {
            // Left Click -> Toggle Panel
            if panel.isVisible {
                hidePanel()
            } else {
                showPanel()
            }
        }
    }
    
    func showPanel() {
        guard let button = statusItem.button else { return }
        
        // Position panel below status item
        let buttonRect = button.window?.convertToScreen(button.convert(button.bounds, to: nil)) ?? .zero
        let panelX = buttonRect.midX - panel.frame.width / 2
        let panelY = buttonRect.minY - panel.frame.height - 4
        
        panel.setFrameOrigin(NSPoint(x: panelX, y: panelY))
        panel.makeKeyAndOrderFront(nil)
        
        // Monitor clicks outside to dismiss
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            self?.hidePanel()
        }
    }
    
    func hidePanel() {
        panel.orderOut(nil)
        
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
    
    @objc func terminateApp() {
        NSApplication.shared.terminate(nil)
    }
}
