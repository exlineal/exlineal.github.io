!function(i){skel.breakpoints({xlarge:"(max-width: 1680px)",large:"(max-width: 1280px)",medium:"(max-width: 980px)",small:"(max-width: 736px)",xsmall:"(max-width: 480px)",xxsmall:"(max-width: 360px)"}),i(function(){var e,s=i(window),o=i("body"),t=i("#wrapper"),a=i("#header"),l=i("#footer"),n=i("#main"),r=n.children("article");(o.addClass("is-loading"),s.on("load",function(){window.setTimeout(function(){o.removeClass("is-loading")},100)}),i("form").placeholder(),skel.vars.IEVersion<12)&&s.on("resize.flexbox-fix",function(){clearTimeout(e),e=setTimeout(function(){t.prop("scrollHeight")>s.height()?t.css("height","auto"):t.css("height","100vh")},250)}).triggerHandler("resize.flexbox-fix");var h=a.children("nav"),c=h.find("li");c.length%2==0&&(h.addClass("use-middle"),c.eq(c.length/2).addClass("is-middle"));var d=325,u=!1;if(n._show=function(i,e){var t=r.filter("#"+i);if(0!=t.length){if(u||void 0!==e&&!0===e)return o.addClass("is-switching"),o.addClass("is-article-visible"),r.removeClass("active"),a.hide(),l.hide(),n.show(),t.show(),t.addClass("active"),u=!1,void setTimeout(function(){o.removeClass("is-switching")},e?1e3:0);if(u=!0,o.hasClass("is-article-visible")){var h=r.filter(".active");h.removeClass("active"),setTimeout(function(){h.hide(),t.show(),setTimeout(function(){t.addClass("active"),s.scrollTop(0).triggerHandler("resize.flexbox-fix"),setTimeout(function(){u=!1},d)},25)},d)}else o.addClass("is-article-visible"),setTimeout(function(){a.hide(),l.hide(),n.show(),t.show(),setTimeout(function(){t.addClass("active"),s.scrollTop(0).triggerHandler("resize.flexbox-fix"),setTimeout(function(){u=!1},d)},25)},d)}},n._hide=function(i){var e=r.filter(".active");if(o.hasClass("is-article-visible")){if(void 0!==i&&!0===i&&history.pushState(null,null,"#"),u)return o.addClass("is-switching"),e.removeClass("active"),e.hide(),n.hide(),l.show(),a.show(),o.removeClass("is-article-visible"),u=!1,o.removeClass("is-switching"),void s.scrollTop(0).triggerHandler("resize.flexbox-fix");u=!0,e.removeClass("active"),setTimeout(function(){e.hide(),n.hide(),l.show(),a.show(),setTimeout(function(){o.removeClass("is-article-visible"),s.scrollTop(0).triggerHandler("resize.flexbox-fix"),setTimeout(function(){u=!1},d)},25)},d)}},r.each(function(){var e=i(this);i('<div class="close">Close</div>').appendTo(e).on("click",function(){location.hash=""}),e.on("click",function(i){i.stopPropagation()})}),o.on("click",function(i){o.hasClass("is-article-visible")&&n._hide(!0)}),s.on("keyup",function(i){switch(i.keyCode){case 27:o.hasClass("is-article-visible")&&n._hide(!0)}}),s.on("hashchange",function(i){""==location.hash||"#"==location.hash?(i.preventDefault(),i.stopPropagation(),n._hide()):r.filter(location.hash).length>0&&(i.preventDefault(),i.stopPropagation(),n._show(location.hash.substr(1)))}),"scrollRestoration"in history)history.scrollRestoration="manual";else{var f=0,v=0,m=i("html,body");s.on("scroll",function(){f=v,v=m.scrollTop()}).on("hashchange",function(){s.scrollTop(f)})}n.hide(),r.hide(),""!=location.hash&&"#"!=location.hash&&s.on("load",function(){n._show(location.hash.substr(1),!0)})})}(jQuery);