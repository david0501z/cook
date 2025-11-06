import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../database/database_helper.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  String _selectedCategory = '全部';
  List<String> _categories = ['全部'];
  bool _isLoading = false;

  List<Recipe> get recipes => _filteredRecipes.isEmpty && _selectedCategory == '全部' 
      ? _recipes 
      : _filteredRecipes;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;

  // 初始化数据
  Future<void> initializeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await DatabaseHelper.instance.getAllRecipes();
      _categories = await DatabaseHelper.instance.getCategories();
      _categories.insert(0, '全部');
      _filteredRecipes = [];
    } catch (e) {
      debugPrint('Error loading recipes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 刷新数据
  Future<void> refreshData() async {
    await initializeData();
  }

  // 根据分类筛选
  void filterByCategory(String category) {
    _selectedCategory = category;
    if (category == '全部') {
      _filteredRecipes = [];
    } else {
      _filteredRecipes = _recipes.where((recipe) => recipe.category == category).toList();
    }
    notifyListeners();
  }

  // 搜索菜谱
  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) {
      filterByCategory(_selectedCategory);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final searchResults = await DatabaseHelper.instance.searchRecipes(query);
      if (_selectedCategory == '全部') {
        _filteredRecipes = searchResults;
      } else {
        _filteredRecipes = searchResults.where((recipe) => recipe.category == _selectedCategory).toList();
      }
    } catch (e) {
      debugPrint('Error searching recipes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 获取随机菜谱
  Future<List<Recipe>> getRandomRecipes(int count) async {
    return await DatabaseHelper.instance.getRandomRecipes(count);
  }

  // 添加菜谱
  Future<bool> addRecipe(Recipe recipe) async {
    try {
      final id = await DatabaseHelper.instance.insertRecipe(recipe);
      final newRecipe = recipe.copyWith(id: id);
      _recipes.insert(0, newRecipe);
      
      // 更新分类列表
      if (!_categories.contains(recipe.category)) {
        _categories.add(recipe.category);
        _categories.sort();
      }
      
      // 重新筛选
      filterByCategory(_selectedCategory);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding recipe: $e');
      return false;
    }
  }

  // 更新菜谱
  Future<bool> updateRecipe(Recipe recipe) async {
    try {
      await DatabaseHelper.instance.updateRecipe(recipe);
      final index = _recipes.indexWhere((r) => r.id == recipe.id);
      if (index != -1) {
        _recipes[index] = recipe;
      }
      
      // 重新筛选
      filterByCategory(_selectedCategory);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating recipe: $e');
      return false;
    }
  }

  // 删除菜谱
  Future<bool> deleteRecipe(int id) async {
    try {
      await DatabaseHelper.instance.deleteRecipe(id);
      _recipes.removeWhere((recipe) => recipe.id == id);
      
      // 重新筛选
      filterByCategory(_selectedCategory);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting recipe: $e');
      return false;
    }
  }

  // 重置搜索
  void resetSearch() {
    _filteredRecipes = [];
    notifyListeners();
  }

  // 清除筛选
  void clearFilter() {
    _selectedCategory = '全部';
    _filteredRecipes = [];
    notifyListeners();
  }
}