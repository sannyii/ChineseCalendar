# 禅历 - Mac App Store 上架清单

## ✅ 已创建的文件

| 文件 | 用途 |
|------|------|
| `Resources/Assets.xcassets/AppIcon.appiconset/` | App 图标 (1024x1024) |
| `Resources/ZenCalendar.entitlements` | App Sandbox 权限 |
| `Resources/Info.plist` | App 元数据配置 |

## 📋 App 信息

- **Bundle ID**: `com.sannyii.ZenCalendar`
- **App 名称**: 禅历
- **版本**: 1.0.0
- **最低系统**: macOS 13.0
- **分类**: 效率工具

## 🚀 下一步：Xcode 创建项目

由于 Swift Package 无法直接上架 App Store，需要用 Xcode 创建项目：

1. 打开 Xcode → File → New → Project
2. 选择 macOS → App
3. 设置：
   - Product Name: `ZenCalendar`
   - Bundle Identifier: `com.sannyii.ZenCalendar`
   - Team: 选择你的开发者账号
4. 将 `Sources/ZenCalendar/` 下的 Swift 文件拖入项目
5. 将 `Resources/` 下的文件拖入项目
6. Product → Archive → 上传到 App Store Connect

## 📝 App Store Connect 需要

- **截图**: 1 张以上 (建议 1280x800 或 1440x900)
- **描述**: 简短描述 App 功能
- **隐私政策**: 可用 GitHub Pages 托管简单页面
