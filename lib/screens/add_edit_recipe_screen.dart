import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  const AddEditRecipeScreen({
    super.key,
    this.recipe,
  });

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  final _imagePathController = TextEditingController();

  String _selectedCategory = '川菜';
  int _cookingTime = 30;
  int _difficulty = 2;

  final List<String> _categories = [
    '川菜',
    '粤菜',
    '湘菜',
    '鲁菜',
    '苏菜',
    '浙菜',
    '闽菜',
    '徽菜',
    '家常菜',
    '汤类',
    '凉菜',
    '甜品',
    '其他',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _loadRecipeData();
    }
  }

  void _loadRecipeData() {
    final recipe = widget.recipe!;
    _nameController.text = recipe.name;
    _descriptionController.text = recipe.description;
    _ingredientsController.text = recipe.ingredients;
    _stepsController.text = recipe.steps;
    _imagePathController.text = recipe.imagePath;
    _selectedCategory = recipe.category;
    _cookingTime = recipe.cookingTime;
    _difficulty = recipe.difficulty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.recipe != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑菜谱' : '添加菜谱'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: const Text(
              '保存',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 菜名
              _buildTextField(
                controller: _nameController,
                label: '菜名',
                hint: '请输入菜名',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入菜名';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 分类和基本信息
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildCategoryDropdown(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDifficultyDropdown(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 烹饪时间
              _buildCookingTimeSlider(),
              const SizedBox(height: 16),

              // 描述
              _buildTextField(
                controller: _descriptionController,
                label: '菜品描述',
                hint: '简单描述这道菜的特点',
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // 食材
              _buildTextField(
                controller: _ingredientsController,
                label: '所需食材',
                hint: '请输入所需食材，用"、"分隔',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入所需食材';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 制作步骤
              _buildTextField(
                controller: _stepsController,
                label: '制作步骤',
                hint: '请输入制作步骤，每步用换行分隔',
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入制作步骤';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 图片路径（可选）
              _buildTextField(
                controller: _imagePathController,
                label: '图片路径（可选）',
                hint: 'assets/images/recipe_name.jpg',
              ),
              const SizedBox(height: 32),

              // 保存按钮
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEditing ? '更新菜谱' : '添加菜谱',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: '菜系分类',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey,
      ),
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value!;
        });
      },
    );
  }

  Widget _buildDifficultyDropdown() {
    return DropdownButtonFormField<int>(
      value: _difficulty,
      decoration: const InputDecoration(
        labelText: '难度',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey,
      ),
      items: const [
        DropdownMenuItem(value: 1, child: Text('简单')),
        DropdownMenuItem(value: 2, child: Text('容易')),
        DropdownMenuItem(value: 3, child: Text('中等')),
        DropdownMenuItem(value: 4, child: Text('困难')),
        DropdownMenuItem(value: 5, child: Text('专业')),
      ],
      onChanged: (value) {
        setState(() {
          _difficulty = value!;
        });
      },
    );
  }

  Widget _buildCookingTimeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '烹饪时间：$_cookingTime 分钟',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Slider(
          value: _cookingTime.toDouble(),
          min: 5,
          max: 120,
          divisions: 23,
          label: '$_cookingTime 分钟',
          activeColor: Colors.orange,
          onChanged: (value) {
            setState(() {
              _cookingTime = value.round();
            });
          },
        ),
      ],
    );
  }

  void _saveRecipe() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final recipe = Recipe(
      id: widget.recipe?.id,
      name: _nameController.text.trim(),
      category: _selectedCategory,
      description: _descriptionController.text.trim(),
      ingredients: _ingredientsController.text.trim(),
      steps: _stepsController.text.trim(),
      imagePath: _imagePathController.text.trim().isEmpty
          ? 'assets/images/default_recipe.jpg'
          : _imagePathController.text.trim(),
      cookingTime: _cookingTime,
      difficulty: _difficulty,
      createdAt: widget.recipe?.createdAt ?? DateTime.now(),
    );

    final provider = context.read<RecipeProvider>();
    
    if (widget.recipe != null) {
      // 编辑模式
      provider.updateRecipe(recipe).then((success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success ? '更新成功' : '更新失败'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
          if (success) {
            Navigator.of(context).pop();
          }
        }
      });
    } else {
      // 添加模式
      provider.addRecipe(recipe).then((success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success ? '添加成功' : '添加失败'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
          if (success) {
            Navigator.of(context).pop();
          }
        }
      });
    }
  }
}