import consumer from "./consumer"

const chatChannel = consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  },

  received: function(data) {
    var message = data['message'];
    console.log('message recieved: ' + message);
    if( message[0] == 'msg' ) {
      if( $('#msgarea') != null ) {
        console.log('event msg: ' + message);
        $('#msgarea').text(message[1]);
      }
    }
    else if( message[0] == 'stt' ) {
      if( $('#atdlist') != null ) {
        console.log('event stt: ' + message);
        updateStatus(message[1], message[2]);
        marking();
      }
    }
    else if( message[0] == 'add' ) {
      if( $('#atdlist') != null ) {
        console.log('event add: ' + message);
        appendatd(message[1], message[2]);
      }
    }
    else if( message[0] == 'del' ) {
      console.log('event del: ' + message);
      if( $('#atdlist') != null ) {
        deleteatd(message[1]);
      }
    }
    return true;
  },

  speak: function(message) {
    return this.perform('speak', {
      message: message
    });
  }
});


// *** イベント処理 ***
// リスト部状態更新処理
function updateStatus(atdname, status) {
  var list = $('.mbr')
  if(list.length > 0) {
      console.log('updateStatus: ' + atdname + ' to ' + status);
      list.each(function(idx, atd) {
          if($(atd).text().trim() == atdname) {
              $(atd).find('input').val(status);
              console.log( atdname + ' Status Changed' )
          }
      });
  }
}

// リスト部マーキング処理
function marking() {
  var list = $('.mbr');
  console.log(list.length);
  if(list.length > 0) {
      list.each(function(idx, mbr){
          var stt = mbr.getElementsByTagName('input')[0].getAttribute('value');
          var bkcolor = (stt == 0 ?  '' : 'rgb(250, 250, 0)');
  //        console.log(bkcolor);
          $(mbr).css('background-color', bkcolor);
      });
  }
}

// 参加者追加処理
function appendatd(atdid, text) {
  console.log('append: ' + atdid + ',' + text);
  var found = false;
  $('#atdlist').find('.mbr').each( function(idx, elm) {
    if(elm.getElementsByTagName('input')[1].value == atdid) {
      found = true;
    }
  });
  if(found == false) {
    $('#atdlist').append(text);
  }
}

// 参加者削除処理
function deleteatd(atdid) {
  console.log('delete atd: ' + atdid);
  var list = $('.mbr');
  if(list.length > 0) {
      list.each(function(idx, mbr){
        var atdidofmbr = mbr.getElementsByTagName('input')[1].getAttribute('value');
        if(atdidofmbr == atdid) {
          console.log('  removed')
          mbr.parentNode.removeChild(mbr);
        }
      });
  }
}

// クリック時（メンバーリストアイテム、挙手ボタン、メッセージボタン、離席ボタン）:
$('*').on('click', function(e) {
  // メンバーリストアイテムクリックの時: 人数指定に遷移する
  if(e.target.getAttribute('class') == 'addatd') {
    console.log('参加者 SELECTED');
  }

// 挙手ボタンクリック時: ボタン色変更->レコード更新->status値更新->リスト部マーキング->通知
  if(e.target.getAttribute('id') == 'btnatend') {
    var btncolor = 'rgb(240, 240, 240)';
    var status = 0;
    if($('#btnatend').css('background-color') == btncolor) {
        btncolor = 'rgb(250, 250, 0)';
        status = 1;
    }

    $('#btnatend').css('background-color', btncolor);

    chatChannel.speak(['stt', $('#atdname').text(), status]);
  }

  // メッセージボタンの時: メッセージを書き込む->メッセージ配信
  if($('#viewname').val() == 'mecha' && e.target.getAttribute('class') == 'btnmsg') {
    var msg = e.target.parentNode.childNodes.item(1).getAttribute('value');
    $.ajax({
      url: 'mecha/message',
      type: 'GET',
      data: {
        text: msg
      }
//    })
//    .done(function(response) {
//    })
//    .faile(function(xhr){
    });
    
    chatChannel.speak(['msg', msg]);
  }

});
