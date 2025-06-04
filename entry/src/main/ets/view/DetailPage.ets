import { Cocktail, CocktailData } from "../model/CocktailModel"
import { font } from '@kit.ArkUI';

// 页面跳转入口函数
@Builder
export function DetailPageBuilder() {
  DetailPage()
}

@Component
struct DetailPage {
  // 导入字体
  onPageShow(): void {
    font.registerFont({
      familyName: "Avara-Black", // 字体名
      familySrc: $rawfile('Avara-Black.otf') // 字体资源
    })
  }

  pathStack: NavPathStack = new NavPathStack()
  private cocktail: Cocktail = new Cocktail()

  build() {
    NavDestination() {
      Column({ space: 10 }) {
        // 1. 鸡尾酒介绍：图片、名字、使用杯子类型
        Row({ space: 30 }) {
          Column() {
            // 1.1 图片
            Image(this.cocktail.strDrinkThumb).width(120).height(120).borderRadius(10)
          }

          Column({ space: 10 }) {
            // 1.2 鸡尾酒名称
            Row() {
              Text(this.cocktail.strDrink).fontSize(28).fontColor(Color.White).fontWeight(500)
                .fontFamily('Avara-Black')
            }

            // 1.3 鸡尾酒所用杯子类型
            Row() {
              Text(this.cocktail.strGlass).fontSize(15).fontColor(Color.White)
            }
          }
        }.justifyContent(FlexAlign.Center)

        // 2. 操作步骤
        Row() {
          Column({ space: 10 }) {
            // 2.1 操作步骤title
            Row() {
              Text('操作步骤')
                .width('100%')
                .fontSize(20)
                .fontColor(Color.White)
                .fontWeight(500)// 下划线
                .borderWidth({ bottom: 1 })
                .borderStyle(BorderStyle.Solid)
                .borderColor(Color.White)
            }.justifyContent(FlexAlign.Start)

            // 2.2. 操作步骤详情内容
            Row() {
              Text(this.cocktail.strInstructions).fontSize(15).fontColor(Color.White)
            }.justifyContent(FlexAlign.Start)
          }
        }.padding(10)
        .backgroundColor(Color.Black)
        .borderRadius(10)


        // 3. 配方用量
        Row() {
          Column({ space: 10 }) {
            // 3.1 配方用量title
            Text('配方用量')
              .width('100%')
              .fontSize(20)
              .fontWeight(500)
              .fontColor(Color.White)
              .textAlign(TextAlign.Start)
              .margin({ bottom: 10 })// 下划线
              .borderWidth({ bottom: 1 })
              .borderStyle(BorderStyle.Solid)
              .borderColor(Color.White)

            ForEach(this.cocktail.strIngredients, (item: string, index: number) => {
              Row() {
                // 3.2 左侧配方名
                Text(item).fontSize(15).fontColor(Color.White).textAlign(TextAlign.Start).layoutWeight(1)
                // 3.3 右侧配方用量
                Text((this.cocktail.strMeasures[index] && this.cocktail.strMeasures[index].trim() !== '')
                  ? this.cocktail.strMeasures[index]
                  : '-').width(80).fontSize(15).fontColor(Color.White).textAlign(TextAlign.End)
              }
              .width('90%')
              .margin({ bottom: 10 })
              // 下划线
              .borderWidth({ bottom: 1 })
              .borderStyle(BorderStyle.Solid)
              .borderColor(Color.White)
            }, (item: string, _: number) => item)

          }
        }.padding(10)
        .backgroundColor(Color.Black)
        .borderRadius(10)
      }.width('90%')
    }
    .backgroundColor('#2C2C2B')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      let param = this.pathStack.getParamByName('DetailPage') as CocktailData[]
      this.cocktail = new Cocktail(param[0])
    })
  }
}