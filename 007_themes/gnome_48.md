# Debian GNOME 48: Fluent Light Compact + Kora Icons

Полная инструкция для текущего пользователя. Подготовлена 28 сентября 2026 года по разговору «Помощь с GNOME Tweaks» с проверкой официальных источников.

Команды выполняйте в Bash-терминале внутри своей графической сессии GNOME. `sudo` нужен только для установки пакетов. `~` означает домашний каталог пользователя.

## 1. Что получится

- Fluent Light Compact — оформление GTK-приложений.
- GTK4/libadwaita — подключение файлов темы через `~/.config/gtk-4.0`.
- Kora — значки приложений и папок.
- User Themes — отдельное оформление GNOME Shell: панели, меню и обзора окон.

Подмена CSS libadwaita может давать визуальные несовпадения в отдельных приложениях; одинаковый результат во всех программах не гарантируется. Qt, Electron и приложения с собственным оформлением могут требовать отдельной настройки. Экран входа GDM этими действиями не меняется.

## 2. Официальные источники

- [Fluent GTK Theme — GitHub автора](https://github.com/vinceliuice/Fluent-gtk-theme).
- [Параметры и логика установщика Fluent](https://github.com/vinceliuice/Fluent-gtk-theme/blob/master/install.sh).
- [Kora Icons — GitHub автора](https://github.com/bikass/kora).
- [User Themes — официальный репозиторий GNOME](https://gitlab.gnome.org/GNOME/gnome-shell-extensions).
- [User Themes — каталог GNOME Extensions](https://extensions.gnome.org/extension/19/user-themes/).

Исходники тем будем хранить в `~/Downloads/gnome-themes-src`. Каталог создаётся явно, поэтому команды работают и при русскоязычном названии стандартной папки загрузок.

## 3. Проверка GNOME и зависимости

```bash
gnome-shell --version
printf 'Тип сессии: %s\n' "$XDG_SESSION_TYPE"

sudo apt update
sudo apt install -y \
  git sassc gtk2-engines-murrine gnome-themes-extra \
  gnome-tweaks gnome-shell-extension-prefs libgtk-3-bin
```

Инструкция рассчитана на `GNOME Shell 48.x`; в исходном разговоре использовалась версия 48.7. Она не предполагает обновление Debian до другой версии GNOME. Если пакет не найден, проверьте репозитории своего выпуска Debian, не подключая случайные репозитории других выпусков.

`sassc`, Murrine и `gnome-themes-extra` нужны теме; Tweaks и настройки расширений — для управления оформлением; `libgtk-3-bin` предоставляет обновление кеша значков. Пакет `gnome-shell-extensions` содержит стандартное User Themes; его установка на новой системе описана в разделе 8.

## 4. Резервная копия GTK4

Установщик Fluent с ключом `-l` заменяет `assets`, `gtk.css` и `gtk-dark.css` в `~/.config/gtk-4.0`. Сначала сохраните существующий каталог:

```bash
theme_backup="$HOME/.local/share/theme-backups/$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$theme_backup"
if [ -e "$HOME/.config/gtk-4.0" ] || [ -L "$HOME/.config/gtk-4.0" ]; then
  cp -a "$HOME/.config/gtk-4.0" "$theme_backup/gtk-4.0"
fi
{
  gsettings get org.gnome.desktop.interface gtk-theme
  gsettings get org.gnome.desktop.interface icon-theme
  gsettings get org.gnome.desktop.interface color-scheme
} > "$theme_backup/interface-before.txt"
printf 'Резервная копия: %s\n' "$theme_backup"
```

Сохраните показанный путь. Если GTK4-каталога ещё не было, сохранятся только значения настроек.

## 5. Скачать и установить Fluent Light Compact

```bash
mkdir -p "$HOME/Downloads/gnome-themes-src" "$HOME/.themes"
cd "$HOME/Downloads/gnome-themes-src"
git clone --depth=1 https://github.com/vinceliuice/Fluent-gtk-theme.git
cd Fluent-gtk-theme
./install.sh -d "$HOME/.themes" -c light -s compact -l
```

Значение параметров:

| Параметр | Назначение |
| --- | --- |
| `-d "$HOME/.themes"` | Установка в домашний каталог |
| `-c light` | Светлый вариант |
| `-s compact` | Компактный вариант |
| `-l` | Ссылки на GTK4 CSS для libadwaita |

Ожидаемое имя — `Fluent-Light-compact`, с таким регистром букв. Для компактного размера используйте именно `-s compact`.

Если каталог исходников уже существует, не удаляйте его. Для обновления чистого клона используйте `git -C "$HOME/Downloads/gnome-themes-src/Fluent-gtk-theme" pull --ff-only`, затем повторите установку. Если Git сообщает о локальных изменениях, сначала разберитесь с ними.

Проверка:

```bash
ls -l "$HOME/.themes/Fluent-Light-compact/gtk-4.0/"
ls -l "$HOME/.config/gtk-4.0/"
test -f "$HOME/.themes/Fluent-Light-compact/gnome-shell/gnome-shell.css" \
  && echo 'Shell-тема найдена'
```

Три ссылки в конфигурации GTK4 должны вести в `~/.themes/Fluent-Light-compact/gtk-4.0/`.

## 6. Скачать и установить Kora Icons

```bash
cd "$HOME/Downloads/gnome-themes-src"
git clone --depth=1 https://github.com/bikass/kora.git
mkdir -p "$HOME/.local/share/icons"
cp -a "$HOME/Downloads/gnome-themes-src/kora/kora" "$HOME/.local/share/icons/"
gtk-update-icon-cache -f -t "$HOME/.local/share/icons/kora"
```

Копируется внутренняя папка `kora`, содержащая `index.theme`, а не весь репозиторий. Основной вариант использует синие папки. Дополнительный `kora-pgrey` для серых папок зависит от основной Kora и для этой инструкции не нужен.

Проверка:

```bash
test -f "$HOME/.local/share/icons/kora/index.theme" && echo 'Kora установлена'
```

Если клон уже есть, используйте `git -C "$HOME/Downloads/gnome-themes-src/kora" pull --ff-only`, затем повторите копирование и обновление кеша.

## 7. Активировать тему и значки

```bash
gsettings set org.gnome.desktop.interface color-scheme 'default'
gsettings set org.gnome.desktop.interface gtk-theme 'Fluent-Light-compact'
gsettings set org.gnome.desktop.interface icon-theme 'kora'
```

`default` снимает системное предпочтение тёмного режима; приложение с собственным выбором оформления может его переопределять. В таких приложениях выберите светлое оформление или следование системным настройкам.

В GNOME Tweaks → «Внешний вид» тема может отображаться в разделе Legacy Applications / «Устаревшие приложения», а Kora — в разделе значков. GTK4 CSS подключается отдельно шагом 5.

## 8. GNOME Shell: User Themes

По вашему актуальному скриншоту включено **User Themes**, а **User Theme X выключено**. Оставьте такую конфигурацию: дальнейшие команды относятся к User Themes.

### Установка на новой системе

На вашей системе расширение уже установлено — повторная установка не нужна. На чистой Debian его можно установить из репозиториев:

```bash
sudo apt install -y gnome-shell-extensions
```

После первой установки выйдите из сеанса и войдите снова. Альтернатива — [официальная страница User Themes](https://extensions.gnome.org/extension/19/user-themes/): выбирайте выпуск, совместимый с GNOME 48. Не включайте одновременно User Themes и User Theme X.

### Включение и выбор Fluent

```bash
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com
gsettings set org.gnome.shell.extensions.user-theme name 'Fluent-Light-compact'
```

Проверка выбранной темы:

```bash
gsettings get org.gnome.shell.extensions.user-theme name
```

Ожидается `'Fluent-Light-compact'`. В информации расширения ожидаются `Enabled: Yes` и `State: ACTIVE`.

Графический способ: откройте GNOME Tweaks → «Внешний вид» → Shell / «Оболочка» и выберите `Fluent-Light-compact`. Если пункт недоступен, проверьте включение User Themes, затем закройте и снова откройте Tweaks; при необходимости повторно войдите в сеанс.

### Если появляется «No such schema»

При установке расширения в домашний каталог схема может быть локальной. В этом случае используйте:

```bash
ext_schema="$HOME/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com/schemas"
gsettings --schemadir "$ext_schema" set org.gnome.shell.extensions.user-theme name 'Fluent-Light-compact'
gsettings --schemadir "$ext_schema" get org.gnome.shell.extensions.user-theme name
```

Если каталога нет, посмотрите поле `Path` в выводе `gnome-extensions info` и найдите `schemas` внутри него. При системной установке из пакета схема обычно доступна без `--schemadir`. Не подставляйте схему `org.gnome.shell.extensions.user-theme-x`: она принадлежит другому расширению.

## 9. Перезапуск приложений

Закройте и снова откройте приложения. Перед закрытием файлового менеджера дождитесь завершения копирования файлов.

```bash
nautilus -q
pkill -x gnome-tweaks 2>/dev/null || true
nautilus >/dev/null 2>&1 &
gnome-tweaks >/dev/null 2>&1 &
```

Терминал перезапустите вручную после выполнения команд. Самый полный способ обновить оформление — выйти из учётной записи и войти снова, предварительно сохранив работу. На Wayland не используйте `Alt+F2 → r` для перезапуска оболочки.

## 10. Диагностика

Собрать основные сведения:

```bash
gnome-shell --version
gsettings get org.gnome.desktop.interface color-scheme
gsettings get org.gnome.desktop.interface gtk-theme
gsettings get org.gnome.desktop.interface icon-theme
ls -ld "$HOME/.themes/Fluent-Light-compact"
ls -l "$HOME/.config/gtk-4.0/"
ls -l "$HOME/.local/share/icons/kora/index.theme"
gnome-extensions info user-theme@gnome-shell-extensions.gcampax.github.com
```

Ожидаемые настройки: `'default'`, `'Fluent-Light-compact'`, `'kora'`.

| Проблема | Что проверить |
| --- | --- |
| GTK3 изменился, Files остался прежним | Ссылки GTK4, наличие CSS и полный перезапуск Files |
| Панель осталась прежней | User Themes активно и выбрана тема Shell в Tweaks или через gsettings |
| Kora отсутствует в списке | Файл должен лежать в `~/.local/share/icons/kora/index.theme`, без лишнего уровня `kora/kora` |
| Значки частично старые | Обновите кеш, перезапустите приложение; некоторые значки встроены в саму программу |
| Shell сам меняет тему | Проверьте другие расширения автоматического оформления; User Theme X оставьте выключенным |
| Расширение несовместимо | Установите выпуск для GNOME 48; не отключайте проверку совместимости |
| Flatpak выглядит иначе | Изоляция может мешать доступу к теме; эти команды не гарантируют оформление Flatpak |
| Приложение всё ещё тёмное | Проверьте его собственную настройку цвета |

### Восстановление ссылок GTK4 вручную

Если `-l` не помог, следующий блок сначала сохраняет прежние три элемента, затем создаёт ссылки. Выполняйте после успешной установки Fluent:

```bash
(
  set -e
  fluent_gtk4="$HOME/.themes/Fluent-Light-compact/gtk-4.0"
  test -d "$fluent_gtk4/assets"
  test -f "$fluent_gtk4/gtk.css"
  test -f "$fluent_gtk4/gtk-dark.css"
  repair_backup="$HOME/.local/share/theme-backups/gtk4-repair-$(date +%Y%m%d-%H%M%S)-$$"
  mkdir -p "$repair_backup" "$HOME/.config/gtk-4.0"
  for item in assets gtk.css gtk-dark.css; do
    target="$HOME/.config/gtk-4.0/$item"
    if [ -e "$target" ] || [ -L "$target" ]; then
      mv "$target" "$repair_backup/$item"
    fi
    ln -s "$fluent_gtk4/$item" "$target"
  done
  printf 'Предыдущие файлы: %s\n' "$repair_backup"
)
```

Затем повторите активацию из раздела 7 и перезапустите приложения.

## 11. Структура каталогов

```text
~
├── Downloads/gnome-themes-src/
│   ├── Fluent-gtk-theme/              # исходники и install.sh
│   └── kora/                         # репозиторий значков
│       └── kora/index.theme
├── .themes/Fluent-Light-compact/
│   ├── gtk-3.0/
│   ├── gtk-4.0/
│   │   ├── assets/
│   │   ├── gtk.css
│   │   └── gtk-dark.css
│   └── gnome-shell/gnome-shell.css
├── .config/gtk-4.0/
│   ├── assets       → ~/.themes/Fluent-Light-compact/gtk-4.0/assets
│   ├── gtk.css      → ~/.themes/Fluent-Light-compact/gtk-4.0/gtk.css
│   └── gtk-dark.css → ~/.themes/Fluent-Light-compact/gtk-4.0/gtk-dark.css
└── .local/share/
    ├── icons/kora/index.theme
    ├── gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com/
    └── theme-backups/
```

Для User Themes показан путь пользовательской установки. При установке из Debian-пакета расширение находится в `/usr/share/gnome-shell/extensions/`. Показаны только основные файлы. В реальных символических ссылках вместо `~` будет полный путь домашнего каталога.

## 12. Краткая установка одним блоком

Этот блок заменяет шаги установки GTK и значков выше. Запускайте в Bash. Он создаёт резервную копию GTK4, при наличии клонов использует имеющиеся исходники и останавливается при ошибке. Для обновления клонов отдельно выполните `git pull --ff-only`, как описано выше.

```bash
(
  set -e
  sudo apt update
  sudo apt install -y git sassc gtk2-engines-murrine gnome-themes-extra \
    gnome-tweaks gnome-shell-extension-prefs libgtk-3-bin

  theme_backup="$HOME/.local/share/theme-backups/$(date +%Y%m%d-%H%M%S)-$$"
  mkdir -p "$theme_backup"
  if [ -e "$HOME/.config/gtk-4.0" ] || [ -L "$HOME/.config/gtk-4.0" ]; then
    cp -a "$HOME/.config/gtk-4.0" "$theme_backup/gtk-4.0"
  fi
  {
    gsettings get org.gnome.desktop.interface gtk-theme
    gsettings get org.gnome.desktop.interface icon-theme
    gsettings get org.gnome.desktop.interface color-scheme
  } > "$theme_backup/interface-before.txt"

  mkdir -p "$HOME/Downloads/gnome-themes-src" "$HOME/.themes" "$HOME/.local/share/icons"
  cd "$HOME/Downloads/gnome-themes-src"
  if [ ! -d Fluent-gtk-theme ]; then
    git clone --depth=1 https://github.com/vinceliuice/Fluent-gtk-theme.git
  fi
  (cd Fluent-gtk-theme && ./install.sh -d "$HOME/.themes" -c light -s compact -l)
  if [ ! -d kora ]; then
    git clone --depth=1 https://github.com/bikass/kora.git
  fi
  cp -a kora/kora "$HOME/.local/share/icons/"
  gtk-update-icon-cache -f -t "$HOME/.local/share/icons/kora"

  gsettings set org.gnome.desktop.interface color-scheme 'default'
  gsettings set org.gnome.desktop.interface gtk-theme 'Fluent-Light-compact'
  gsettings set org.gnome.desktop.interface icon-theme 'kora'
  printf 'Готово. Резервная копия: %s\n' "$theme_backup"
)
```

**После блока:** установите/включите User Themes по разделу 8, выберите `Fluent-Light-compact` через Tweaks или команду gsettings и перезапустите приложения. Установка расширения может потребовать подтверждения в графическом окне и повторного входа в сеанс.

## 13. Как вернуть стандартное оформление

Сначала отключите расширение и выберите стандартные GTK и значки:

```bash
gnome-extensions disable user-theme@gnome-shell-extensions.gcampax.github.com
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
gsettings set org.gnome.desktop.interface color-scheme 'default'
```

Чтобы убрать именно созданные здесь ссылки GTK4, не затрагивая другие файлы:

```bash
for item in assets gtk.css gtk-dark.css; do
  target="$HOME/.config/gtk-4.0/$item"
  if [ -L "$target" ] && \
     [ "$(readlink "$target")" = "$HOME/.themes/Fluent-Light-compact/gtk-4.0/$item" ]; then
    rm -- "$target"
  fi
done
```

Перезапустите приложения. Если нужно вернуть прежнее индивидуальное оформление, возьмите три исходных элемента из сохранённого каталога `theme-backups/.../gtk-4.0/`, а прежние значения — из `interface-before.txt`. Это отличается от возврата к стандартной Adwaita. Установленные темы и исходники можно оставить для повторного использования.

---

Параметры Fluent, структура Kora и сведения о User Themes сверены по ссылкам раздела 2. Установка на конкретной системе пользователя при подготовке файла не выполнялась.
