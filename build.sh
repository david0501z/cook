#!/bin/bash

# 菜谱大全APP构建脚本

echo "🍳 开始构建菜谱大全APP..."

# 检查Flutter环境
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    exit 1
fi

# 检查项目依赖
echo "📦 检查项目依赖..."
flutter pub get

# 运行分析
echo "🔍 运行代码分析..."
flutter analyze

# 运行测试
echo "🧪 运行测试..."
flutter test

# 清理之前的构建
echo "🧹 清理之前的构建..."
flutter clean

# 重新获取依赖
flutter pub get

# 构建APK
echo "📱 构建Android APK..."
flutter build apk --release

# 检查构建结果
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ APK构建成功！"
    echo "📍 APK位置：build/app/outputs/flutter-apk/app-release.apk"
    
    # 显示APK信息
    ls -lh build/app/outputs/flutter-apk/app-release.apk
else
    echo "❌ APK构建失败"
    exit 1
fi

echo "🎉 构建完成！"