import { Cocktail } from "../model/CocktailModel";
import { CocktailService } from "../service/CocktailService";

export class IndexViewModel {
  async fetchAllCocktails(): Promise<Cocktail[]> {
    const data = await CocktailService.fetchAll()
    return data.map(item => new Cocktail(item))
  }

  async searchByBaseSpirit(baseSpirit: string): Promise<Cocktail[]> {
    const data = await CocktailService.searchByBaseSpirit(baseSpirit)
    return data.map(item => new Cocktail(item))
  }

  async searchByName(name: string): Promise<Cocktail | null> {
    const data = await CocktailService.searchByName(name)
    if (data.length > 0) {
      return new Cocktail(data[0])
    }
    return null
  }
}