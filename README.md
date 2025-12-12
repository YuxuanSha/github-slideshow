# Bagel AI - Flutter Mobile App

🥯 你的第二大脑 - Less Noise, More Focus

## 项目简介

Bagel AI 是一款基于 Flutter 开发的移动端 AI 助手应用，旨在帮助用户管理信息、记忆和日程。

### 核心功能

- 📬 **智能推送中心**：重要消息聚合
- 🧠 **深度记忆系统**：个性化记忆管理
- 📅 **AI 日历**：智能日程管理
- 💬 **对话界面**：自然语言交互
- 🎙️ **灵动核心**：创新的输入交互方式

## 技术栈

- **框架**: Flutter 3.x
- **语言**: Dart
- **UI**: Material Design + 自定义组件
- **平台**: iOS & Android

## 快速开始

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- iOS: Xcode 14+ (macOS)
- Android: Android Studio

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/YuxuanSha/github-slideshow.git
cd github-slideshow
git checkout flutter-frontend
```

2. **安装依赖**
```bash
flutter pub get
```

3. **运行项目**
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# 或选择设备
flutter devices
flutter run
```

## 项目结构

```
.
├── lib/
│   └── main.dart          # 主应用入口
├── pubspec.yaml           # 项目配置文件
├── README.md              # 项目说明（本文件）
└── FLUTTER_GUIDE.md       # Flutter 开发指南
```

## 设计规范

### 颜色方案

```dart
// 品牌色 - 青绿色
brandCyan: #00D4D4
brandTeal: #00CED1

// 背景色 - 米白色
background: #F5F5F0
cardBackground: #FFFBF5

// 卡片渐变
gradientPeach: #FFF8F0 → #FFF0E6  // 米黄色
gradientBlue: #F0F9FF → #E8F4F8   // 淡蓝色
gradientGreen: #F0FDF4 → #E8F5E9  // 淡绿色
```

### 设计原则

- **大圆角**: 24-32px 圆角设计
- **Emoji 优先**: 使用原生 Emoji 作为图标
- **柔和渐变**: 使用温暖、柔和的渐变色
- **流畅动画**: 弹性缓动曲线
- **留白充足**: 大量的呼吸空间

## 核心功能

### 1. 首页 (HomePage)

- 顶部导航栏
- 今日重点卡片（横向滚动）
- 发现瀑布流（2列网格）
- 灵动核心浮动按钮

### 2. 灵动核心 (Smart Core)

创新的输入交互方式：
- 静止态：青绿渐变圆形按钮
- 展开态：白色输入框
- 流畅的展开/收起动画

### 3. 聊天界面 (ChatPage)

- AI 消息气泡（白色 + 🥯 头像）
- 用户消息气泡（青绿渐变）
- 自动滚动

### 4. 侧边栏导航 (Drawer)

- 👤 个人中心
- 🧠 历史记忆
- 🔗 数据连接
- ⚙️ 设置

## 开发指南

### 添加新页面

1. 在 `lib/main.dart` 中创建新的 Widget
2. 使用 `Navigator.push()` 进行导航
3. 遵循现有的设计规范

### 修改颜色

编辑 `AppColors` 类：

```dart
class AppColors {
  static const Color brandCyan = Color(0xFF00D4D4);
  // 修改颜色值
}
```

### 调试

```bash
# 热重载
r

# 热重启
R

# 查看日志
flutter logs
```

## 构建发布

### iOS

```bash
flutter build ios --release
```

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

## 贡献指南

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

## 联系方式

- 项目主页: [GitHub](https://github.com/YuxuanSha/github-slideshow)
- 分支: `flutter-frontend`

---

**版本**: 1.0.0
**更新日期**: 2025-12-12
**设计理念**: Less Noise, More Focus 🥯
