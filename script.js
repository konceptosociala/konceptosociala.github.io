(function(script) {

    script(window.jQuery, window, document);

}(function($, window, document) {

    $(function() {
            
        var glide = new Glide('.glide', {
            type: 'carousel',
            perView: 3,
            focusAt: 'center',
            breakpoints: {
                1280: {
                    perView: 2
                },
                1024: {
                    perView: 1
                }
            }
        })
          
        glide.mount()

    });

}));

function toggleTopbar() {
    var links = $('.links');
    links.css("display", "flex");

    if (links.hasClass("animate__fadeInRight")) {
        links.removeClass("animate__fadeInRight");
        links.addClass("animate__fadeOutLeft")
    } else {
        links.removeClass("animate__fadeOutLeft");
        links.addClass("animate__fadeInRight")
    }
}