# 日常消费

轻量、清晰、可离线使用的个人记账应用。把记账变成可持续的习惯。

## 在线体验

- 网页版：https://xiaofeiapp-d9ghb3hggdc33c5b8-1473415600.tcloudbaseapp.com/xiaofei9/
- 手机版：通过 `android/` 下的 WebView 壳打包成 APK（包名 `com.frieny.xiaofeiapp`）。
- 直接下载 APK：[Releases · v2.6.0](https://github.com/frieny1/xiaofeiapp/releases/latest)

## 目录结构

```
xiaofeiapp/
├── web/        # 网页端源码（PWA 单文件，含全部 HTML/CSS/JS）
│   ├── index.html
│   ├── sw.js
│   ├── manifest.webmanifest
│   ├── version.json
│   └── icon-*.png / *.svg
├── android/    # Android 套壳源码（WebView）
│   ├── AndroidManifest.xml
│   ├── src/com/frieny/xiaofeiapp/MainActivity.java
│   ├── res/drawable/app_icon.png
│   └── build.sh            # 手动打包脚本（不依赖 Gradle）
├── dist/       # 已构建的安装包
│   └── xiaofei-v2.6.0.apk
├── archive/    # 历史版本归档
│   └── v24/                # v24 原始文件（网页端四件套）
└── docs/       # 文档
    ├── 日常消费-产品说明书.docx
    └── 日常消费-用户使用说明书.docx
```

## 主要功能

- 收支记账、分类管理、预算管理
- 账单搜索（含日历选日期）、批量管理
- 统计分析（日历、分类占比、本周/上周对比、月度环比）
- 周期账单、存钱目标、旅游记账
- 多用户、隐私模式、备份导出、OCR 截图识别
- 离线可用、应用内更新

## 版本

当前 v28。更新机制：网页 fetch `version.json` 比对版本号，检测到新版时提示「立即更新」。

## 注意

签名密钥（release.keystore）与密码不入库，请本地妥善保管。
