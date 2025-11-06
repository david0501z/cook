import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'recipe_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 创建菜谱表
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        ingredients TEXT NOT NULL,
        steps TEXT NOT NULL,
        imagePath TEXT,
        cookingTime INTEGER NOT NULL,
        difficulty INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // 创建索引
    await db.execute('CREATE INDEX idx_category ON recipes(category)');
    await db.execute('CREATE INDEX idx_difficulty ON recipes(difficulty)');
    await db.execute('CREATE INDEX idx_name ON recipes(name)');

    // 插入初始数据
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    final recipes = [
      // 川菜类
      Recipe(
        name: '宫保鸡丁',
        category: '川菜',
        description: '经典川菜，酸甜微辣，鸡肉嫩滑，花生酥脆',
        ingredients: '鸡胸肉200g、花生米50g、干辣椒10个、葱段2根、蒜3瓣、生抽2勺、醋1勺、糖1勺、料酒1勺、淀粉1勺、盐适量',
        steps: '''1. 鸡胸肉切丁，加料酒、淀粉抓匀腌制15分钟
2. 花生米用油炸至酥脆盛起
3. 热锅下油，爆炒鸡丁至变色盛起
4. 锅内留底油，下干辣椒、蒜爆香
5. 下鸡丁翻炒，加调味料炒匀
6. 最后加入花生米和葱段炒匀即可''',
        imagePath: 'assets/images/gongbao_chicken.jpg',
        cookingTime: 20,
        difficulty: 3,
        createdAt: DateTime.now(),
      ),
      Recipe(
        name: '麻婆豆腐',
        category: '川菜',
        description: '川菜经典，麻辣鲜香，豆腐嫩滑',
        ingredients: '嫩豆腐1块、肉末50g、豆瓣酱2勺、花椒粉适量、蒜末1勺、葱花适量、淀粉水适量、盐适量',
        steps: '''1. 豆腐切块，用盐水焯烫去腥
2. 热锅下油，炒肉末至变色
3. 下豆瓣酱、蒜末炒出红油
4. 加适量水烧开，下豆腐炖3分钟
5. 淋入淀粉水勾芡
6. 撒花椒粉和葱花即可''',
        imagePath: 'assets/images/mapo_tofu.jpg',
        cookingTime: 15,
        difficulty: 2,
        createdAt: DateTime.now(),
      ),
      Recipe(
        name: '鱼香肉丝',
        category: '川菜',
        description: '酸甜咸辣，无鱼而有鱼香，肉丝嫩滑',
        ingredients: '里脊肉200g、木耳5朵、胡萝卜半根、青椒1个、豆瓣酱1勺、醋2勺、糖1勺、生抽1勺、淀粉1勺、葱姜蒜适量',
        steps: '''1. 肉丝用生抽、淀粉腌制15分钟
2. 配菜切丝，焯水备用
3. 热锅下油，滑炒肉丝至变色盛起
4. 锅内留底油，炒豆瓣酱出红油
5. 下配菜翻炒，加肉丝炒匀
6. 调入鱼香汁炒至收汁即可''',
        imagePath: 'assets/images/fish_flavored_pork.jpg',
        cookingTime: 25,
        difficulty: 3,
        createdAt: DateTime.now(),
      ),
      // 粤菜类
      Recipe(
        name: '白切鸡',
        category: '粤菜',
        description: '粤菜经典，皮脆肉嫩，保持原味',
        ingredients: '三黄鸡1只、姜片5片、葱段3根、料酒2勺、盐适量、蘸料：蒜蓉、生抽、香油、葱花',
        steps: '''1. 整鸡洗净，去除内脏杂质
2. 锅中加水烧开，放入姜片、葱段、料酒
3. 下鸡煮沸后转小火煮20-25分钟
4. 捞出放入冰水中过凉
5. 切块装盘，配蘸料食用''',
        imagePath: 'assets/images/white_cut_chicken.jpg',
        cookingTime: 35,
        difficulty: 2,
        createdAt: DateTime.now(),
      ),
      Recipe(
        name: '蒸蛋羹',
        category: '粤菜',
        description: '嫩滑如布丁，营养丰富，老少皆宜',
        ingredients: '鸡蛋3个、温水150ml、盐少许、香油几滴、葱花适量',
        steps: '''1. 鸡蛋打散，加盐调味
2. 加入温水搅拌均匀（蛋液与水比例1:1.5）
3. 过筛去除泡沫
4. 蒸锅水开后，放入蛋液蒸8-10分钟
5. 出锅淋香油，撒葱花即可''',
        imagePath: 'assets/images/steamed_egg.jpg',
        cookingTime: 12,
        difficulty: 1,
        createdAt: DateTime.now(),
      ),
      // 家常菜类
      Recipe(
        name: '番茄炒蛋',
        category: '家常菜',
        description: '国民家常菜，酸甜开胃，制作简单',
        ingredients: '番茄2个、鸡蛋3个、盐适量、糖1小勺、葱花适量、食用油适量',
        steps: '''1. 番茄切块，鸡蛋加少许盐打散
2. 热锅下油，倒入蛋液炒至凝固盛起
3. 锅中余油爆香葱花，下番茄翻炒出汁
4. 加糖提鲜，倒入鸡蛋翻炒
5. 加盐调味，撒葱花即可''',
        imagePath: 'assets/images/tomato_egg.jpg',
        cookingTime: 10,
        difficulty: 1,
        createdAt: DateTime.now(),
      ),
      Recipe(
        name: '红烧排骨',
        category: '家常菜',
        description: '色泽红亮，肉质酥烂，甜咸适中',
        ingredients: '排骨500g、冰糖10g、姜3片、八角1颗、桂皮1小块、生抽2勺、老抽1勺、料酒1勺、盐适量',
        steps: '''1. 排骨冷水下锅焯水，捞出洗净
2. 热锅下油，炒化冰糖至焦糖色
3. 下排骨翻炒上色
4. 加入香料和调料，加热水没过排骨
5. 大火烧开转小火炖40分钟
6. 大火收汁即可''',
        imagePath: 'assets/images/braised_ribs.jpg',
        cookingTime: 50,
        difficulty: 3,
        createdAt: DateTime.now(),
      ),
      Recipe(
        name: '青椒肉丝',
        category: '家常菜',
        description: '经典下饭菜，肉丝嫩滑，青椒爽脆',
        ingredients: '猪里脊200g、青椒2个、蒜2瓣、生抽1勺、淀粉1勺、盐适量、料酒1勺',
        steps: '''1. 里脊肉切丝，加生抽、料酒、淀粉抓匀腌制10分钟
2. 青椒切丝，蒜切片
3. 热锅下油，滑炒肉丝至变色盛起
4. 锅内留底油，爆香蒜片
5. 下青椒炒至断生，加入肉丝翻炒
6. 加盐调味即可''',
        imagePath: 'assets/images/green_pepper_pork.jpg',
        cookingTime: 15,
        difficulty: 2,
        createdAt: DateTime.now(),
      ),
      Recipe(
        name: '酸辣土豆丝',
        category: '家常菜',
        description: '酸辣爽口，土豆丝爽脆，开胃下饭',
        ingredients: '土豆1个、干辣椒3个、蒜2瓣、醋2勺、盐适量、糖少许、食用油适量',
        steps: '''1. 土豆切细丝，用水冲洗去淀粉
2. 热锅下油，爆香干辣椒和蒜末
3. 下土豆丝大火快炒
4. 加醋、盐、糖调味
5. 炒至断生即可''',
        imagePath: 'assets/images/sour_spicy_potato.jpg',
        cookingTime: 8,
        difficulty: 2,
        createdAt: DateTime.now(),
      ),
      Recipe(
        name: '清蒸鲈鱼',
        category: '家常菜',
        description: '肉质鲜嫩，清淡鲜美，保持原味',
        ingredients: '鲈鱼1条、姜丝适量、葱丝适量、蒸鱼豉油2勺、料酒1勺、盐少许、食用油适量',
        steps: '''1. 鲈鱼洗净，两面打花刀
2. 鱼身抹盐和料酒，腌制10分钟
3. 鱼肚塞姜丝，表面铺葱丝
4. 水开后蒸8-10分钟
5. 倒掉蒸鱼水，重新摆葱丝
6. 淋蒸鱼豉油，浇热油即可''',
        imagePath: 'assets/images/steamed_bass.jpg',
        cookingTime: 15,
        difficulty: 2,
        createdAt: DateTime.now(),
      ),
    ];

    for (Recipe recipe in recipes) {
      await db.insert('recipes', recipe.toMap());
    }
  }

  // 获取所有菜谱
  Future<List<Recipe>> getAllRecipes() async {
    final db = await instance.database;
    final maps = await db.query('recipes', orderBy: 'createdAt DESC');
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  // 根据分类获取菜谱
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    final db = await instance.database;
    final maps = await db.query(
      'recipes',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  // 搜索菜谱
  Future<List<Recipe>> searchRecipes(String query) async {
    final db = await instance.database;
    final maps = await db.query(
      'recipes',
      where: 'name LIKE ? OR description LIKE ? OR ingredients LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  // 获取随机菜谱
  Future<List<Recipe>> getRandomRecipes(int count) async {
    final db = await instance.database;
    final maps = await db.rawQuery(
      'SELECT * FROM recipes ORDER BY RANDOM() LIMIT ?',
      [count],
    );
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  // 添加菜谱
  Future<int> insertRecipe(Recipe recipe) async {
    final db = await instance.database;
    return await db.insert('recipes', recipe.toMap());
  }

  // 更新菜谱
  Future<int> updateRecipe(Recipe recipe) async {
    final db = await instance.database;
    return await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  // 删除菜谱
  Future<int> deleteRecipe(int id) async {
    final db = await instance.database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 获取所有分类
  Future<List<String>> getCategories() async {
    final db = await instance.database;
    final maps = await db.rawQuery('SELECT DISTINCT category FROM recipes ORDER BY category');
    return maps.map((map) => map['category'] as String).toList();
  }

  // 关闭数据库
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}