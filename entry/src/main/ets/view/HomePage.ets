// 页面跳转入口函数
@Builder
export function HomePageBuilder() {
  HomePage()
}

@Component
struct HomePage {
  build() {
    Column() {
      NavDestination() {
        Scroll() {
          Column() {
            Text('hahahah')
            Text('hahahah')
            Text('hahahah')
            Text('hahahah')
            Text('hahahah')
            Text('hahahah')
            Text('hahahah')
          }
        }
      }
    }
  }
}