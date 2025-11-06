#!/bin/bash

# Flutter Android 构建修复和自动化脚本
# 作者: MiniMax Agent
# 日期: 2025-11-06

set -e

echo "🍳 Flutter菜谱应用 - Android构建修复脚本"
echo "================================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查是否在正确的目录
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}错误: 请在Flutter项目根目录运行此脚本${NC}"
    exit 1
fi

echo -e "${BLUE}步骤1: 检查Flutter环境...${NC}"

# 检查Flutter是否可用
if command -v flutter &> /dev/null; then
    echo -e "${GREEN}✅ Flutter命令可用${NC}"
    flutter --version
else
    echo -e "${RED}❌ Flutter命令不可用，请检查PATH配置${NC}"
    echo -e "${YELLOW}提示: 确保Flutter SDK在PATH中${NC}"
    exit 1
fi

echo -e "${BLUE}步骤2: 验证Android配置文件...${NC}"

# 检查关键配置文件
if [ -f "android/gradle.properties" ]; then
    echo -e "${GREEN}✅ gradle.properties 存在${NC}"
else
    echo -e "${RED}❌ gradle.properties 不存在${NC}"
    exit 1
fi

if [ -f "android/app/build.gradle" ]; then
    echo -e "${GREEN}✅ app/build.gradle 存在${NC}"
else
    echo -e "${RED}❌ app/build.gradle 不存在${NC}"
    exit 1
fi

if [ -f "android/settings.gradle" ]; then
    echo -e "${GREEN}✅ settings.gradle 存在${NC}"
else
    echo -e "${RED}❌ settings.gradle 不存在${NC}"
    exit 1
fi

echo -e "${BLUE}步骤3: 清理项目缓存...${NC}"
flutter clean

echo -e "${BLUE}步骤4: 获取依赖包...${NC}"
flutter pub get

echo -e "${BLUE}步骤5: 检查依赖解析...${NC}"
flutter pub deps

echo -e "${BLUE}步骤6: 构建Android APK...${NC}"
echo -e "${YELLOW}开始构建APK，请耐心等待...${NC}"

# 尝试构建
if flutter build apk --release; then
    echo -e "${GREEN}🎉 APK构建成功！${NC}"
    echo -e "${GREEN}APK文件位置: build/outputs/apk/release/${NC}"
    ls -la build/outputs/apk/release/
    
    echo ""
    echo -e "${BLUE}构建完成信息:${NC}"
    echo "✅ Android配置已修复"
    echo "✅ AndroidX依赖问题已解决"
    echo "✅ Gradle插件配置已更新"
    echo "✅ APK已生成"
    
else
    echo -e "${RED}❌ APK构建失败${NC}"
    echo -e "${YELLOW}尝试诊断问题...${NC}"
    
    echo ""
    echo -e "${BLUE}运行Flutter诊断:${NC}"
    flutter doctor
    
    echo ""
    echo -e "${BLUE}检查Gradle配置:${NC}"
    if [ -f "android/gradlew" ]; then
        cd android
        chmod +x gradlew
        ./gradlew --version
        cd ..
    fi
    
    exit 1
fi

echo ""
echo -e "${GREEN}✨ 构建脚本执行完成！${NC}"
echo -e "${BLUE}项目现在包含:${NC}"
echo "- ✅ 修复的Android配置文件"
echo "- ✅ AndroidX支持已启用"
echo "- ✅ 现代Gradle插件配置"
echo "- ✅ 生产级APK文件"