# 禅历 ZenCalendar

[English Readme](README.md)

一个极简、优雅的 macOS 菜单栏中国农历日历。采用现代毛玻璃设计风格，完美融合原生系统体验。

![Screenshot](screenshot.png)

## ⚠️ 重要说明：“应用已损坏” 解决方案

由于本项目没有购买 Apple 开发者账号（$99/年）进行公证，macOS Gatekeeper 安全机制可能会拦截应用。如果你打开时提示 **“禅历”已损坏，无法打开**，请尝试以下方法：

**方法一：右键打开（推荐）**
1. 在 Finder (访达) 中找到这一应用。
2. **按住 Control 键并右键点击**应用图标。
3. 在菜单中选择 **“打开”**。
4. 在弹出的确认框中点击 **“打开”**。

**方法二：终端修复（彻底解决）**
如果上述方法无效，请在“终端”应用中运行以下命令（直接复制粘贴）：
```bash
xattr -cr /Applications/禅历.app
```
*(如果你的应用不在应用程序文件夹，请相应修改路径)*

---

## 功能特性

- 📅 **菜单栏日历** - 点击菜单栏图标快速查看。
- 🌙 **农历支持** - 完整的农历日期显示。
- 🎉 **节假日** - 包含中国传统节日和法定节假日（带休/班标记）。
- 🌿 **二十四节气** - 精确显示节气信息。
- 📖 **每日宜忌** - 每日黄历运势指南。
- 🎨 **毛玻璃 UI** - 类似原生控制中心的磨砂玻璃效果。

## 系统要求

- macOS 13.0+

## 安装方法

### 下载安装包 (DMG)
前往 [Releases 页面](https://github.com/sannyii/ChineseCalendar/releases) 下载最新版。

1. 双击打开 `.dmg` 文件。
2. 将 **禅历** 图标拖入 **Applications** (应用程序) 文件夹。
3. **注意**：如果无法打开，请参考上方的“应用已损坏”解决方案。

### 源码编译

```bash
git clone https://github.com/sannyii/ChineseCalendar.git
cd ChineseCalendar/ZenCalendar
swift build -c release
```

## 使用说明

- **左键点击图标**：显示/隐藏日历。
- **点击顶部标题**：打开日期选择器，快速跳转年份/月份。
- **右键点击图标**：退出应用。

## 许可证

MIT License
