# 产品原型图示例集

本文档提供了多种原型图绘制方法和示例，帮助你在PRD中清晰地表达产品设计。

---

## 目录
1. [Mermaid图表示例](#mermaid图表示例)
2. [ASCII艺术界面](#ascii艺术界面)
3. [详细界面描述模板](#详细界面描述模板)

---

## Mermaid图表示例

### 1. 用户流程图（Flowchart）

#### 登录流程
```mermaid
graph TD
    A[用户访问登录页] --> B{是否已有账号}
    B -->|是| C[输入用户名密码]
    B -->|否| D[跳转注册页面]
    C --> E{验证是否通过}
    E -->|通过| F[登录成功，跳转首页]
    E -->|失败| G[显示错误信息]
    G --> H{重试次数<3}
    H -->|是| C
    H -->|否| I[锁定账号，发送通知]
    D --> J[填写注册信息]
    J --> K[提交注册]
    K --> L{验证邮箱}
    L -->|已验证| F
    L -->|未验证| M[发送验证邮件]
```

#### 购物流程
```mermaid
graph LR
    A[浏览商品] --> B[查看详情]
    B --> C{决定购买?}
    C -->|是| D[加入购物车]
    C -->|否| A
    D --> E[继续购物或结算]
    E --> F{继续购物?}
    F -->|是| A
    F -->|否| G[去结算]
    G --> H[确认订单]
    H --> I[选择支付方式]
    I --> J[完成支付]
    J --> K[订单成功]
```

### 2. 序列图（Sequence Diagram）

#### API交互流程
```mermaid
sequenceDiagram
    autonumber
    actor User as 用户
    participant Web as Web前端
    participant API as API网关
    participant Auth as 认证服务
    participant BIZ as 业务服务
    participant DB as 数据库
    participant Cache as Redis缓存

    User->>Web: 1. 发起登录请求
    Web->>API: 2. POST /api/auth/login
    API->>Auth: 3. 验证凭证
    Auth->>DB: 4. 查询用户信息
    DB-->>Auth: 5. 返回用户数据
    Auth->>Auth: 6. 生成JWT Token
    Auth->>Cache: 7. 缓存会话信息
    Cache-->>Auth: 8. 缓存成功
    Auth-->>API: 9. 返回Token
    API-->>Web: 10. 返回登录成功
    Web->>Web: 11. 存储Token到LocalStorage
    Web-->>User: 12. 跳转到首页

    Note over User,Cache: 后续请求携带Token

    User->>Web: 13. 访问个人中心
    Web->>API: 14. GET /api/user/profile (带Token)
    API->>Auth: 15. 验证Token
    Auth->>Cache: 16. 检查会话
    Cache-->>Auth: 17. 会话有效
    Auth-->>API: 18. Token有效
    API->>BIZ: 19. 获取用户资料
    BIZ->>DB: 20. 查询用户详情
    DB-->>BIZ: 21. 返回数据
    BIZ-->>API: 22. 返回资料
    API-->>Web: 23. 返回数据
    Web-->>User: 24. 显示个人中心
```

#### 支付流程
```mermaid
sequenceDiagram
    participant U as 用户
    participant APP as 应用
    participant ORDER as 订单服务
    participant PAY as 支付服务
    participant THIRD as 第三方支付
    participant NOTIFY as 通知服务

    U->>APP: 提交订单
    APP->>ORDER: 创建订单
    ORDER->>ORDER: 检查库存
    ORDER->>ORDER: 锁定库存
    ORDER-->>APP: 返回订单号
    APP-->>U: 显示支付页面

    U->>APP: 选择支付方式
    APP->>PAY: 发起支付请求
    PAY->>THIRD: 调用第三方支付API
    THIRD-->>PAY: 返回支付链接
    PAY-->>APP: 返回支付信息
    APP-->>U: 跳转支付页面

    U->>THIRD: 完成支付
    THIRD->>PAY: 支付结果回调
    PAY->>ORDER: 更新订单状态
    ORDER->>ORDER: 扣减库存
    PAY->>NOTIFY: 发送支付成功通知
    NOTIFY->>U: 发送邮件/短信
    PAY-->>THIRD: 确认接收回调
    PAY->>APP: 推送支付结果
    APP-->>U: 显示支付成功页面
```

### 3. 状态图（State Diagram）

#### 订单状态机
```mermaid
stateDiagram-v2
    [*] --> 待支付: 创建订单

    待支付 --> 已支付: 支付成功
    待支付 --> 已取消: 超时未支付
    待支付 --> 已取消: 用户取消

    已支付 --> 待发货: 商家确认
    已支付 --> 退款中: 用户申请退款

    待发货 --> 已发货: 商家发货
    待发货 --> 退款中: 用户申请退款

    已发货 --> 待收货: 物流中
    待收货 --> 已完成: 确认收货
    待收货 --> 已完成: 自动确认(7天后)
    待收货 --> 退货中: 申请退货

    退货中 --> 退款中: 退货成功
    退货中 --> 待收货: 退货失败

    退款中 --> 已退款: 退款成功
    退款中 --> 已支付: 退款失败

    已完成 --> 售后中: 申请售后
    售后中 --> 已完成: 售后完成

    已取消 --> [*]
    已退款 --> [*]
    已完成 --> [*]

    note right of 待支付
        15分钟内必须完成支付
        否则自动取消订单
    end note

    note right of 已发货
        用户可随时查看物流信息
    end note
```

#### 文章审核状态
```mermaid
stateDiagram-v2
    [*] --> 草稿: 创建文章

    草稿 --> 待审核: 提交审核
    草稿 --> [*]: 删除

    待审核 --> 审核通过: 审核员批准
    待审核 --> 审核拒绝: 审核员拒绝
    待审核 --> 草稿: 撤回修改

    审核拒绝 --> 草稿: 重新编辑
    审核拒绝 --> [*]: 删除

    审核通过 --> 已发布: 发布
    审核通过 --> 草稿: 撤回

    已发布 --> 已下架: 违规下架
    已发布 --> 草稿: 下架编辑
    已发布 --> [*]: 删除

    已下架 --> 待审核: 申诉
    已下架 --> [*]: 删除
```

### 4. 实体关系图（ER Diagram）

#### 电商系统数据模型
```mermaid
erDiagram
    USER ||--o{ ORDER : places
    USER ||--o{ CART : owns
    USER ||--o{ ADDRESS : has
    USER ||--o{ REVIEW : writes
    USER ||--o{ FAVORITE : collects

    USER {
        bigint id PK "用户ID"
        varchar username "用户名"
        varchar email "邮箱"
        varchar phone "手机号"
        varchar password_hash "密码哈希"
        tinyint status "状态: 0禁用 1正常"
        datetime created_at "创建时间"
        datetime updated_at "更新时间"
    }

    ORDER ||--|{ ORDER_ITEM : contains
    ORDER }o--|| ADDRESS : ships_to
    ORDER }o--|| PAYMENT : has_payment

    ORDER {
        bigint id PK "订单ID"
        varchar order_no UK "订单号"
        bigint user_id FK "用户ID"
        decimal total_amount "总金额"
        decimal discount_amount "优惠金额"
        decimal final_amount "实付金额"
        tinyint status "状态"
        bigint address_id FK "收货地址ID"
        datetime paid_at "支付时间"
        datetime shipped_at "发货时间"
        datetime completed_at "完成时间"
        datetime created_at "创建时间"
    }

    ORDER_ITEM }o--|| PRODUCT : references
    ORDER_ITEM }o--|| SKU : references

    ORDER_ITEM {
        bigint id PK "明细ID"
        bigint order_id FK "订单ID"
        bigint product_id FK "商品ID"
        bigint sku_id FK "SKU ID"
        varchar product_name "商品名称"
        varchar sku_attrs "规格属性"
        int quantity "数量"
        decimal price "单价"
        decimal total_price "小计"
    }

    PRODUCT ||--o{ SKU : has
    PRODUCT }o--|| CATEGORY : belongs_to
    PRODUCT }o--|| BRAND : from
    PRODUCT ||--o{ PRODUCT_IMAGE : has
    PRODUCT ||--o{ REVIEW : has
    PRODUCT ||--o{ FAVORITE : favorited_by

    PRODUCT {
        bigint id PK "商品ID"
        varchar name "商品名称"
        text description "商品描述"
        bigint category_id FK "分类ID"
        bigint brand_id FK "品牌ID"
        decimal price "价格"
        int stock "库存"
        int sales "销量"
        decimal rating "评分"
        tinyint status "状态"
        datetime created_at "创建时间"
    }

    SKU {
        bigint id PK "SKU ID"
        bigint product_id FK "商品ID"
        varchar sku_code UK "SKU编码"
        json attrs "属性JSON"
        decimal price "价格"
        int stock "库存"
        string image_url "图片"
    }

    CATEGORY {
        bigint id PK "分类ID"
        varchar name "分类名称"
        bigint parent_id "父分类ID"
        int level "层级"
        int sort_order "排序"
    }

    BRAND {
        bigint id PK "品牌ID"
        varchar name "品牌名称"
        varchar logo "品牌LOGO"
    }

    ADDRESS {
        bigint id PK "地址ID"
        bigint user_id FK "用户ID"
        varchar recipient "收件人"
        varchar phone "电话"
        varchar province "省"
        varchar city "市"
        varchar district "区"
        varchar detail "详细地址"
        boolean is_default "是否默认"
    }

    CART {
        bigint id PK "购物车ID"
        bigint user_id FK "用户ID"
        bigint sku_id FK "SKU ID"
        int quantity "数量"
        boolean selected "是否选中"
        datetime created_at "添加时间"
    }

    REVIEW {
        bigint id PK "评价ID"
        bigint user_id FK "用户ID"
        bigint product_id FK "商品ID"
        bigint order_id FK "订单ID"
        tinyint rating "评分"
        text content "评价内容"
        json images "图片数组"
        datetime created_at "评价时间"
    }

    PAYMENT {
        bigint id PK "支付ID"
        bigint order_id FK "订单ID"
        varchar payment_no UK "支付单号"
        tinyint payment_method "支付方式"
        decimal amount "支付金额"
        tinyint status "支付状态"
        datetime paid_at "支付时间"
    }

    FAVORITE {
        bigint id PK "收藏ID"
        bigint user_id FK "用户ID"
        bigint product_id FK "商品ID"
        datetime created_at "收藏时间"
    }

    PRODUCT_IMAGE {
        bigint id PK "图片ID"
        bigint product_id FK "商品ID"
        varchar url "图片URL"
        int sort_order "排序"
    }
```

### 5. 类图（Class Diagram）

#### 系统架构类图
```mermaid
classDiagram
    class User {
        +Long id
        +String username
        +String email
        +String passwordHash
        +UserStatus status
        +login()
        +logout()
        +updateProfile()
    }

    class Order {
        +Long id
        +String orderNo
        +Long userId
        +OrderStatus status
        +BigDecimal totalAmount
        +create()
        +pay()
        +cancel()
        +ship()
        +complete()
    }

    class Product {
        +Long id
        +String name
        +BigDecimal price
        +Integer stock
        +getDetails()
        +updateStock()
        +checkAvailability()
    }

    class Cart {
        +Long id
        +Long userId
        +addItem()
        +removeItem()
        +updateQuantity()
        +clear()
        +checkout()
    }

    class Payment {
        +Long id
        +String paymentNo
        +PaymentMethod method
        +PaymentStatus status
        +BigDecimal amount
        +process()
        +refund()
    }

    User "1" --> "0..*" Order : places
    User "1" --> "1" Cart : owns
    Order "1" --> "1..*" Product : contains
    Order "1" --> "1" Payment : has
    Cart "1" --> "0..*" Product : includes
```

### 6. 组件图（Component Diagram）

#### 微服务架构
```mermaid
graph TB
    subgraph 前端层
        WEB[Web前端]
        MOBILE[移动端App]
    end

    subgraph API网关层
        GATEWAY[API Gateway<br/>Kong/Nginx]
    end

    subgraph 业务服务层
        USER_SVC[用户服务<br/>User Service]
        PRODUCT_SVC[商品服务<br/>Product Service]
        ORDER_SVC[订单服务<br/>Order Service]
        PAYMENT_SVC[支付服务<br/>Payment Service]
        SEARCH_SVC[搜索服务<br/>Search Service]
    end

    subgraph 基础服务层
        AUTH_SVC[认证服务<br/>Auth Service]
        NOTIFY_SVC[通知服务<br/>Notification]
        FILE_SVC[文件服务<br/>File Service]
    end

    subgraph 数据层
        MYSQL[(MySQL<br/>主数据库)]
        REDIS[(Redis<br/>缓存)]
        ES[(Elasticsearch<br/>搜索引擎)]
        OSS[(对象存储<br/>S3/OSS)]
    end

    subgraph 消息队列
        MQ[消息队列<br/>RabbitMQ/Kafka]
    end

    WEB --> GATEWAY
    MOBILE --> GATEWAY

    GATEWAY --> USER_SVC
    GATEWAY --> PRODUCT_SVC
    GATEWAY --> ORDER_SVC
    GATEWAY --> PAYMENT_SVC
    GATEWAY --> SEARCH_SVC

    USER_SVC --> AUTH_SVC
    ORDER_SVC --> PAYMENT_SVC
    ORDER_SVC --> NOTIFY_SVC
    PRODUCT_SVC --> FILE_SVC

    USER_SVC --> MYSQL
    PRODUCT_SVC --> MYSQL
    ORDER_SVC --> MYSQL
    PAYMENT_SVC --> MYSQL

    USER_SVC --> REDIS
    PRODUCT_SVC --> REDIS
    ORDER_SVC --> REDIS

    SEARCH_SVC --> ES
    FILE_SVC --> OSS

    ORDER_SVC --> MQ
    PAYMENT_SVC --> MQ
    NOTIFY_SVC --> MQ
```

### 7. 时间线图（Gantt Chart）

#### 项目开发计划
```mermaid
gantt
    title 产品开发时间线（2025年Q1-Q2）
    dateFormat YYYY-MM-DD

    section 第一阶段: 需求与设计
    市场调研                :done,    phase1_1, 2025-01-01, 10d
    需求分析                :done,    phase1_2, 2025-01-08, 7d
    PRD编写                 :done,    phase1_3, 2025-01-12, 10d
    UI/UX设计              :active,  phase1_4, 2025-01-15, 20d
    技术方案评审            :         phase1_5, 2025-01-25, 5d

    section 第二阶段: MVP开发
    环境搭建                :         phase2_1, 2025-02-01, 5d
    数据库设计              :         phase2_2, 2025-02-03, 5d
    后端API开发             :         phase2_3, 2025-02-08, 25d
    前端页面开发            :         phase2_4, 2025-02-10, 30d
    第三方服务集成          :         phase2_5, 2025-02-20, 15d

    section 第三阶段: 测试优化
    单元测试                :         phase3_1, 2025-03-01, 15d
    集成测试                :         phase3_2, 2025-03-10, 10d
    性能测试与优化          :         phase3_3, 2025-03-15, 10d
    安全测试                :         phase3_4, 2025-03-18, 7d
    Bug修复                 :         phase3_5, 2025-03-20, 10d

    section 第四阶段: 发布上线
    预发布环境验证          :         phase4_1, 2025-03-25, 5d
    灰度发布(10%)          :crit,    phase4_2, 2025-04-01, 3d
    灰度发布(50%)          :crit,    phase4_3, 2025-04-04, 3d
    全量发布                :milestone, phase4_4, 2025-04-08, 0d
    运营数据监控            :         phase4_5, 2025-04-08, 7d

    section 第五阶段: 迭代优化
    用户反馈收集            :         phase5_1, 2025-04-10, 15d
    功能优化                :         phase5_2, 2025-04-20, 20d
    V1.1版本开发            :         phase5_3, 2025-05-01, 30d
    V1.1发布                :milestone, phase5_4, 2025-06-01, 0d
```

---

## ASCII艺术界面

### 移动端界面示例

#### 1. 登录页面
```
┌─────────────────────────────┐
│                             │
│         📱 MyApp            │
│                             │
│   ┌─────────────────────┐   │
│   │                     │   │
│   │      [Logo图]       │   │
│   │                     │   │
│   └─────────────────────┘   │
│                             │
│   欢迎回来                   │
│                             │
│   ┌─────────────────────┐   │
│   │ 📧 邮箱/手机号       │   │
│   └─────────────────────┘   │
│                             │
│   ┌─────────────────────┐   │
│   │ 🔒 密码              │   │
│   └─────────────────────┘   │
│                             │
│   忘记密码？                 │
│                             │
│   ┌─────────────────────┐   │
│   │      登 录          │   │
│   └─────────────────────┘   │
│                             │
│   ──────── 或 ────────      │
│                             │
│   [微信登录] [支付宝登录]    │
│                             │
│   还没有账号？ 立即注册      │
│                             │
└─────────────────────────────┘
```

#### 2. 首页
```
┌─────────────────────────────────┐
│  ☰ MyApp    🔍搜索    🔔 👤    │  ← 顶部导航
├─────────────────────────────────┤
│                                 │
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━┓   │
│  ┃                         ┃   │
│  ┃    轮播Banner 1/3       ┃   │  ← 轮播图
│  ┃         ● ○ ○           ┃   │
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━┛   │
│                                 │
│  🎯 快捷入口                     │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐  │
│  │ 🛒 │ │ 📦 │ │ 💰 │ │ ⭐ │  │
│  │秒杀│ │新品│ │优惠│ │精选│  │  ← 分类入口
│  └────┘ └────┘ └────┘ └────┘  │
│                                 │
│  📌 精选推荐            更多 ＞ │
│  ╔═══════════╗  ╔═══════════╗  │
│  ║   图片    ║  ║   图片    ║  │
│  ║           ║  ║           ║  │
│  ╠═══════════╣  ╠═══════════╣  │
│  ║ 商品标题  ║  ║ 商品标题  ║  │  ← 商品卡片
│  ║ ￥99.00   ║  ║ ￥149.00  ║  │
│  ║ ⭐⭐⭐⭐⭐ ║  ║ ⭐⭐⭐⭐   ║  │
│  ║ [购买]    ║  ║ [购买]    ║  │
│  ╚═══════════╝  ╚═══════════╝  │
│                                 │
│  ╔═══════════╗  ╔═══════════╗  │
│  ║   图片    ║  ║   图片    ║  │
│  ║           ║  ║           ║  │
│  ╠═══════════╣  ╠═══════════╣  │
│  ║ 商品标题  ║  ║ 商品标题  ║  │
│  ║ ￥79.00   ║  ║ ￥199.00  ║  │
│  ║ ⭐⭐⭐⭐⭐ ║  ║ ⭐⭐⭐⭐⭐ ║  │
│  ║ [购买]    ║  ║ [购买]    ║  │
│  ╚═══════════╝  ╚═══════════╝  │
│                                 │
│  ⬇ 下拉加载更多...              │
│                                 │
├─────────────────────────────────┤
│ [🏠首页][📂分类][🛒购物车][👤我] │  ← 底部Tab
└─────────────────────────────────┘
```

#### 3. 商品详情页
```
┌─────────────────────────────────┐
│  ← 返回    商品详情    ⋮  ♥     │  ← 顶部操作栏
├─────────────────────────────────┤
│                                 │
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━┓   │
│  ┃                         ┃   │
│  ┃     商品主图 1/5        ┃   │  ← 图片轮播
│  ┃                         ┃   │
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━┛   │
│                                 │
│  超值热销商品 - 限时特惠        │
│  ￥149.00  ￥199.00  🔥25%OFF   │  ← 价格区
│  ⭐⭐⭐⭐⭐ 4.8 (1234评价)      │
│                                 │
│  ┌───────────────────────────┐ │
│  │ 🚚 配送: 预计2-3天送达    │ │
│  │ 🛡️ 服务: 7天无理由退换    │ │  ← 服务信息
│  │ ✅ 保障: 正品保证          │ │
│  └───────────────────────────┘ │
│                                 │
│  选择规格                   [＞]│
│  ┌───────────────────────────┐ │
│  │ 颜色: ⚪白色 ⚫黑色 🔴红色  │ │
│  │ 尺寸: ○S ○M ●L ○XL       │ │  ← 规格选择
│  │ 数量: [➖] 1 [➕]          │ │
│  └───────────────────────────┘ │
│                                 │
│  ┌─[产品介绍]─[规格]─[评价]─┐  │
│  │                           │  │
│  │  这款产品采用优质材料...  │  │
│  │  适合各种场景使用...      │  │  ← 详情Tab
│  │                           │  │
│  │  [查看完整介绍]           │  │
│  └───────────────────────────┘  │
│                                 │
│  猜你喜欢                       │
│  ╔══════╗ ╔══════╗ ╔══════╗   │
│  ║ 图片 ║ ║ 图片 ║ ║ 图片 ║   │  ← 推荐商品
│  ║￥99  ║ ║￥79  ║ ║￥129 ║   │
│  ╚══════╝ ╚══════╝ ╚══════╝   │
│                                 │
├─────────────────────────────────┤
│ [💬客服] [🛒2] [加入购物车] [立即购买] │  ← 底部操作栏
└─────────────────────────────────┘
```

#### 4. 购物车页面
```
┌─────────────────────────────────┐
│  购物车 (3件商品)        清空    │  ← 标题栏
├─────────────────────────────────┤
│                                 │
│  店铺A                [✓] 全选  │
│  ┌───────────────────────────┐ │
│  │☑️ [图] 商品名称            │ │
│  │     黑色/L                │ │
│  │     ￥149 x 1             │ │  ← 商品项
│  │     [➖] 1 [➕]     [🗑️]  │ │
│  └───────────────────────────┘ │
│                                 │
│  ┌───────────────────────────┐ │
│  │☑️ [图] 商品名称            │ │
│  │     白色/M                │ │
│  │     ￥99 x 2              │ │
│  │     [➖] 2 [➕]     [🗑️]  │ │
│  └───────────────────────────┘ │
│                                 │
│  店铺B                          │
│  ┌───────────────────────────┐ │
│  │☐  [图] 商品名称            │ │
│  │     已失效 [删除]          │ │  ← 失效商品
│  └───────────────────────────┘ │
│                                 │
│  为你推荐                       │
│  ┌────┐ ┌────┐ ┌────┐         │
│  │图片│ │图片│ │图片│         │  ← 推荐商品
│  │￥99│ │￥79│ │￥129│        │
│  └────┘ └────┘ └────┘         │
│                                 │
│                                 │
│                                 │
│                                 │
├─────────────────────────────────┤
│ ☑️全选  合计: ￥347.00           │
│           优惠: -￥20.00         │  ← 结算信息
│         实付: ￥327.00 [去结算(2)]│
└─────────────────────────────────┘
```

### Web端界面示例

#### 5. Dashboard后台
```
╔═════════════════════════════════════════════════════════════════╗
║  📊 DashBoard                          👤 Admin    🔔 ⚙️ 🚪  ║  ← 顶部导航
╠═══════╦═════════════════════════════════════════════════════════╣
║       ║                                                         ║
║  📂   ║  概览数据                                               ║
║ 首页  ║  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      ║
║       ║  │  今日订单   │ │  今日销售额 │ │  活跃用户   │      ║
║  📊   ║  │             │ │             │ │             │      ║
║ 统计  ║  │    1,234    │ │  ￥56,789  │ │    8,901    │      ║  ← 主内容区
║       ║  │  ↑ 12.5%    │ │  ↑ 8.3%    │ │  ↓ 2.1%    │      ║
║  🛍️   ║  └─────────────┘ └─────────────┘ └─────────────┘      ║
║ 订单  ║                                                         ║
║       ║  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      ║
║  📦   ║  │  待处理订单 │ │  库存预警   │ │  退款申请   │      ║
║ 商品  ║  │      23     │ │      5      │ │      3      │      ║
║       ║  └─────────────┘ └─────────────┘ └─────────────┘      ║
║  👥   ║                                                         ║
║ 用户  ║  销售趋势                            [日] [周] [月]     ║
║       ║  ┌───────────────────────────────────────────────┐    ║
║  💬   ║  │ 销售额                                        │    ║
║ 客服  ║  │ 60K├─────┐                                    │    ║
║       ║  │    │     │        ┌────┐                      │    ║
║  ⚙️   ║  │ 40K├     └─┐  ┌──┘    └──┐                  │    ║  ← 图表区域
║ 设置  ║  │    │       └──┘           └──┐               │    ║
║       ║  │ 20K├                          └────           │    ║
║       ║  │    │                                          │    ║
║       ║  │  0K└─┬────┬────┬────┬────┬────┬────┬────┬──  │    ║
║       ║  │      1    5   10   15   20   25   30        │    ║
║       ║  └───────────────────────────────────────────────┘    ║
║       ║                                                         ║
║       ║  最近订单                              [查看全部 >]    ║
║       ║  ┌─────┬──────────┬──────┬────────┬────────┬─────┐  ║
║       ║  │订单号│  商品    │ 数量 │  金额  │  状态  │操作 │  ║
║       ║  ├─────┼──────────┼──────┼────────┼────────┼─────┤  ║
║       ║  │10001│ 商品A    │  2   │ ￥298  │ 已发货 │详情 │  ║  ← 表格区域
║       ║  │10002│ 商品B    │  1   │ ￥149  │ 待发货 │处理 │  ║
║       ║  │10003│ 商品C    │  3   │ ￥447  │ 已完成 │详情 │  ║
║       ║  └─────┴──────────┴──────┴────────┴────────┴─────┘  ║
║       ║                                                         ║
╠═══════╩═════════════════════════════════════════════════════════╣
║  © 2025 MyCompany  |  v1.2.0  |  帮助文档  |  隐私政策        ║  ← 页脚
╚═════════════════════════════════════════════════════════════════╝
```

---

## 详细界面描述模板

### 界面描述示例：商品详情页

**页面名称：** 商品详情页（Product Detail Page）

**页面URL：** `/products/{product_id}`

**页面用途：** 展示商品的详细信息，帮助用户了解商品并做出购买决策

---

#### 布局结构

**1. 顶部导航栏（高度: 60px，固定定位）**
- **左侧：** 返回按钮（< 图标 + "返回"文字）
- **中间：** 页面标题"商品详情"（居中显示）
- **右侧：** 更多操作按钮（⋮）+ 收藏按钮（♥）

**2. 商品图片区（高度: 400px）**
- 主图轮播组件
  - 支持左右滑动切换图片
  - 底部显示图片指示器（小圆点，当前图片为实心）
  - 显示当前图片序号（如"1/5"）
  - 点击可放大查看
  - 支持双指缩放

**3. 商品基本信息卡片（白色背景，圆角，阴影）**
- **商品标题：**
  - 字体大小: 18px
  - 字重: 加粗
  - 颜色: #333
  - 最多显示2行，超出显示省略号

- **价格区域：**
  - 当前价格: ￥149.00（红色，24px，加粗）
  - 原价: ￥199.00（灰色，16px，删除线）
  - 折扣标签: "25% OFF"（红色背景，白色文字，圆角标签）

- **评分与销量：**
  - 星级评分: ⭐⭐⭐⭐⭐（5星，黄色）
  - 评分数值: 4.8分（灰色，14px）
  - 评价数量: (1234条评价)（灰色，14px，可点击）

**4. 服务信息区域（浅灰色背景）**
- 配送信息: 🚚 图标 + "预计2-3天送达"
- 服务承诺: 🛡️ 图标 + "7天无理由退换"
- 正品保障: ✅ 图标 + "正品保证"

**5. 规格选择区域（可展开/收起）**
- **标题栏：** "选择规格" + 右箭头
- **点击后展开：**
  - 颜色选择：
    - 圆形色块按钮（直径40px）
    - 已选中有边框高亮
    - 每个色块显示颜色名称

  - 尺寸选择：
    - 圆形按钮（直径50px）
    - 已选中有填充背景色
    - 显示尺码标签（S/M/L/XL）

  - 数量选择：
    - 减号按钮 + 数字输入框 + 加号按钮
    - 最小值为1
    - 最大值为库存数量
    - 数字居中显示

**6. 商品详情标签页**
- **Tab切换栏：**
  - Tab1: "产品介绍"
  - Tab2: "规格参数"
  - Tab3: "用户评价(1234)"
  - 当前Tab下方有下划线标识

- **Tab内容区域：**
  - **产品介绍：** 富文本内容，包含图文混排
  - **规格参数：** 表格形式展示（参数名 | 参数值）
  - **用户评价：** 列表展示，每条评价包含：
    - 用户头像 + 用户名
    - 评分星级
    - 评价内容
    - 评价图片（如有）
    - 评价时间
    - 点赞数

**7. 推荐商品区域（"猜你喜欢"）**
- 横向滚动的商品卡片列表
- 每个卡片显示：
  - 商品缩略图
  - 商品名称（1行）
  - 价格
- 无限滚动加载更多

**8. 底部操作栏（高度: 60px，固定定位）**
- **左侧：**
  - 客服按钮（💬 图标 + "客服"文字）
  - 购物车按钮（🛒 图标 + "购物车"文字）
    - 如有商品，显示数量徽章（红色圆点，白色数字）

- **右侧：**
  - "加入购物车"按钮（次要样式，浅色背景）
  - "立即购买"按钮（主要样式，主题色背景）
  - 按钮高度: 48px
  - 圆角: 24px

---

#### 交互行为

**1. 图片交互：**
- 左右滑动切换图片，有滑动动画
- 点击图片进入全屏查看模式
- 全屏模式支持双指缩放
- 全屏模式点击返回按钮或背景退出

**2. 规格选择：**
- 选择颜色/尺寸后，更新商品价格和库存信息
- 如果某规格缺货，显示为灰色不可选状态，并显示"缺货"标签
- 数量输入框只能输入正整数
- 点击减号至1时，减号变灰不可点击
- 点击加号至库存上限时，加号变灰不可点击，并提示"已达库存上限"

**3. 加入购物车：**
- 点击"加入购物车"按钮
- 显示商品图片从当前位置飞入购物车图标的动画
- 购物车数量徽章数字+1
- 底部弹出Toast提示"已加入购物车"
- 提供"去购物车查看"的快捷按钮

**4. 立即购买：**
- 点击"立即购买"按钮
- 如果未选择规格，弹出规格选择弹窗
- 选择完规格后，直接跳转到订单确认页面
- 页面切换使用右滑入动画

**5. 收藏功能：**
- 点击顶部收藏按钮
- 未收藏时显示空心♥，已收藏显示实心♥（红色）
- 收藏成功显示Toast提示"已加入收藏"
- 取消收藏显示Toast提示"已取消收藏"

**6. 下拉刷新：**
- 在页面顶部下拉可刷新商品数据
- 显示加载指示器
- 刷新完成后显示"刷新成功"提示

**7. 评价互动：**
- 点击评价内容展开查看完整评价
- 点击评价图片放大查看
- 点击点赞按钮，点赞数+1，按钮变为已点赞状态（红色）
- 再次点击取消点赞

---

#### 异常状态处理

**1. 加载中状态：**
- 显示骨架屏占位
- 主要区域显示灰色占位块，模拟实际内容布局

**2. 加载失败：**
- 显示错误提示："加载失败，请重试"
- 显示刷新按钮

**3. 商品已下架：**
- 显示提示信息："该商品已下架"
- 隐藏购买相关按钮
- 推荐相似商品

**4. 库存为0：**
- 显示"暂时缺货"标签
- 购买按钮变灰不可点击
- 提供"到货通知"功能

---

#### 性能要求

- 首屏渲染时间 < 1.5秒
- 图片懒加载，进入可视区域才加载
- 图片使用WebP格式，压缩优化
- 评价列表虚拟滚动，一次加载20条
- 滚动性能保持60fps

---

#### 可访问性

- 所有交互元素有明确的点击区域（最小44x44px）
- 按钮有明确的文字说明
- 图片有alt属性
- 支持键盘导航（Tab键切换焦点）
- 颜色对比度符合WCAG AA标准

---

### 弹窗/对话框描述模板

**弹窗名称：** 规格选择弹窗

**触发条件：** 点击"立即购买"且未选择规格时弹出

**弹窗样式：**
- 从底部滑入
- 高度: 60%屏幕高度
- 顶部圆角: 16px
- 背景: 白色
- 遮罩层: 半透明黑色背景（rgba(0,0,0,0.5)）

**弹窗内容：**
1. **顶部拖动条**（居中，灰色，宽80px，高4px）
2. **商品信息区域**
   - 左侧：商品缩略图（80x80px）
   - 右侧：
     - 价格（红色，大字号）
     - 库存（灰色小字）
     - 已选规格（可为空）
3. **规格选择区域**（同页面内的规格选择）
4. **数量选择**
5. **确认按钮**（底部固定，主题色，"确定"）

**交互：**
- 点击遮罩层关闭弹窗
- 向下滑动弹窗关闭
- 选择完规格后点击"确定"关闭弹窗并执行购买

---

这些示例可以帮助你在PRD中清晰地描述产品原型和界面设计！
