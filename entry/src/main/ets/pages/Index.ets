import { Cocktail, CocktailData } from '../model/CocktailModel';
import hilog from '@ohos.hilog';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios';
import { font } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  // 导入字体
  onPageShow(): void {
    font.registerFont({
      familyName: "Avara-Black", // 字体名
      familySrc: $rawfile('Avara-Black.otf') // 字体资源
    })
  }

  @State inputValue: string = ''
  pathStack: NavPathStack = new NavPathStack();
  cocktail: Cocktail = new Cocktail({
    idDrink: '11007',
    strDrink: '玛格丽塔',
    strDrinkThumb: 'https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg',
    strGlass: 'Cocktail glass',
    strInstructions: '摇匀后倒入冰镇的鸡尾酒杯。',
    strIngredients: ['龙舌兰', '君度橙酒', '青柠汁', '盐'],
    strMeasures: ['45ml', '15ml', '30ml', ''],
  });

  build() {
    Navigation(this.pathStack) {
      Column({ space: 10 }) {
        Row() {
          Text('CocktailHelper').fontSize('30.00').fontColor(Color.White)
            .fontFamily('Avara-Black')
        }

        Row() {
          Stack() {
            TextInput({ placeholder: '请输入搜索内容' })
              .backgroundColor(Color.White)
              .width('90.00%')
              .onChange((value: string) => {
                this.inputValue = value;
              })

            Button() {
              Image($r('app.media.search')).width(25).height(25)
            }
            .width('20%')
            .onClick(() => {
              hilog.info(0xFFFF, "testTag", `用户输入：${this.inputValue}`)

              axios.get('https://www.thecocktaildb.com/api/json/v1/1/search.php', {
                params: {
                  s: this.inputValue
                }
              }).then((resp: AxiosResponse) => {
                if (resp.data.drinks !== null) {
                  const cocktailData: CocktailData = {
                    idDrink: resp.data.drinks[0].idDrink,
                    strDrink: resp.data.drinks[0].strDrink,
                    strDrinkThumb: resp.data.drinks[0].strDrinkThumb,
                    strGlass: resp.data.drinks[0].strGlass,
                    strInstructions: resp.data.drinks[0].strInstructions,
                    strIngredients: [],
                    strMeasures: []
                  }
                  let ingredients: string[] = [];
                  let measures: string[] = [];
                  for (let i = 1; i <= 15; i++) {
                    const ingredient: string | null = resp.data.drinks[0][`strIngredient${i}`];
                    const measure: string | null = resp.data.drinks[0][`strMeasure${i}`];
                    if (!ingredient || ingredient.trim() === '') {
                      break;
                    }
                    ingredients.push(ingredient.trim());
                    if (measure && measure.trim() !== '') {
                      measures.push(measure.trim());
                    } else {
                      measures.push('');
                    }
                  }
                  cocktailData.strIngredients = ingredients;
                  cocktailData.strMeasures = measures;
                  this.cocktail = new Cocktail(cocktailData);
                  this.pathStack.pushPathByName("DetailPage", this.cocktail);
                } else {
                  hilog.error(0xFFFF, 'testTag', 'Error: 获取请求失败，code != 200');
                }
              }).catch((err: AxiosError) => {
                hilog.error(0xFFFF, 'testTag', `catchError: ${err}`);
              });
            })
            .height('40.00vp')
          }.align(Alignment.End)
        }
      }.width('80%').height('100%').justifyContent(FlexAlign.Center)
    }.width('100%').height('100%').backgroundColor('#2C2C2B')
  }
}
