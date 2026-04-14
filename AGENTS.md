# AGENTS.md

## 每次会话

1. 读 `SOUL.md`、`USER.md`（身份和偏好）
2. 读 `memory/YYYY-MM-DD.md`（今天+昨天的日志）
3. **主会话**额外读 `MEMORY.md`
4. **主会话**读取最近 3 天的 `quality-gate/logs/*.json` 质检摘要，了解哪些条目经常 fail，本次重点关注

## 技能优先 #强制（扩展）

收到指令后先扫描 `<available_skills>`，有匹配就用 skill 完成，没有再自行处理。

### 显式 skill 命令强制执行 #绝对规则

**以下任一触发时，必须立即加载对应 SKILL.md 并完整执行 skill 流程，不得降级为普通流程：**

1. 用户发送 `/skill:xxx` 命令（任意 skill 名称）
2. 用户发送"Use the [skill-name] skill" / "用 skill 做 xxx"
3. 用户说"走质检" / "走质量门" / "触发 skill"
4. **任何时候用户明确要求使用某个 skill**

**执行步骤：**
1. 用 `read` 工具加载 SKILL.md（不得跳过，不得"我知道大概"就直接执行）
2. 按 SKILL.md 定义的流程执行（每个步骤都要走完）
3. 输出前强制执行质检（来自 skill 自己的 checklist，不是通用 checklist）
4. 输出末尾附加 skill 定义的质检标记（如 `[质检: reasoning ✓]`）

**反面模式（绝对禁止）：**
- ❌ "我读过了，直接执行" — 每次都必须重新读取 skill 文件
- ❌ 读了一遍 skill 但跳过了 skill 定义的执行步骤，自己按 AGENTS.md 的通用规则走
- ❌ 用 AGENTS.md 的通用质检替代 skill 自己的 checklist

**理由：** skill 是用户的显式意图，不是建议。降级执行等于忽略用户指令。

---

**搜索/抓取类任务优先走 agent-reach 路由：**
| 场景 | 命令 |
|------|------|
| 网页搜索 | `mcporter call 'exa.web_search_exa(query: "xxx", numResults: 5)'` |
| 抓取任意网页(含Reddit) | `mcporter call 'exa.crawling_exa(urls: ["URL"], maxCharacters: 15000)'` |
| Reddit 限定搜索 | `mcporter call 'exa.web_search_exa(query: "xxx", includeDomains: ["reddit.com"])'` |
| 微信公众号搜索 | `mcporter call 'exa.web_search_exa(query: "xxx", includeDomains: ["mp.weixin.qq.com"])'` |

**失败回退规则：任何工具失败 2 次 → 重新扫描 available_skills，换完全不同的方法。**

## 质量保障体系 #强制（Quality Gate）

### 任务分级
| 级别 | 特征 | 质检要求 |
|------|------|----------|
| 轻量 | 查天气、简单问答、格式转换、时间查询 | 不检 |
| 中等 | 搜索整理、写文案、总结文章、翻译 | 只检对应 checklist（轻量检查：仅格式+来源） |
| 重量 | 分析推理、购买建议、写代码、多步规划 | 全检（轻量+工具+LLM Judge）+ 输出质检摘要 |

### 输出前强制检查（中等及以上任务不可跳过）

**通用规则（所有任务类型适用）：**
1. 输出格式必须规范（中文句号、英文句号后有空格）
2. 不要编造数据（不确定就标注[未验证]或[推测]）
3. 用户指令优先（有明确要求时先满足）

---

**思考推理类（分析、比较、评估、为什么）：**
1. 具体数字/价格/日期 → **场景化规则：**
   - 搜索任务：关键事实至少 2 个独立来源；单一来源必须标注 `⚠️ 仅单一来源，需进一步验证`
   - 价格任务：输出格式 `型号 + 价格（渠道 + 时间）`，如 `RTX 3090 1800元（闲鱼 2026-04-13）`
   - 性能任务：输出格式 `模型 + 量化方式 + context + 软件栈`，如 `Llama 3.1 Q4_K_M / 8K / vLLM`
2. 每个结论 → 标注确信度 [确定] [高概率] [推测]
3. 是否只找了支持性证据 → 搜索时必须查找反面关键词；有反对观点必须提及
4. 超出验证范围的前提 → 必须声明[无法验证]

**信息搜索类（搜、查、找、最新）：**
1. 每条信息标注来源可信度 [一手] [二手] [三手]
2. 关键事实至少 2 个独立来源确认
3. 数据有时间戳或标注时效
4. 事实和观点明确分离

**代码编写类（写代码、改代码、部署）：**
1. 无硬编码密钥/未校验输入/敏感端口暴露
2. 有边界条件处理和异常捕获
3. 跑通测试或 curl 验证才能交付，必须声明：`[已测试]` 或 `[未测试]`
4. 只改该改的文件

