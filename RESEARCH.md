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

Apple не документирует соотношение. Эмпирически символ занимает ~50% площади фона.

pointSize 32 (фон) / 16 (символ) — ratio 1:2 — визуально совпадает с Apple Settings. При ratio 55% символ слишком близко к краям squircle.

### draw(at:) vs draw(in:)

`draw(in: rect)` растягивает изображение в rect без сохранения пропорций. Поскольку `app.fill` имеет слегка разную ширину и высоту (типографические метрики), squircle сплющивается.

`draw(at: point)` рисует в натуральном размере. Squircle сохраняет форму.

### SwiftUI: .resizable() требует .scaledToFit()

`Image(systemName:).resizable()` теряет свойства SF Symbol. Без `.scaledToFit()` — `.frame()` растягивает непропорционально.

```swift
Image(systemName: "app.fill")
    .resizable()
    .scaledToFit()
    .frame(width: 29, height: 29)
```

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

1. **Рендер** — `app.fill` при pointSize 32 + символ при pointSize 16. Натуральный размер (~35pt). `draw(at:)`, без масштабирования.

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
