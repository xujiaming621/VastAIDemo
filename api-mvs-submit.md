# MVS Submit API 接口文档

## 接口概述

`/api/mvs/submit` 接口用于将 MVS（模块化虚拟服务）工单数据提交到 Dify AI 平台进行处理。该接口接收任意 JSON 格式的工单数据，将其转发到 Dify 平台，并返回一个会话 ID 和重定向 URL，用户可以通过该 URL 查看 AI 处理结果。

## 基本信息

- **接口地址**: `POST http://43.139.131.125:8081/api/mvs/submit`
- **请求方式**: POST
- **Content-Type**: `application/json`
- **响应格式**: JSON

## 请求参数

### 请求体 (Body)

接口接收任意 JSON 格式的数据。数据将被原样转发到 Dify AI 平台进行处理。

#### 示例请求体

```json
{
    "customerName": "示例客户",
    "environment": "生产",
    "productVersion": "1.2.3",
    "hardwarePlatform": "x86",
    "osVersion": "CentOS 7",
    "severity": "高",
    "urgency": "中",
    "description": "这是一个通过JSON导入的exbase问题描述。",
    "category": "exBase",
    "exBase": {
        "sourceDbVersion": "MySQL 5.7",
        "targetDbVersion": "PostgreSQL 13",
        "actionExecuted": "数据迁移"
    }
}
```

#### 字段说明

接口不限制具体的字段结构，可以传递任意 JSON 数据。常见的工单字段包括：

| 字段名 | 类型 | 说明 | 示例 |
|--------|------|------|------|
| customerName | string | 客户名称 | "示例客户" |
| environment | string | 环境类型 | "生产"、"测试"、"开发" |
| productVersion | string | 产品版本 | "1.2.3" |
| hardwarePlatform | string | 硬件平台 | "x86"、"ARM" |
| osVersion | string | 操作系统版本 | "CentOS 7"、"Windows Server 2019" |
| severity | string | 严重程度 | "高"、"中"、"低" |
| urgency | string | 紧急程度 | "高"、"中"、"低" |
| description | string | 问题描述 | 详细的问题描述文本 |
| category | string | 问题分类 | "exBase"、"performance"、"security" 等 |
| 其他自定义字段 | any | 根据具体需求定义 | 任意 JSON 数据 |

## 响应格式

### 成功响应 (HTTP 200)

```json
{
    "success": true,
    "message": "MVS工单数据已提交至Dify",
    "sessionId": "mvs-1744195200000-abc123def",
    "conversationId": "conv-1234567890abcdef",
    "redirectUrl": "http://127.0.0.1:8081/support-chat.html?conversation_id=conv-1234567890abcdef"
}
```

#### 字段说明

| 字段名 | 类型 | 说明 |
|--------|------|------|
| success | boolean | 请求是否成功，始终为 `true` |
| message | string | 成功消息 |
| sessionId | string | 本次会话的唯一标识符，格式为 `mvs-时间戳-随机字符串` |
| conversationId | string | Dify 平台返回的会话 ID |
| redirectUrl | string | 重定向 URL，用户可以通过此 URL 查看 AI 处理结果 |

### 错误响应

#### 400 Bad Request
```json
{
    "error": "Bad Request",
    "message": "请求数据不能为空"
}
```

#### 502 Bad Gateway
```json
{
    "error": "Dify Error",
    "message": "Dify未返回有效的conversation_id"
}
```

#### 504 Gateway Timeout
```json
{
    "error": "Gateway Timeout",
    "message": "等待Dify conversation_id超时",
    "code": 504
}
```

#### 500 Internal Server Error
```json
{
    "error": "Internal Server Error",
    "message": "具体的错误信息"
}
```

## 使用示例

### cURL 示例

```bash
curl -X POST http://127.0.0.1:8081/api/mvs/submit \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "测试客户",
    "environment": "测试",
    "productVersion": "2.0.0",
    "description": "测试问题描述"
  }'
```

### JavaScript Fetch 示例

```javascript
const response = await fetch('http://127.0.0.1:8081/api/mvs/submit', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({
        customerName: '测试客户',
        environment: '测试',
        productVersion: '2.0.0',
        description: '测试问题描述'
    })
});

const result = await response.json();
console.log(result);

if (result.success) {
    // 重定向到聊天界面
    window.location.href = result.redirectUrl;
}
```

### Python 示例

```python
import requests
import json

url = "http://127.0.0.1:8081/api/mvs/submit"
data = {
    "customerName": "测试客户",
    "environment": "测试",
    "productVersion": "2.0.0",
    "description": "测试问题描述"
}

response = requests.post(url, json=data)
result = response.json()

if result.get("success"):
    print(f"会话ID: {result['sessionId']}")
    print(f"重定向URL: {result['redirectUrl']}")
else:
    print(f"错误: {result.get('error')} - {result.get('message')}")
```

## 技术细节

### 数据处理流程

1. **接收请求**: 接口接收 POST 请求和 JSON 数据
2. **数据验证**: 检查请求数据是否为空
3. **会话ID生成**: 生成唯一的会话 ID (`mvs-时间戳-随机字符串`)
4. **JSON格式优化**: 对时间格式中的 `~` 符号进行保护，避免被 Markdown 解析器误解析为删除线格式
5. **转发到Dify**: 将优化后的 JSON 数据转发到 Dify AI 平台
6. **等待响应**: 等待 Dify 返回 `conversation_id`
7. **返回结果**: 返回会话信息和重定向 URL

### 超时设置

- **Dify请求超时**: 30秒
- **服务器超时**: 310秒

### 特殊处理

#### JSON格式优化
接口会对 JSON 字符串中的时间格式进行特殊处理，将 `~时间` 格式中的 `~` 替换为全角波浪号 `～`，以防止 Markdown 解析器将其误解析为删除线格式。例如：
- 原始: `"time": "~10:30"`
- 优化后: `"time": "～10:30"`

### 配置信息

#### API密钥
接口使用固定的 Dify API 密钥进行身份验证：
```javascript
const MVS_DIFY_API_KEY = 'app-99L4qvG2FF9611Pl6OkYSkbo';
```

#### 用户标识
所有通过此接口提交的请求都使用相同的用户标识：
```javascript
const userId = 'mvs-user';
```

#### Dify请求参数
转发到 Dify 平台的请求包含以下固定参数：
- `inputs`: 空对象 `{}`
- `response_mode`: `'streaming'`（流式响应模式）
- `user`: `'mvs-user'`（用户标识）

## 注意事项

1. **数据格式**: 接口接收任意 JSON 格式数据，但建议保持结构清晰，便于 AI 理解
2. **超时处理**: 如果 Dify 平台在30秒内未返回 `conversation_id`，接口会返回504超时错误
3. **重定向**: 成功响应中包含 `redirectUrl`，用户应通过此 URL 查看 AI 处理结果
4. **CORS支持**: 接口设置了 `Access-Control-Allow-Origin: *`，支持跨域请求
5. **错误处理**: 建议客户端对可能的错误响应进行适当处理

## 相关文件

- `server.js`: 接口实现文件
- `example.json`: 示例数据文件
- `support-chat.html`: 聊天界面
- `support-submit.html`: 提交界面

## 版本信息

- **当前版本**: 1.0
- **最后更新**: 2024-04-09
- **服务端口**: 8081
- **Dify API**: http://101.35.56.39/v1/chat-messages