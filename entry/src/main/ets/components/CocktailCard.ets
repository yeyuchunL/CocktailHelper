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
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.cocktail.strCnName)
            .fontSize(14)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
        .width('90%') // 让文字部分填满剩余
      }
    }
    .width('90%')
    .backgroundColor('#80FFFFFF') // 半透明白色
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