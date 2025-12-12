# Bagel AI - 灵动核心 (Smart Core) 设计文档

## 🌟 设计概念

"灵动核心"是 Bagel AI 的终极交互中枢，灵感来源于：
- 🔮 **钢铁侠反应堆**：空心圆环 + 核心光晕
- 🎙️ **Siri 球体**：呼吸动效 + 声波可视化
- 💧 **水银流体**：流畅的形态变换

---

## 📐 视觉设计规范

### 1. 基础形态（静止态）

#### 结构层次
```
┌─────────────────────────────────┐
│    外层：发光圆环 (Glowing Ring)   │
│    ├─ 2px 青色边框                │
│    ├─ 外发光 (0-40px)            │
│    └─ 内发光 (半透明)             │
│                                   │
│    中层：玻璃背景 (Glass Layer)    │
│    ├─ 磨砂质感                    │
│    ├─ backdrop-filter: blur      │
│    └─ 半透明 rgba(0,217,255,0.05)│
│                                   │
│    内层：核心光点 (Core Light)     │
│    ├─ 12px 发光球体               │
│    ├─ 径向渐变                    │
│    └─ 脉冲动画 (2s 循环)          │
└─────────────────────────────────┘
```

#### 色彩系统
```css
--color-brand-primary: #00D9FF;        /* 青色 - 主色调 */
--color-brand-secondary: #00FFA3;      /* 绿色 - 渐变辅助 */
--color-brand-glow: rgba(0,217,255,0.6); /* 发光效果 */
--color-brand-dim: rgba(0,217,255,0.2);  /* 内发光 */
```

### 2. 核心动画效果

#### A. 呼吸灯效果 (Breathing Glow)
```css
@keyframes breathingGlow {
    0%, 100% {
        box-shadow: 0 0 20px var(--color-brand-glow);
        opacity: 1;
    }
    50% {
        box-shadow: 0 0 40px var(--color-brand-glow);
        opacity: 0.8;
    }
}
/* 周期: 3秒 */
```

#### B. 核心脉冲 (Core Pulse)
```css
@keyframes corePulse {
    0%, 100% {
        transform: scale(1);
        opacity: 1;
    }
    50% {
        transform: scale(1.5);
        opacity: 0.6;
    }
}
/* 周期: 2秒 */
```

#### C. 声波动画 (Sound Wave)
```css
5根波形条，高度: 12px, 20px, 16px, 24px, 18px
延迟: 0s, 0.1s, 0.2s, 0.3s, 0.4s
动画: 上下缩放 (0.5x ~ 1.5x)
周期: 1秒
```

---

## 🎯 交互逻辑

### 三种主要状态

| 状态 | 触发方式 | 视觉变化 | 时长 |
|------|----------|----------|------|
| **静止态** | 默认 | 圆形 + 呼吸灯 | - |
| **输入态** | 点按 (Tap) | 横向展开为矩形 | 0.4s |
| **录音态** | 长按 (Long Press > 500ms) | 放大 1.2x + 声波 | - |

### 详细交互流程

#### 1️⃣ 点按 (Tap) → 文本输入模式

**时间线**：
```
0ms:    用户点击 → 触发点击事件
0-10ms: 创建水波纹扩散效果 (Ripple)
10ms:   开始形变动画
        ├─ 宽度: 64px → 320px
        ├─ 高度: 64px → 48px
        └─ 圆角: 50% → 24px
400ms:  动画完成
        ├─ 输入框 opacity: 0 → 1
        ├─ 核心光点隐藏
        └─ 键盘弹出，光标闪烁
```

**动画曲线**: `cubic-bezier(0.68, -0.55, 0.265, 1.55)` (弹性缓动)

**收起逻辑**:
- 输入框失焦 + 内容为空 → 200ms 后收回
- 发送消息 → 立即收回并跳转对话页

#### 2️⃣ 长按 (Long Press) → 语音录制模式

**时间线**：
```
0ms:     touchstart 事件
         ├─ 记录触摸起点 (x, y)
         ├─ 创建水波纹效果
         └─ 启动 500ms 定时器

500ms:   定时器触发 → 进入录音状态
         ├─ transform: scale(1.2)
         ├─ 边缘线条变粗
         ├─ 显示声波动画 (5根波形条)
         ├─ 震动反馈 (50ms)
         └─ 屏幕上方显示 "正在录音..."

持续:    touchmove 事件
         └─ 实时检测滑动方向 (见下节)

结束:    touchend 事件
         ├─ 根据 currentGesture 执行操作
         ├─ 恢复原始大小
         └─ 隐藏手势图标
```

#### 3️⃣ 长按滑动 → 手势操作

**手势检测阈值**: 60px

