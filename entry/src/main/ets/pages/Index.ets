import hilog from '@ohos.hilog';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios';
import { font, PromptAction } from '@kit.ArkUI';
import { Cocktail } from '../model/CocktailModel';

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

  @State pageNum: number = 1;
  @State inputValue: string = ''
  pathStack: NavPathStack = new NavPathStack()
  cocktail: Cocktail = new Cocktail();
  private uiContext: UIContext = this.getUIContext()
  private promptAction: PromptAction = this.uiContext.getPromptAction()

  build() {
    Column() {
      Navigation(this.pathStack) {
        Row() {
          Blank();
        }.height('40%')

        // 1. logo名字
        Row() {
          Text('CocktailHelper').fontSize('30.00').fontColor(Color.White)
            .fontFamily('Avara-Black')
        }.width('90%').justifyContent(FlexAlign.Center)

        // 2. 搜索栏和搜索按钮
        Row() {
          Stack() {
            TextInput({ placeholder: '请输入搜索内容' })
              .backgroundColor(Color.White)
              .fontColor(Color.Black)
              .width('80.00%')
              .onChange((value: string) => {
                this.inputValue = value;
              })

            Button() {
              Image($r('app.media.search')).width(25).height(25)
            }
            .width('50.00vp')
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
                    this.pathStack.pushPathByName("DetailPage", this.cocktail);
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
            }).height('40.00vp')
          }.align(Alignment.End)
        }
      }.height('95%')

      // 3. 底部导航栏
      Row() {
        // 搜索按钮
        Text('搜索')
          .fontColor(this.pageNum === 1 ? Color.White : Color.Grey)
          .fontWeight(this.pageNum === 1 ? 500 : 400)
          .textAlign(TextAlign.Center)
          .padding({ left: 10, right: 10 })  // 扩大点击区域
          .onClick(() => {
            this.pageNum = 1
            hilog.info(0xFFFF, "testTag", `=======搜索 ${this.pageNum} ============`)
          })

        // 首页按钮
        Text('首页')
          .fontColor(this.pageNum === 2 ? Color.White : Color.Grey)
          .fontWeight(this.pageNum === 2 ? 500 : 400)
          .textAlign(TextAlign.Center)
          .padding({ left: 10, right: 10 })
          .onClick(() => {
            this.pageNum = 2
            hilog.info(0xFFFF, "testTag", `=======首页 ${this.pageNum} ============`)
            this.pathStack.pushPathByName("HomePage", '')
          })
      }
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor('#2C2C2B')
      .height('5.00%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#2C2C2B')
  }
}
