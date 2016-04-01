// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// *********************************
//  Bower front-end dependencies
// *********************************
//= require jquery
//= require mui
//= require_self

jQuery(function($) {
    var $bodyEl = $('body'),
        $sidedrawerEl = $('#sidedrawer'),
        $titleEls = $('strong', $sidedrawerEl);



    function showSidedrawer() {
        // show overlay
        var options = {
            onclose: function() {
                $sidedrawerEl
                    .removeClass('active')
                    .appendTo(document.body);
            }
        };

        var $overlayEl = $(mui.overlay('on', options));

        // show element
        $sidedrawerEl.appendTo($overlayEl);
        setTimeout(function() {
            $sidedrawerEl.addClass('active');
        }, 20);
    }


    function hideSidedrawer() {
        $bodyEl.toggleClass('hide-sidedrawer');
    }


    $('.js-show-sidedrawer').on('click', showSidedrawer);
    $('.js-hide-sidedrawer').on('click', hideSidedrawer);

    $titleEls
        .next()
        .hide();

    $titleEls.on('click', function() {
        $(this).next().slideToggle(200);
    });
});
