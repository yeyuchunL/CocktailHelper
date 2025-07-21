import { Cocktail } from '../model/CocktailModel'

@Component
export struct CocktailCard {
  @Prop cocktail: Cocktail;

  build() {
    // 外部统一宽度
    Column() {
      Row() {
        // 缩略图：固定宽高
        Image(this.cocktail.strDrinkThumb)
          .width(80)
          .height(80)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)

        // 信息部分：占据剩余空间
        Column() {
          Text(this.cocktail.strDrink)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.cocktail.strCnName)
            .fontSize(14)
            .fontColor(Color.Grey)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
        .width('90%') // 让文字部分填满剩余
      }
    }
    .padding(12)
    .width('90%') // 卡片宽度统一
    .backgroundColor('#3A3A3A')
    .borderRadius(12)
    .margin({ bottom: 10 })
  }
}