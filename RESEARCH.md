# Settings-Style Icons — Research

Задача: программно генерировать иконки, идентичные Apple Settings (цветной squircle + белый SF Symbol).

## Нет публичного API

Apple Settings.app использует приватные фреймворки (Preferences.framework, PreferencesUI.framework). Публичного API не существует — ни UIKit-компонента, ни SwiftUI-view.

`UIListContentConfiguration.ImageProperties` не имеет `backgroundColor`. Palette-режим SF Symbols не поможет: `app.fill` — однослойный символ, palette красит слои внутри одного символа, а не композитит два.

Единственный путь — ручной композитинг: фон + символ → растровый UIImage.

## Рендеринг

### app.fill — форма фона

SF Symbol `app.fill` — единственный способ получить **точную** форму Apple app icon (superellipse / continuous corner curve). Это не обычный rounded rect.

Альтернативы:
- `UIBezierPath(roundedRect:cornerRadius:)` — с iOS 7 использует continuous corners (не circular arc). Анализ Liam Rosenfeld показал 0-pixel-error match с Apple icon mask. Близко, но нет гарантии идентичности на будущих версиях iOS.
- `CGPath(roundedRect:cornerRadius:)` — circular arc углы, визуально отличается от Apple squircle.
- `RoundedRectangle(style: .continuous)` в SwiftUI, `CALayer.cornerCurve = .continuous` — используют ту же систему что UIBezierPath, визуально очень близки.

`app.fill` гарантирует совпадение с Apple на любом размере и версии iOS — это системный символ, форма которого определяется Apple. Если Apple изменит форму — символ обновится автоматически. При ручном рендеринге через path пришлось бы подбирать corner radius (≈ 17.5% от ширины для circular arc, для continuous curvature Apple не публикует ratio).

### SF Symbols: pointSize ≠ размер картинки

SF Symbols — шрифтовые глифы. `pointSize` задаёт типографический размер (cap height), а не bounding box. `UIImage.size` как правило больше pointSize.

Для `app.fill`:
- pointSize 32 → UIImage.size ≈ 35pt
- pointSize 29 → UIImage.size ≈ 32pt
- Ratio ≈ 1.08–1.12, варьируется между версиями iOS

Следствие: невозможно задать pointSize и получить pixel-perfect размер UIImage. Любая калибровка хрупкая.

### Пропорции фона и символа

Apple не документирует соотношение. Замеры по пикселям скриншотов системного Settings (симуляторы, 2026-10, OS 27):

| Платформа | Фон | Символ | Значения пакета |
|---|---|---|---|
| iOS 27, iPhone | сквиркл 28 pt | ~17.4 pt (≈62% фона) | pointSize фона 31, символ 0.56 × 31 |
| watchOS 27, Ultra 4 49mm и Series 12 46mm | круг 24 pt | ~12.8 pt (bell.badge.fill 12 pt в высоту) | pointSize фона 25.5, символ 0.5 × 25.5 |
| visionOS 27, Vision Pro | круг 32 pt | ~19.2 pt (≈60% фона) | pointSize фона 32, символ 0.6 × 32 |

`app.fill` при pointSize p даёт сквиркл 0.9 × p, `circle.fill` — круг ~p. На watchOS глифы SF Compact в ~0.95 раза меньше: круг 0.94 × p. Системные глифы нарисованы вручную и по-разному оптически скомпенсированы (шестерёнка ~76% фона, камера ~64%), поэтому одно соотношение даёт среднее совпадение, а не точное для каждого символа. Вес — regular: толщина линий совпадает с системной у accessibility и arrow.triangle.2.circlepath.

### Оформление фона и символа

Сверено по пикселям скриншотов Settings: iOS 27.0 (iPhone 18 Pro), iOS 27.1 (iPhone Duo, сложен) и watchOS 27 (Ultra 4), 2026-10.

- **Градиент.** Фон не плоский: низ — исходный системный цвет, к верху линейно светлее. Одной формулы поверх цвета нет: перебраны белый слой с прозрачностью, multiply/screen, color dodge, сдвиг L в OKLab, сложение и усиление в линейном свете, в sRGB и Display P3 — ни одна не попадает во все цвета точнее 6 единиц. Подъём у цветов разный: серый +17, зелёный +12–15, красный по зелёной компоненте +7, чёрный 0 → 10. Поэтому для системных цветов верх и низ прописаны по замерам (`SettingsIconGradient`), цвет узнаётся по значению с допуском 3 единицы. Для остальных цветов верх — color dodge 0.08 и белый с прозрачностью 0.0225, по замеренным цветам это не дальше 6 единиц.
- **Где замерено.** iPhone: строки 6 и 71 сквиркла высотой 78 px. Часы: строки 3 и 43 круга высотой 48 px. Цвета стоят на этих долях высоты, за ними продолжаются.

