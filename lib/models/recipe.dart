class Recipe {
  final int? id;
  final String name;
  final String category;
  final String description;
  final String ingredients;
  final String steps;
  final String imagePath;
  final int cookingTime; // 烹饪时间（分钟）
  final int difficulty; // 难度 1-5
  final DateTime createdAt;

  Recipe({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.imagePath,
    required this.cookingTime,
    required this.difficulty,
    required this.createdAt,
  });

  // 从Map创建Recipe对象
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      ingredients: map['ingredients'],
      steps: map['steps'],
      imagePath: map['imagePath'],
      cookingTime: map['cookingTime'],
      difficulty: map['difficulty'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // 转换为Map格式
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'imagePath': imagePath,
      'cookingTime': cookingTime,
      'difficulty': difficulty,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // 复制Recipe对象
  Recipe copyWith({
    int? id,
    String? name,
    String? category,
    String? description,
    String? ingredients,
    String? steps,
    String? imagePath,
    int? cookingTime,
    int? difficulty,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      imagePath: imagePath ?? this.imagePath,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // 获取难度文本
  String get difficultyText {
    switch (difficulty) {
      case 1:
        return '简单';
      case 2:
        return '容易';
      case 3:
        return '中等';
      case 4:
        return '困难';
      case 5:
        return '专业';
      default:
        return '未知';
    }
  }

  // 获取难度颜色
  Color get difficultyColor {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }
}