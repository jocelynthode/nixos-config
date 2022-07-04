# pyright: reportMissingImports=false
from kitty.fast_data_types import Screen
from kitty.rgb import Color
from kitty.tab_bar import (
  DrawData,
  ExtraData,
  TabBarData,
  as_rgb,
  draw_title,
)
from kitty.utils import color_as_int

timer_id = None


def calc_draw_spaces(*args) -> int:
  length = 0
  for i in args:
      if not isinstance(i, str):
          i = str(i)
      length += len(i)
  return length


def _draw_icon(screen: Screen, index: int, symbol: str = "") -> int:
  if index != 1:
      return 0

  fg, bg = screen.cursor.fg, screen.cursor.bg
  screen.cursor.fg = as_rgb(color_as_int(Color(255, 250, 205)))
  screen.cursor.bg = as_rgb(color_as_int(Color(60, 71, 77)))
  screen.draw(symbol)
  screen.cursor.fg, screen.cursor.bg = fg, bg
  screen.cursor.x = len(symbol)
  return screen.cursor.x


def _draw_left_status(
  draw_data: DrawData,
  screen: Screen,
  tab: TabBarData,
  before: int,
  max_title_length: int,
  index: int,
  is_last: bool,
  extra_data: ExtraData,
) -> int:
  print(extra_data)
  if draw_data.leading_spaces:
      screen.draw(" " * draw_data.leading_spaces)

  draw_title(draw_data, screen, tab, index)
  trailing_spaces = min(max_title_length - 1, draw_data.trailing_spaces)
  max_title_length -= trailing_spaces
  extra = screen.cursor.x - before - max_title_length
  if extra > 0:
      screen.cursor.x -= extra + 1
      screen.draw("…")
  if trailing_spaces:
      screen.draw(" " * trailing_spaces)
  end = screen.cursor.x
  screen.cursor.bold = screen.cursor.italic = False
  screen.cursor.fg = 0
  screen.cursor.bg = 0
  if not is_last:
      screen.cursor.fg = (
          as_rgb(color_as_int(Color(98, 114, 164)))
          if tab.is_active
          else as_rgb(color_as_int(Color(68, 71, 90)))
      )
      screen.draw(draw_data.sep)
  return end


def draw_tab(
  draw_data: DrawData,
  screen: Screen,
  tab: TabBarData,
  before: int,
  max_title_length: int,
  index: int,
  is_last: bool,
  extra_data: ExtraData,
) -> int:
  _draw_icon(screen, index, symbol=" \uf120 ")
  _draw_left_status(
      draw_data,
      screen,
      tab,
      before,
      max_title_length,
      index,
      is_last,
      extra_data,
  )

  return screen.cursor.x
