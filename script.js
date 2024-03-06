(function(script) {

    script(window.jQuery, window, document);

}(function($, window, document) {

    $(function() {
        // do logic
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