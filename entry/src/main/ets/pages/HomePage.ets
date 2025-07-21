import axios, { AxiosError, AxiosResponse } from "@ohos/axios";
import { Cocktail, CocktailData } from "../model/CocktailModel"
import hilog from '@ohos.hilog';
import { CocktailCard } from "../components/CocktailCard";

@Entry
@Component
struct HomePage {
  @State cocktailList: Cocktail[] = [];
  @State baseSpirit: string = '';
  pathStack: NavPathStack = new NavPathStack();
  private fetchAllCocktails = () => {
    axios.get('http://123.249.44.20:9090/cocktails/findAll')
      .then((resp: AxiosResponse) => {
        if (resp.data.code === 1 && resp.data.data.length > 0) {
          const data = resp.data.data as CocktailData[];
          this.cocktailList = data.map(item => new Cocktail(item));
          hilog.info(0xFFFF, 'testTag', '查询所有鸡尾酒成功');
        } else {
          hilog.error(0xFFFF, 'testTag', '查询鸡尾酒失败');
        }
      })
      .catch((err: AxiosError) => {
        hilog.error(0xFFFF, 'testTag', '发送请求失败');
      });
  }
  private searchByBaseSpirit = () => {
    axios.get('http://123.249.44.20:9090/cocktails/findByBaseSpirit', {
      params: {
        baseSpirit: this.baseSpirit
      }
    }).then((resp: AxiosResponse) => {
      if (resp.data.code === 1 && resp.data.data.length > 0) {
        const data = resp.data.data as CocktailData[];
        this.cocktailList = data.map(item => new Cocktail(item));
        hilog.info(0xFFFF, 'testTag', `查询 ${this.baseSpirit} 成功`)
      } else {
        this.cocktailList = []
        hilog.info(0xFFFF, 'testTag', `没有找到 ${this.baseSpirit} 的鸡尾酒`)
      }
    }).catch((err: AxiosError) => {
      hilog.error(0xFFFF, 'testTag', '搜索请求失败')
    })
  }

  aboutToAppear(): void {
    this.fetchAllCocktails()
  }

  build() {
    Column() {
      NavDestination() {
        Row() {
          Stack() {
            TextInput({ placeholder: '输入要查询的基酒', text: this.baseSpirit })
              .backgroundColor('#3A3A3A')
              .fontColor(Color.White)
              .onChange((val: string) => {
                this.baseSpirit = val
              })

            Button() {
              Image($r('app.media.search')).width(25).height(25)
            }
            .width('50.00vp').height('40.00vp')
            .onClick(() => this.searchByBaseSpirit())
          }.align(Alignment.End)
        }.width('90%')


        Scroll() {
          Column() {
            ForEach(this.cocktailList, (item: Cocktail) => {
              CocktailCard({ cocktail: item })
                .onClick(() => {
                  this.pathStack.pushPathByName("DetailPage", item)
                  hilog.info(0xFFFF, "testTag", "clicked Card!")
                })
            }, (item: Cocktail) => item.id.toString())
          }.padding({ top: 20, bottom: 20 }).width('100%')
        }
      }.backgroundColor('#2C2C2B')
    }.width('100%')
    .height('100%')
    .backgroundColor('#2C2C2B')
  }
}
