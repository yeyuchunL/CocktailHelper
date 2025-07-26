import axios, { AxiosError, AxiosResponse } from "@ohos/axios";
import { Cocktail, CocktailData } from "../model/CocktailModel";
import hilog from "@ohos.hilog";
import { CocktailCard } from "../components/CocktailCard";

@Component
export default struct Home {
  @Consume pageStack: NavPathStack
  @State cocktailList: Cocktail[] = [];
  tabs: string[] = ['Gin', 'Rum', 'Vodka', 'Tequila', 'Brandy', 'Whiskey']
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
  private searchByBaseSpirit = (baseSpirit: string) => {
    axios.get('http://123.249.44.20:9090/cocktails/findByBaseSpirit', {
      params: {
        baseSpirit: baseSpirit
      }
    }).then((resp: AxiosResponse) => {
      if (resp.data.code === 1 && resp.data.data.length > 0) {
        const data = resp.data.data as CocktailData[];
        this.cocktailList = data.map(item => new Cocktail(item));
        hilog.info(0xFFFF, 'testTag', `查询成功`)
      } else {
        this.cocktailList = []
        hilog.info(0xFFFF, 'testTag', `没有找到鸡尾酒`)
      }
    }).catch((err: AxiosError) => {
      hilog.error(0xFFFF, 'testTag', '搜索请求失败')
    })
  }

  aboutToAppear(): void {
    this.fetchAllCocktails()
  }

  build() {
    NavDestination() {
      Tabs() {
        ForEach(this.tabs, (label: string, index: number) => {
          TabContent() {
            Scroll() {

              Column() {
                Text(`当前选中：${label}`)
                  .fontSize(24)
                  .margin(20)

                // 示例内容列表
                ForEach(this.cocktailList, (item: Cocktail) => {
                  CocktailCard({ cocktail: item })
                    .onClick(() => {
                      this.pageStack.pushPathByName('Detail', new Object({ 'content': item }))
                    })
                })

                Button('返回 Index 搜索页')
                  .margin(20)
                  .width('80%')
                  .onClick(() => {
                    this.pageStack.pop()
                  })

              }.alignItems(HorizontalAlign.Center)
            }
          }.tabBar(this.tabs[index]) // 设置 Tab 标签
        })
      }
      .vertical(false)
      .barPosition(BarPosition.Start) // 放在顶部
      .onChange((index: number) => {
        this.searchByBaseSpirit(this.tabs[index])
      })
    }.hideTitleBar(true)
  }
}