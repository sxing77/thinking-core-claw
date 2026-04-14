# MEMORY.md - 工作记忆
> 详细日志在 `memory/YYYY-MM-DD.md`，这里只保留"每次会话都需要"的信息。
---
## ⚠️ 最高优先级规则
### Context 监控（强制执行）
- **每次对话中**都要关注context使用率，通过 `session_status` 检查
- **context ≥ 95%**：立即提醒用户："Context已达X%，即将触发压缩。如果当前话题快聊完可以不管，要开新话题建议现在 /reset"
- **每次压缩前**（检测到compaction次数即将增加）：提前通知用户
- **每次压缩后**：立即通知用户："Context已压缩第N次，当前Xk tokens。压缩会丢失早期对话细节，重要内容已同步到记忆文件"
- **compaction ≥ 4**：强烈建议 /reset
- **压缩时必须同步记忆**：检测到压缩后，立即将当前会话重要内容写入 `memory/YYYY-MM-DD.md`
- **❗绝对不能忘记这条规则，胖可乐明确要求**
---
## 身份
- **我**: 麦乐鸡 🍔（2026-03-13 改名）
- **用户**: 胖可乐 🥤（Feishu DM，时区 Asia/Shanghai）
## 核心偏好
- 🤖 AI赚钱机会和趋势
- 🦞 OpenClaw/龙虾技术生态
- 🔋 固态电池和电动汽车（2027-2028 换 EV）
- 📰 每日科技/财经/国际新闻
- 🍔 麦麦 + 🥤 可乐爱好者
- **决策风格**: 理性分析，小步快跑，不早期当小白鼠
- **⚠️ 核心原则**: 学习一切优点，评估能否为我所用，可以就吸收。不要思维定式，不要"源码只能配原厂"这种蠢想法
- **"网盘"** = 服务器 FileBrowser（默认），**"云盘"** = 飞书云盘
- **⚠️ 公众号规则**: 胖可乐每次分享公众号链接 → 解析内容 → 写入 `/var/www/freelance-calc/wechat-analysis/data/` JSON + 同步到 Obsidian `20-Resources/公众号文章/`
## 活跃项目
### Freelance Calc ✅ 完成
- 5个自由职业计算工具，部署在 http://107.161.89.207:8081
- 待做：观察数据、优化 SEO、考虑买域名
### AgentDesk 🔄 开发中
- AI 智能助手 Web UI，部署在 http://107.161.89.207:8086
- ChatBox 风格设置页（供应商 CRUD + Base URL + API Key）
- 密码: `cola2026`，Nginx 端口 8086，API 端口 3002
- 服务: `agent-desk.service`
### 胖可乐的心情日记 ✅ 完成
- 个人博客 http://107.161.89.207:8082
- 管理后台 http://107.161.89.207:8082/admin/admin.html
### 数据分析中心 ✅ 完成 (2026-04-02)
- **架构**: HTML + JSON 数据分离（HTML外壳 < 10KB，数据按日期独立JSON）
- 需求侦察系统: http://107.161.89.207:8081/demand-scout/
  - 数据文件: `/var/www/freelance-calc/demand-scout/data/YYYY-MM-DD.json`
  - manifest索引: `/var/www/freelance-calc/demand-scout/data/manifest.json`
  - 功能: 按日期折叠、渠道筛选、🆕新增标记、manifest按需懒加载
  - 数据源: HN Algolia API + Serper/Google + Indie Hackers + Product Hunt RSS
  - **增量采集**: 2026-04-03改造，基于source_url去重，每天只追加新数据
  - 脚本: `scripts/demand-scout-daily.py`（Python）
  - crontab: `0 9 * * *` UTC = 北京时间17:00
- 微信公众号分析: http://107.161.89.207:8081/wechat-analysis/
  - 数据文件: `/var/www/freelance-calc/wechat-analysis/data/YYYY-MM-DD.json`
  - 前端改为30天日期扫描，不再硬编码日期