| Цвет | iPhone, верх → низ | Часы, верх → низ |
|---|---|---|
| Красный | 255,63,66 → 255,56,60 | 255,63,66 → 255,56,60 |
| Оранжевый | 255,155,54 → 255,141,40 | 249,151,53 → 255,141,40 |
| Зелёный | 66,212,100 → 52,199,89 | 66,212,101 → 52,199,89 |
| Синий | 0,147,255 → 0,136,255 | 0,147,255 → 0,136,255 |
| Индиго | 109,96,255 → 97,85,245 | 109,96,255 → 97,85,245 |
| Розовый | нет в Settings симулятора, формула | 255,51,95 → 255,45,85 |
| Серый | 159,159,164 → 142,142,147 | у часов свои серые: 162,168,178 → 146,153,162 и 150,155,165 → 134,141,150, формула |
| Чёрный | 10,10,10 → 0,0,0 | нет |

Жёлтого, бирюзового, мятного, голубого, фиолетового и коричневого нет ни в Settings симулятора iPhone, ни на часах — для них формула.

- **Цвет.** Settings берёт светлый вариант системного цвета в любой теме: на часах (всегда тёмные) красный 255,56,60 вместо 255,66,69, синий 0,136,255 вместо 0,145,255.
- **Тёмная тема.** На iOS 27.1 иконки в тёмной теме те же по каждой строке, что в светлой, и после перезапуска Settings тоже: серый 158 → 144, синий 0,147 → 0,138, белый символ 254. Затемнения нет.
- **Тень символа.** Под белым символом мягкая чёрная тень: сразу под ним фон темнее на ~5.5% (синий 255 → 241), тянется ~5 px при @3x, по бокам 1–2 px, сверху нет. Подобрано: прозрачность 0.09, сдвиг вниз 0.8 pt, радиус 0.75 pt (в UIKit blur = 2 × радиус).
- **Кромка.** На iPhone кромки нет: на белом фоне крайний пиксель светлее только из-за сглаживания, а в тёмной теме он темнее. На часах по верхнему краю круга светлый пиксель: красный 255,63,66 → 255,75,78, снизу слабее (+5). Пакет кладёт серый в plus lighter: 0.12 сверху и 0.1 снизу, крайний пиксель красного выходит 254,93,97. Кромка — фон минус тот же фон, сдвинутый на один пиксель экрана: дробный сдвиг SwiftUI округляет к сетке, и при 0.4 pt верхняя полоса пропадала.

### draw(at:) vs draw(in:)

`draw(in: rect)` растягивает изображение в rect без сохранения пропорций. Поскольку `app.fill` имеет слегка разную ширину и высоту (типографические метрики), squircle сплющивается.

`draw(at: point)` рисует в натуральном размере. Squircle сохраняет форму.

### SwiftUI: фон шрифтом, не .resizable()

`Image(systemName:).resizable().scaledToFit()` вписывает форму в весь фрейм: при `frame(32)` сквиркл получается 32 pt, а `UIImage` с pointSize 32 даёт сквиркл ~28.8 pt. Чтобы SwiftUI и UIKit совпадали, фон рисуется так же, как в UIKit — шрифтом:

```swift
Image(systemName: "app.fill")
    .font(.system(size: 31))
    .imageScale(.medium)
```

`.imageScale(.medium)` обязателен и для символа: `Label` в `List` ставит иконке `.imageScale(.large)`, символ вырастает ~на 25%.

## UIListContentConfiguration: изображения в ячейках

### SF Symbols vs растровые изображения

Когда `content.image` — SF Symbol, система автоматически:
- Применяет стандартный `reservedLayoutSize`
- Масштабирует символ под текст
- Ячейка = стандартная высота (44pt)

Когда `content.image` — растровый UIImage:
- `reservedLayoutSize` = intrinsic size картинки (по умолчанию)
- Высота ячейки = margins + image height + margins
- Картинка 35pt → ячейка ≈ 55pt вместо 44pt

