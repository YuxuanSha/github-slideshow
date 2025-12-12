# Bagel AI Flutter 版本

## 📱 项目说明

这是 Bagel AI 的 Flutter 移动端实现，完全基于您提供的设计参考图的颜色方案。

### 🎨 颜色方案（基于参考图）

```dart
// 品牌色 - 青绿色 (Teal/Cyan)
static const Color brandCyan = Color(0xFF00D4D4);
static const Color brandTeal = Color(0xFF00CED1);

// 背景色 - 米白色
static const Color background = Color(0xFFF5F5F0);
static const Color cardBackground = Color(0xFFFFFBF5);

// 卡片渐变色
static const List<Color> gradientPeach = [
  Color(0xFFFFF8F0),  // 米黄色
  Color(0xFFFFF0E6),  // 奶白色
];

static const List<Color> gradientBlue = [
  Color(0xFFF0F9FF),
  Color(0xFFE8F4F8),
];

static const List<Color> gradientGreen = [
  Color(0xFFF0FDF4),
  Color(0xFFE8F5E9),
];
```

## 🚀 如何运行

### 1. 安装 Flutter

如果还没有安装 Flutter，请访问：https://flutter.dev/docs/get-started/install

### 2. 创建 Flutter 项目

```bash
# 进入项目目录
cd github-slideshow

# 检查 Flutter 环境
flutter doctor

# 获取依赖
flutter pub get
```

### 3. 运行项目

#### 在 iOS 模拟器上运行
```bash
flutter run -d ios
```

#### 在 Android 模拟器上运行
```bash
flutter run -d android
```

#### 在真机上运行
```bash
# 连接手机并开启开发者模式
flutter devices  # 查看可用设备
flutter run      # 运行在连接的设备上
```

## 📂 项目结构

```
github-slideshow/
├── lib/
│   └── main.dart          # 主应用代码
├── pubspec.yaml           # 项目配置
└── FLUTTER_README.md      # 本文档
```

## ✨ 已实现功能

### 1. 首页 (HomePage)
- ✅ 顶部导航栏（菜单 + Logo + 日历）
- ✅ 今日重点卡片（横向滚动）
  - 📬 待处理消息（米黄渐变）
  - 📅 今日日程（蓝色渐变）
  - ✅ 待办事项（绿色渐变）
- ✅ 发现瀑布流（2列网格）
  - 使用 Emoji 图标
  - 柔和渐变背景
  - 标签和时间戳

### 2. 灵动核心 (Smart Core)
- ✅ 青绿渐变圆形按钮
- ✅ 点击展开为输入框（动画流畅）
- ✅ 输入消息并跳转到聊天页
- ✅ 发光阴影效果

### 3. 侧边栏导航 (Drawer)
- ✅ 用户信息卡片（青色渐变背景）
- ✅ 菜单项：
  - 👤 个人中心
  - 🧠 历史记忆
  - 🔗 数据连接
  - ⚙️ 设置

### 4. 其他页面
- ✅ 聊天页面（Chat Page）
  - AI 消息气泡（白色 + 🥯 头像）
  - 用户消息气泡（青绿渐变）
- ✅ 日历页面（Calendar Page）
- ✅ 个人中心页面（Profile Page）
- ✅ 历史记忆页面（Memory Page）
- ✅ 数据连接页面（Connections Page）
- ✅ 设置页面（Settings Page）

## 🎯 核心特性

### 动画效果
```dart
// 灵动核心展开动画
AnimatedContainer(
  duration: const Duration(milliseconds: 400),
  curve: Curves.easeOutBack,  // 弹性缓动
  width: _isCoreExpanded ? 340 : 64,
  height: _isCoreExpanded ? 52 : 64,
)
```

### 渐变效果
```dart
// 卡片渐变
BoxDecoration(
  gradient: LinearGradient(
    colors: AppColors.gradientPeach,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.circular(24),
)
```

### 阴影效果
```dart
// 发光阴影
boxShadow: [
  BoxShadow(
    color: AppColors.brandCyan.withOpacity(0.3),
    blurRadius: 20,
    offset: const Offset(0, 8),
  ),
]
```

## 📱 设备兼容性

- ✅ iOS (iPhone 8 及以上)
- ✅ Android (Android 6.0 及以上)
- ✅ 支持各种屏幕尺寸

## 🎨 设计亮点

### 1. 颜色精准匹配参考图
- 青绿色 Logo (#00D4D4)
- 米黄色卡片渐变 (#FFF8F0 → #FFF0E6)
- 柔和的背景色 (#F5F5F0)

### 2. 大圆角设计
- 所有卡片使用 24px 圆角
- 按钮使用 32px 圆角
- 视觉柔和、友好

### 3. Emoji 优先
- 所有图标使用原生 Emoji
- 无需导入图标库
- 跨平台显示一致

### 4. 流畅动画
- 灵动核心使用弹性缓动曲线
- 页面切换使用 Material 风格过渡
- 所有交互都有视觉反馈

## 🔧 自定义修改

### 修改颜色
编辑 `lib/main.dart` 中的 `AppColors` 类：

```dart
class AppColors {
  static const Color brandCyan = Color(0xFF00D4D4);  // 修改品牌色
  // ...
}
```

### 修改卡片内容
修改 `_buildDailyBrief()` 方法中的卡片数据。

### 添加新页面
1. 创建新的 `StatelessWidget` 或 `StatefulWidget`
2. 在侧边栏添加导航项
3. 使用 `Navigator.push()` 进行跳转

## 🐛 已知问题

目前没有已知问题。如果发现问题，请检查：
1. Flutter SDK 版本是否 >= 3.0.0
2. 是否运行了 `flutter pub get`
3. 模拟器/真机是否正常连接

## 📝 下一步开发

### 短期
- [ ] 实现真实的日历组件
- [ ] 添加下拉刷新
- [ ] 实现消息详情页
- [ ] 添加搜索功能

### 中期
- [ ] 接入真实 AI API
- [ ] 实现语音录制
- [ ] 添加图片上传
- [ ] 本地数据持久化（SQLite）

### 长期
- [ ] 离线模式
- [ ] 多语言支持
- [ ] 深色模式
- [ ] Widget 插件

## 💡 技术栈

- **框架**: Flutter 3.x
- **语言**: Dart
- **状态管理**: setState (简单场景)
- **导航**: Navigator 2.0
- **UI**: Material Design + 自定义组件

## 📞 技术支持

如需帮助，请参考：
- [Flutter 官方文档](https://flutter.dev/docs)
- [Dart 语言指南](https://dart.dev/guides)
- [Material Design](https://material.io)

---

**版本**: 1.0.0
**创建日期**: 2025-12-12
**设计理念**: Less Noise, More Focus 🥯
