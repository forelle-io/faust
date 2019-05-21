import $ from "jquery";

$(document).ready(function () {
    // Подписаться / отписаться от пользователя
    window.follow_user = function(token, link) {
        window.token = token;

        switch($(link).data("action")) {
            case "follow":
                follow_request(link, "POST", "/followers", {"follower_id": link.id});
                break;

            case "unfollow":
                follow_request(link, "DELETE", `/followers/${link.id}`);
                break;
        }
    }

    function follow_request(link, type, url, data = {}) {
        $.ajax({
            type: type,
            url: url,
            data: data || {},
            headers: {
              "X-CSRF-TOKEN": window.token
            },
            success: function (data) {
              let response = JSON.parse(data);

              if (response.status == "ok") {
                switch (response.action) {
                  case "create":
                    $(link)
                      .text("Отписаться")
                      .addClass("btn-primary")
                      .removeClass("btn-outline-primary")
                      .data("action", "unfollow");
                    break;
    
                  case "delete":
                    $(link)
                        .text("Подписаться")
                        .addClass("btn btn-outline-primary")
                        .removeClass("btn-primary")
                        .data("action", "follow");
                    break;
                }
              } else {
                $(link)
                  .text("Произошла ошибка")
                  .removeClass()
                  .addClass("btn btn-danger disabled");
              }
    
              $(link).blur();
            }
        });
    }
});
