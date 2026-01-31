import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize Status Item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "Calendar")
            button.action = #selector(handleStatusItemClick(_:))
            // Critical: Enable right click detection
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Initialize Popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 320, height: 480)
        popover.behavior = .transient
        // Important: .hudWindow style often brings its own dark background. 
        // We use .popover or default and rely on our SwiftUI view's GlassBackgroundView for the effect.
        // However, standard NSPopover enforces a look. 
        // To get "Transparency", we might need to rely on the content view doing the work.
        popover.contentViewController = NSHostingController(rootView: MainView())
        
        // Try to minimize popover's default background if possible, 
        // though standard NSPopover is somewhat opinionated.
        popover.appearance = NSAppearance(named: .vibrantLight) 
    }
    
    @objc func handleStatusItemClick(_ sender: AnyObject?) {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            // Right Click -> Show Menu
            let menu = NSMenu()
            
            // Add Quit Option
            menu.addItem(NSMenuItem(title: "Quit ZenCalendar", action: #selector(terminateApp), keyEquivalent: "q"))
            
            statusItem.menu = menu
            statusItem.button?.performClick(nil) // Trigger the menu
            statusItem.menu = nil // Reset so prompt doesn't stick
        } else {
            // Left Click -> Toggle Popover
            if popover.isShown {
                popover.performClose(sender)
            } else {
                if let button = statusItem.button {
                    popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                    // Force transparent background logic again
                    // The MainView's TransparentWindowBackground helper handles the window transparency
                }
            }
        }
    }
    
    @objc func terminateApp() {
        NSApplication.shared.terminate(nil)
    }
}
