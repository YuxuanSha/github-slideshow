import 'package:flutter/material.dart';

void main() {
  runApp(const BagelAIApp());
}

class BagelAIApp extends StatelessWidget {
  const BagelAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bagel AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
        fontFamily: 'PingFang SC',
      ),
      home: const HomePage(),
    );
  }
}

// ========== 颜色定义 (基于参考图) ==========
class AppColors {
  // 品牌色 - 青绿色 (参考图中的Logo颜色)
  static const Color brandCyan = Color(0xFF00D4D4);
  static const Color brandTeal = Color(0xFF00CED1);

  // 背景色 - 米白色
  static const Color background = Color(0xFFF5F5F0);
  static const Color cardBackground = Color(0xFFFFFBF5);

  // 文字颜色
  static const Color textPrimary = Color(0xFF2C2C2E);
  static const Color textSecondary = Color(0xFF8E8E93);

  // 卡片渐变色 (参考图中的柔和渐变)
  static const List<Color> gradientPeach = [
    Color(0xFFFFF8F0),
    Color(0xFFFFF0E6),
  ];

  static const List<Color> gradientBlue = [
    Color(0xFFF0F9FF),
    Color(0xFFE8F4F8),
  ];

  static const List<Color> gradientGreen = [
    Color(0xFFF0FDF4),
    Color(0xFFE8F5E9),
  ];
}

// ========== 主页 ==========
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCoreExpanded = false;
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          _buildContent(),
          _buildSmartCore(),
        ],
      ),
    );
  }

  // 主要内容
  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildTopNav(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDailyBrief(),
                  const SizedBox(height: 32),
                  _buildDiscoveryFeed(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 顶部导航栏
  Widget _buildTopNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: const Icon(Icons.menu, size: 24),
          ),
          const SizedBox(width: 12),
          // Logo
          Row(
            children: const [
              Text(
                'Bagel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brandCyan,
                ),
              ),
              SizedBox(width: 4),
              Text('🥯', style: TextStyle(fontSize: 20)),
            ],
          ),
          const Spacer(),
          // 日历按钮
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalendarPage()),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('📅', style: TextStyle(fontSize: 20)),
                SizedBox(height: 2),
                Text(
                  '日历',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 侧边栏
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // 头部
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.gradientBlue,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.brandCyan, AppColors.brandTeal],
                      ),
                    ),
                    child: const Center(
                      child: Text('🙋', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Alex Chen',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'alex@bagel.ai',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 菜单项
          _buildDrawerItem('👤', '个人中心', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }),
          _buildDrawerItem('🧠', '历史记忆', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MemoryPage()),
            );
          }),
          _buildDrawerItem('🔗', '数据连接', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ConnectionsPage()),
            );
          }),
          _buildDrawerItem('⚙️', '设置', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String emoji, String title, VoidCallback onTap) {
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 24)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  // 今日重点
  Widget _buildDailyBrief() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '今日重点',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildBriefCard(
                  '📬',
                  '待处理消息',
                  '8',
                  '3条高优先级 • 5条普通',
                  AppColors.gradientPeach,
                ),
                const SizedBox(width: 12),
                _buildBriefCard(
                  '📅',
                  '今日日程',
                  '5',
                  '下一场会议 10:30',
                  AppColors.gradientBlue,
                ),
                const SizedBox(width: 12),
                _buildBriefCard(
                  '✅',
                  '待办事项',
                  '12',
                  '3项今日截止',
                  AppColors.gradientGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBriefCard(
    String emoji,
    String title,
    String number,
    String subtitle,
    List<Color> gradient,
  ) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            number,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: AppColors.brandCyan,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // 发现
  Widget _buildDiscoveryFeed() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '发现',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
            children: [
              _buildFeedCard('💡', '关于灵动核心的设计思考', '#产品灵感', '刚刚', AppColors.gradientBlue),
              _buildFeedCard('🎨', '钢铁侠反应堆视觉参考', '#设计', '1小时前', AppColors.gradientPeach),
              _buildFeedCard('🎯', '本周工作目标总结', '#工作', '2小时前', AppColors.gradientGreen),
              _buildFeedCard('✨', '像素艺术设计灵感', '#创意', '3小时前', AppColors.gradientBlue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedCard(
    String emoji,
    String title,
    String tag,
    String time,
    List<Color> gradient,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji区域
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 64)),
            ),
          ),
          // 内容区域
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brandCyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.brandCyan,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 灵动核心
  Widget _buildSmartCore() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 32,
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (!_isCoreExpanded) {
              setState(() => _isCoreExpanded = true);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            width: _isCoreExpanded ? 340 : 64,
            height: _isCoreExpanded ? 52 : 64,
            decoration: BoxDecoration(
              gradient: _isCoreExpanded
                  ? null
                  : const LinearGradient(
                      colors: [AppColors.brandCyan, AppColors.brandTeal],
                    ),
              color: _isCoreExpanded ? Colors.white : null,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandCyan.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: _isCoreExpanded
                ? TextField(
                    controller: _inputController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: '输入消息...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 24),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(initialMessage: value),
                          ),
                        );
                        _inputController.clear();
                        setState(() => _isCoreExpanded = false);
                      }
                    },
                  )
                : const Center(
                    child: Text('🎙️', style: TextStyle(fontSize: 28)),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}

// ========== 聊天页 ==========
class ChatPage extends StatefulWidget {
  final String? initialMessage;

  const ChatPage({super.key, this.initialMessage});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add({
      'type': 'ai',
      'content': '你好！我是你的AI助手Bagel。有什么我可以帮你的吗？',
    });

    if (widget.initialMessage != null) {
      _messages.add({
        'type': 'user',
        'content': widget.initialMessage,
      });
      // 模拟AI回复
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _messages.add({
            'type': 'ai',
            'content': '收到！我已经记录下来了。',
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bagel AI',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final isAI = message['type'] == 'ai';

          return Align(
            alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                gradient: isAI
                    ? null
                    : const LinearGradient(
                        colors: [AppColors.brandCyan, AppColors.brandTeal],
                      ),
                color: isAI ? Colors.white : null,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isAI ? const Radius.circular(4) : null,
                  bottomRight: isAI ? null : const Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isAI) ...[
                    const Text('🥯', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      message['content'],
                      style: TextStyle(
                        fontSize: 16,
                        color: isAI ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ========== 日历页 ==========
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '日历',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '2025年12月',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Text('📅 日历组件'),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== 其他页面 ==========
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '个人中心',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: const Center(child: Text('👤 个人中心', style: TextStyle(fontSize: 24))),
    );
  }
}

class MemoryPage extends StatelessWidget {
  const MemoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '历史记忆',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: const Center(child: Text('🧠 历史记忆', style: TextStyle(fontSize: 24))),
    );
  }
}

class ConnectionsPage extends StatelessWidget {
  const ConnectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '数据连接',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: const Center(child: Text('🔗 数据连接', style: TextStyle(fontSize: 24))),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '设置',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: const Center(child: Text('⚙️ 设置', style: TextStyle(fontSize: 24))),
    );
  }
}