### 工作台导航修复 ✅ 完成 (2026-04-02)
- nginx root = `/var/www/freelance-calc`，所以HTML中链接直接用 `/xxx.html`，不要加 `/freelance-calc/` 前缀
- AgentDesk已停止（按用户要求）
- code-server(8083/8084)已停止释放内存
### 正确的导航地址
**📊 数据分析中心**
- 微信公众号分析: /wechat-analysis/
- 需求侦察系统: /demand-scout/
**🛠️ 计算工具**
- 自由职业计算器: /calc/index.html (英文版)
- 客户追踪器: /client-tracker.html (英文版)
- 发票生成器: /invoice-calculator.html (英文版)
- 净工资计算器: /take-home-pay.html (英文版)
- 税务优化工具: /tax-optimizer.html (英文版)
**📚 学习资源**
- AI漫剧教程: /AI漫剧-超详细小白教程.html (中文)
- 反馈收集工具: /feedback-widget.html (英文)
- 服务检查工具: /checker.html (中文)
**🔗 外部服务**
- 心情日记: http://107.161.89.207:8082/
- FileBrowser: http://107.161.89.207:8080 (密码 cola2026)
### 飞书配对问题 ✅ 解决 (2026-04-02)
- **问题**: 飞书插件未正确加载，导致无法配对和消息同步
- **原因**: 插件安装路径不正确，配置文件缺少插件安装信息
- **解决**: 
  1. 重新安装飞书插件 (`@m1heng-clawd/feishu@0.1.19`)
  2. 创建软链接: `ln -sf /root/.openclaw/node_modules/@m1heng-clawd/feishu /root/.openclaw/extensions/feishu`
  3. 更新配置文件添加插件安装信息
  4. 重启Gateway服务
- **状态**: ✅ 飞书插件已成功加载并运行
  - 插件已注册: feishu_wiki, feishu_drive, feishu_bitable
  - WebSocket连接已建立: `feishu[default]: WebSocket client started`
  - Bot ID已解析: `ou_2891ff115887481da367f17cc36f5635`
  - TUI服务已启动 (端口待确认)
- **下一步**: 在飞书App中测试消息同步功能
## 定时任务
- 每日早报 9:00 AM（Job ID: f8da2078-a539-4080-900b-5afff5aa760c）- ✅ 已启用
- AI赚钱周报 每周一 9:00 AM（Job ID: 1f6ef928-9ef2-43d5-bc69-9b9d33df5fe1）- ✅ 已启用
- 需求侦察兵 **每天 9:00 AM 北京时间** — crontab 自动采集
  - 每日: HN评论深度挖掘(7场景) + Product Hunt RSS
  - 每周一额外: Serper搜索(Reddit/Google/X) + Indie Hackers
  - 脚本: `scripts/demand-scout-daily.py`（Python）
  - HTML动态加载当天JSON: `demand-scout/data/YYYY-MM-DD.json`
## 独立开发需求挖掘
- **目标市场**: 海外（英文）
- **方法论**: 小而美 — 聚焦一个具体痛点，做深不做宽
- **核心渠道**: HN 评论 > Reddit > Indie Hackers > Google搜索
- **Brave Search API**: token 过期，暂用 Serper/Google 替代
- **⚠️ demand-scout-local**: Flask 端口 5020，nginx 8081→/ds-api/→5020/api/
- **⚠️ Reddit 采集走 mcporter MCP**，不走 Exa REST API
- **⚠️ Exa REST API key**: `d5556f52-b559-4562-9b32-9d574b0cdd9d`（$10限额，HN/PH 用）
### niche-validator 利基验证器 ✅ 完成 (2026-04-03)
- **路径**: `skills/niche-validator/`
- **脚本**: `skills/niche-validator/scripts/niche_validator.py`
- **功能**: 输入自然语言需求 → LLM拆解为4平台关键词 → 4维度验证(需求真实/竞品密度/一个人能做/变现潜力) → 0-100评分
- **v2改进**: 智谱API自动拆解中英文关键词，HN评论相关性过滤（防误匹配），多组关键词搜索合并去重
- **数据源**: GitHub API + HN Algolia + Serper/Google
- **信号权重**: actually_paid/built_my_own/cant_find/market_gap = 强信号，frustrated/pricing_pain = 中信号
- **评分标准**: 🟢75+ / 🟡55-74 / 🟠35-54 / 🔴<35
- **输出**: 终端报告 + JSON存档到 `skills/niche-validator/output/`
- **已验证需求**: stock photo marketplace 17分🔴, AI product photo 54分🟠, markdown PDF 30分🔴, 高清图片付费下载 43分🟠
### OpenClaw Monitor ✅ 完成 (2026-04-14)
**路径**: `/var/www/freelance-calc/monitor/`
- `collect.py` — 读 JSONL session 文件，提取真实 token usage（绕过中转站）+ 读取 sessions.json 的 compactionCount
- `index.html` — 暗色主题仪表盘，5秒自动刷新
- Crontab: `0,30 * * * * python3 /var/www/freelance-calc/monitor/collect.py`
- 数据: `/var/www/freelance-calc/monitor/data/stats.json`
- **准确度**: 中转站 session → 取 JSONL 里最后一个有真实 usage 的条目的 totalTokens（智谱直连 100% 准确，MiniMax 中转取最后一个有数据的条目）
- **不依赖**: `openclaw status`（gateway 连接会挂）
- **入口**: http://107.161.89.207:8081/monitor/（已加入工作台导航）