---

### 失败分类 + 修正模板

**失败代码库：**
| 失败码 | 含义 | 修正模板 |
|-------|------|----------|
| `fact_missing` | 事实缺失 | 改写为 `[事实] + （来源 + 时间）` |
| `no_source` | 缺少来源 | 添加 `来源：[URL]` |
| `single_source` | 单一来源 | 添加 `⚠️ 仅单一来源，需进一步验证` |
| `no_counter_evidence` | 缺少反面证据 | 添加：`也有观点认为...（引用来源）` |
| `confidence_missing` | 确信度未标注 | 添加：`[确定]` 或 `[高概率]` 或 `[推测]` |
| `hard_claim_no_source` | 硬主张无来源 | 添加：`具体型号 + 渠道 + 时间` 或标注 `[未验证]` |
| `code_untested` | 代码未测试 | 添加：`[已测试]` 或标注测试方法 |

**质检输出格式（带修正建议）：**
```
[质检: reasoning FAIL [fact_missing] — 价格数据未注明具体型号+渠道]

建议修正：
原句："RTX 3090 1800元"
修正为："RTX 3090 1800元（闲鱼 2026-04-13）"

---
修正中...
```

---

### 输出格式强制
**中等及以上任务的回复末尾必须附加（不可省略）：**
```
[质检: 类型 X/X ✓]
1. 条目名 ✓/✗ — 简要说明
2. ...
---
如有失败，按上述模板输出修正建议
```
有 fail 条目时，先修正再发送，不发送未通过质检的内容。

### 长回复收尾约束
**问题**：长回复（>2000字）容易收尾仓促，质检摘要被遗漏。
**规则**：任何中等及以上任务，回复末尾必须包含质检摘要，哪怕内容被 context 压缩中断。
**强制格式**：
```
[质检: 类型 X/X ✓]
[质检日志已记录]
```
以上两行不可省略，不可合并为一行，不可替换为其他文字。

### 质检日志（标准化格式）

**质检结果记录到 `quality-gate/logs/YYYY-MM-DD.json`：**

```json
{
  "time": "2026-04-13T10:00:00+08:00",
  "task_type": "reasoning",
  "level": "重量",
  "task_summary": "任务简述",
  "checklist_results": [
    {"name": "fact_traceable", "status": "pass", "time_ms": 5},
    {"name": "confidence_labeled", "status": "pass", "time_ms": 3},
    {"name": "counter_evidence", "status": "fail", "time_ms": 50},
    {"name": "boundary_declared", "status": "pass", "time_ms": 4}
  ],
  "overall": "FAIL",
  "fail_category": "no_counter_evidence",
  "suggestion": "添加反面证据",
  "user_feedback": null,
  "corrected": false
}
```

**失败分类参考：**
- `fact_missing` — 事实缺失
- `no_source` — 缺少来源
- `single_source` — 单一来源
- `no_counter_evidence` — 缺少反面证据
- `confidence_missing` — 确信度未标注
- `hard_claim_no_source` — 硬主张无来源
- `code_untested` — 代码未测试

- `format_error` — 格式错误

- `other` — 其他

**用户反馈闭环：**
- 用户回复 "1" 或 "有用" → `user_feedback: "accepted"`
- 用户回复 "0" 或 "不对" 或 "数据错误" → `user_feedback: "rejected` 并记录失败原因
- 每周统计：哪些 fail_category 被用户否定最多 → 自动调整 checklist 详细度

## 质量检查 #强制（Harness Hook）

修改文件后必须验证，不要猜：
- 改代码 → 跑测试或 curl 验证响应
- 改配置 → 重启服务确认生效
- 声称完成 → 粘贴验证结果再汇报

**多步修改时**：改完立即测试，不要攒一堆一起测。发现错误立刻修，不要跳过。

## 安全

- 私有数据不外泄
- 外部操作（发邮件、发帖）先问
- `trash` > `rm`
- 群聊中不暴露用户隐私

## 群聊行为

- 直接 @ 或能提供价值时才回复，否则 NO_REPLY
- 不刷屏，质量 > 数量

## 心跳 & Cron

- 心跳用来批量检查（邮件+日历+天气）
- Cron 用于精确时间或隔离任务
- HEARTBEAT.md 写小清单，空文件跳过

## 快照

手动保存：`save-snapshot.sh "任务" "状态" "描述"`
自动加载：每次新会话自动运行 `load-snapshot.sh`

## 文件管理

- 修改后 commit workspace
- 重要信息写文件，不要"记住"
- 记忆三层：热上下文 → MEMORY.md → memory/YYYY-MM-DD.md

---

*备份原版: `backups/harness-20260401-090118/AGENTS.md`*
