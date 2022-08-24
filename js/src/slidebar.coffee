###
	Slidebar
	Last update: 2017/10/15
###

# 第一引数に設定オブジェクトを渡す
# $el: scrollさせる<a>を含む要素 初期値: false
# $targetEl: Slidebarを挿入する要素 初期値: $ 'main + aside[role="complementary"]'
# $template: テンプレート 初期値: $ '#slidebar-template'
# data: テンプレートに用いるデータ
# selector.abs: data-toggle="slidebar"を付与 初期値: '#slidebar-open-abs'
# selector.fixed: data-toggle="slidebar"を付与 初期値: '#slidebar-open-fixed'
# selector.overlay: 初期値: '#slidebar-overlay'
# selector.bar: 初期値: '#slidebar'
# selector.menu: 初期値: '#slidemenu'
# selector.close: data-toggle="slidebar"を付与 初期値: '#slidebar-close'
# showBarHeight: $(window).height()を1とする$fixedが表示されるタイミングのスクロール量 初期値: false

class Slidebar extends Scrolling
	constructor: (options = {}) ->
		options.$el ||= false
		@$targetEl = options.$targetEl ? $ 'main + aside[role="complementary"]'
		@$template = options.$template ? $ '#slidebar-template'
		data = options.data ? {}
		options.selector ||= {}
		selector = {
			abs: options.selector.abs ? '#slidebar-open-abs'
			fixed: options.selector.fixed ? '#slidebar-open-fixed'
			overlay: options.selector.overlay ? '#slidebar-overlay'
			bar: options.selector.bar ? '#slidebar'
			menu: options.selector.menu ? '#slidemenu'
			close: options.selector.close ? '#slidebar-close'
		}
		@render data
		@$abs = @$targetEl.find selector.abs
		@$fixed = @$targetEl.find selector.fixed
		@$overlay = @$targetEl.find selector.overlay
		@$bar = @$targetEl.find selector.bar
		@$menu = @$targetEl.find selector.menu
		@$close = @$targetEl.find selector.close
		@showBarHeight = options.showBarHeight ? false
		if @showBarHeight
			@isScrolled = false
		else 
			@$fixed.addClass 'show'
			@showBarHeight = 0
			@isScrolled = true
		@isShown = false
		super options
	
	render: (data) ->
		compiled = _.template @$template.html()
		output = compiled {data: data}
		@$targetEl.append output
	
	handleEvents: ->
		$('[data-toggle="slidebar"]').on MyEvent.touch, =>
			if @isShown
				@hideBar()
			else
				@showBar()
			false
		
		$(window).on 'scroll', @windowScrollHandler
		
		super()
		return
	
	showBar: ->
		dfd1 = new $.Deferred()
		dfd2 = new $.Deferred()
		@isShown = true
		if @isScrolled
			dfd1 = Util.transitionEnd(
				@$fixed.removeClass 'show'
			)
		else
			dfd1.resolve()
		dfd1.done =>
			Util.transitionEnd(
				@$bar.addClass 'show'
			).then =>
				@$overlay.addClass 'show'
				@$close.addClass 'show'
				Util.transitionEnd(
					@$menu.addClass 'show'
				).then ->
					dfd2.resolve()
					return
				return
			return
		dfd2

	hideBar: ->
		dfd1 = new $.Deferred()
		dfd2 = new $.Deferred()
		@isShown = false
		@$overlay.removeClass 'show'
		@$close.removeClass 'show'
		Util.transitionEnd(
			@$menu.removeClass 'show'
		).then =>
			Util.transitionEnd(
				@$bar.removeClass 'show'
			).then =>
				dfd1.resolve()
				return
			return
		dfd1.done =>
			@$fixed.addClass 'show' if @isScrolled
			dfd2.resolve()
			return
		dfd2
	
	windowScrollHandler: =>
		h = $(window).height() * @showBarHeight
		if @isShown
			@hideBar()
		else
			if $(window).scrollTop() > h && !@isScrolled
				@isScrolled = true
				@$fixed.addClass 'show'
			else if $(window).scrollTop() < h && @isScrolled
				@isScrolled = false
				@$fixed.removeClass 'show'
		return
	