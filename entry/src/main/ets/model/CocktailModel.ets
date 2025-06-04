export interface CocktailData {
  idDrink: string;
  strDrink: string;
  strDrinkThumb: string;
  strGlass: string;
  strInstructions: string;
  strIngredients: string[];
  strMeasures: string[];
}

// 基于 interface 创建类
export class Cocktail implements CocktailData {
  idDrink: string
  strDrink: string
  strDrinkThumb: string
  strGlass: string
  strInstructions: string
  strIngredients: string[]
  strMeasures: string[]

  constructor(data?: CocktailData) {
    this.idDrink = data?.idDrink ?? ''
    this.strDrink = data?.strDrink ?? ''
    this.strDrinkThumb = data?.strDrinkThumb ?? ''
    this.strGlass = data?.strGlass ?? ''
    this.strInstructions = data?.strInstructions ?? ''
    this.strIngredients = data?.strIngredients ?? []
    this.strMeasures = data?.strMeasures ?? []
  }
}