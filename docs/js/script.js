$('document').ready(function(){
    $("a").click(function(){
        $(this).toggleClass("open");
    });

    $(window).scroll(function() {
        if ($(document).scrollTop() > 80) {
            $('.navbar').css("padding", "7.5px");
        } else {
            $('.navbar').css("padding", "20px");
        }
    });
});