# thinking-core

> 🍔 麦乐鸡出品 — AI Agent 思考推理核心能力

## 是什么

一套给 AI Agent 使用的"思考推理能力"封装，让 AI 的输出质量可量化、可改进、不合格不出厂。

## 包含什么

- **质量保障体系（Quality Gate）**：输出前强制质检，不合格不出厂
- **场景化规则**：不同任务类型有不同的检查标准（价格/性能/搜索）
- **失败分类系统**：7 个失败码 + 修正模板，不只报错还给解法
- **五大质检清单**：思考推理 / 代码编写 / 信息搜索 / 内容生成 / 交付终检

## 快速安装

```bash
git clone https://github.com/sxing77/thinking-core-claw.git
cd thinking-core-claw
bash scripts/setup.sh
openclaw gateway restart
```

## 安装内容

| 文件 | 作用 |
|------|------|
| `AGENTS.md` | 主规则引擎（核心） |
| `SOUL.md` | 核心原则 + 信用gate |
| `checklists/reasoning.md` | 思考推理 checklist |
| `checklists/coding.md` | 代码编写 checklist |
| `checklists/search.md` | 信息搜索 checklist |
| `checklists/writing.md` | 内容生成 checklist |
| `checklists/delivery.md` | 交付终检 checklist |

## 核心概念

### 任务分级

| 级别 | 特征 | 质检要求 |
|------|------|---------|
| 轻量 | 查天气、简单问答 | 不检 |
| 中等 | 搜索整理、写文案、总结 | 只检 checklist |
| 重量 | 分析推理、写代码、多步规划 | 全检 + 输出质检摘要 |

### 质检流程

```
任务完成，准备输出
  ↓
判断任务级别
  ↓ 轻量 → 直接发送
  ↓ 中等/重量
加载对应 checklist → 逐条检查
  ↓
全部 pass → 发送 + 记录日志
有 fail → 修正 → 重新检查
```

### 失败分类

| 代码 | 含义 | 修正方式 |
|------|------|---------|
| `fact_missing` | 事实缺失 | 补充来源 + 时间 |
| `no_source` | 缺少来源 | 添加 URL |
| `single_source` | 单一来源 | 标注 ⚠️ |
| `no_counter_evidence` | 缺少反面证据 | 补充不同观点 |
| `confidence_missing` | 确信度未标注 | 补充 [确定]/[高概率]/[推测] |
| `hard_claim_no_source` | 硬主张无来源 | 补充具体信息或标注 [未验证] |
| `code_untested` | 代码未测试 | 补充 [已测试] |

## 适用场景

- **AI Agent 开发**：给 Agent 装上质检能力
- **多 Agent 协作**：统一输出质量标准
- **工作流自动化**：作为判断节点嵌入流程

## 不适用场景

- OpenCode / Claude Code 等代码驱动型 Agent（规则嵌在 SDK 里，无法外部扩展）
- 只需要轻量对话的场景

## 背景

2026-04-12 麦乐鸡与胖可乐共创，2026-04-13 发布初始版本。

参考了 OpenClaw PR #21832、CRITIC（Gou et al. 2023）、Self-Verification（Weng et al. 2022）、Kaya Stechly 反直觉发现。
