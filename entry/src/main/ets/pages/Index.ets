import axios, { AxiosResponse, AxiosError } from '@ohos/axios'
import { Cocktail, CocktailData } from '../model/CocktailModel';
import hilog from '@ohos.hilog';
import { CocktailCard } from '../components/CocktailCard';
import Detail from './Detail';
import { PromptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @Provide pageStack: NavPathStack = new NavPathStack()
  // 顶部标签切换状态
  @State currentTopTab: number = 0;
  // 底部导航切换状态
  @State currentBottomTab: number = 0;
  cocktail: Cocktail = new Cocktail();
  @State cocktailList: Cocktail[] = [];
  // 当前选中的基酒
  @State currentBaseLiquor: string = ''
  @State inputValue: string = ''
  private uiContext: UIContext = this.getUIContext()
  private promptAction: PromptAction = this.uiContext.getPromptAction()
  //函数
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

  @Builder
  PagesMap(name: string, param: Record<string, Object>) {
    if (name == 'Detail') {
      Detail({ param: param['content'] as Cocktail })
    }
  }

  // 自定义按钮：磨砂玻璃风格
  @Builder
  TabButton(index: number, title: string) {
    // 使用一个 Container 来包裹 Button，实现背景样式
    Column() {
      Button(title)
        .fontSize(16)
        .fontColor(Color.Black)
        .fontWeight(this.currentTopTab === index ? FontWeight.Bold : FontWeight.Normal)
        .backgroundColor(Color.Transparent) // 按钮本身透明
        .onClick(() => {
          this.currentTopTab = index
          switch (title) {
            case '金酒':
              this.currentBaseLiquor = 'Gin';
              break
            case '朗姆酒':
              this.currentBaseLiquor = 'Rum';
              break
            case '伏特加':
              this.currentBaseLiquor = 'Vodka';
              break
            case '龙舌兰':
              this.currentBaseLiquor = 'Tequila';
              break
            case '威士忌':
              this.currentBaseLiquor = 'Whiskey';
              break
            case '白兰地':
              this.currentBaseLiquor = 'Brandy';
              break
            default:
              this.currentBaseLiquor = ''
          }
          this.currentBaseLiquor === '' ? this.fetchAllCocktails() : this.searchByBaseSpirit(this.currentBaseLiquor)
        })
    }
    .padding({ left: 10, right: 10 }) // 按钮内边距
    .margin({
      left: 6,
      right: 6,
      top: 8,
      bottom: 8
    }) // 外边距，按钮之间留空
    .backgroundColor('#80FFFFFF') // 半透明白
    .borderRadius(12)
    .shadow({
      radius: 6,
      color: Color.Grey,
      offsetX: 0,
      offsetY: 3
    })
  }

  // 顶部标签栏组件：水平滑动 + 全宽
  @Builder
  TopTabBar() {
    Scroll() {
      Row() {
        this.TabButton(0, '全部')
        this.TabButton(1, '金酒')
        this.TabButton(2, '朗姆酒')
        this.TabButton(3, '伏特加')
        this.TabButton(4, '龙舌兰')
        this.TabButton(5, '威士忌')
        this.TabButton(6, '白兰地')
      }.width('100%')
      .padding({ left: 10, right: 10 }) // 整体左右留白
    }
    .scrollable(ScrollDirection.Horizontal)
    .width('100%')
  }

  // 底部导航栏-单项
  @Builder
  BottomTabItem(index: number, title: string, normalIcon: Resource) {
    Column() {
      Image(normalIcon).size({ width: 24, height: 24 })
      Text(title).fontSize(12)
    }.onClick(() => {
      this.currentBottomTab = index
    })
  }

  // 底部导航栏
  @Builder
  BottomTabBar() {
    this.BottomTabItem(0, '搜索', $r('app.media.home'))
    this.BottomTabItem(0, '首页', $r('app.media.home'))
  }

  // 内容区域，传入字符串，进行搜索
  @Builder
  showCocktailList() {
    Scroll() {
      Column() {
        ForEach(this.cocktailList, (item: Cocktail) => {
          Row() {
            CocktailCard({ cocktail: item })
              .onClick(() => {
                hilog.info(0xFFFF, 'testTag', `点击${item.strCnName}`)
                this.pageStack.pushPathByName('Detail', new Object({ 'content': item }))
              })
          }.width('90%').borderRadius(10).margin({ top: 10 })
        }, (item: Cocktail) => item.id.toString())
      }.width('100%')
    }
  }

  build() {
    Navigation(this.pageStack) {
      Tabs({ barPosition: BarPosition.End, index: this.currentBottomTab }) {
        // 1.搜索页
        TabContent() {
          Column() {
            // 1. logo名字
            Row() {
              Text('CocktailHelper')
                .fontSize(30)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.Black)
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .margin({ top: 16, bottom: 12 })

            // 2. 搜索栏和搜索按钮
            Row() {
              Stack() {
                TextInput({ placeholder: '请输入搜索内容' })
                  .fontSize(16)
                  .fontColor('#000000')
                  .backgroundColor('#F5F5F5')
                  .borderRadius(12)
                  .padding({
                    left: 16,
                    right: 48,
                    top: 12,
                    bottom: 12
                  })
                  .width(300)
                  .onChange((value: string) => {
                    this.inputValue = value
                  })

                // 搜索按钮（右上角叠加）
                Button() {
                  Image($r('app.media.search')).width(20).height(20)
                }
                .width(36)
                .height(36)
                .position({ x: 260, y: 10 }) // 精准定位右侧按钮（宽300 - padding - 按钮宽）
                .backgroundColor(Color.Transparent)
                .onClick(() => {
                  hilog.info(0xFFFF, "testTag", `用户输入：${this.inputValue}`)
                  if (this.inputValue.trim() === '') {
                    this.promptAction.showToast({ message: '请输入搜索内容' })
                    return
                  }
                  axios.get('http://123.249.44.20:9090/cocktails/findByName', {
                    params: {
                      strDrink: this.inputValue
                    }
                  }).then((resp: AxiosResponse) => {
                    if (resp.data.code === 1) {
                      hilog.info(0xFFFF, 'testTag', `查询结果：${JSON.stringify(resp.data)}`)
                      if (resp.data.data && resp.data.data.length > 0) {
                        // 取第一个鸡尾酒作为当前 cocktail 对象
                        const data = resp.data.data[0] as Cocktail
                        this.cocktail = new Cocktail(data)
                        this.pageStack.pushPathByName('Detail', new Object({ 'content': this.cocktail }))
                      } else {
                        this.promptAction.showToast({
                          message: '未找到相关鸡尾酒',
                          duration: 2000
                        })
                        hilog.info(0xFFFF, 'testTag', '未找到相关鸡尾酒')
                      }
                    } else {
                      this.promptAction.showToast({
                        message: '查找失败',
                        duration: 2000
                      })
                      hilog.error(0xFFFF, 'testTag', 'Error: code != 200');
                    }
                  }).catch((err: AxiosError) => {
                    this.promptAction.showToast({
                      message: '请求异常',
                      duration: 2000
                    })
                    hilog.error(0xFFFF, 'testTag', `catchError: ${err}`);
                  });

                })
              }
            }

          }.alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .height('100%')
        }.tabBar('搜索页')

        // 2.首页
        TabContent() {
          Column() {
            this.TopTabBar()

            // 显示内容
            this.showCocktailList()

          }.width('100%').height('100%')
        }.tabBar('首页')

      }.width('100%').height('100%')
      .onChange((index: number) => {
        this.currentBottomTab = index
        this.currentTopTab = 0
        if (index === 1) {
          this.fetchAllCocktails()
          this.inputValue = ''
        }
      })
    }.navDestination(this.PagesMap)
    .hideTitleBar(true)

  }
}
