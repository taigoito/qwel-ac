// Generated by CoffeeScript 1.12.7

/*
	Author:	Taigo Ito
	Site: https://qwel.design
	Twitter: @taigoito
	Location: Tokyo
	Last update: 2018/05/23
 */
var Router,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Router = (function() {
  function Router(options) {
    var ref;
    if (options == null) {
      options = {};
    }
    this.urlChangeHandler = bind(this.urlChangeHandler, this);
    this.ruteDir = (ref = options.ruteDir) != null ? ref : location.protocol + '//' + location.hostname + '/';
    this.currentUrl = location.href.replace(this.ruteDir, '');
    this.initialize();
    return;
  }

  Router.prototype.initialize = function() {
    var urlChangeHandler;
    urlChangeHandler = this.urlChangeHandler;
    $(window).on('popstate', urlChangeHandler).trigger('popstate');
    $(document).on('click', 'a:not([target="_blank"])', function(el) {
      var href;
      el.preventDefault();
      href = $(this).attr('href');
      history.pushState(null, null, href);
      return urlChangeHandler();
    });
  };

  Router.prototype.urlChangeHandler = function() {
    var dfd, nextUrl, url;
    nextUrl = location.href.replace(this.ruteDir, '');
    url = this.ruteDir + nextUrl;
    dfd = new $.Deferred();
    dfd.resolve();
    if (this.currentUrl !== nextUrl) {
      this.currentUrl = nextUrl;
      return this.change($('#contents'), url + ' #contents > .inner');
    }
  };

  Router.prototype.change = function($el, url) {
    var callback, dfd;
    dfd = new $.Deferred;
    callback = function() {
      dfd.resolve();
    };
    this.hide($el).then(function() {
      return $el.load(url, callback);
    });
    return dfd.promise().then((function(_this) {
      return function() {
        return _this.show($el);
      };
    })(this)).then((function(_this) {
      return function() {
        return _this.scroll($el);
      };
    })(this));
  };

  Router.prototype.show = function($el) {
    return this.animEnd($el.css('visibility', 'visible').addClass('anim-show')).then(function() {
      $el.removeClass('anim-show');
    });
  };

  Router.prototype.hide = function($el) {
    return this.animEnd($el.addClass('anim-hide')).then(function() {
      $el.css('visibility', 'hidden').removeClass('anim-hide');
    });
  };

  Router.prototype.scroll = function() {
    var callback, dfd;
    dfd = new $.Deferred;
    callback = function() {
      dfd.resolve();
    };
    if (window.pageYOffset > 0) {
      $('html, body').animate({
        scrollTop: 0
      }, 1200, 'swing', callback);
    } else {
      $('html, body').animate({
        scrollTop: 1
      }, 1200, 'swing', callback);
    }
    return dfd;
  };

  Router.prototype.animEnd = function($el) {
    var callback, dfd;
    dfd = new $.Deferred;
    callback = function() {
      dfd.resolve($el);
    };
    if (($el != null) && $el.length && ($el.css('animation') != null)) {
      $el.on('animationend', callback);
      dfd.done(function() {
        $el.off('animationend', callback);
      });
    } else {
      dfd.resolve();
    }
    return dfd;
  };

  return Router;

})();

window.Router = Router;
