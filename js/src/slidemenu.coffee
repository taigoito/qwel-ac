###
	Slidemenu
	Last update: 2017/10/15
###

# 第一引数に設定オブジェクトを渡す
# $el: scrollさせる<a>を含む要素 初期値: $ document
# scrollさせる<a>に data-location="scroll" data-target="#*" を付与
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
# $nav: $menuに挿入するul要素をラップする要素 初期値: $ 'nav'

class Slidemenu extends Slidebar
	constructor: (options = {}) ->
		options.$el ||= $ document
		$nav = options.$nav ? $ 'nav'
		listItems = []
		$nav.find('ul').each (i, ul) ->
			listItems[i] = []
			$(ul).find('li').each (j, li) ->
				$a = $(li).find('a').clone()
				$li = $('<li>').append $a
				listItems[i][j] = {html: $li.html()}
				return
			return
		options.data ||= listItems
		super options
		return
	
	scroll: (targetId) ->
		dfd = new $.Deferred()
		if @isShown
			dfd = @hideBar()
		else
			dfd.resolve()
		dfd.done ->
			super targetId