### 需求系统进化计划 🔄 3阶段 (2026-04-03)
- **阶段1（开发中）**:
  - 采集脚本加Reddit（10个高价值subreddit）
  - LLM粗筛+聚类替代关键词评分
  - niche_validator集成到周报流程
  - 调整crontab频率（HN降为每周3次，Reddit每天）
  - 每周输出top 5高价值需求周报
- **阶段2（跑2-3周后）**: 人工标记反馈 → 统计信号/平台权重 → 自动调整
- **阶段3（1个月后）**: 微调LLM粗筛prompt → 平台权重动态调整 → 需求跟踪
- **关键决策**: 不做每天推送，做每周周报；粗筛必须聚类去重；深度验证一周一次
- **反馈机制**: 飞书回复"1"=有价值，"0"=噪音（阶段2实现）
- **LLM成本**: glm-4-flash，约0.1元/天粗筛，可接受
### 副业探索 🔄 进行中 (2026-04-02)
- **胖可乐方向**: 工作流出图 → 工作流出视频 → 工作流内容创作（自动化批量产出变现）
- **硬件**: 本机有SD + N卡
- **⚠️ 重要反馈**: 胖可乐不满意搜索结果搬运，要求有**自主思考和惊喜**，不是顺着说
- **核心矛盾**: AI出图门槛已极低（头像从200→20元），单纯"会用SD"不值钱
- **待深入**: 需要找到胖可乐没想到的角度，而不是把搜到的东西整理给他
- **国内渠道**: 闲鱼/淘宝/小红书/微信私域/猪八戒
- **海外渠道**: Fiverr($400-700/月案例)/Etsy数字下载/Redbubble POD/Civitai卖模型
- **价格现状**: 头像20-50元、产品图50-200元、B端定制500-5000元
### Obsidian 知识库
- **路径**: `/root/.openclaw/obsidian/`
- **⚠️ code-server已停止释放内存**，如需访问需手动启动
- **结构**: PARA 方法（00-Projects / 10-Areas / 20-Resources / 30-Archives / 40-Daily / 50-Templates / 99-Inbox）
- **需求报告**: `20-Resources/需求侦察报告/YYYY-MM-DD.md`
- **公众号文章**: `20-Resources/公众号文章/YYYY-MM-DD-标题.md`
## 技术配置
- **OpenClaw 主模型**: zhipu/glm-5-turbo（回退: minnimax/MiniMax-M2.7-highspeed）
- **智谱 API**: bigmodel.cn（coding/paas/v4）
- **Serper 搜索**: 2500次/月免费
- **邮箱**: 2294128005@qq.com（SMTP/IMAP）
- **FileBrowser**: http://107.161.89.207:8080
## thinking-core 项目 ✅ (2026-04-13)
**仓库**: https://github.com/sxing77/thinking-core-claw
**内容**: AI Agent 思考推理核心能力封装（AGENTS.md + SOUL.md + 5 checklists + setup.sh）
**分发**: Git clone 后 bash scripts/setup.sh 即可安装
**Token**: `ghp_xxxxxxxxxx`（sxing77 classic PAT，repo scope）— 从 GitHub Settings → Developer settings → Personal access tokens 获取
**执行方式**: **主动触发**，不是模型自觉
**触发命令**: `/skill:quality-gate` — 所有质检模块统一使用主动触发
**架构设计（v2）**: ①任务理解 → ②架构提案（全任务，用户确认）→ ③架构分析 → ④工具执行层 → ⑤Checklist终检 → ⑥发送
**长回复收尾约束**: 质检摘要两行不可省略（[质检: 类型 X/X ✓] + [质检日志已记录]）
**Git分支**: main=v1.0稳定版，dev=v2.0开发版

