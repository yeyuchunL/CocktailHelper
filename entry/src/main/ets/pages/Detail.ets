import { Cocktail, Ingredient } from "../model/CocktailModel"

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

          // ===== 1. 鸡尾酒信息卡片 =====
          Column() {
            Row({ space: 15 }) {
              Image(this.param.strDrinkThumb)
                .width(120)
                .height(120)
                .borderRadius(10)

              Column({ space: 10 }) {
                Text(this.param.strDrink)
                  .width('100%')
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Start)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.MARQUEE })

                Text(this.param.strGlass)
                  .width('100%')
                  .fontSize(15)
              }.layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }.width('100%').justifyContent(FlexAlign.Center)

          }
          .backgroundColor($r('app.color.card_back_color'))
          .borderRadius(12)
          .shadow({
            radius: 8,
            color: Color.Grey,
            offsetX: 0,
            offsetY: 4
          })
          .padding(12)
          .margin(12)

          // ===== 2. 操作步骤卡片 =====
          Column() {
            this.buildTitleText('操作步骤')

            Text(this.param.strInstructions)
              .fontSize(15)
              .textAlign(TextAlign.Start)
          }
          .backgroundColor($r('app.color.card_back_color'))
          .borderRadius(12)
          .shadow({
            radius: 8,
            color: Color.Grey,
            offsetX: 0,
            offsetY: 4
          })
          .padding(12)
          .margin(12)

          // ===== 3. 配方用量卡片 =====
          Column() {
            this.buildTitleText('配方用量')

            ForEach(this.param.ingredients, (item: Ingredient) => {
              Row() {
                Text(item.ingredientName)
                  .fontSize(15)
                  .textAlign(TextAlign.Start)
                  .layoutWeight(1)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(item.ingredientMeasure?.trim() !== '' ? item.ingredientMeasure : '-')
                  .width(80)
                  .fontSize(15)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
              .margin({ bottom: 10 })
              .borderWidth({ bottom: 1 })
              .borderStyle(BorderStyle.Solid)
            }, (item: Ingredient) => item.ingredientName)
          }
          .backgroundColor($r('app.color.card_back_color'))
          .borderRadius(12)
          .shadow({
            radius: 8,
            color: Color.Grey,
            offsetX: 0,
            offsetY: 4
          })
          .padding(12)
          .margin(12)

          // ===== 4. 相关故事卡片（可选）=====
          if (this.param.strStory.trim() !== '') {
            Column() {
              this.buildTitleText('相关故事')

              Text(this.param.strStory)
                .fontSize(15)
                .textAlign(TextAlign.Start)
            }
            .backgroundColor($r('app.color.card_back_color'))
            .borderRadius(12)
            .shadow({
              radius: 8,
              color: Color.Grey,
              offsetX: 0,
              offsetY: 4
            })
            .padding(12)
            .margin(12)
          }

        }
      }
    }
  }
}