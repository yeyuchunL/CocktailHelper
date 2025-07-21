// 配料接口
export interface IngredientData {
  id: number | null;
  cocktailId: number | null;
  ingredientName: string;
  ingredientMeasure: string;
}

// 鸡尾酒接口
export interface CocktailData {
  id: number;
  strDrink: string;
  strCnName: string;
  strCategory: string;
  strAlcoholic: string;
  strGlass: string;
  strInstructions: string;
  strStory: string;
  strDrinkThumb: string;
  strImageSource: string;
  ingredients: IngredientData[];
}

// Ingredient 类
export class Ingredient implements IngredientData {
  id: number | null;
  cocktailId: number | null;
  ingredientName: string;
  ingredientMeasure: string;

  constructor(data?: IngredientData) {
    this.id = data?.id ?? null;
    this.cocktailId = data?.cocktailId ?? null;
    this.ingredientName = data?.ingredientName ?? '';
    this.ingredientMeasure = data?.ingredientMeasure ?? '';
  }
}

// Cocktail 类
export class Cocktail implements CocktailData {
  id: number;
  strDrink: string;
  strCnName: string;
  strCategory: string;
  strAlcoholic: string;
  strGlass: string;
  strInstructions: string;
  strStory: string;
  strDrinkThumb: string;
  strImageSource: string;
  ingredients: Ingredient[];

  constructor(data?: CocktailData) {
    this.id = data?.id ?? 0;
    this.strDrink = data?.strDrink ?? '';
    this.strCnName = data?.strCnName ?? '';
    this.strCategory = data?.strCategory ?? '';
    this.strAlcoholic = data?.strAlcoholic ?? '';
    this.strGlass = data?.strGlass ?? '';
    this.strInstructions = data?.strInstructions ?? '';
    this.strStory = data?.strStory ?? '';
    this.strDrinkThumb = data?.strDrinkThumb ?? '';
    this.strImageSource = data?.strImageSource ?? '';
    // 注意 ingredients 这里的类型转换
    this.ingredients = data?.ingredients?.map(ing => new Ingredient(ing)) ?? [];
  }
}