**手势判断逻辑**:
```javascript
const deltaX = touchX - touchStartX;
const deltaY = touchStartY - touchY;  // 上滑为正

if (Math.abs(deltaX) > Math.abs(deltaY)) {
    // 水平滑动占主导
    if (deltaX < -60px) → 左滑 (Add Image)
    if (deltaX > 60px)  → 右滑 (Lock Recording)
} else {
    // 垂直滑动占主导
    if (deltaY > 60px)  → 上滑 (Cancel)
}
```

**三个方向的交互**:

| 方向 | 图标 | 位置 | 触发效果 |
|------|------|------|----------|
| **⬅️ 左滑** | 📷 相机 | 左下角 (left: 40px) | 打开相册/相机 |
| **➡️ 右滑** | 🔒 锁定 | 右下角 (right: 40px) | 锁定录音模式 |
| **⬆️ 上滑** | 🗑️ 垃圾桶 | 顶部居中 (top: 30%) | 取消录音 |

**视觉反馈**:
- 手指接近图标 → 图标放大 1.3x + 发光
- 松手时达到阈值 → 执行对应操作
- 未达到阈值 → 橡皮筋回弹

---

## 🎨 动效实现细节

### 1. 流体变形 (Morphing)

**关键**: 使用 CSS `transition` 而非 `animation`，保证可中断性

```css
.smart-core {
    width: 64px;
    height: 64px;
    transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

.smart-core.expanded {
    width: 320px;
    height: 48px;
    border-radius: var(--radius-lg);
}
```

**为什么这样设计？**
- ✅ 水银般流畅
- ✅ 支持中途中断
- ✅ 自动处理边缘圆角过渡

### 2. 粒子效果 (Ripple)

**触发时机**: 每次 `touchstart`

**实现原理**:
```javascript
function createRipple(x, y) {
    const ripple = document.createElement('div');
    ripple.className = 'ripple';

    // 根据触摸点计算位置
    const rect = smartCore.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height) * 2;

    ripple.style.left = (x - rect.left - size / 2) + 'px';
    ripple.style.top = (y - rect.top - size / 2) + 'px';

    // 0.6s 后自动移除
    setTimeout(() => ripple.remove(), 600);
}
```

### 3. 阻尼回弹 (Damping)

**场景**: 手势未达到阈值时松手

**实现**:
- 移除 `active-hint` class → 图标自动缩小
- CSS `transition` 的 `cubic-bezier` 提供缓动感
- 无需额外 JS 控制

### 4. 触觉反馈 (Haptic Feedback)

| 场景 | 震动模式 | 时长 |
|------|----------|------|
| 点击 | `vibrate(10)` | 10ms |
| 开始录音 | `vibrate(50)` | 50ms |
| 取消录音 | `vibrate([50, 100, 50])` | 双次震动 |
| 锁定录音 | `vibrate([30, 50, 30])` | 三段式 |

---

## 🔧 技术实现架构

### HTML 结构

```html
<div class="smart-core" id="smartCore">
    <!-- 外层发光环 -->
    <div class="core-ring"></div>

    <!-- 中层玻璃 -->
    <div class="core-glass"></div>

    <!-- 内层光点 -->
    <div class="core-light"></div>

    <!-- 声波可视化 (录音时显示) -->
    <div class="sound-waves">
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
    </div>

    <!-- 文本输入 (展开时显示) -->
    <input type="text" class="core-input" id="coreInput">
</div>
```

### JavaScript 状态机

```javascript
State Management:
├─ isExpanded: boolean      // 是否展开为输入框
├─ isRecording: boolean     // 是否正在录音
├─ currentGesture: string   // 当前手势 ('image'|'lock'|'cancel'|null)
└─ longPressTimer: number   // 长按定时器 ID

Event Handlers:
├─ handleTouchStart()   → 记录起点 + 启动定时器
├─ handleTouchMove()    → 检测手势方向 + 更新图标
├─ handleTouchEnd()     → 执行对应操作 + 清理状态
└─ handleClick()        → 桌面端点击 → 展开输入框

Core Functions:
├─ expandToInput()      → 展开为输入框
├─ collapseFromInput()  → 收回为圆形
├─ startRecording()     → 开始录音
├─ stopRecording()      → 发送语音
├─ lockRecording()      → 锁定录音
├─ cancelRecording()    → 取消录音
└─ addImage()          → 添加图片
```

---

## 🎬 使用演示

### 桌面端测试
1. 打开 `bagel-ai-smart-core.html`
2. 点击底部的发光圆环 → 观察流体变形
3. 输入文字并按回车 → 跳转到对话页

### 移动端测试（推荐）
1. 使用 Chrome DevTools 设备模拟器 (iPhone 12 Pro)
2. **点按**: 圆环展开为输入框
3. **长按 0.5秒**: 进入录音状态 (声波动画)
4. **长按后左滑**: 📷 图标高亮
5. **长按后右滑**: 🔒 图标高亮
6. **长按后上滑**: 🗑️ 图标高亮 (背景变红)

---

## 🌈 设计亮点总结

