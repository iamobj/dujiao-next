本仓库是 `dujiao-next` 仓库的二开版本。上游代码通过 `upstream` 同步，二开改动保持在较小范围内，便于后续合并；`origin` 指向本项目远端。
如有新的二开逻辑或功能，需要更新此文档。

## 同步规则

- 先从 `upstream` 获取并检查变更，再在本地合并或变基。
- 上游冲突以本清单记录的业务行为为准，优先恢复二开逻辑而不是整文件替换。

## 二开清单

- 品牌与默认文案去上游化：前台默认站点名为空，移除前台 GitHub 链接和启动控制台品牌输出；站点配置存在时优先使用后台配置。
- 图标替换：`frontend/user/public/icon.webp` 作为默认图标，`frontend/user/public/dj.svg` 不再使用，favicon 回落到 `/icon.webp`。
- 联系方式展示：保留后端 `whatsapp` 配置字段以兼容数据；用户端 Footer、About 和 Vault 页面按微信样式展示，并直接显示配置值，底部使用站点 logo 或 `icon.webp`。
- 订单流交付标签：`frontend/user/src/composables/useProduct.ts` 识别 `订单流交付`，隐藏内部标签；带该标签的人工交付仅在前台显示为自动交付。购物车本地字段 `hasOrderFlowDeliveryTag` 在加入、恢复、更新时保留，不扩展后端订单 API。
- 注册流程：classic 与 Vault 注册页不显示或强制勾选协议，`useRegister.ts` 固定发送 `agreement_accepted: true`，邮箱验证码和验证码组件逻辑保持不变。

## 开发规范

- commit 使用 commitizen 规范，subject 为中文