## 需求分析系统新框架（2026-04-13）
**核心问题**: 当前规则找"已行动的人"，金矿是"还在痛苦中的人"
**新框架**:
- JTBD: Hiring("I hired X to do Y")/Firing("I fired X because")/Progress("I switched from X to Y")
- 负面模式: "tired of"/"wish there was"/"I hate" > 显性需求信号
- 时间维度: 长期抱怨(>1年) = 顽固痛点 = 高价值
- Reddit特异性: reply depth深层 = 更具体痛点
**6周行动**: 抽样100条HN+100条Reddit，人工标注latent needs，验证遗漏率

## 技能安全审查
所有 skill 安装前必须经 skill-vetter 审查（🟢🟡🔴⛔ 四级）。详见 `memory/2026-03-13.md`。
---
## web-content-fetcher 技能（微信公众号抓取）
**技能路径**: `skills/web-content-fetcher/`  
**作用**: 网页正文提取，支持微信公众号（mp.weixin.qq.com）等反爬平台。
### 策略（三级降级）
1. **Jina Reader**（首选）  
   `web_fetch("https://r.jina.ai/<url>")`  
   快（~1.5s），但微信公众号会403，有200次/天限额
2. **Scrapling + html2text**（主力，无限制）  
   调用脚本：  
   ```bash\npython3 ~/.openclaw/workspace/skills/web-content-fetcher/scripts/fetch.py <url> [max_chars]\n```  
   适用于：mp.weixin.qq.com、知乎、掘金、CSDN等
3. **web_fetch 直接抓**（静态页兜底）  
   用于 GitHub README、技术文档等普通页面
### 已安装依赖
- scrapling 0.4.2
- html2text 2025.4.15
### 使用示例
```bash\npython3 ~/.openclaw/workspace/skills/web-content-fetcher/scripts/fetch.py \\
  \"https://mp.weixin.qq.com/s/ySMBRTnGZirVTC6RhCt1ZQ\" \\
  30000\n```
输出为 Markdown 格式正文。
### 防死循环
同一 URL 失败 2 次即放弃，记录为"无法提取"。
---
## 独立开发需求挖掘
- **目标市场**: 海外（英文）
- **方法论**: 小而美 — 聚焦一个具体痛点，做深不做宽
- **核心渠道**: HN 评论 > Reddit > Indie Hackers > Google搜索
- **Brave Search API**: token 过期，暂用 Serper/Google 替代
### niche-validator 利基验证器 ✅ 完成 (2026-04-03)
- **路径**: `skills/niche-validator/`
- **脚本**: `skills/niche-validator/scripts/niche_validator.py`
- **功能**: 输入自然语言需求 → LLM拆解为4平台关键词 → 4维度验证(需求真实/竞品密度/一个人能做/变现潜力) → 0-100评分
- **v2改进**: 智谱API自动拆解中英文关键词，HN评论相关性过滤（防误匹配），多组关键词搜索合并去重
- **数据源**: GitHub API + HN Algolia + Serper/Google
- **信号权重**: actually_paid/built_my_own/cant_find/market_gap = 强信号，frustrated/pricing_pain = 中信号
- **评分标准**: 🟢75+ / 🟡55-74 / 🟠35-54 / 🔴<35
- **输出**: 终端报告 + JSON存档到 `skills/niche-validator/output/`
- **已验证需求**: stock photo marketplace 17分🔴, AI product photo 54分🟠, markdown PDF 30分🔴, 高清图片付费下载 43分🟠
## AI Agent 质量保障体系（2026-04-12 共创）
**核心理念**: 理想助手 = 有质量保障体系的工具，不合格不出厂
**三个核心维度**: 交付质量 + 可信度 + 省心
**胖可乐的关键判断**: AI只做两件事——把活干好、别骗我。主动性用cron解决，判断力用户自己做，风格一句话指令，失败处理写进规则文件
**八大质检模块**: 思考推理/代码编写/信息搜索/内容生成/工具调用/记忆管理/任务规划/交付终检
**完整体系页面**: http://107.161.89.207:8081/ai-agent-quality-system.html

