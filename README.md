# thinking-core

> 🍔 麦乐鸡出品 — AI Agent 思考推理核心能力

## 是什么

一套给 AI Agent 使用的"思考推理能力"封装，让 AI 的输出质量可量化、可改进、不合格不出厂。

不是让 AI 更聪明，是给每个动作加一道质检。

## 核心架构（v2）

```
用户任务
  ↓
① 任务理解 → 模糊则确认
  ↓
② 架构提案（所有任务，用户确认）→ 不同意则重新设计
  ↓
③ 架构分析（内部推理）
  ↓
④ 工具执行层
  ↓
⑤ Checklist 终检
  ↓
⑥ 发送结果
```

## 包含什么

| 文件 | 作用 |
|------|------|
| `AGENTS.md` | 主规则引擎（含架构层触发条件） |
| `SOUL.md` | 核心原则 + 批判性思维生成原则 |
| `MEMORY.md` | 体系知识 + 执行计划 |
| `checklists/reasoning.md` | 思考推理 checklist |
| `checklists/coding.md` | 代码编写 checklist |
| `checklists/search.md` | 信息搜索 checklist |
| `checklists/writing.md` | 内容生成 checklist |
| `checklists/delivery.md` | 交付终检 checklist |
| `scripts/setup.sh` | 一键安装脚本 |

## 批判性思维生成原则（SOUL.md）

每次生成回复时，必须执行：

1. **顺向检测** — 是否在重复用户观点？是则补充不同角度
2. **反方搜索** — 存在不同意见？必须标注`[反方观点]`
3. **利益立场识别** — 标注`[官方]`/`[厂商利益]`/`[社区]`/`[来源不明]`
4. **意外惊喜** — 补充用户可能没想到的信息，格式`[另外]`

## 执行方式

**主动触发，不是模型自觉。**

触发命令：`/skill:quality-gate`

每个质检模块 = 一个独立 skill，需要哪个触发哪个。

## 快速安装

```bash
git clone https://github.com/sxing77/thinking-core-claw.git
cd thinking-core-claw
git checkout dev  # v2 开发版
bash scripts/setup.sh
openclaw gateway restart
```

## 任务分级

| 级别 | 特征 | 质检要求 |
|------|------|---------|
| 轻量 | 查天气、简单问答 | 架构提案（单行） |
| 中等 | 搜索整理、写文案 | 架构提案（完整）+ checklist |
| 重量 | 分析推理、写代码、多步规划 | 架构提案 + 工具层 + 全 checklist |

## 失败分类

| 代码 | 含义 | 修正方式 |
|------|------|---------|
| `fact_missing` | 事实缺失 | 补充来源 + 时间 |
| `no_source` | 缺少来源 | 添加 URL |
| `single_source` | 单一来源 | 标注 ⚠️ |
| `no_counter_evidence` | 缺少反面证据 | 补充不同观点 |
| `confidence_missing` | 确信度未标注 | 补充 [确定]/[高概率]/[推测] |
| `hard_claim_no_source` | 硬主张无来源 | 补充具体信息或标注 [未验证] |
| `code_untested` | 代码未测试 | 补充 [已测试] |

## 外部数据支撑（2025-2026）

| 研究 | 关键结论 |
|------|---------|
| Superface / Applied AI 2025 | 5步工作流成功率59%，减少步骤数是最有效的可靠性手段 |
| NeurIPS 2025 | 自验证在可验证领域（数学/代码）有效，准确率提升最高14% |
| Self-Verification Dilemma 2025 | 大量反射步骤是重复且无意义的确认性重检，可节省20.3% token |
| THINKSLM EMNLP 2025 | SLM推理能力主要由训练方法决定，Qwen2.5-32B与GPT-4-Turbo持平 |
| Zylos 2026 | 双层评估：Reasoning Layer + Action Layer |

## 分支说明

| 分支 | 内容 |
|------|------|
| `main` | v1.0 稳定版 |
| `dev` | v2.0 开发版（含架构层、批判性思维生成原则） |

## 背景

2026-04-12 麦乐鸡与胖可乐共创，2026-04-13 发布 v1.0，2026-04-13 迭代 v2.0。

参考了 OpenClaw PR #21832、CRITIC（Gou et al. 2023）、Self-Verification（Weng et al. 2022）、Kaya Stechly 反直觉发现、NeurIPS 2025、THINKSLM EMNLP 2025。
