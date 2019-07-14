import $ from "jquery";

window.changeButtonWhenFollowerCreated = userId => {
  $(`#follower_${userId}`)
      .removeClass("btn-outline-primary")
      .addClass("btn-primary")
      .attr("onclick", `deleteFollower(${userId})`)
      .text("Отписаться");
}

window.changeButtonWhenFollowerDeleted = userId => {
  $(`#follower_${userId}`)
      .removeClass("btn-primary")
      .addClass("btn-outline-primary")
      .attr("onclick", `createFollower(${userId})`)
      .text("Подписаться");
}

window.changeUserPresense = presences => {
  let presences_keys = Object.keys(presences)
  if (presences_keys.length > 0) {
    $(".user-presence").each( function (index) {
      if (presences_keys.includes( $(this).data("user_id").toString())) {
        if (!$(this).hasClass("user-online")) {
          $(this).removeClass("user-offline").addClass("user-online")
        }
      } else {
        $(this).removeClass("user-online").addClass("user-offline")
      }
    })
  }
}

window.base64toBlob = (b64Data, contentType, sliceSize) => {
  contentType = contentType || '';
  sliceSize = sliceSize || 512;

  let byteCharacters = atob(b64Data);
  let byteArrays = [];

  for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
    let slice = byteCharacters.slice(offset, offset + sliceSize);

      let byteNumbers = new Array(slice.length);
      for (let i = 0; i < slice.length; i++) {
          byteNumbers[i] = slice.charCodeAt(i);
      }

      let byteArray = new Uint8Array(byteNumbers);

      byteArrays.push(byteArray);
  }

  return new Blob(byteArrays, {type: contentType})
}