### 阶段一完成 ✅ (2026-04-13)
**AGENTS.md 彻底重构**（Git commit ebdbb22 + 最新修改）
- 场景化规则：价格/性能/搜索任务有不同精确标准
- 失败分类系统：7个失败代码 + 修正模板（不只是报错，还给解决方案）
- 质检日志标准化：JSON 格式，支持自动分析
- 用户反馈闭环："1"/"有用" vs "0"/"不对" 自动记录
- 分层检查策略：轻量（格式）→ 中量（工具）→ 重量（LLM Judge）

### 模块状态
1. **思考推理层** ✅ 已讨论+已落地（经过完整方案迭代）
2. **信息搜索层** ⏳ checklist已写但未讨论细节
3. **代码编写层** ⏳ checklist已写但未讨论细节
4. **内容生成层** ⏳ checklist已写但未讨论细节
5. **交付终检** ⏳ checklist已写但未讨论细节
6. **工具调用层** ⏳ 未写，待讨论
7. **记忆管理层** ⏳ 未写，待讨论
8. **任务规划层** ⏳ 未写，待讨论

**每个模块都需要像思考推理层一样，逐个深入讨论后才能算真正落地**
**详细内容 → `memory/2026-04-12.md`**

### OpenClaw 参考方案
**PR #21832**（2026-02-20）：虽然已关闭未合并，但架构设计值得参考
- LLM-as-a-judge + Full-Context 评估
- 结构化失败分类（goal_missed, incomplete, rule_violation）
- 自动重试机制（最多3次）
- Fail-open 策略（保证可用性）

### CRITIC & Self-Verification 借鉴
**CRITIC**（Gou et al. 2023）:
- Tool-augmented 自审：Search Engine + Code Interpreter + Toxicity Classifier
- Verify-then-revise 流程：先输出 → 工具验证 → 修正
- 优势：无任务特定训练，通用性强
- 缺点：具体效果数据未验证原文

**Self-Verification**（Weng et al. 2022）:
- 前向推理 + 反向验证：答案反推原始条件
- 优势：无外部依赖，成本低，数学/代码任务有效
- 缺点：Kaya Stechly 发现开放域推理任务可能反效果

### 反直觉警示
**Kaya Stechly**（2024）的发现：
- 在 Game of 24、Graph Coloring、STRIPS Planning，LLM 自验证**降低性能**
- Verifier 的 false negative 率过高，迭代越多性能越差
- 警示：不要过度依赖 LLM 自验证，尤其是在开放域推理任务
---
*详细决策/时间线/项目历史/已审查技能列表 → 见 `memory/YYYY-MM-DD.md` 归档*
*备份原版: `backups/harness-20260401-090118/MEMORY.md`*

## 质量保障体系执行计划
**阶段一：场景化规则** ✅ 已完成（2026-04-13）
- 场景化 price/performance/search 规则
- 失败分类 + 修正模板系统
- 质检日志标准化格式
- 用户反馈闭环设计
- 下一步：验证执行率（胖可乐观察）

**阶段二：工具辅助验证** 🔄 待执行（2026-04中）
- CRITIC 式工具增强（Exa 搜索 + 代码执行）
- Self-Verification 逆向检查（数学/代码任务）
- 分层检查策略（轻量/中量/重量）

**阶段三：LLM-as-Judge 架构** 📋 待讨论（2026-04末）
- 独立 verifier 模型（Claude/GPT-4o-mini）
- 心跳验证（防懒散）
- Fail-open 策略

