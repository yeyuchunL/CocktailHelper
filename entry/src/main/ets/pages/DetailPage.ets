import { Cocktail, CocktailData, Ingredient } from "../model/CocktailModel"
import { font } from '@kit.ArkUI';

@Entry
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
  @State cocktail: Cocktail = new Cocktail()

  // 定义 Builder
  @Builder
  buildTitleText(title: string) {
    Text(title)
      .width('100%')
      .fontSize(20)
      .fontWeight(500)
      .fontColor(Color.White)
      .textAlign(TextAlign.Start)
      .margin({ bottom: 10 })
      .borderWidth({ bottom: 1 })
      .borderStyle(BorderStyle.Solid)
      .borderColor(Color.White)
  }

  build() {
    NavDestination() {
      Scroll() {
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
              }.padding({ right: 10 })
            }
          }.justifyContent(FlexAlign.Center)

          // 2. 操作步骤
          Row() {
            Column({ space: 10 }) {
              // 2.1 操作步骤title
              Row() {
                this.buildTitleText('操作步骤')
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
              Row() {
                this.buildTitleText('配方用量')
              }.justifyContent(FlexAlign.Start)

              ForEach(this.cocktail.ingredients, (item: Ingredient) => {
                Row() {
                  // 左侧：配料名，最长一行，省略号处理
                  Text(item.ingredientName)
                    .fontSize(15)
                    .fontColor(Color.White)
                    .textAlign(TextAlign.Start)
                    .layoutWeight(1)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  // 右侧：用量，若为空显示为 "-"
                  Text((item.ingredientMeasure && item.ingredientMeasure.trim() !== '') ? item.ingredientMeasure :
                    '-')
                    .width(80)
                    .fontSize(15)
                    .fontColor(Color.White)
                    .textAlign(TextAlign.End)
                }
                .width('90%')
                .margin({ bottom: 10 })
                .borderWidth({ bottom: 1 })
                .borderStyle(BorderStyle.Solid)
                .borderColor(Color.White)
              }, (item: Ingredient) => item.ingredientName)


            }
          }.padding(10)
          .backgroundColor(Color.Black)
          .borderRadius(10)

          // 4. 相关故事
          if (this.cocktail.strStory.trim() !== '') {
            Column() {
              Row() {
                this.buildTitleText('相关故事')
              }.justifyContent(FlexAlign.Start)

              Row() {
                Text(this.cocktail.strStory).fontSize(15).fontColor(Color.White)
              }.justifyContent(FlexAlign.Start)
            }.padding(10)
            .backgroundColor(Color.Black)
            .borderRadius(10)
          }
        }.width('90%')
      }.scrollBar(BarState.Off)
    }
    .backgroundColor('#2C2C2B')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      let param = this.pathStack.getParamByName('DetailPage') as CocktailData[]
      this.cocktail = new Cocktail(param[0])
    })
  }
}