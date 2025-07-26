import { Cocktail, Ingredient } from "../model/CocktailModel"

// Detail 页面：详情页
@Component
export default struct Detail {
  @Consume pageStack: NavPathStack
  param: Cocktail = new Cocktail()

  @Builder
  buildTitleText(title: string) {
    Text(title)
      .width('100%')
      .fontSize(20)
      .fontWeight(500)
      .textAlign(TextAlign.Start)
      .margin({ bottom: 10 })
      .borderWidth({ bottom: 1 })
      .borderStyle(BorderStyle.Solid)
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 10 }) {
          // 1. 鸡尾酒介绍：图片、名字、使用杯子类型
          Row({ space: 30 }) {
            Column() {
              // 1.1 图片
              Image(this.param.strDrinkThumb).width(120).height(120).borderRadius(10)
            }

            Column({ space: 10 }) {
              // 1.2 鸡尾酒名称
              Row() {
                Text(this.param.strDrink).fontSize(28).fontWeight(500)
              }

              // 1.3 鸡尾酒所用杯子类型
              Row() {
                Text(this.param.strGlass).fontSize(15)
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
                Text(this.param.strInstructions).fontSize(15)
              }.justifyContent(FlexAlign.Start)
            }
          }.padding(10)
          .borderRadius(10)

          // 3. 配方用量
          Row() {
            Column({ space: 10 }) {
              // 3.1 配方用量title
              Row() {
                this.buildTitleText('配方用量')
              }.justifyContent(FlexAlign.Start)

              ForEach(this.param.ingredients, (item: Ingredient) => {
                Row() {
                  // 左侧：配料名，最长一行，省略号处理
                  Text(item.ingredientName)
                    .fontSize(15)
                    .textAlign(TextAlign.Start)
                    .layoutWeight(1)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  // 右侧：用量，若为空显示为 "-"
                  Text((item.ingredientMeasure && item.ingredientMeasure.trim() !== '') ? item.ingredientMeasure :
                    '-')
                    .width(80)
                    .fontSize(15)
                    .textAlign(TextAlign.End)
                }
                .width('90%')
                .margin({ bottom: 10 })
                .borderWidth({ bottom: 1 })
                .borderStyle(BorderStyle.Solid)
              }, (item: Ingredient) => item.ingredientName)


            }
          }.padding(10)
          .borderRadius(10)

          // 4. 相关故事
          if (this.param.strStory.trim() !== '') {
            Column() {
              Row() {
                this.buildTitleText('相关故事')
              }.justifyContent(FlexAlign.Start)

              Row() {
                Text(this.param.strStory).fontSize(15)
              }.justifyContent(FlexAlign.Start)
            }.padding(10)
            .borderRadius(10)
          }


        }
      }

    }
  }
}