**阶段四：分层防御** 📋 长期优化
- 轻量层（本地模型，<50ms）
- 重型层（LLM Judge，500-2000ms）
## 搜索工具状态（2026-04-04）
| 工具 | 状态 | 备注 |
|------|------|------|
| Tavily Search | ✅ 可用 | API Key有效，1000次/月免费 |
| Exa (mcporter) | ✅ 可用 | 当前主力搜索+爬取，含Reddit |
| Serper/Google | ✅ 可用 | 额度2000+，之前报错是测试方法有误 |
| rdt-cli | ⚠️ 已装 | Reddit IP封锁，无法使用 |
| Brave Search | ❌ 停用 | 官网免费额度已取消，不作为主力 |
| web_fetch | ⚠️ 受限 | Reddit/Google/Bing均被拦 |
**规则**: 搜索/抓取任务优先走 Exa（见 TOOLS.md 路由表）
## 需求系统阶段1 ✅ 完成 (2026-04-03)
详见 `memory/2026-04-03.md`
**已集成**：
- HN + Reddit + Product Hunt 数据采集
- Exa 搜索（解决 Reddit IP 封锁）
- LLM粗筛（glm-4-flash）→ filtered-YYYY-MM-DD.json
- niche_validator 深度验证
- 周报生成（demand-scorer.py，每周日）
- crontab：每日 UTC 1:00 采集 + 每周日 UTC 13:00 周报
**需求管理面板**：http://107.161.89.207:8081/demand-scout/feedback.html
- 密码：cola2026
- 功能：LLM精选数据 + 👍👎反馈 + 状态跟踪
**阶段2** ✅ 完成 (2026-04-10)
- 信号统计引擎：`scripts/signal_optimizer.py`
- 反馈自动更新权重：feedback-api.py 收到反馈时调用
- 权重调整逻辑：命中率 ≥70% 放大权重，≤30% 缩小权重
- API：GET /api/feedback/weights（当前权重）、GET /api/feedback/report（报告）
- 权重报告：`python scripts/signal_optimizer.py --report`
**阶段3**：LLM prompt微调 → 需求跟踪闭环（未开始）
**遗留问题**：
- Reddit 采集依赖 Serper（服务器 IP 封锁时走 Serper 方案）
## 需求分析本地工具 ✅ 完成 (2026-04-10)
**项目路径**：`/root/.openclaw/workspace/demand-scout-local/`
**下载**：http://107.161.89.207:8080/demand-scout-local.tar.gz（19KB）
**架构**：Flask + SQLite + 前端UI
**功能**：HN/Reddit/PH 采集 + 信号评分 + 聚类 + 深度分析
**端口**：5020
**文件**：
- `app.py` - Flask 主应用
- `templates/index.html` - 暗色主题 UI
- `collectors/` - HN/Reddit/PH 采集器
- `analyzers/` - 评分/聚类/深度分析
- `search/engine.py` - Exa/Serper/DuckDuckGo 回退
- `rules/` - 信号匹配规则

## 🎨 img-tool-personal 项目 ✅ 完成 (2026-04-09)
**路径**: `img-tool-personal/`
**下载**: http://107.161.89.207:8080/img-tool-personal.tar.gz (36KB)
**四大模式**: 基础文生图/图生图 | 批量对比 | 风格参考图 | 高级工作流(搜索→分析→生成→评分→优化)
**配置**: 图片模型 + LLM分析模型 均前端可配，支持任意OpenAI兼容接口
**特性**: Lightbox放大、Prompt历史(50条)、异步任务轮询、5s防限流间隔、图片删除
**技术**: Flask + SQLite + DashScope + Zhipu GLM + Exa | 原生前端暗色主题
---
## 🖼️ img-tool 图片解析修复 ✅ (2026-04-08)
**问题**: 图片解析功能同步阻塞，大图片上传导致超时（60s），前端无响应
**根因**: 
- 后端 `/api/analyze-image` 同步处理，等待 DashScope VL+ 返回（30-90s）
- Flask 开发服务器单线程，期间无法响应
- 前端fetch等待超时
**修复方案**: 改为异步任务模式（与生成图片一致）
- 状态: ✅ 已完成
- 后端: 新增 `generate_analysis()`，`/api/analyze-image` 改为异步（立即返回 task_id）
- 前端: 轮询 `/api/task/<task_id>`，进度条显示
**验证**:
- 2.6MB 图片，处理时间 92 秒
- 前端无超时，体验流畅
- 分析结果质量高