WWDC 2020 "Modern cell configuration":
> "If you're using symbol images, UIKit applies a standard reserved layout size automatically, **which you can request manually for non-symbol images if needed.**"

### reservedLayoutSize — только layout

Из UIKit header:
> "The reservedLayoutSize width & height only affect the space reserved for the image and its positioning; they do not affect the image's size."

- Высота ячейки считается из reserved size, не intrinsic size картинки
- Изображение центрируется внутри зарезервированной области
- Если изображение больше — визуально выходит за reserved area, cell height не меняется
- НЕ масштабирует, НЕ клипает

### maximumSize — визуальный размер

> "If the image exceeds this size on either dimension, its size will be reduced proportionately (maintaining aspect ratio)."

Масштабирует пропорционально вниз. В отличие от `reservedLayoutSize`, реально уменьшает отрисовку.

### standardDimension — sentinel, не число

`UIListContentConfiguration.ImageProperties.standardDimension` — специальная константа-маркер (sentinel). Из UIKit header:
> "A special constant that can be set to the reservedLayoutSize width or height. This forces the system standard value that a symbol image would use for that dimension, even when the image is not a symbol image."

Конкретное числовое значение — implementation detail (не документировано). UIKit распознаёт его и подставляет runtime-значение, адаптивное к Dynamic Type. Нельзя использовать как размер канваса для рендеринга.

### Сводка

| Свойство | Размер картинки | Layout |
|---|---|---|
| `reservedLayoutSize` | Не влияет | Определяет резервацию |
| `maximumSize` | Масштабирует пропорционально | Косвенно |
| `standardDimension` | Sentinel для обоих | — |

## Тупиковые пути

### Фиксированный канвас + draw(in:)

Создать канвас 29×29, отрендерить `app.fill` через `draw(in: rect)`. Squircle сплющивается из-за разницы ширины/высоты SF Symbol (см. «draw(at:) vs draw(in:)» выше).

### Фиксированный канвас + aspect-fit

Вписать `app.fill` пропорционально в квадратный канвас. Squircle оказывается меньше канваса, внутренний символ — непропорционально крупным. Не похоже на Apple Settings.

### Калибровка pointSize под целевой размер

Вычислить pointSize для целевого канваса через ratio на эталонном размере, рисовать `draw(at:)`. Squircle рендерится нативно, но возникает конфликт: размер изображения и layout ячейки — разные задачи. Любой фиксированный размер либо ломает визуал, либо ломает layout.

### standardDimension как размер канваса

`standardDimension` — sentinel-константа, не реальный размер (см. выше). Её runtime-значение слишком мало для визуально корректной иконки.

## Итог

Размер изображения и layout ячейки — **разные задачи**, которые решаются разными API:

1. **Рендер** — `app.fill` при pointSize 31 + символ при pointSize 17.4 (iOS). Сквиркл 28 pt, канвас ~36 pt. `draw(at:)`, без масштабирования.

2. **Layout ячейки** — `reservedLayoutSize = standardDimension`. Система определяет высоту, адаптивно к Dynamic Type.

3. **Визуальный размер в ячейке** — `maximumSize = standardDimension`. Система пропорционально масштабирует картинку.

## Ссылки

- [WWDC 2020: Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
- [UIListContentConfiguration.ImageProperties](https://developer.apple.com/documentation/uikit/uilistcontentconfiguration/imageproperties)
- [reservedLayoutSize](https://developer.apple.com/documentation/uikit/uilistcontentconfiguration-swift.struct/imageproperties-swift.struct/reservedlayoutsize)
- [maximumSize](https://developer.apple.com/documentation/uikit/uilistcontentconfiguration-swift.struct/imageproperties-swift.struct/maximumsize)
- [standardDimension](https://developer.apple.com/documentation/uikit/uilistcontentconfiguration/imageproperties/3601001-standarddimension)
- [SF Symbols — configuring and displaying](https://developer.apple.com/documentation/uikit/uiimage/configuring_and_displaying_symbol_images_in_your_ui)
- [Apple icon shape analysis](https://liamrosenfeld.com/posts/apple_icon_quest/)
- [iOS icon corner radii](https://hicks.design/journal/ios-icon-corner-radii)
- [App icons HIG](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Resizing SF Symbols in SwiftUI](https://nilcoalescing.com/blog/ResizingSFSymbolsInSwiftUI/)
- [Apple Developer Forums — SF Symbol size](https://developer.apple.com/forums/thread/663728)
