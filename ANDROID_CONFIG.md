# 安卓配置信息

## 应用基本信息

- 应用名称：菜谱大全
- 包名：com.recipe.app
- 版本：1.0.0
- 最小SDK版本：21 (Android 5.0)
- 目标SDK版本：34 (Android 14)

## 权限配置

应用需要以下权限：
- 访问网络（用于可能的在线功能）
- 访问存储（用于图片上传功能）

## 依赖库

已在pubspec.yaml中配置：
- sqflite: ^2.3.0 - SQLite数据库
- provider: ^6.1.1 - 状态管理
- image_picker: ^1.0.4 - 图片选择
- cached_network_image: ^3.3.0 - 网络图片缓存

## 构建配置

### 开发环境
```bash
flutter build apk --debug
```

### 生产环境
```bash
flutter build apk --release
```

### 签名配置
1. 生成密钥库：
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. 在android/app/build.gradle中配置签名信息

## 性能优化

- 使用cached_network_image优化图片加载
- 数据库查询优化
- 列表懒加载
- 图片压缩和缓存

## 兼容性

- Android 5.0+ (API 21+)
- 支持多种屏幕尺寸
- 横竖屏自适应