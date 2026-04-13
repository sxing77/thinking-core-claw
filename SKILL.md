---
name: thinking-core
description: AI Agent 思考推理核心能力 — 麦乐鸡出品。包含质量保障体系、场景化规则、失败分类系统。适用于需要分析、推理、评估的重量级任务。
---

# thinking-core

> AI Agent 质量保障体系 | 麦乐鸡 🍔

## 是什么

一套给 AI Agent 使用的"思考推理能力"封装，包含：

- **质量保障体系**（Quality Gate）：输出前强制质检，不合格不出厂
- **场景化规则**：不同任务类型有不同的检查标准
- **失败分类系统**：不只是报错，还给修正模板
- **五大质检清单**：思考推理 / 代码编写 / 信息搜索 / 内容生成 / 交付终检

## 文件结构

```
thinking-core/
├── SKILL.md              ← 本文件
├── AGENTS.md             ← 主规则引擎（核心）
├── SOUL.md               ← 核心原则 + 信用gate
├── MEMORY.md             ← 体系知识 + 执行计划
├── checklists/           ← 五张质检清单
│   ├── reasoning.md      # 思考推理 checklist
│   ├── coding.md         # 代码编写 checklist
│   ├── search.md         # 信息搜索 checklist
│   ├── writing.md        # 内容生成 checklist
│   └── delivery.md       # 交付终检 checklist
├── scripts/
│   └── setup.sh          ← 一键安装脚本
└── README.md             ← 使用说明
```

## 核心规则

### 任务分级

| 级别 | 特征 | 质检要求 |
|------|------|---------|
| 轻量 | 查天气、简单问答、格式转换 | 不检 |
| 中等 | 搜索整理、写文案、总结文章 | 只检 checklist |
| 重量 | 分析推理、写代码、多步规划 | 全检 + 质检摘要 |

### 质检流程

```
任务完成，准备输出
  ↓
判断任务级别（轻量？中等？重量？）
  ↓ 轻量 → 直接发送
  ↓ 中等/重量
加载对应 checklist
  ↓
逐条检查（每条 pass/fail）
  ↓
全部 pass → 发送 + 记录日志
有 fail → 修正 → 重新检查
```

### 质检日志

记录到 `quality-gate/logs/YYYY-MM-DD.json`，标准化格式：

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
  "suggestion": "添加反面证据"
}
```

## 安装

```bash
git clone https://github.com/sxing77/thinking-core-claw.git
cd thinking-core-claw
bash scripts/setup.sh
openclaw gateway restart
```

## 背景

2026-04-12 麦乐鸡与胖可乐共创，2026-04-13 完成初始版本。