| 亮点 | 设计意图 | 技术实现 |
|------|----------|----------|
| **空心圆环** | 科技感、未来感 | CSS `border` + `box-shadow` |
| **呼吸灯** | 拟人化，暗示"活着" | `@keyframes` 3秒循环 |
| **核心光点** | "智能中枢"的视觉隐喻 | 径向渐变 + 脉冲动画 |
| **流体变形** | 水银般流畅 | `cubic-bezier` 弹性曲线 |
| **声波可视化** | 让用户"看到"AI在听 | 5根波形条交错动画 |
| **水波纹** | 物理反馈感 | 动态创建 DOM + `transform: scale` |
| **手势图标** | 功能发现性 (Discoverability) | 滑动时动态显示 + 高亮 |
| **触觉震动** | 多感官体验 | `navigator.vibrate()` API |

---

## 🚀 与前版本对比

| 维度 | V2.0 (橙色实心按钮) | Smart Core (灵动核心) |
|------|---------------------|----------------------|
| **视觉** | 实心橙色圆形 | 空心青色圆环 + 光晕 |
| **动效** | 呼吸动画 | 呼吸灯 + 脉冲 + 声波 |
| **变形** | 无变形 | 流体变形 (圆→矩形) |
| **手势反馈** | 静态提示 | 动态图标 + 高亮 |
| **科技感** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

---

## 📋 未来增强方向

### 短期（1-2周）

- [ ] **实时音量可视化**: 声波高度根据麦克风音量动态调整
- [ ] **粒子爆炸效果**: 发送消息时的粒子扩散动画
- [ ] **颜色主题切换**: 支持青色/橙色/紫色等多种主题

### 中期（1个月）

- [ ] **3D 旋转效果**: 使用 CSS `perspective` 实现伪 3D
- [ ] **AI 情绪反馈**: 根据 AI 回复情绪改变光环颜色
- [ ] **语音唤醒**: "Hey Bagel" 语音唤醒核心

### 长期（2-3个月）

- [ ] **WebGL 粒子系统**: 使用 Three.js 实现真实粒子效果
- [ ] **手势识别增强**: 支持双指捏合、旋转等手势
- [ ] **AR 核心**: 使用 WebXR 将核心投射到现实空间

---

## 🎓 设计灵感来源

### 视觉参考
- 🔮 **钢铁侠反应堆** (MCU): 圆环 + 蓝色发光
- 🎙️ **Siri 球体** (Apple): 声波可视化
- 🌊 **水银流体** (T-1000): 形态变换
- 💎 **OLED 微光** (AMOLED): 发光线条

### 交互参考
- 📱 **微信语音** (WeChat): 长按录音 + 上滑取消
- 🎮 **iOS 控制中心** (Apple): 长按展开菜单
- 🎨 **Material Design** (Google): Ripple 水波纹效果

---

## 📝 开发者注意事项

### 性能优化

1. **使用 `transform` 和 `opacity`**
   - ✅ 触发 GPU 加速
   - ❌ 避免使用 `width`/`height` 动画（会触发重排）

2. **动画帧率控制**
   ```css
   animation-timing-function: ease-in-out;
   /* 避免使用 linear，更自然 */
   ```

3. **避免过多 DOM 操作**
   - Ripple 元素在 600ms 后自动移除
   - 复用已有元素，减少创建/销毁

### 浏览器兼容性

| 特性 | 兼容性 | Fallback |
|------|--------|----------|
| `backdrop-filter` | Chrome 76+, Safari 9+ | 降级为纯色背景 |
| `vibrate()` | Chrome 32+, Firefox 16+ | 静默失败 |
| `cubic-bezier` | 所有现代浏览器 | - |

### 调试技巧

```javascript
// 在控制台查看当前状态
console.log({
    isExpanded,
    isRecording,
    currentGesture
});

// 强制触发录音状态（测试用）
startRecording();

// 查看触摸坐标
handleTouchMove = (e) => {
    console.log(e.touches[0].clientX, e.touches[0].clientY);
};
```

---

## 🏆 设计哲学

> "灵动核心不仅仅是一个按钮，它是 Bagel AI 的**灵魂**。
>
> 空心的圆环代表**开放**，核心的光点代表**智慧**，
> 呼吸的节奏代表**生命**，流动的形态代表**灵活**。
>
> 当用户触摸它时，它不是冷冰冰的玻璃屏幕，
> 而是一个有温度、会回应、懂你的**智能伴侣**。"

---

**文档版本**: Smart Core V1.0
**创建日期**: 2025-12-12
**核心理念**: "触摸未来，感知智能"

---

## 快速开始

打开 `bagel-ai-smart-core.html`，体验：

- ✨ 发光的圆环在静静呼吸
- 💧 点击时如水银般流动展开
- 🎙️ 长按时声波随你的声音律动
- 🌊 每次触摸都有水波纹扩散
- 📷 左滑发图，右滑锁定，上滑取消

这就是 **灵动核心** —— Bagel AI 的心脏。
