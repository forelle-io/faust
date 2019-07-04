import $ from "jquery";

window.changeButtonWhenFollowerCreated = function(userId) {
    $(`#follower_${userId}`)
        .removeClass("btn-outline-primary")
        .addClass("btn-primary")
        .attr("onclick", `deleteFollower(${userId})`)
        .text("Отписаться");
}

window.changeButtonWhenFollowerDeleted = function(userId) {
    $(`#follower_${userId}`)
        .removeClass("btn-primary")
        .addClass("btn-outline-primary")
        .attr("onclick", `createFollower(${userId})`)
        .text("Подписаться");
}

$(document).ready(function () {
    
});
