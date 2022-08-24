###
	Fader
	Last update: 2017/11/28
###

# 第一引数に設定オブジェクトを渡す
# $fader: 初期値: $ '.fader'
# $items: 初期値: $ '.fader-item'
# $toggle: data-toggle="fader" を付与 初期値: $ '.fader-toggle'
# $prev: data-fade="prev" を付与 初期値: $ '.fader-prev'
# $next: data-fade="next" を付与 初期値: $ '.fader-next'
# $counterCurrent: 初期値: $ '.fader-counter-current'
# $counterMax: 初期値: $ '.fader-counter-max'
# hasCounter: カウンターの有無 初期値: false
# interval: falseに設定すると自動再生しない 初期値: 5000

class Fader
	constructor: (options = {}) ->
    @$fader = options.$fader ? $ '.fader'
    @$items = $('.fader-item').detach()
    @$toggle = options.$prev ? $ '.fader-toggle'
    @$prev = options.$prev ? $ '.fader-prev'
    @$next = options.$next ? $ '.fader-next'
    @hasCounter = options.hasCounter ? false
    @interval = options.interval ? 5000
    @activeIndex = 0
    @len =  @$items.length
    if @hasCounter
      @$counterCurrent = options.counterCurrent ? $ '.fader-counter-current'
      @$counterMax = options.counterMax ? $ '.fader-counter-max'
      @$counterCurrent.text(@activeIndex + 1)
      @$counterMax.text @len
    @isPlay = false
    @isPlay = true if (@interval && @len > 1)
    @$currentItem = $(@$items[@activeIndex])
    @$fader.append @$currentItem
    setTimeout =>
      @move(1) if @isPlay
    , @interval
    @handleEvents()
  
  handleEvents: ->
    $(document)
      .on MyEvent.touch, '[data-toggle="fader"]', =>
        @toggleMode() if @interval
        false
      .on MyEvent.touch, '[data-fade="prev"]', =>
        @move -1
        false
      .on MyEvent.touch, '[data-fade="next"]', =>
        @move 1
        false
    return
  
  toggleMode: ->
    if @isPlay
      @isPlay = false
    else
      @isPlay = true
      setTimeout =>
        @move(1) if @isPlay
      , @interval
    return
  
  move: (direction) ->
    @activeIndex += (@len + direction)
    @activeIndex = @activeIndex % @len
    $nextItem = $(@$items[@activeIndex])
    @$fader.append $nextItem
    @$counterCurrent.html(@activeIndex + 1) if @hasCounter
    Util.animationEnd(
      $nextItem.addClass 'enter'
    ).done =>
      $nextItem.removeClass 'enter'
    Util.animationEnd(
      @$currentItem.addClass 'leave'
    ).done =>
      @$currentItem.removeClass 'leave'
      @$currentItem.remove()
      @$currentItem = $nextItem
      setTimeout =>
        @move(1) if @isPlay
      , @interval
    return
