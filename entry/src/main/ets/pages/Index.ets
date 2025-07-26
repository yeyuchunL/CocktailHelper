import { Cocktail, CocktailData } from '../model/CocktailModel';
import hilog from '@ohos.hilog';
import { CocktailCard } from '../components/CocktailCard';
import Detail from './Detail';
import { PromptAction } from '@kit.ArkUI';
import { IndexViewModel } from '../viewmodel/IndexViewModel';

@Entry
@Component
struct Index {
  @Provide pageStack: NavPathStack = new NavPathStack()
  private viewModel: IndexViewModel = new IndexViewModel()
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

  aboutToAppear() {
    this.fetchAllCocktails()
  }

  private fetchAllCocktails = () => {
    this.viewModel.fetchAllCocktails().then(data => {
      this.cocktailList = data;
    })
  }
  private searchByBaseSpirit = (baseSpirit: string) => {
    this.currentBaseLiquor = baseSpirit
    this.viewModel.searchByBaseSpirit(baseSpirit).then(data => {
      this.cocktailList = data;
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
        .fontColor(this.currentTopTab === index ? $r('app.color.selected_color') : $r('app.color.unselected_color'))
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
    .backgroundColor(this.currentTopTab === index ? $r('app.color.selected_back_color') :
    $r('app.color.unselected_back_color'))
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
      }
      .padding({ left: 10, right: 10 })
      .align(Alignment.Start)
      .height('60.00vp')
    }.scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
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
                .fontColor($r('app.color.logo_title'))
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .margin({ top: 16, bottom: 12 })

            // 2. 搜索栏和搜索按钮
            Row() {
              Stack() {
                TextInput({ placeholder: '请输入搜索内容' })
                  .fontSize(16)
                  .backgroundColor($r('app.color.unselected_back_color'))
                  .borderRadius(12)
                  .width(300)
                  .height(50)
                  .onChange((value: string) => {
                    this.inputValue = value
                  })

                // 搜索按钮（右上角叠加）
                Button() {
                  Image($r('app.media.search')).width(20).height(20)
                }
                .width(50)
                .height(50)
                .position({ x: 250, y: 0 })
                .backgroundColor(Color.Transparent)
                .onClick(async () => {
                  hilog.info(0xFFFF, "testTag", `用户输入：${this.inputValue}`)
                  if (this.inputValue.trim() === '') {
                    this.promptAction.showToast({ message: '请输入搜索内容' })
                    return
                  }

                  const result = await this.viewModel.searchByName(this.inputValue)
                  if (result) {
                    this.pageStack.pushPathByName('Detail', new Object({ 'content': result }))
                  } else {
                    this.promptAction.showToast({ message: '未找到相关鸡尾酒' })
                  }

                })

              }
            }

          }.alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .height('100%')
        }.tabBar('搜索页')

        TabContent() {
          Column() {
            this.TopTabBar()

            // 内容滚动区域（减去顶部 tab 高度）
            Scroll() {
              Column() {
                ForEach(this.cocktailList, (item: Cocktail) => {
                  Row() {
                    CocktailCard({ cocktail: item })
                      .onClick(() => {
                        hilog.info(0xFFFF, 'testTag', `点击${item.strCnName}`)
                        this.pageStack.pushPathByName('Detail', new Object({ 'content': item }))
                      })
                  }
                  .width('90%')
                  .borderRadius(10)
                  .margin({ top: 10 })
                }, (item: Cocktail) => item.id.toString())
              }
              .width('100%')
              .alignItems(HorizontalAlign.Center)
            }
            .height('calc(100% - 150px)')
            .scrollBar(BarState.Off)

          }
          .width('100%')
          .height('100%')
        }
        .tabBar('首页')

      }
      .width('100%')
      .height('100%')
      .scrollable(false)
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
    .backgroundColor($r('app.color.back_color'))
  }
}
