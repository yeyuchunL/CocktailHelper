import { CocktailData } from "../model/CocktailModel";
import axios, { AxiosResponse, AxiosError } from '@ohos/axios'

export class CocktailService {
  // 查询所有鸡尾酒
  static async fetchAll(): Promise<CocktailData[]> {
    const resp: AxiosResponse = await axios.get('http://123.249.44.20:9090/cocktails/findAll')
    return resp.data.data
  }

  // 通过基酒查询鸡尾酒
  static async searchByBaseSpirit(baseSpirit: string): Promise<CocktailData[]> {
    const resp: AxiosResponse = await axios.get('http://123.249.44.20:9090/cocktails/findByBaseSpirit', {
      params: { baseSpirit }
    })
    return resp.data.data;
  }

  // 通过名称查询鸡尾酒
  static async searchByName(strDrink: string): Promise<CocktailData[]> {
    const resp: AxiosResponse = await axios.get('http://123.249.44.20:9090/cocktails/findByName', {
      params: { strDrink }
    })
    return resp.data.data
  }
}