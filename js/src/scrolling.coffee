###
	Scrolling
	Last update: 2017/10/15
###

# 第一引数に設定オブジェクトを渡す
# $el: scrollさせる<a>を含む要素 初期値: $ document
# 派生クラスでScrollingさせたくない場合は、$el: falseとする
# scrollさせる<a>に data-location="scroll" data-target="#*" を付与

class Scrolling
	constructor: (options = {}) ->
		@$el = options.$el ? $ document
		targetSelector = location.hash
		@scroll targetSelector if @$el && targetSelector
		@handleEvents()

	handleEvents: ->
		if @$el
			@$el.on MyEvent.touch, '[data-location="scroll"]', (el) =>
				$target = $ el.currentTarget
				targetSelector = $target.data 'target'
				@scroll targetSelector
				false
		return

	scroll: (targetSelector) ->
		dfd = new $.Deferred
		targetTop = $(targetSelector).offset().top
		targetTop -= $(window).height() * 0.05
		$('html, body').animate {scrollTop: targetTop}, 1000, 'swing', ->
			dfd.resolve()
		dfd