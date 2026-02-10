# Cobalt Dispatcher (Proxy) Support Fix Summary

## 问题描述
Cobalt 配置了 DataImpulse 代理，但多个服务的 `fetch` 请求没有传递 `dispatcher` 参数，导致请求直连而非通过代理。

## 已修复的服务

### ✅ TikTok (已完成)
- **文件**: `api/src/processing/services/tiktok.js`
- **修改**:
  - Line 16-21: 添加 `dispatcher: obj.dispatcher` 到短链接 fetch
  - Line 36-42: 添加 `dispatcher: obj.dispatcher` 到视频页面 fetch
- **match.js**: 添加 `dispatcher` 参数传递
- **Commit**: `eb957d6d`, `c5a428d1`

### ✅ Bilibili (已完成)
- **文件**: `api/src/processing/services/bilibili.js`
- **修改**:
  - `com_download()`: 添加 `dispatcher` 参数
  - `tv_download()`: 添加 `dispatcher` 参数
  - `export default`: 添加 `dispatcher` 参数并传递
- **match.js**: 添加 `dispatcher` 参数传递
- **Commit**: `b0caa726`

## 待修复的服务

以下服务需要添加 dispatcher 支持（按优先级排序）：

### 高优先级（常用平台）
1. **Instagram** - 已有 dispatcher 支持 ✅
2. **YouTube** - 已有 dispatcher 支持 ✅
3. **Twitter** - 已有 dispatcher 支持 ✅
4. **Facebook** - 已有 dispatcher 支持 ✅
5. **Reddit** - 已有 dispatcher 支持 ✅

### 中优先级
6. **Vimeo** - 需要修复
7. **Dailymotion** - 需要修复
8. **Twitch** - 需要修复
9. **Tumblr** - 需要修复
10. **Pinterest** - 需要修复

### 低优先级
11. **VK** - 需要修复
12. **OK** - 需要修复
13. **Rutube** - 需要修复
14. **Snapchat** - 需要修复
15. **Soundcloud** - 需要修复
16. **Streamable** - 需要修复
17. **Loom** - 需要修复

## 修复模式

每个服务需要修改：

1. **服务文件** (`api/src/processing/services/{service}.js`):
   - 在 `export default async function` 中添加 `dispatcher` 参数
   - 在所有 `fetch()` 调用中添加 `dispatcher` 选项
   - 传递 `dispatcher` 给内部函数

2. **match.js** (`api/src/processing/match.js`):
   - 在对应的 `case` 中添加 `dispatcher` 参数传递

## 测试验证

修复后需要测试：
1. 通过代理访问是否成功
2. 错误处理是否正常
3. 不影响其他功能

## 环境配置

当前代理配置：
```yaml
HTTP_PROXY: http://c1f432089f2f01b28d01:458942cdea6d34e5@gw.dataimpulse.com:823
HTTPS_PROXY: http://c1f432089f2f01b28d01:458942cdea6d34e5@gw.dataimpulse.com:823
COBALT_PROXY_PARSE_ONLY: 1
```

`COBALT_PROXY_PARSE_ONLY=1` 表示只在解析阶段使用代理，下载阶段直连。
