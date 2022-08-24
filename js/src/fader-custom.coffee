###
	Fader-Custom
	Last update: 2018/09/28
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

class FaderCustom extends Fader
	constructor: (options = {}) ->
		$container = $ '.fader-custom'
		$description = $ '.fader-description'
		$imgs = $container.find('img').detach()
		$txts = $container.find('p').detach()
		$fader = $ '<ul>'
			.addClass 'fader' 
			.addClass 'fader-figures'
			.addClass 'list-unstyled'
			.addClass 'mb-3'
		$container
			.empty()
			.append $fader
		for $img, i in $imgs
			$item = $ '<li>'
				.addClass 'fader-item'
				.addClass 'fader-top'
				.attr 'style', 'background-image:url(' + $img.src + ')'
			$fader.append $item
		for $txt, i in $txts
			$description.append $txt
		super options
