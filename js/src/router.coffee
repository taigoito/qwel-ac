###
	Author:	Taigo Ito
	Site: https://qwel.design
	Twitter: @taigoito
	Location: Tokyo
	Last update: 2018/05/23
###

# 第一引数に設定オブジェクトを渡す
# ruteDir: ルートディレクトリ 初期値: '/'

class Router
	constructor: (options = {}) ->
		@ruteDir = options.ruteDir ? location.protocol + '//' + location.hostname + '/'
		@currentUrl = location.href.replace @ruteDir, ''
		@initialize()
		return

	initialize: ->
		urlChangeHandler = @urlChangeHandler
		$(window)
			.on 'popstate', urlChangeHandler
			.trigger 'popstate'
		$(document)
			.on 'click', 'a:not([target="_blank"])', (el) ->
				el.preventDefault()
				href = $(this).attr 'href'
				history.pushState null, null, href
				urlChangeHandler()
		return

	urlChangeHandler: =>
		nextUrl = location.href.replace @ruteDir, ''
		url = @ruteDir + nextUrl
		dfd = new $.Deferred()
		dfd.resolve()
		if @currentUrl != nextUrl
			@currentUrl = nextUrl
			@change $('#contents'), url + ' #contents > .inner'

	change: ($el, url) ->
		dfd = new $.Deferred
		callback = ->
			dfd.resolve()
			return
		@hide($el).then ->
			$el.load url, callback
		dfd.promise().then =>
			@show $el
		.then =>
			@scroll $el

	show: ($el) ->
		@animEnd(
			$el
				.css 'visibility', 'visible'
				.addClass 'anim-show'
		).then ->
			$el
				.removeClass 'anim-show'
				return

	hide: ($el) ->
		@animEnd(
			$el
				.addClass 'anim-hide'
		).then ->
			$el
				.css 'visibility', 'hidden'
				.removeClass 'anim-hide'
			return

	scroll: ->
		dfd = new $.Deferred
		callback = ->
			dfd.resolve()
			return
		if window.pageYOffset > 0
			$('html, body').animate { scrollTop: 0 }, 1200, 'swing', callback
		else
			$('html, body').animate { scrollTop: 1 }, 1200, 'swing', callback
		dfd
	
	animEnd: ($el) ->
		dfd = new $.Deferred
		callback = ->
			dfd.resolve $el
			return
		if $el? && $el.length && $el.css('animation')?
			$el.on 'animationend', callback
			dfd.done ->
				$el.off 'animationend', callback
				return
		else
			dfd.resolve()
		dfd

window.Router = Router